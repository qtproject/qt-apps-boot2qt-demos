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

    property bool available: false
    property bool connected: false
    signal pressed()

    state: !available ? "" : (connected ? "connected" : "error")

    // changing button state
    MouseArea {
        anchors.fill: parent
        onPressed: root.scale = 0.9
        onReleased: root.scale = 1.0
        onClicked: if (available) root.pressed()
    }

    // button icon
    Image {
        id: icon
        source: "assets/icon_usb.png"
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        height: parent.height * 0.9
    }

    // marker for the states
    Image {
        id: markerBackground
        height: icon.height/2

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        source: "assets/icon_markerBackground.png"
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        fillMode: Image.PreserveAspectFit

        Image {
            id: errorIcon
            height: parent.height * 0.5
            anchors.centerIn: parent
            source: "assets/icon_error.png"
            fillMode: Image.PreserveAspectFit
            opacity: 0
        }
        Image {
            id: unavailableIcon
            height: parent.height * 0.5
            anchors.centerIn: parent
            source: "assets/icon_nok.png"
            fillMode: Image.PreserveAspectFit
            opacity: 1
        }
        Image {
            id: okIcon
            height: parent.height * 0.5
            anchors.centerIn: parent
            source: "assets/icon_ok.png"
            fillMode: Image.PreserveAspectFit
            opacity: 0
        }
    }

    states: [
        State {
            name: "connected"
            PropertyChanges {
                target: errorIcon
                opacity: 0
            }
            PropertyChanges {
                target: unavailableIcon
                opacity: 0
            }
            PropertyChanges {
                target: okIcon
                opacity: 1
            }
        },
        State {
            name: "error"
            PropertyChanges {
                target: errorIcon
                opacity: 1
            }
            PropertyChanges {
                target: unavailableIcon
                opacity: 0
            }
            PropertyChanges {
                target: okIcon
                opacity: 0
            }
        }
    ]
    transitions: [
        Transition {
            from: "error"
            to: "connected"
            PropertyAnimation {
                duration: 200
                properties: "opacity"
            }
        },
        Transition {
            from: "connected"
            to: "error"
            PropertyAnimation {
                duration: 200
                properties: "opacity"

            }
        }
    ]
}

/*##^##
Designer {
    D{i:0;height:100;width:100}
}
##^##*/
