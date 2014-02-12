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

Item {


    width: 700
    height: 600
    id: root

    property real inputX: 0.5;
    property real feedbackX: inputX
    property string nameX: "Dissolution"

    property real inputY: 0.5;
    property real feedbackY: effect.amplitude
    property string nameY: "Amplitude"

    Rectangle {
        id: sourceItem
        anchors.centerIn: parent
        width: text.width + 50
        height: text.height + 20
        gradient: Gradient {
            GradientStop { position: 0; color: "steelblue" }
            GradientStop { position: 1; color: "black" }
        }
        border.color: "lightsteelblue"
        border.width: 2

//?        color: "transparent"

        radius: 10

        layer.enabled: true
        layer.smooth: true
        layer.sourceRect: Qt.rect(-1, -1, width + 2, height + 2);

        visible: false

        Text {
            id: text
            font.pixelSize: root.height * 0.08
            anchors.centerIn: parent;
            text: "Code Less, Create More!"
            color: "lightsteelblue"
            style: Text.Raised

        }
    }

    ShaderEffect {

        id: effect

        anchors.fill: sourceItem;

        property variant source: sourceItem;

        property real t: (1 + tlength) * (1 - root.inputX) - tlength;
        property real tlength: 1.0
        property real amplitude: 2.0 * height * root.inputY;

        mesh: "40x4"

        vertexShader:
            "
            uniform highp mat4 qt_Matrix;
            uniform lowp float t;
            uniform lowp float tlength;
            uniform highp float amplitude;

            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;

            varying highp vec2 vTexCoord;
            varying lowp float vOpacity;

            void main() {
                vTexCoord = qt_MultiTexCoord0;

                vec4 pos = qt_Vertex;

                lowp float tt = smoothstep(t, t+tlength, qt_MultiTexCoord0.x);

                vOpacity = 1.0 - tt;

                pos.y += (amplitude * (qt_MultiTexCoord0.y * 2.0 - 1.0) * (-2.0 * tt)
                          + 3.0 * amplitude * (qt_MultiTexCoord0.y * 2.0 - 1.0)
                          + amplitude * sin(0.0 + tt * 2.14152 * qt_MultiTexCoord0.x)
                          + amplitude * sin(0.0 + tt * 7.4567)
                         ) * tt;

                pos.x += amplitude * sin(6.0 + tt * 4.4567) * tt;

                gl_Position = qt_Matrix * pos;
            }
            "
        fragmentShader:
            "
            uniform sampler2D source;

            uniform lowp float t;
            uniform lowp float tlength;
            uniform lowp float qt_Opacity;

            varying highp vec2 vTexCoord;
            varying lowp float vOpacity;

            // Noise function from: http://stackoverflow.com/questions/4200224/random-noise-functions-for-glsl
            highp float rand(vec2 n) {
                return fract(sin(dot(n.xy, vec2(12.9898, 78.233))) * 43758.5453);
            }

            void main() {
                lowp vec4 tex = texture2D(source, vTexCoord);
                lowp float opacity = 1.0 - smoothstep(0.9, 1.0, vOpacity);
                lowp float particlify = smoothstep(1.0 - vOpacity, 1.0, rand(vTexCoord)) * vOpacity;
                gl_FragColor = tex * mix(vOpacity, particlify, opacity) * qt_Opacity;
            }

            "

    }

}
