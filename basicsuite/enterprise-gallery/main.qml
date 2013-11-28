/****************************************************************************
**
** Copyright (C) 2013 Digia Plc
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
import QtQuick.Controls.Styles 1.0
import QtQuick.Controls.Private 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Enterprise.Controls 1.0
import QtQuick.Enterprise.Controls.Styles 1.0
import QtQuick.Window 2.1

Rectangle {
    id: root
    visible: true
    width: 480
    height: 800

    color: "#161616"
    //title: "QtQuick Enterprise Controls Demo"

    function toPixels(percentage) {
        return percentage * Math.min(root.width, root.height);
    }

    property bool isScreenPortrait: height > width
    property color fontColor: "white"
    readonly property color lightBackgroundColor: "#ccc"
    readonly property color darkBackgroundColor: "#161616"
    property real customizerPropertySpacing: 10
    property real colorPickerRowSpacing: 8

    property Component circularGauge: CircularGaugeView {}

    property Component dial: ControlView {
        darkBackground: false

        control: Dial {
            id: dial
            width: root.toPixels(0.3)
            height: width

            /*!
                Determines whether the dial animates its rotation to the new value when
                a single click or touch is received on the dial.
            */
            property bool animate: customizerItem.animate

            Behavior on value {
                enabled: dial.animate && !dial.pressed
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutSine
                }
            }

            Text {
                text: "Volume"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: dial.bottom
                anchors.topMargin: 10
                font.pixelSize: root.toPixels(0.045)
                color: "#4e4e4e"
                styleColor: "#ffffff"
                style: Text.Raised
            }
        }

        customizer: Column {
            spacing: customizerPropertySpacing

            property alias animate: animateCheckBox.checked

            CustomizerLabel {
                text: "Animate"
                color: "black"
            }

            CustomizerCheckBox {
                id: animateCheckBox
            }
        }
    }

    property Component delayButton: ControlView {
        darkBackground: false

        control: DelayButton {
            text: "Alarm"
            anchors.centerIn: parent
            width: toPixels(0.3)
            height: width
        }
    }

    property Component gauge: ControlView {
        id: gaugeView
        control: Gauge {
            id: gauge
            width: orientation === Qt.Vertical ? root.toPixels(0.15) : gaugeView.controlBounds.width * 0.65
            height: orientation === Qt.Vertical ? root.toPixels(0.65) : gaugeView.controlBounds.height * 0.15
            anchors.centerIn: parent

            minimumValue: 0
            value: customizerItem.value
            maximumValue: 100
            orientation: customizerItem.orientationFlag ? Qt.Vertical : Qt.Horizontal
            tickmarkAlignment: orientation === Qt.Vertical
                ? (customizerItem.alignFlag ? Qt.AlignLeft : Qt.AlignRight)
                : (customizerItem.alignFlag ? Qt.AlignTop : Qt.AlignBottom)
        }

        customizer: Column {
            spacing: customizerPropertySpacing

            property alias value: valueSlider.value
            property alias orientationFlag: orientationCheckBox.checked
            property alias alignFlag: alignCheckBox.checked

            CustomizerLabel {
                text: "Value"
            }

            CustomizerSlider {
                id: valueSlider
                minimumValue: 0
                value: 50
                maximumValue: 100
            }

            CustomizerLabel {
                text: "Vertical orientation"
            }

            CustomizerCheckBox {
                id: orientationCheckBox
                checked: true
            }

            CustomizerLabel {
                text: controlItem.orientation === Qt.Vertical ? "Left align" : "Top align"
            }

            CustomizerCheckBox {
                id: alignCheckBox
                checked: true
            }
        }
    }

    property Component toggleButton: ControlView {
        darkBackground: false

        control: ToggleButton {
            text: checked ? "On" : "Off"
            width: toPixels(0.3)
            height: width
            anchors.centerIn: parent
        }
    }

    property Component pieMenu: PieMenuControlView {}

    FontLoader {
        id: openSans
        Component.onCompleted: {
            // QTBUG-35909
            if (Qt.platform.os === "ios")
                name = "Open Sans"
            else
                source = "fonts/OpenSans-Regular.ttf"
        }
     }

    property var componentMap: {
        "CircularGauge": circularGauge,
        "DelayButton": delayButton,
        "Dial": dial,
        "Gauge": gauge,
        "PieMenu": pieMenu,
        "ToggleButton": toggleButton
    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: ListView {
            model: ListModel {
                ListElement {
                    title: "CircularGauge"
                }
                ListElement {
                    title: "DelayButton"
                }
                ListElement {
                    title: "Dial"
                }
                ListElement {
                    title: "Gauge"
                }
                //ListElement {
                //    title: "PieMenu"
                //}
                ListElement {
                    title: "ToggleButton"
                }
            }

            delegate: Button {
                width: stackView.width
                height: root.height * 0.125
                text: title

                Image {
                    source: "images/icon-go.png"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 30
                }

                style: BlackButtonStyle {
                    fontColor: root.fontColor
                }

                onClicked: {
                    if (stackView.depth == 1) {
                        // Only push the control view if we haven't already pushed it...
                        stackView.push({item: componentMap[title]});
                        stackView.currentItem.forceActiveFocus();
                    }
                }
            }
        }
    }
}
