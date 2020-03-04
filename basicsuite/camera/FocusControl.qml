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
import QtQuick 2.0
import QtMultimedia 5.0

MouseArea {
    id: focusRoot

    signal searchAndLock

    onClicked: {
        camera.focus.focusPointMode = Camera.FocusPointCustom
        camera.focus.customFocusPoint = viewfinder.mapPointToSourceNormalized(Qt.point(mouse.x, mouse.y))
        focusRoot.searchAndLock()
    }

    Item {
        id: zones
        anchors.fill: parent

        property color focusAreaColor
        property real focusAreaScale: 1

        Repeater {
            model: camera.focus.focusZones

            Rectangle {
                border {
                    width: Math.round(2 * root.contentScale)
                    color: zones.focusAreaColor
                }
                radius: 8 * root.contentScale
                color: "transparent"
                scale: zones.focusAreaScale

                // Map from the relative, normalized frame coordinates
                property rect mappedRect: viewfinder.mapNormalizedRectToItem(area);

                Connections {
                    target: viewfinder
                    function onContentRectChanged() {
                        mappedRect = viewfinder.mapNormalizedRectToItem(area);
                    }
                }

                x: mappedRect.x - (width - mappedRect.width) / 2
                y: mappedRect.y - (height - mappedRect.height) / 2
                width: Math.round(120 * root.contentScale)
                height: width

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -1.5
                    color: "transparent"
                    border.width: 1
                    border.color: "black"
                    radius: parent.radius + 2
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1 + parent.border.width / 2 + 0.5
                    color: "transparent"
                    border.width: 1
                    border.color: "black"
                    radius: parent.radius - 3
                }
            }
        }

        states: [
            State {
                name: "unlocked"; when: camera.lockStatus === Camera.Unlocked
                PropertyChanges { target: zones; opacity: 0; focusAreaColor: "red" }
            },
            State {
                name: "searching"; when: camera.lockStatus === Camera.Searching
                PropertyChanges { target: zones; opacity: 1; focusAreaColor: "white" }
            },
            State {
                name: "locked"; when: camera.lockStatus === Camera.Locked
                PropertyChanges { target: zones; opacity: 0; focusAreaColor: "green" }
            }
        ]

        transitions: [
            Transition {
                to: "searching"
                NumberAnimation { properties: "opacity"; duration: 60 }
                SequentialAnimation {
                    NumberAnimation {
                        target: zones; property: "focusAreaScale"; from: 1; to: 1.3; duration: 150
                    }
                    PauseAnimation { duration: 20 }
                    NumberAnimation {
                        target: zones; property: "focusAreaScale"; easing.period: 1; easing.amplitude: 1.4
                        easing.type: Easing.OutElastic; from: 1.3; to: 1
                        duration: 450
                    }
                }
            },
            Transition {
                from: "searching"
                SequentialAnimation {
                    PauseAnimation { duration: 1500 }
                    NumberAnimation { properties: "opacity"; duration: 60 }
                }
            }

        ]
    }

}
