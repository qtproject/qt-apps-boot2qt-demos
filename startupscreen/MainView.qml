/****************************************************************************
**
** Copyright (C) 2020 The Qt Company Ltd.
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
import StartupScreen

Item {
    id: root

    property var textNormal: panel.height / 9
    property var textLarge: panel.height / 7

    Image {
        id: backgroundImage
        source: "assets/background.png"
        anchors.fill: parent
    }

    Item {
        id: panel
        anchors.top: root.top
        anchors.topMargin: height / 10

        anchors.left: root.left
        height: width / 2
        width: root.width * 0.6

        Item {
            id: headerBackground

            height: parent.height / 3
            anchors.top: panel.top
            anchors.left: panel.left
            anchors.right: panel.right

            Image {
                id: headerBackgroundRight
                source: "assets/headerBackgroundRight.png"
                width: height
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
            }
            Image {
                id: headerBackgroundLeft
                source: "assets/headerBackgroundLeft.png"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: headerBackgroundRight.left
            }
            Text {
                id: headerText_1
                color: "#ffffff"
                text: "Get started with"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                font.pixelSize: textNormal
                font.family: "Titillium Web"
            }
            Text {
                id: headerText_2
                color: "#ffffff"
                text: "Boot to Qt "
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                font.bold: true
                font.pixelSize: textLarge
                font.family: "Titillium Web"
            }
        }

        // body of the text panel
        Rectangle {
            id: bodyBackground
            color: "#000000"
            anchors.right: panel.right
            anchors.left: panel.left
            anchors.top: headerBackground.bottom
            anchors.bottom: panel.bottom

            Text {
                id: bodyText
                color: "#ffffff"
                text: "How to install demo\napplication from Qt Creator?"
                font.pixelSize: textNormal
                font.family: "Titillium Web"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                horizontalAlignment: Text.AlignHCenter
                lineHeight: 0.8
                wrapMode: Text.WordWrap
            }

            TextButton {
                id: textButton
                width: parent.width * 0.9
                height: parent.height / 3
                fontSize: textNormal
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: height / 4
            }
        }
    }

    // Analog clock showing the current time
    Item {
        id: clockAlignment
        anchors.right: root.right
        anchors.left: panel.right
        anchors.top: panel.top
        anchors.bottom: panel.bottom
    }
    AnalogClock {
        id: clock
        width: height
        height: panel.height * 0.7
        anchors.horizontalCenter: clockAlignment.horizontalCenter
        anchors.verticalCenter: panel.verticalCenter
        anchors.topMargin: height * 0.1
    }


    // Button row
    Row {
        id: buttonRow
        anchors.top: panel.bottom
        anchors.horizontalCenter: panel.horizontalCenter
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
            visible: false
        }
    }

    // label and IP address
    Text {
        id: ipLabel
        color: "grey"
        text: "Networks:"
        anchors.bottom: ipAddress.top
        anchors.horizontalCenter: ipAddress.horizontalCenter
        font.pixelSize: textNormal
        font.family: "Titillium Web"
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

    UsbModeDialog {
        id: usbModeDialog
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



