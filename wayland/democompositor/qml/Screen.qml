/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
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

    property bool darkMode: true

    property color backgroundCol: darkMode ?  "#1b1c1d" : "white"
    property color pressedCol: darkMode ? "#000000" :  "#eeeeee"
    property color textCol: darkMode ? "#cdcdcd" : "black"
    property color weakLineCol: darkMode ?  "#2f3d24" : "#d6d6d6" //"#585a5c"????
    property color weakTextCol: darkMode ? "#585a5c" : "#d6d6d6"
    property color strongLineCol: darkMode ? "#5caa15" : "#80c342"

    window: Window {
        id: screen

        flags: Qt.FramelessWindowHint

        property QtObject output

        width: 1024
        height: 760
        visible: true

        ProcessLauncher {
            id: launcher
        }


        Rectangle {
            id: curtain
            color: "black"
            anchors.fill: parent
            opacity: 0
            z: 100
        }

        SequentialAnimation {
            id: quitAnimation

            PropertyAnimation {
                target: curtain
                property: "opacity"
                duration: 500
                to: 1
                easing.type: Easing.InQuad
            }
            ScriptAction {
                script: Qt.quit()
            }
        }

        Rectangle {
            id: sidebar

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            property int sidebarWidth : 150

            width: sidebarWidth

            color: backgroundCol

            Column {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                z: 1
                padding: 5
                spacing: 0
                Text {
                    color: weakTextCol
                    text: "OPEN APPS"
                    padding: 5
                }

                Rectangle {
                    height: 1
                    width: sidebar.width - 10
                    color: strongLineCol
                }

                Repeater {
                    model: windowList
                    Item {
                        height: 36
                        width: 1
                        Item {
                            anchors.top:parent.top
                            anchors.left:parent.left
                            height: 35
                            width: sidebar.width - 10
                            Rectangle {
                                anchors.fill: parent
                                color: "#e41e25"
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    leftPadding: 10
                                    text: "Terminate"
                                    color: "white"
                                }
                            }

                            MyButton {
                                anchors.fill: parent
                                id: winButton
                                enableAlternate: true
                                enableSlide: true
                                property QtObject winItem: modelData

                                icon.source: sliding ? "qrc:/images/reddot.png" : (winItem.explicitlyHidden ? "qrc:/images/graydot.png" : "qrc:/images/greendot.png")
                                //icon.visible: !winItem.explicitlyHidden

                                buttonColor: backgroundCol
                                pressedColor: pressedCol

                                text.maximumLineCount: 1
                                text.text: modelData.shellSurface.title.length > 0 ? modelData.shellSurface.title : "Untitled"
                                text.elide: Text.ElideRight
                                text.color: textCol
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
                            Rectangle {
                                anchors.top: winButton.bottom
                                height: 1
                                width: sidebar.width - 10
                                color: weakLineCol
                            }

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
                    buttonColor: backgroundCol
                    pressedColor: pressedCol
                    enabled: windowList.length > 0 && hiddenWindowCount > 0
                    text.color: enabled ?  strongLineCol : weakTextCol  //"#5caa15" : "#585a5c"
                    //visible: enabled
                    text.text: "Show all"
                    iconSize: 21
                    icon.source: enabled ? "qrc:/images/greendots.png" : "qrc:/images/graydots.png"
                    onTriggered: setFullscreen(null)
                }
                Rectangle {
                    height: 1
                    width: sidebar.width - 10
                    color: weakLineCol
                }

            }


            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                padding: 5
                spacing: 0

                Text {
                    padding: 5
                    color: weakTextCol
                    text: "LAUNCHER"
                }

                Rectangle {
                    height: 1
                    width: sidebar.width - 10
                    color: strongLineCol
                }

                Item {
                    height: 5
                    width: 1
                }
                LaunchButton {
                    height: 60
                    width: sidebar.width - 10
                    buttonColor: backgroundCol
                    pressedColor: pressedCol
                    textColor: textCol
                    text.text: "Clocks"
                    executable: "./clocks"
                    icon.source: "qrc:/images/Icon_Clocks.png"
                }

                LaunchButton {
                    height: 60
                    width: sidebar.width - 10
                    buttonColor: backgroundCol
                    pressedColor: pressedCol
                    textColor: textCol
                    text.text: "RSS News"
                    executable: "./rssnews"
                    icon.source: "qrc:/images/Icon_RSS.png"
                }
                LaunchButton {
                    height: 60
                    width: sidebar.width - 10
                    buttonColor: backgroundCol
                    pressedColor: pressedCol
                    textColor: textCol
                    text.text: "StoQt"
                    executable: "./stocqt"
                    icon.source: "qrc:/images/Icon_StocQt.png"
                }
                LaunchButton {
                    height: 60
                    width: sidebar.width - 10
                    buttonColor: backgroundCol
                    pressedColor: pressedCol
                    textColor: textCol
                    text.text: "Maps"
                    executable: "./qml_location_mapviewer"
                    icon.source: "qrc:/images/Icon_Maps.png"
                }

                TimedButton {
                    //visible: false
                    height: 60
                    width: sidebar.width - 10
                    text: "Shut down"

                    color: backgroundCol
                    textColor: textCol

                    grooveColor:  pressedCol // "black" ??

                    onTriggered: quitAnimation.start()
                    icon.source: "qrc:/images/quit.png"
                }
            }
        }


        WaylandMouseTracker {
            id: mouseTracker
            anchors.top: parent.top
            anchors.left: sidebar.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            enableWSCursor: false
            Rectangle {
                id: background
                anchors.fill: parent
                color: darkMode ?  "#26282a" : "#f6f6f6"
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
