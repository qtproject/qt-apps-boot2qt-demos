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
import QtQuick.Particles 2.0
import QtQuick.Window 2.1

Rectangle {
    id: root
    color: "white"
    width : Screen.height > Screen.width ? Screen.height : Screen.width
    height : Screen.height > Screen.width ? Screen.width : Screen.height

    Flickable {
        id: flick
        property real inertia: 0.4

        property real cellWidth;
        property real cellHeight;

        width: parent.width
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter

        contentHeight: content.height

        flickableDirection: Flickable.VerticalFlick

        property real topOvershoot: Math.max(0, contentItem.y);
        property real bottomOvershoot: Math.max(0, root.height - (contentItem.height + contentItem.y));

        Item {
            id: shiftTrickery

            width: flick.width
            height: content.height

            Column {
                id: content;

                y: -flick.contentItem.y + offsetY;
                width: flick.width * 2 / 3
                anchors.horizontalCenter: parent.horizontalCenter

                property real offsetY: 0;
                property real inertia: flick.inertia;
                property real t;
                NumberAnimation on t {
                    id: animation;
                    from: 0;
                    to: 1;
                    duration: 1000;
                    loops: Animation.Infinite
                    running: Math.abs(content.y) > 0.001 || Math.abs(content.x) > 0.001
                }

                onTChanged: {
                    offsetY += (flick.contentItem.y - offsetY) * inertia
                }


                spacing: engine.smallFontSize() * 2

                Item { width: 1; height: engine.smallFontSize() }
                AboutBoot2Qt { }
                Image {
                    id: codeLessImage
                    source: "codeless.png"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Item { width: 1; height: engine.smallFontSize() }
            }

        }
    }

    ParticleSystem {

        anchors.fill: parent

        ImageParticle {
            id: imageParticle
            source: "particle_star2.png"
            color: "#80c342"
            alpha: 0
            colorVariation: 0.3
            entryEffect: ImageParticle.None
        }

        Emitter {
            id: topEmitter
            width: root.width
            height: 1
            x: 0
            y: -1
            shape: EllipseShape { fill: true }

            emitRate: 300
            lifeSpan: 1000
            size: 20
            sizeVariation: 4
            endSize: 0

            enabled: flick.topOvershoot > 0

            velocity: PointDirection { xVariation: 10; yVariation: 50; y: Math.sqrt(flick.topOvershoot) * 10; }
            acceleration: PointDirection { y: 50 }
        }

        Emitter {
            id: bottomEmitter
            width: root.width
            height: 1
            x: 0
            y: root.height + 1
            shape: EllipseShape { fill: true }

            emitRate: 300
            lifeSpan: 1000
            size: 20
            sizeVariation: 4
            endSize: 0

            enabled: flick.bottomOvershoot > 0

            velocity: PointDirection { xVariation: 10; yVariation: -50; y: Math.sqrt(flick.bottomOvershoot) * -10; }
            acceleration: PointDirection { y: -50 }
        }
    }
}
