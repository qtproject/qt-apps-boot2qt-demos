/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://qt.digia.com
**
** This file is part of the QtQuick Enterprise Controls Add-on.
**
** $QT_BEGIN_LICENSE$
** Licensees holding valid Qt Commercial licenses may use this file in
** accordance with the Qt Commercial License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://qt.digia.com
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.0
import QtQuick.Enterprise.Controls 1.0

Rectangle {
    id: view
    color: customizerItem.currentStyleDark ? "#111" : "#555"

    Behavior on color {
        ColorAnimation {}
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            stackView.pop();
            event.accepted = true;
        }
    }

    property bool darkBackground: true

    property Component mouseArea

    property Component customizer: Column {
        property alias currentStylePath: stylePicker.currentStylePath
        property alias currentStyleDark: stylePicker.currentStyleDark

        StylePicker {
            id: stylePicker
            currentIndex: 0

            model: ListModel {
                ListElement {
                    name: "Default"
                    path: "PieMenuDefaultStyle.qml"
                    dark: false
                }
                ListElement {
                    name: "Dark"
                    path: "PieMenuDarkStyle.qml"
                    dark: true
                }
            }
        }
    }

    property alias controlItem: pieMenu
    property alias customizerItem: customizerLoader.item

    Item {
        id: controlBoundsItem
        width: parent.width
        height: parent.height - toolbar.height
        visible: customizerLoader.opacity === 0

        Image {
            id: bgImage
            anchors.centerIn: parent
            height: 48
            Text {
                id: bgLabel
                anchors.top: parent.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Tap to open"
                color: "#999"
                font.pointSize: 20
            }
        }

        MouseArea {
            id: touchArea
            anchors.fill: parent

            onClicked: {
                pieMenu.popup(touchArea.mouseX, touchArea.mouseY)
            }
        }

        Item {
            width: labelText.width
            height: labelText.height
            anchors.bottom: pieMenu.top
            anchors.bottomMargin: 10
            anchors.horizontalCenter: pieMenu.horizontalCenter
            visible: pieMenu.visible

            Item {
                id: labelBlurGuard
                anchors.centerIn: parent
                width: labelText.implicitWidth * 2
                height: labelText.implicitHeight * 2

                Text {
                    id: labelText
                    font.pointSize: 20
                    text: pieMenu.currentIndex !== -1 ? pieMenu.menuItems[pieMenu.currentIndex].text : ""
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.centerIn: parent
                    color: "#ccc"
                    antialiasing: true
                }
            }
        }

        PieMenu {
            id: pieMenu
            activationMode: ActivationMode.ActivateOnClick
            width: Math.min(controlBoundsItem.width, controlBoundsItem.height) * 0.5
            height: width

            style: Qt.createComponent(customizerItem.currentStylePath)

            MenuItem {
                text: "Zoom In"
                onTriggered: {
                    bgImage.source = iconSource
                    bgLabel.text = text + " selected"
                }
                iconSource: "images/zoom_in.png"
            }
            MenuItem {
                text: "Zoom Out"
                onTriggered: {
                    bgImage.source = iconSource
                    bgLabel.text = text + " selected"
                }
                iconSource: "images/zoom_out.png"
            }
            MenuItem {
                text: "Info"
                onTriggered: {
                    bgImage.source = iconSource
                    bgLabel.text = text + " selected"
                }
                iconSource: "images/info.png"
            }
        }
    }
    Loader {
        id: customizerLoader
        sourceComponent: customizer
        opacity: 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 30
        anchors.rightMargin: 30
        y: parent.height / 2 - height / 2 - toolbar.height
        visible: customizerLoader.opacity > 0

        property alias view: view

        Behavior on y {
            NumberAnimation {
                duration: 300
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }
    }

    ControlViewToolbar {
        id: toolbar

        onCustomizeClicked: {
            customizerLoader.opacity = customizerLoader.opacity == 0 ? 1 : 0;
        }
    }
}
