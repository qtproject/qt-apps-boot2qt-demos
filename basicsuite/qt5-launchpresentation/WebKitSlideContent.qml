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
import QtQuick.Particles 2.0
import QtWebKit 3.0

Item {
    id: slide

    anchors.fill: parent;

    WebView {
        id: browser
        anchors.fill: parent
        url: editor.text

    // This works around rendering bugs in webkit. CSS animations
    // and webGL content gets a bad offset, but this hack
    // clips it so it is not visible. Not ideal, but it kinda works
    // for now.
        layer.enabled: true
        layer.smooth: true
    }

    Rectangle {
        border.width: 2
        border.color: "black"
        opacity: 0.5
        color: "black"
        anchors.fill: editor
        anchors.margins: -editor.height * 0.2;

        radius: -anchors.margins
        antialiasing: true
    }

    TextInput {
        id: editor
        anchors.top: browser.bottom;
        anchors.horizontalCenter: browser.horizontalCenter
        font.pixelSize: slide.height * 0.05;
        text: "http://qt.digia.com"
        onAccepted: browser.reload();
        color: "white"

        onCursorPositionChanged: {
            var rect = positionToRectangle(cursorPosition);
            emitter.x = rect.x;
            emitter.y = rect.y;
            emitter.width = rect.width;
            emitter.height = rect.height;
            emitter.burst(10);
        }

        ParticleSystem {
            id: sys1
            running: slide.visible
        }

        ImageParticle {
            system: sys1
            source: "images/particle.png"
            color: "white"
            colorVariation: 0.2
            alpha: 0
        }

        Emitter {
            id: emitter
            system: sys1

            enabled: false

            lifeSpan: 2000

            velocity: PointDirection { xVariation: 30; yVariation: 30; }
            acceleration: PointDirection {xVariation: 30; yVariation: 30; y: 100 }

            endSize: 0

            size: 8
            sizeVariation: 2
        }
    }

}
