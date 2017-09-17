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

Effect {
    parameters: ListModel {
        ListElement {
            name: "threshold"
            value: 0.5
        }
    }

    // Transform slider values, and bind result to shader uniforms
    property real weight: parameters.get(0).value

    fragmentShaderSrc: "#version 130
                        uniform sampler2D source;
                        uniform float dividerValue;
                        uniform float weight;
                        mat3 G[2] = mat3[](
                            mat3( 1.0, 2.0, 1.0, 0.0, 0.0, 0.0, -1.0, -2.0, -1.0 ),
                            mat3( 1.0, 0.0, -1.0, 2.0, 0.0, -2.0, 1.0, 0.0, -1.0 )
                        );
                        uniform lowp float qt_Opacity;
                        in vec2 qt_TexCoord0;
                        out vec4 FragmentColor;
                        void main() {
                            vec2 uv = qt_TexCoord0.xy;
                            vec4 c = vec4(0.0);
                            if (uv.x < dividerValue) {
                                mat3 intensity;
                                float conv[2];
                                vec3 sample;
                                for (int i=0; i<3; ++i) {
                                    for (int j=0; j<3; ++j) {
                                        sample = texelFetch(source, ivec2(gl_FragCoord) + ivec2(i-1, j-1), 0).rgb;
                                        intensity[i][j] = length(sample) * weight;
                                    }
                                }
                                for (int i=0; i<2; ++i) {
                                    float dp3 = dot(G[i][0], intensity[0]) + dot(G[i][1], intensity[1]) + dot(G[i][2], intensity[2]);
                                    conv[i] = dp3 * dp3;
                                }
                                c = vec4(0.5 * sqrt(conv[0]*conv[0] + conv[1]*conv[1]));
                            } else {
                                c = texture2D(source, qt_TexCoord0);
                            }
                            FragmentColor = qt_Opacity * c;
                        }"
}
