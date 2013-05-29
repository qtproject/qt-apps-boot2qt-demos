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
import "presentation"


Slide {
    id: slide

    title: "Qt Quick - ShaderEffect"

    writeInText: "Harness the raw power of the graphics processor. The ShaderEffect\nelement lets you write GLSL inline in your QML files."

    Image {
        id: sourceItem
        source: "images/ally.png"
        visible: false
    }

    SequentialAnimation {
        id: kickoffAnimation

        // setup
        PropertyAction { target: rotationAnimation; property: "running"; value: false }
        PropertyAction { target: timeAnimation; property: "running"; value: false }
        PropertyAction { target: shader; property: "amp"; value: 0 }
        PropertyAction { target: shader; property: "xrot"; value: 0 }
        PropertyAction { target: shader; property: "zrot"; value: 0 }
        PropertyAction { target: shader; property: "time"; value: 0 }
        PropertyAction { target: shader; property: "scale"; value: 1; }
        PropertyAction { target: rotationAnimation; property: "running"; value: false }
        PropertyAction { target: timeAnimation; property: "running"; value: false }
        // short pause
        PauseAnimation { duration: 2000 }
        // get started...
        ParallelAnimation {
            NumberAnimation { target: shader; property: "xrot"; to: 2 * Math.PI / 8; duration: 1000; easing.type: Easing.InOutCubic }
            NumberAnimation { target: shader; property: "amp"; to: 0.1; duration: 1000; easing.type: Easing.InOutCubic }
//            NumberAnimation { target: shader; property: "scale"; to: 1.5; duration: 1000; easing.type: Easing.InOutCubic }
            PropertyAction { target: rotationAnimation; property: "running"; value: true }
            PropertyAction { target: timeAnimation; property: "running"; value: true }
        }

        running: slide.visible;
    }


    ShaderEffect {
        id: shader
        width: height
        height: Math.min(parent.height, parent.width)
        anchors.centerIn: parent;
        anchors.verticalCenterOffset: Math.min(slide.height, slide.width) * 0.1

        blending: true

        mesh: "50x50"

        property variant size: Qt.size(width, height);

        property variant source: sourceItem;

        property real amp: 0

        property real xrot: 0; // 2 * Math.PI / 8;
//        NumberAnimation on xrot { from: 0; to: Math.PI * 2; duration: 3000; loops: Animation.Infinite }

        property real zrot: 0
        NumberAnimation on zrot {
            id: rotationAnimation
            from: 0;
            to: Math.PI * 2;
            duration: 20000;
            loops: Animation.Infinite
            easing.type: Easing.InOutCubic
            running: false;
        }

        property real time: 0
        NumberAnimation on time {
            id: timeAnimation
            from: 0;
            to: Math.PI * 2;
            duration: 3457;
            loops: Animation.Infinite
            running: false;
        }

        vertexShader: "
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;
        uniform highp mat4 qt_Matrix;
        uniform highp float xrot;
        uniform highp float zrot;
        uniform highp vec2 size;
        uniform highp float time;
        uniform highp float amp;
        varying lowp vec2 v_TexCoord;
        varying lowp float v_light;
        void main() {
            highp float xcosa = cos(xrot);
            highp float xsina = sin(xrot);

            highp mat4 xrot = mat4(1, 0, 0, 0,
                                   0, xcosa, xsina, 0,
                                   0, -xsina, xcosa, 0,
                                   0, 0, 0, 1);

            highp float zcosa = cos(zrot);
            highp float zsina = sin(zrot);

            highp mat4 zrot = mat4(zcosa, zsina, 0, 0,
                                   -zsina, zcosa, 0, 0,
                                   0, 0, 1, 0,
                                   0, 0, 0, 1);

            highp float near = 2.;
            highp float far = 6.;
            highp float fmn = far - near;

            highp mat4 proj = mat4(near, 0, 0, 0,
                                   0, near, 0, 0,
                                   0, 0, -(far + near) / fmn, -1.,
                                   0, 0, -2. * far * near / fmn, 1);

            highp mat4 model = mat4(2, 0, 0, 0,
                                    0, 2, 0, 0,
                                    0, 0, 2, 0,
                                    0, -.5, -4, 1);

            vec4 nLocPos = vec4(qt_Vertex.xy * 2.0 / size - 1.0, 0, 1);
            nLocPos.z = cos(nLocPos.x * 5. + time) * amp;

            vec4 pos = proj * model * xrot * zrot * nLocPos;
            pos = vec4(pos.xyx/pos.w, 1);

            gl_Position = qt_Matrix * vec4((pos.xy + 1.0) / 2.0 * size , 0, 1);

            v_TexCoord = qt_MultiTexCoord0;


            v_light = dot(normalize(vec3(-sin(nLocPos.x * 5.0 + time) * 5.0 * amp, 0, -1)), vec3(0, 0, -1));
        }
        "

        fragmentShader: "
            uniform lowp sampler2D source;
            uniform lowp float qt_Opacity;
            varying highp vec2 v_TexCoord;
            varying lowp float v_light;
            void main() {
                highp vec4 c = texture2D(source, v_TexCoord);
                gl_FragColor = (vec4(pow(v_light, 16.0)) * 0.3 + c) * qt_Opacity;
            }
        "

    }

}
