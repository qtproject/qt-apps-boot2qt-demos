/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
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

import QtQuick 2.6

Rectangle {
    id: theButton

    //radius: 10
    color: "magenta"
    property color grooveColor: "cyan"
    property color textColor: "#777"
    property alias icon: iconImage
    property double iconSize: 32

    property alias text: buttonText.text
    signal triggered()

    property int percent : 0
    state: "UNPRESSED"

    states: [
        State {
            name: "UNPRESSED"
        },
        State {
            name: "PRESSED"
        },
        State {
            name: "TRIGGERED"
        }

    ]

    transitions: [ Transition {
        from: "UNPRESSED"
        to: "PRESSED"
            NumberAnimation {
                target: theButton
                property: "percent"
                to: 100
                duration: 1500
            }
    },
        Transition {
                from: "PRESSED"
                to: "UNPRESSED"
                    NumberAnimation {
                        target: theButton
                        property: "percent"
                        to: 0
                        duration: 100
                    }
                }
    ]
    Rectangle {
        id: timeIndicator
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 10
        color: grooveColor
        Rectangle {
            color: "#e41e25"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * percent / 100
            visible: percent > 0
        }
    }

    Item {
        anchors.top: timeIndicator.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        Item {
            id: iconRect
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 5
            width: iconSize
            height: iconSize
            Image {
                anchors.centerIn: parent
                id: iconImage
            }
        }


        Text {
            id: buttonText
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: iconRect.right
            anchors.right: parent.right
            anchors.leftMargin: 10

            color: textColor
            text: "[Uninitialized]"
            font.bold: true
        }

    }


    MouseArea {
        id: mouser
        anchors.fill: parent

        Timer {
            id: timer
            interval: 1000
        }

        onPressed: parent.state = "PRESSED"

        onReleased: {
            if (containsMouse && parent.percent >= 100) {
                parent.triggered()
                parent.state = "TRIGGERED"
            } else {
                parent.state = "UNPRESSED"
            }
        }

        onPositionChanged: {
            parent.state = containsMouse ? "PRESSED" : "UNPRESSED"
        }
    }
}
