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

import QtQuick 2.6
import QtQuick.Window 2.2
import QtWayland.Compositor 1.0

import com.theqtcompany.wlprocesslauncher 1.0


WaylandOutput {
    id: output
    property alias surfaceArea: background
    property var windowList: [ ]
    property int hiddenWindowCount

    window: Window {
        id: screen

        //flags: Qt.FramelessWindowHint

        property QtObject output

        width: 1024
        height: 760
        visible: true

        ProcessLauncher {
            id: launcher
        }

        Rectangle {
            id: sidebar

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            property int sidebarWidth : 150

            width: sidebarWidth

            color: "#6f6d75"

            Column {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                z: 1
                padding: 5
                spacing: 5
                Repeater {
                    model: windowList
                    MyButton {
                        id: winButton
                        enableAlternate: true
                        enableSlide: true
                        property QtObject winItem: modelData

                        height: 30
                        width: sidebar.width - 10

                        buttonColor: winItem.explicitlyHidden ? "#8f8f9f" : "lightgray"

                        text.maximumLineCount: 1
                        text.text: modelData.shellSurface.title.length > 0 ? modelData.shellSurface.title : "Untitled"
                        text.elide: Text.ElideRight
                        onTriggered: {
                            winItem.toggleVisible()
                        }
                        onAlternateTrigger: {
                            //console.log("alt " + winItem + " : " + winItem.shellSurface.surface)
                            setFullscreen(winItem)

                        }
                        onSlideTrigger: {
                            //console.log("slide " + winItem + " : " + winItem.shellSurface.surface)
                            winItem.shellSurface.surface.client.close()
                        }
                    }
                }
                Item {
                    height: 20
                    visible: true
                }
                MyButton {
                    height: 50
                    width: sidebar.width - 10
                    buttonColor: enabled ? "#6fdf7f" : "lightgray"
                    enabled: windowList.length > 0 && hiddenWindowCount > 0
                    text.color: enabled ? "black" : "gray"
                    text.text: "Show all"
                    onTriggered: setFullscreen(null)
                }
            }


            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                padding: 5
                spacing: 5


                LaunchButton {
                    height: 30
                    width: sidebar.width - 10
                    text.text: "Launch wiggly"
                    executable: "/tmp/wiggly"
                }
                LaunchButton {
                    height: 30
                    width: sidebar.width - 10
                    text.text: "Launch analog clock"
                    executable: "/tmp/analogclock"
                }
                LaunchButton {
                    height: 30
                    width: sidebar.width - 10
                    text.text: "Launch digital clock"
                    executable: "/tmp/digitalclock"
                }
                TimedButton {
                    //visible: false
                    height: 50
                    width: sidebar.width - 10
                    text: "Quit"
                    onTriggered: Qt.quit()
                }
            }
        }


        WaylandMouseTracker {
            id: mouseTracker
            anchors.top: parent.top
            anchors.left: sidebar.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            enableWSCursor: true
            Rectangle {
                id: background
                anchors.fill: parent
                color: "#8f8d95"
                onWidthChanged: output.relayout()
                onHeightChanged: output.relayout()
            }
        }
    }

    function setFullscreen(obj) {
        var n = windowList.length
        for (var i = 0; i < n; i++) {
            var child = windowList[i]
            child.explicitlyHidden = !(obj === null || child === obj)
        }

        relayout();
    }

    function relayout() {
        var ch = []
        var vc = []
        var nn = surfaceArea.children.length
        var i = 0;
        var foundFS = false
        var nh = 0;
        for (i = 0; i < nn; i++) {
            var child = surfaceArea.children[i]
            var surf = child.surface
            //var valid = child.valid
            //surf.size.width > 0 && surf.size.height > 0 && !surf.cursorSurface && child.visible
            //console.log(i + " " + child +" valid " + child.valid)
            //console.log("surf: " + surf)
            if (child.valid) {
                ch.push(child)
                //console.log(child + " " + child.shellSurface.title)
                if (!child.explicitlyHidden)
                    vc.push(child)
                else
                    nh++
            }
        }
        windowList = ch
        hiddenWindowCount = nh
//console.log("fsw: " + fullscreenWindow + " found: " + foundFS)

        var n = vc.length
        var ny = Math.round(Math.sqrt(n))
        var nx = Math.ceil(n/ny)
        var extra = nx*ny - n
        //console.log(n + ": " + nx + " * " + ny + " extra: " + extra)

        var w = surfaceArea.width / nx;
        var x = 0;
        i = 0;
        for (var ix = 0; ix < nx; ix++) {
            var nny = (ix < nx - extra) ? ny : ny - 1;
            var h = surfaceArea.height / nny;
            var y = 0;
            for (var iy = 0; iy < nny; iy++) {

                vc[i].x = x
                vc[i].y = y
                vc[i].width = w
                vc[i].height = h
                vc[i].requestSize(w,h)
                vc[i].state = "SHOWN"
                y += h
                i++
            }
            x += w
        }
    }
}
