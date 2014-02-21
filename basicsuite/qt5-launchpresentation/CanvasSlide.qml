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
import QtQuick.Particles 2.0
import "presentation"

Slide {
    id: slide

    title: "Qt Quick -  Canvas"



    Rectangle {
        height: parent.height
        width: parent.width * 0.45
        anchors.right: parent.right;
        antialiasing: true
        radius: slide.height * 0.03;
        color: Qt.rgba(0.0, 0.0, 0.0, 0.2);
        Canvas {
            id:canvas
            anchors.fill: parent;

            renderTarget: Canvas.Image;
            antialiasing: true;
            onPaint: {
                eval(editor.text);
            }
        }
    }

    Rectangle {
        height: parent.height
        width: parent.width * 0.45
        anchors.left: parent.left
        antialiasing: true
        radius: slide.height * 0.03;
        color: Qt.rgba(0.0, 0.0, 0.0, 0.2);

        clip: true;

        TextEdit {
            id: editor
            anchors.fill: parent;
            anchors.margins: 10

            font.pixelSize: 16
            color: "white"
            font.family: "courier"
            font.bold: true

            text:
"var ctx = canvas.getContext('2d');
ctx.save();
ctx.clearRect(0, 0, canvas.width, canvas.height);
ctx.strokeStyle = 'palegreen'
ctx.fillStyle = 'limegreen';
ctx.lineWidth = 5;

ctx.beginPath();
ctx.moveTo(100, 100);
ctx.lineTo(300, 100);
ctx.lineTo(100, 200);
ctx.closePath();
ctx.fill();
ctx.stroke();

ctx.fillStyle = 'aquamarine'
ctx.font = '20px sans-serif'
ctx.fillText('HTML Canvas API!', 100, 300);
ctx.fillText('Imperative Drawing!', 100, 340);

ctx.restore();
"
                onTextChanged: canvas.requestPaint();

                onCursorRectangleChanged: {
                    emitter.burst(10)

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

                    x: editor.cursorRectangle.x - editor.cursorRectangle.height / 2;
                    y: editor.cursorRectangle.y
                    width: editor.cursorRectangle.height
                    height: editor.cursorRectangle.height
                    enabled: false

                    lifeSpan: 1000

                    velocity: PointDirection { xVariation: 30; yVariation: 30; }
                    acceleration: PointDirection {xVariation: 30; yVariation: 30; y: 100 }

                    endSize: 0

                    size: 4
                    sizeVariation: 2
                }

        }




    }
}
