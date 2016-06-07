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
import QtWayland.Compositor 1.0

Rectangle {
    border.width: 0
    color: "#1b1c1d"
    id: rootChrome
    property alias surface: surfaceItem.surface
    property alias valid: surfaceItem.valid
    property alias explicitlyHidden: surfaceItem.explicitlyHidden
    property alias shellSurface: surfaceItem.shellSurface

    property alias destroyAnimation : destroyAnimationImpl

    property int marginWidth : 5
    property int titlebarHeight : 5

    function requestSize(w, h) {
        surfaceItem.requestSize(Qt.size(w - 2 * marginWidth, h - titlebarHeight - marginWidth))
    }

    function toggleVisible() {
        surfaceItem.explicitlyHidden = ! surfaceItem.explicitlyHidden
        defaultOutput.relayout()
    }

    Behavior on x {
        NumberAnimation { duration: 300 }
    }
    Behavior on y {
        NumberAnimation { duration: 300 }
    }
    Behavior on width {
        NumberAnimation { duration: 300 }
    }
    Behavior on height {
        NumberAnimation { duration: 300 }
    }

    SequentialAnimation {
        id: destroyAnimationImpl
        ParallelAnimation {
            NumberAnimation { target: scaleTransform; property: "yScale"; to: 2/height; duration: 150 }
            NumberAnimation { target: scaleTransform; property: "xScale"; to: 0.4; duration: 150 }
        }
        NumberAnimation { target: scaleTransform; property: "xScale"; to: 0; duration: 150 }
        ScriptAction { script: { rootChrome.destroy(); } }
    }

    transform: [
        Scale {
            id:scaleTransform
            origin.x: rootChrome.width / 2
            origin.y: rootChrome.height / 2

        }
    ]

    WaylandQuickItem {
        id: surfaceItem

        anchors.fill: parent
        anchors.margins: marginWidth
        anchors.topMargin: titlebarHeight

        property bool dead: false
        property bool valid: false
        property bool explicitlyHidden: false
        property var shellSurface: ShellSurface {
        }

        sizeFollowsSurface: false

        onSurfaceDestroyed: {
            view.bufferLock = true;
            x = 0
            y = 0
            rootChrome.destroyAnimation.start();
            valid = false
            dead = true
        }

        onValidChanged: comp.defaultOutput.relayout()

        function requestSize(size) {
            //console.log("requesting size: " + size)
            shellSurface.sendConfigure(size, ShellSurface.DefaultEdge)
        }

        onExplicitlyHiddenChanged: {
            state = explicitlyHidden ? "HIDDEN" : "SHOWN"
        }

        state: "SHOWN"

        states: [
            State {
                name: "SHOWN"
                PropertyChanges {
                    target: rootChrome
                    visible: true
                }
            },
            State {
                name: "HIDDEN"
                PropertyChanges {
                    target: rootChrome
                    x: 0
                    y: 0
                    width: 0
                    height: 0
                }
            }
        ]

        transitions: [
            Transition {
                from: "SHOWN"
                to: "HIDDEN"
                SequentialAnimation {

                    PauseAnimation {duration: 300}

                    PropertyAction {target: rootChrome; property: "visible"; value: false}
                    ScriptAction {script: rootChrome.requestSize(0,0)}
                }
            }
        ]

        Connections {
            target: surface
            onSizeChanged: {
                valid = !surfaceItem.dead && !surface.cursorSurface && surface.size.width > 0 && surface.size.height > 0
                //console.log(shellSurface.title + " surface size: " + surface.size + " curs: " + surface.cursorSurface + " valid: " + valid)
            }
        }

    }

}
