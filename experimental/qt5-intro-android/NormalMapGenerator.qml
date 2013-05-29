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
import QtGraphicalEffects 1.0

ShaderEffect {
    id: effectRoot;

    property alias source: blurShader.source;

    GaussianBlur
    {
        id: blurShader;
        width: source != undefined ? source.width : 0
        height: source != undefined ? source.height : 0
        samples: 8
        radius: 8

        layer.enabled: true;
        layer.smooth: true;

        visible: false;
    }

    width: 256
    height: 128

    property variant tex: blurShader;
    property size pixelSize: Qt.size(1 / blurShader.width, 1 / blurShader.height);

    fragmentShader: "
        #ifdef GL_ES
        precision lowp float;
        #endif

        uniform lowp float qt_Opacity;
        uniform lowp sampler2D tex;
        uniform highp vec2 pixelSize;
        varying highp vec2 qt_TexCoord0;
        void main() {

            lowp vec2 xps = vec2(pixelSize.x, 0.0);
            vec3 vx = vec3(1, 0, texture2D(tex, qt_TexCoord0 + xps).x - texture2D(tex, qt_TexCoord0 - xps).x);

            lowp vec2 yps = vec2(0.0, pixelSize.y);
            vec3 vy = vec3(0, 1, texture2D(tex, qt_TexCoord0 + yps).x - texture2D(tex, qt_TexCoord0 - yps).x);

            vec3 n = normalize(cross(vx, vy)) * 0.5 + 0.5;

            gl_FragColor = vec4(n, 1);
        }
    "

}
