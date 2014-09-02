/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://qt.digia.com/
**
** This file is part of the examples of the Qt Enterprise Embedded.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
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
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
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
import QtSensors 5.0

Rectangle {
    id: area
    color: "lightblue"
    border.width: 1
    border.color: "darkblue"
    property real velocityX: 0
    property real velocityY: 0

    // Calculate effective rotation
    function getRotation() {
        var rot = rotation
        var newParent = parent

        while (newParent) {
            rot += newParent.rotation
            newParent = newParent.parent
        }
        return rot%360
    }

    function updatePosition() {
        var actualRotation = getRotation();

        // Transform accelerometer readings according
        // to actual rotation of item
        if (actualRotation == 0) {
            velocityX -= accel.reading.x
            velocityY += accel.reading.y
        } else if (actualRotation == 90 || actualRotation == -270) {
            velocityX += accel.reading.y
            velocityY += accel.reading.x
        } else if (actualRotation == 180 || actualRotation == -180) {
            velocityX += accel.reading.x
            velocityY -= accel.reading.y
        } else if (actualRotation == 270 || actualRotation == -90) {
            velocityX -= accel.reading.y
            velocityY -= accel.reading.x
        } else {
            console.debug("The screen rotation of the device has to be a multiple of 90 degrees.")
        }

        velocityX *= 0.95
        velocityY *= 0.95

        var newX = bubble.x + velocityX
        var newY = bubble.y + velocityY
        var right = area.width - bubble.width
        var bottom = area.height - bubble.height

        if (newX < 0) {
            newX = 0
            velocityX = -velocityX * 0.9
        }
        if (newY < 0) {
            newY = 0
            velocityY = -velocityY * 0.9
        }

        if (newX > right) {
            newX = right
            velocityX = -velocityX * 0.9
        }
        if (newY > bottom) {
            newY = bottom
            velocityY = -velocityY * 0.9
        }

        bubble.x = newX
        bubble.y = newY
    }

    Accelerometer {
        id: accel
        active:true
    }

    Component.onCompleted: timer.running = true

    Timer {
        id: timer
        interval: 16
        running: false
        repeat: true
        onTriggered: updatePosition()
    }

    Image {
        id: bubble
        source: "bluebubble.png"
        smooth: true
        x: parent.width/2 - bubble.width/2
        y: parent.height/2 - bubble.height/2
    }
}
