/******************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
******************************************************************************/
import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Enterprise.VirtualKeyboard 1.2

Window {
    id: window

    visible: true
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    color: "black"

    Item {
        id: root
        anchors.centerIn: window.contentItem
        property bool portraitMode: Screen.desktopAvailableHeight > Screen.desktopAvailableWidth ? true : false
        rotation: portraitMode ? 90 : 0
        width: portraitMode ? window.height : window.width
        height: portraitMode ? window.width : window.height

        Loader {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: inputPanel.top
            source: "main.qml"
        }

        InputPanel {
            id: inputPanel
            z: 99
            y: root.height
            anchors.left: root.left
            anchors.right: root.right

            states: State {
                name: "visible"
                when: Qt.inputMethod.visible
                PropertyChanges {
                    target: inputPanel
                    y: root.height - inputPanel.height
                }
            }
            transitions: Transition {
                from: ""
                to: "visible"
                reversible: true
                ParallelAnimation {
                    NumberAnimation {
                        properties: "y"
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }
}
