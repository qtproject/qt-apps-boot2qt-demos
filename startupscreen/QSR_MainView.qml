/****************************************************************************
**
** Copyright (C) 2024 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick
import QtQuick.Controls
import StartupScreen
import backend 1.0

Item {
    id: root

    property int textNormal: panel.height / 9
    property int textLarge: panel.height / 7

    Item {
        id: panel
        anchors.top: root.top
        anchors.topMargin: height / 10
        anchors.left: root.left
        anchors.leftMargin: panel.width *.1
        height: width / 2
        width: root.width * 0.6

        Text {
            id: headerText_1
            color: "#2cde85"
            text: qsTr("Get Started with Qt Safe Renderer ")
            anchors.top: panel.top
            anchors.left: panel.left
            font.pixelSize: textNormal * 1.2
            font.family: "Titillium Web"
        }

        Text {
            id: bodyText
            color: "#ffffff"
            text: qsTr("How to install demo application\nfrom Qt Creator?")
            font.pixelSize: textNormal
            font.family: "Titillium Web"
            anchors.left: panel.left
            anchors.top: headerText_1.bottom
            anchors.topMargin: textNormal
            wrapMode: Text.WordWrap
        }

        Text {
            id: buttonLabel
            color: "#2cde85"
            text: qsTr("Click here to learn more!")
            font.underline: true
            anchors.left: panel.left
            anchors.top: bodyText.bottom
            anchors.topMargin: textLarge
            font.pixelSize: textLarge
            font.family: "Titillium Web"

            MouseArea {
                anchors.fill: parent
                anchors.margins: -height * .5
                onPressed: guide.visible = true
            }
        }
    }

    Item {
        id: demoButtonAlignment
        anchors.right: root.right
        anchors.left: panel.right
        anchors.top: panel.top
        anchors.bottom: panel.bottom
    }

    Rectangle {
        width: parent.width * 0.2
        height: parent.height * 0.2
        radius: height * 0.075
        anchors.horizontalCenter: demoButtonAlignment.horizontalCenter
        anchors.verticalCenter: panel.verticalCenter
        color: "#2cde85"

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onPressed: parent.color = "#235866"
            var target = "qsrdemo.target";
            onReleased: {
                parent.color = "#2cde85"
                SettingsManager.runDemoMode(target)
            }
        }

        Text {
            text: "Start Demo"
            font.pixelSize: height * 2
            font.family: "Titillium Web"
            anchors.centerIn: parent
            color: "white"
        }
    }


    // Button row
    Row {
        id: buttonRow
        anchors.top: panel.bottom
        anchors.horizontalCenter: panel.BottomLeft
        spacing: buttonSize / 4
        padding: buttonSize / 4
        property var buttonSize: panel.height / 2

        UsbButton {
            id: usbButton
            height: parent.buttonSize
            width: height
            available: SettingsManager.hasQdb
            connected: ipAddress.text.indexOf("usb0") !== -1
            onPressed: {
                usbModeDialog.open()
            }
        }
        WifiButton {
            id: wifiButton
            height: parent.buttonSize
            width: height
            visible: true
            onPressed: {
                loader.source = "qrc:/NetworkSettings/NetworkSettingsPage.qml"
            }
        }
    }

    // label and IP address
    Text {
        id: ipLabel
        color: "grey"
        text: qsTr("Networks:")
        anchors.bottom: ipAddress.top
        anchors.horizontalCenter: ipAddress.horizontalCenter
        font.pixelSize: textNormal
        font.family: "Titillium Web"
        visible: ipAddress.text !== ""
    }
    Text {
        id: ipAddress
        color: "grey"
        text: SettingsManager.networks
        anchors.bottom: root.bottom
        anchors.right: root.right
        anchors.rightMargin: 5
        font.pixelSize: textNormal
        font.bold: true
        font.family: "Titillium Web"

        Timer {
            interval: 3000
            onTriggered: ipAddress.text = SettingsManager.networks
            running: true
            repeat: true
        }
    }

    Loader {
        id: loader
        anchors.fill: parent
    }

    UsbModeDialog {
        id: usbModeDialog
    }

    GuideView {
        id: guide
        visible: false
    }

    // base state = landscape
    states: [
        State {
            name: "portrait"

            PropertyChanges {
                target: panel
                width: root.width * 0.9
            }
            AnchorChanges {
                target: panel
                anchors.top: clock.bottom
            }
            AnchorChanges {
                target: clock
                anchors.top: root.top
                anchors.horizontalCenter: root.horizontalCenter
                anchors.verticalCenter: undefined
            }
            AnchorChanges {
                target: buttonRow
                anchors.horizontalCenter: undefined
                anchors.left: root.left
            }
        }
    ]
}
