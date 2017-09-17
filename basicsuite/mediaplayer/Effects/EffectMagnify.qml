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
    id: root
    divider: false
    parameters: ListModel {
        ListElement {
            name: "radius"
            value: 0.5
        }
        ListElement {
            name: "diffraction"
            value: 0.5
        }
    }

    property real posX: -1
    property real posY: -1

    QtObject {
        id: d
        property real oldTargetWidth: root.targetWidth
        property real oldTargetHeight: root.targetHeight
    }

    // Transform slider values, and bind result to shader uniforms
    property real radius: parameters.get(0).value * 100
    property real diffractionIndex: parameters.get(1).value

    onTargetWidthChanged: {
        if (posX == -1)
            posX = targetWidth / 2
        else if (d.oldTargetWidth != 0)
            posX *= (targetWidth / d.oldTargetWidth)
        d.oldTargetWidth = targetWidth
    }

    onTargetHeightChanged: {
        if (posY == -1)
            posY = targetHeight / 2
        else if (d.oldTargetHeight != 0)
            posY *= (targetHeight / d.oldTargetHeight)
        d.oldTargetHeight = targetHeight
    }

    fragmentShaderSrc: "uniform sampler2D source;
                        uniform lowp float qt_Opacity;
                        varying vec2 qt_TexCoord0;
                        uniform float radius;
                        uniform float diffractionIndex;
                        uniform float targetWidth;
                        uniform float targetHeight;
                        uniform float posX;
                        uniform float posY;

                        void main()
                        {
                            vec2 tc = qt_TexCoord0;
                            vec2 center = vec2(posX, posY);
                            vec2 xy = gl_FragCoord.xy - center.xy;
                            float r = sqrt(xy.x * xy.x + xy.y * xy.y);
                            if (r < radius) {
                                float h = diffractionIndex * 0.5 * radius;
                                vec2 new_xy = r < radius ? xy * (radius - h) / sqrt(radius * radius - r * r) : xy;
                                vec2 targetSize = vec2(targetWidth, targetHeight);
                                tc = (new_xy + center) / targetSize;
                                tc.y = 1.0 - tc.y;
                            }
                            gl_FragColor = qt_Opacity * texture2D(source, tc);
                        }"

    MouseArea {
        anchors.fill: parent
        onPositionChanged: { root.posX = mouse.x; root.posY = root.targetHeight - mouse.y }
    }
}
