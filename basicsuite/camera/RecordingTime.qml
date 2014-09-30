/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://www.qt.io
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

Rectangle {
    id: recRoot
    width: row.width + 14 * root.contentScale
    height: circle.height + 14 * root.contentScale
    color: "#77333333"
    radius: 5 * root.contentScale
    rotation: root.contentRotation
    Behavior on rotation { NumberAnimation { } }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 10 * root.contentScale

        Item {
            anchors.verticalCenter: timeText.verticalCenter
            width: 18 * root.contentScale
            height: width

            Rectangle {
                id: circle
                width: parent.width
                height: parent.height
                radius: width / 2
                color: "#fa334f"

                SequentialAnimation {
                    loops: Animation.Infinite
                    running: recRoot.visible
                    PropertyAction { target: circle; property: "visible"; value: true }
                    PauseAnimation { duration: 1000 }
                    PropertyAction { target: circle; property: "visible"; value: false }
                    PauseAnimation { duration: 1000 }
                }
            }
        }

        Text {
            id: timeText
            color: "white"
            font.pixelSize: 24 * root.contentScale
            text: formatTime(camera.videoRecorder.duration)
        }
    }

    function formatTime(time) {
         time = time / 1000
         var hours = Math.floor(time / 3600);
         time = time - hours * 3600;
         var minutes = Math.floor(time / 60);
         var seconds = Math.floor(time - minutes * 60);

         if (hours > 0)
             return formatTimeBlock(hours) + ":" + formatTimeBlock(minutes) + ":" + formatTimeBlock(seconds);
         else
             return formatTimeBlock(minutes) + ":" + formatTimeBlock(seconds);

     }

     function formatTimeBlock(time) {
         if (time === 0)
             return "00"
         if (time < 10)
             return "0" + time;
         else
             return time.toString();
     }
}
