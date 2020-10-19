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

import QtQuick 2.12
import StartupScreen 1.0

Item {
    id: root
    width: Constants.smallWidth
    height: Constants.smallHeight

    Image {
        id: backgroundImage
        source: "assets/background.png"
        anchors.fill: parent
    }

    Item {
        id: panel
        anchors.top: root.top
        anchors.topMargin: 20

        anchors.left: root.left
        height: headerBackground.height + bodyBackground.height
        width: Constants.smallPanelWidth


        Item {
            id: headerBackground

            width: parent.width
            height: Constants.smallHeaderHeight

            anchors.top: panel.top
            anchors.left: panel.left

            Image {
                id: headerBackgroundRight
                source: "assets/headerBackgroundRight.png"
                fillMode: Image.PreserveAspectFit
                height: parent.height
                anchors.right: parent.right
                anchors.top: parent.top
            }
            Image {
                id: headerBackgroundLeft
                source: "assets/headerBackgroundLeft.png"
                height: parent.height
                width: parent.width-headerBackgroundRight.width
                anchors.left: parent.left
                anchors.top: parent.top
            }
            Text {
                id: headerText_1
                color: "#ffffff"
                text: "Get started with"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                font.pixelSize: 20
                font.family: "Titillium Web"
                anchors.topMargin: 8
            }
            Text {
                id: headerText_2
                color: "#ffffff"
                text: "Boot to Qt "
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                font.bold: true
                font.pixelSize: 48
                font.family: "Titillium Web"
                anchors.bottomMargin: 0
            }
        }

        // body of the text panel
        Rectangle {
            id: bodyBackground
            height: Constants.smallBodyHeight
            color: "#000000"
            width: headerBackground.width
            anchors.top: headerBackground.bottom
            anchors.left: headerBackground.left

            Text {
                id: bodyText
                color: "#ffffff"
                width: parent.width - 40
                text: "How to install demo\napplication from Qt Creator?"
                font.pixelSize: 24
                font.family: "Titillium Web"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                horizontalAlignment: Text.AlignHCenter
                lineHeight: 0.8
                wrapMode: Text.WordWrap
                anchors.topMargin: 8
            }

            TextButton {
                id: textButton
                width: parent.width - 40
                height: Constants.smallTextButton
                fontSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
            }
        }
    }

    // Button row
    UsbButton {
        id: usbButton
        height: Constants.smallButton
        width: height
        iconHeight: height-24

        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: panel.bottom
        anchors.topMargin: 48
    }
    SDcardButton {
        id: sdCardButton
        height: Constants.smallButton
        width: height
        iconHeight: height-24


        anchors.bottom: usbButton.bottom
        anchors.left: usbButton.right
        anchors.leftMargin: 50
    }
    WifiButton {
        id: wifiButton
        height: Constants.smallButton
        width: height
        iconHeight: height-24

        anchors.bottom: usbButton.bottom
        anchors.right: panel.right
    }

    // Analog clock showing the current time
    AnalogClock {
        id: clock
        width: Constants.smallClock
        height: Constants.smallClock
        anchors.top: root.top
        anchors.topMargin: panel.anchors.topMargin + panel.height / 2 - clock.height / 2
        anchors.right: root.right
        anchors.rightMargin: 20
    }

    // label and IP address
    Item {
        id: ipPanel
        height: usbButton.height
        anchors.horizontalCenter: clock.horizontalCenter
        anchors.bottom: usbButton.bottom

        Text {
            id: ipLabel
            color: "#ffffff"
            text: "IP address"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 24
            font.pixelSize: 20
            font.family: "Titillium Web"
        }
        Text {
            id: ipAddress
            color: "#ffffff"
            text: "255.255.255.255"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 24
            font.pixelSize: 20
            font.bold: true
            font.family: "Titillium Web"
        }
    }

    // states for different resolutions
    // base state = small landscape
    states: [
        State {
            name: "smallPortrait"

            PropertyChanges {
                target: clock
                width: Constants.smallClock
                height: Constants.smallClock

                anchors.topMargin: 12
                anchors.rightMargin: root.width / 2 - clockRadius
            }
            PropertyChanges {
                target: panel
                anchors.topMargin: 204
            }
            PropertyChanges {
                target: usbButton
                anchors.topMargin: 12
            }
            PropertyChanges {
                target: ipPanel
                anchors.bottomMargin: -80
            }
        },
        State {
            name: "mediumLandscape"

            PropertyChanges {
                target: clock
                width: Constants.mediumClock
                height: Constants.mediumClock

                anchors.topMargin: panel.anchors.topMargin + panel.height / 2 - clock.height / 2
                anchors.rightMargin: 152

                wideDial: 8
                narrowDial: 4
            }
            PropertyChanges {
                target: panel
                anchors.topMargin: 48
                width: Constants.mediumPanelWidth
            }
            PropertyChanges {
                target: headerBackground
                height: Constants.mediumHeaderHeight
            }
            PropertyChanges {
                target: bodyBackground
                height: Constants.mediumBodyHeight
            }
            PropertyChanges {
                target: headerText_1
                font.pixelSize: 40
                anchors.topMargin: 0
            }
            PropertyChanges {
                target: headerText_2
                font.pixelSize: 88
                anchors.bottomMargin: -8
            }
            PropertyChanges {
                target: bodyText
                font.pixelSize: 40
            }
            PropertyChanges {
                target: textButton
                height: Constants.mediumTextButton
                width: panel.width - 64
                fontSize: 40
                anchors.bottomMargin: 32
            }
            PropertyChanges {
                target: usbButton
                height: Constants.mediumButton
                width: height
                anchors.topMargin: 54
                anchors.leftMargin: 32
            }
            PropertyChanges {
                target: sdCardButton
                height: Constants.mediumButton
                width: height
                anchors.leftMargin: 90
            }
            PropertyChanges {
                target: wifiButton
                height: Constants.mediumButton
                width: height
            }
            PropertyChanges {
                target: ipPanel
            }
            PropertyChanges {
                target: ipLabel
                font.pixelSize: 36
            }
            PropertyChanges {
                target: ipAddress
                font.pixelSize: 36
            }
        },
        State {
            name: "mediumPortrait"
            PropertyChanges {
                target: clock
                width: Constants.mediumClock
                height: Constants.mediumClock

                anchors.topMargin: 60
                anchors.rightMargin: root.width / 2 - clockRadius

                wideDial: 8
                narrowDial: 4
            }
            PropertyChanges {
                target: panel
                anchors.topMargin: 440
                width: Constants.mediumPanelWidth
            }
            PropertyChanges {
                target: headerBackground
                height: Constants.mediumHeaderHeight
            }
            PropertyChanges {
                target: bodyBackground
                height: Constants.mediumBodyHeight
            }
            PropertyChanges {
                target: headerText_1
                font.pixelSize: 40
                anchors.topMargin: 0
            }
            PropertyChanges {
                target: headerText_2
                font.pixelSize: 88
                anchors.bottomMargin: -8
            }
            PropertyChanges {
                target: bodyText
                font.pixelSize: 40
            }
            PropertyChanges {
                target: textButton
                height: Constants.mediumTextButton
                width: panel.width - 64
                fontSize: 40
                anchors.bottomMargin: 32
            }
            PropertyChanges {
                target: usbButton
                height: Constants.mediumButton
                width: height
                anchors.topMargin: 60
                anchors.leftMargin: 32
            }
            PropertyChanges {
                target: sdCardButton
                height: Constants.mediumButton
                width: height
                anchors.leftMargin: 90
            }
            PropertyChanges {
                target: wifiButton
                height: Constants.mediumButton
                width: height
            }
            PropertyChanges {
                target: ipPanel
                anchors.bottomMargin: -200
            }
            PropertyChanges {
                target: ipLabel
                font.pixelSize: 36
            }
            PropertyChanges {
                target: ipAddress
                font.pixelSize: 36
            }
        },
        State {
            name: "largeLandscape"

            PropertyChanges {
                target: clock
                width: Constants.largeClock
                height: Constants.largeClock

                anchors.topMargin: panel.anchors.topMargin + panel.height / 2 - clock.height / 2
                anchors.rightMargin: 152

                wideDial: 12
                narrowDial: 6
            }
            PropertyChanges {
                target: panel
                anchors.topMargin: 48
                width: Constants.largePanelWidth
            }
            PropertyChanges {
                target: headerBackground
                height: Constants.largeHeaderHeight
            }
            PropertyChanges {
                target: bodyBackground
                height: Constants.largeBodyHeight
            }
            PropertyChanges {
                target: headerText_1
                font.pixelSize: 72
                anchors.topMargin: 0
            }
            PropertyChanges {
                target: headerText_2
                font.pixelSize: 132
                anchors.bottomMargin: -8
            }
            PropertyChanges {
                target: bodyText
                font.pixelSize: 72
            }
            PropertyChanges {
                target: textButton
                height: Constants.largeTextButton
                width: panel.width - 80
                fontSize: 72
                anchors.bottomMargin: 40
            }
            PropertyChanges {
                target: usbButton
                height: Constants.largeButton
                width: height
                anchors.topMargin: 32
                anchors.leftMargin: 40

            }
            PropertyChanges {
                target: sdCardButton
                height: Constants.largeButton
                width: height
                anchors.leftMargin: 188
            }
            PropertyChanges {
                target: wifiButton
                height: Constants.largeButton
                width: height
            }
            PropertyChanges {
                target: ipPanel
                anchors.bottom: usbButton.bottom
            }
            PropertyChanges {
                target: ipLabel
                font.pixelSize: 72
                anchors.topMargin: 0
            }
            PropertyChanges {
                target: ipAddress
                font.pixelSize: 72
                anchors.bottomMargin: 0
            }
        },
        State {
            name: "largePortrait"
            PropertyChanges {
                target: clock
                width: Constants.largeClock
                height: Constants.largeClock

                anchors.topMargin: 48
                anchors.rightMargin: root.width / 2 - clockRadius

                wideDial: 12
                narrowDial: 6
            }
            PropertyChanges {
                target: panel
                anchors.topMargin: 640
                width: Constants.largePanelWidth
            }

            PropertyChanges {
                target: headerBackground
                height: Constants.largeHeaderHeight
            }
            PropertyChanges {
                target: bodyBackground
                height: Constants.largeBodyHeight
            }
            PropertyChanges {
                target: headerText_1
                font.pixelSize: 72
                anchors.topMargin: 0
            }
            PropertyChanges {
                target: headerText_2
                font.pixelSize: 132
                anchors.bottomMargin: -8
            }
            PropertyChanges {
                target: bodyText
                font.pixelSize: 72
            }
            PropertyChanges {
                target: textButton
                height: Constants.largeTextButton
                width: panel.width - 80
                fontSize: 72
                anchors.bottomMargin: 40
            }
            PropertyChanges {
                target: usbButton
                height: Constants.largeButton
                width: height
                anchors.topMargin: 60
                anchors.leftMargin: 40
            }
            PropertyChanges {
                target: sdCardButton
                height: Constants.largeButton
                width: height
                anchors.leftMargin: 188
            }
            PropertyChanges {
                target: wifiButton
                height: Constants.largeButton
                width: height
            }
            PropertyChanges {
                target: ipPanel
                anchors.bottomMargin: -240
            }
            PropertyChanges {
                target: ipLabel
                font.pixelSize: 72
                anchors.topMargin: 0
            }
            PropertyChanges {
                target: ipAddress
                font.pixelSize: 72
                anchors.bottomMargin: 0
            }
        }
    ]
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:640;width:480}
}
##^##*/

