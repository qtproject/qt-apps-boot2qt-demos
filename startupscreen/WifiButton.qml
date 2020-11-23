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

    signal pressed()

    Rectangle {
        id: buttonBackground
        anchors.fill: parent
        color: "#3a4055"
        radius: 0
    }

    // changing button state
    MouseArea {
        anchors.fill: parent

        onPressed: {
            root.scale = 0.9
        }
        onReleased: {
            root.scale = 1.0
            root.pressed()

            if (root.state == "")
                root.state = "working"
            else if (root.state == "working")
                root.state = "ok"
            else
                root.state = ""
        }
    }

    // icons for signal strengths (from 0 to 3)
    Image {
        id: icon_signal_0
        height: parent.height * 0.9
        source: "assets/icon_wifi_0.png"
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
    }
    Image {
        id: icon_signal_1
        height: parent.height * 0.9
        source: "assets/icon_wifi_1.png"
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        opacity: 0
    }
    Image {
        id: icon_signal_2
        height: parent.height * 0.9
        source: "assets/icon_wifi_2.png"
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        opacity: 0
    }
    Image {
        id: icon_signal_3
        height: parent.height * 0.9
        source: "assets/icon_wifi_3.png"
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        opacity: 0
    }

    // marker for the error, working and OK states
    Image {
        id: markerBackground
        height: parent.height * 0.5

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
            opacity: 1
        }
        Image {
            id: workingIcon
            height: parent.height * 0.75
            anchors.centerIn: parent
            source: "assets/icon_working.png"
            fillMode: Image.PreserveAspectFit
            opacity: 0

            RotationAnimation on rotation {
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1000
                running: true
            }
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
            name: "working"
            PropertyChanges {
                target: errorIcon
                opacity: 0
            }
            PropertyChanges {
                target: workingIcon
                opacity: 1
            }
            PropertyChanges {
                target: okIcon
                opacity: 0
            }
        },
        State {
            name: "ok"
            PropertyChanges {
                target: errorIcon
                opacity: 0
            }
            PropertyChanges {
                target: workingIcon
                opacity: 0
            }
            PropertyChanges {
                target: okIcon
                opacity: 1
            }
            PropertyChanges {
                target: markerBackground
                opacity: 0
            }
            PropertyChanges {
                target: icon_signal_0
                opacity: 0
            }
            PropertyChanges {
                target: icon_signal_1
                opacity: 1
            }
            PropertyChanges {
                target: icon_signal_2
                opacity: 1
            }
            PropertyChanges {
                target: icon_signal_3
                opacity: 1
            }
        }
    ]
    transitions: [
        Transition {
            from: ""
            to: "working"
            PropertyAnimation {
                duration: 200
                properties: "opacity"

            }
        },
        Transition {
            from: "working"
            to: "ok"
            SequentialAnimation {
                PropertyAnimation {
                    target: workingIcon
                    duration: 200
                    properties: "opacity"
                }
                PropertyAnimation {
                    target: okIcon
                    duration: 100
                    properties: "opacity"
                }
                ParallelAnimation {
                    PropertyAnimation {
                        target: icon_signal_0
                        duration: 300
                        properties: "opacity"
                    }
                    PropertyAnimation {
                        target: icon_signal_1
                        duration: 300
                        properties: "opacity"
                    }
                }
                PropertyAnimation {
                    target: icon_signal_2
                    duration: 300
                    properties: "opacity"
                }
                PropertyAnimation {
                    target: icon_signal_3
                    duration: 200
                    properties: "opacity"
                }
                PropertyAnimation {
                    target: markerBackground
                    duration: 1000
                    properties: "opacity"
                }
            }
        },
        Transition {
            from: ""
            to: "working"
            PropertyAnimation {
                duration: 200
                properties: "opacity"

            }
        }
    ]
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/