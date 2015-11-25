/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtWayland.Compositor 1.0
import QtGraphicalEffects 1.0

Rectangle {
    border.width: 1
    border.color: "#102080"
    color: "#1337af"
    id: rootChrome
    property alias surface: surfaceItem.surface
    property alias valid: surfaceItem.valid
    property alias explicitlyHidden: surfaceItem.explicitlyHidden
    property alias shellSurface: surfaceItem.shellSurface

    property alias destroyAnimation : destroyAnimationImpl

    property int marginWidth : 5
    property int titlebarHeight : 25

    Item {
        anchors.margins: 1
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: titlebarHeight
        LinearGradient {
              anchors.fill: parent
              start: Qt.point(0, 0)
              end: Qt.point(0, height)
              gradient: Gradient {
                  GradientStop { position: 0.0; color: "steelblue" }
                  GradientStop { position: 1.0; color: "#1337af" }
              }
        }
    }

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
                    //visible: false
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
