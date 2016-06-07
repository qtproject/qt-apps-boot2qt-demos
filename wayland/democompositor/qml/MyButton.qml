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

Item {
    property alias text: buttonText
    signal triggered()
    signal alternateTrigger()
    signal slideTrigger()
    property bool enableAlternate: false
    property bool enableSlide: false
    property bool longPressed: false

    property bool sliding: enableSlide && mouser.drag.active

    property color buttonColor: "magenta"
    property color pressedColor: "cyan"
    property color textColor: "#ff0000"
    property double iconSize: 10

    property alias icon: iconImage

    Rectangle {
        id: rect
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        color: mouser.containsPress && !mouser.drag.active ? (longPressed ? "#3faf1f" : pressedColor) : buttonColor

        Item {
            id: iconRect
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.margins: 5
            width: iconSize
            height: iconSize
            Image {
                anchors.centerIn: parent
                id: iconImage
            }
        }

        Text {
            color: textColor
            anchors.margins: 10
            id: buttonText
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: iconRect.right
            anchors.right: parent.right
            text: "[Uninitialized]"
        }
        //opacity:  (enableSlide && mouser.drag.active) ? (1.2 - (x/width)) : 1.0
    }

    MouseArea {
        id: mouser
        anchors.fill: parent
        onPressed: {
            if (enableSlide) {
                rect.anchors.left = undefined
                rect.anchors.right = undefined
            }
        }

        //onPositionChanged: console.log("Mouse move: " + mouse.x + ", " + mouse.y)

        onPressAndHold: if (enableAlternate) parent.longPressed = true
        onReleased: {
            if (enableSlide && drag.active) {
                //console.log("drag end: " + rect.x + " w: " + rect.width)
                if (rect.x > rect.width || rect.x < -rect.width*3/4)
                    parent.slideTrigger()
            } else if (containsMouse) {
                //console.log("clicked " + mouse.wasHeld + " alt " + enableAlternate)
                if (mouse.wasHeld && enableAlternate)
                    parent.alternateTrigger()
                else
                    parent.triggered()
            }

            rect.anchors.left = parent.left
            rect.anchors.right = parent.right
            parent.longPressed = false
        }
        drag.target: rect
        drag.threshold: 5
        drag.axis: Drag.XAxis
        //drag.maximumX: 0
        drag.minimumX: 0
    }
}
