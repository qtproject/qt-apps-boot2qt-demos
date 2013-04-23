/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt 5 launch demo.
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
import QtMultimedia 5
import "presentation"

import QtGraphicalEffects 1.0

Slide {

    id: slide

    title: "Qt Multimedia - Video"

    Video {
        id: video

        anchors.fill: parent
        source: "bunny.mov"
        autoLoad: true;

        layer.enabled: true;
        layer.smooth: true;
        layer.effect: Displace {
            displacementSource: normalMap
            displacement: button.pressed ? 1.0 : 0.0
            Behavior on displacement {
                NumberAnimation { duration: 1000 }
            }
        }
    }

    Rectangle {
        id: theItem;
        width: 256
        height: 128
        color: "transparent"
        Text {
            id: label
            color: "white"
            text: "Qt 5"
//            font.family: "Times New Roman"
            font.bold: true;
            font.pixelSize: 80
            anchors.centerIn: parent
        }
        visible: false;
    }

    NormalMapGenerator {
        anchors.left: theItem.right
        width: 256
        height: 128
        id: normalMap
        source: theItem;
        visible: false
    }

    centeredText: video.hasVideo ? "" : "'bunny.mov' is not found or cannot be played: " + video.errorString

     onVisibleChanged: {
         if (slide.visible)
             video.play();
         else
             video.pause();
     }

     Button {
         id: button
         anchors.bottom: video.bottom
         anchors.horizontalCenter: video.horizontalCenter
         anchors.bottomMargin: height / 2;
         label: pressed ? "Remove Effect" : "Displacement Effect";
         width: height * 4;
         height: parent.height * 0.1
     }

}
