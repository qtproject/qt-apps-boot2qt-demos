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

Item {
    id: root

    property alias text: buttonTextItem.text
    property bool effectsOn: true
    signal clicked

    width: buttonBackgroundImage.width
    height: buttonBackgroundImage.height
    scale: mouseArea.pressed && mouseArea.containsMouse ? 0.9 : 1.0
    opacity: mouseArea.pressed && mouseArea.containsMouse ? 0.8 : 1.0

    Behavior on scale {
        NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
    }
    Behavior on opacity {
        NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
    }

    BorderImage {
        id: buttonBackgroundImage
        source: "images/button.png"
        border.left: 24
        border.right: 24
        border.top: 20
        border.bottom: 20
        width: 140
    }

    // Stars effect
    ParticleSystem {
        id: particleSystem
        anchors.fill: buttonBackgroundImage
        running: root.effectsOn
        ImageParticle {
            source: "images/star.png"
            rotationVariation: 180
            color:"#ffffff"
        }
        Emitter {
            width: parent.width
            height: 8
            emitRate: 16
            lifeSpan: 2000
            size: 32
            sizeVariation: 16
            endSize: 8
            velocity: PointDirection{ y: 20; x:-2; xVariation: 5; yVariation: 10 }
        }
        Turbulence {
            width: parent.width
            height: (parent.height / 2)
            strength: 8
        }
    }

    // Button background
    ShaderEffectSource {
        id: shaderSource
        anchors.fill: buttonBackgroundImage
        sourceItem: buttonBackgroundImage
        hideSource: true
        visible: false
    }

    // Particles
    ShaderEffectSource {
        id: shaderSource2
        anchors.fill: particleSystem
        sourceItem: particleSystem
        hideSource: true
        visible: false
    }

    // Mask particles inside the button
    ShaderEffect {
        id: shaderEffectItem
        anchors.fill: shaderSource

        property variant source: shaderSource
        property variant source2: shaderSource2

        fragmentShader: "
            uniform sampler2D source;
            uniform sampler2D source2;
            uniform lowp float qt_Opacity;
            varying highp vec2 qt_TexCoord0;
            void main() {
                lowp vec4 pix = texture2D(source, qt_TexCoord0);
                lowp vec4 pix2 = texture2D(source2, qt_TexCoord0);
                gl_FragColor = qt_Opacity * (pix + pix.a * pix2);
            }"
    }

    Text {
        id: buttonTextItem
        anchors.centerIn: parent
        color: "#000000"
        font.pixelSize: 28
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: -16
        onClicked: {
            root.clicked();
        }
    }
}
