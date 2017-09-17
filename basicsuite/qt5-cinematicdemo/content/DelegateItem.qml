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

Item {
    id: root

    property string name
    property bool isSelected: listView.currentIndex === index

    width: parent ? parent.width : imageItem.width
    height: imageItem.height
    z: isSelected ? 1000 : -index
    rotation: isSelected ? 0 : -15
    scale: isSelected ? mainView.height/540 : mainView.height/1080
    opacity: 1.0 - Math.abs((listView.currentIndex - index) * 0.25)

    Behavior on rotation {
        NumberAnimation { duration: 500; easing.type: Easing.OutBack }
    }
    Behavior on scale {
        NumberAnimation { duration: 1500; easing.type: Easing.OutElastic }
    }
    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (isSelected) {
                detailsView.image = model.image
                detailsView.name =  model.name
                detailsView.year = model.year
                detailsView.director = model.director
                detailsView.cast = model.cast
                detailsView.rating = model.rating
                detailsView.overview = model.overview
                detailsView.show();
            } else {
                listView.currentIndex = index;
                if (settings.showShootingStarParticles) shootingStarBurst.burst(50);
            }
        }
    }

    Image {
        id: imageItem
        anchors.horizontalCenter: parent.horizontalCenter
        source: "images/" + model.image
        visible: !settings.showLighting
    }

    ShaderEffectSource {
        id: s1
        sourceItem: imageItem
        hideSource: settings.showLighting
        visible: settings.showLighting
    }

    ShaderEffect {
        anchors.fill: imageItem
        property variant src: s1
        property variant srcNmap: coverNmapSource
        property real widthPortition: mainView.width/imageItem.width
        property real heightPortition: mainView.height/imageItem.height
        property real widthNorm: widthPortition * 0.5 - 0.5
        property real heightNorm: root.y/imageItem.height - listView.contentY / imageItem.height
        property real lightPosX: listView.globalLightPosX * widthPortition - widthNorm
        property real lightPosY: listView.globalLightPosY * heightPortition - heightNorm
        visible: settings.showLighting

        fragmentShader: "
            uniform sampler2D src;
            uniform sampler2D srcNmap;
            uniform lowp float qt_Opacity;
            varying highp vec2 qt_TexCoord0;
            uniform highp float lightPosX;
            uniform highp float lightPosY;
            void main() {
                highp vec4 pix = texture2D(src, qt_TexCoord0.st);
                highp vec4 pix2 = texture2D(srcNmap, qt_TexCoord0.st);
                highp vec3 normal = normalize(pix2.rgb * 2.0 - 1.0);
                highp vec3 light_pos = normalize(vec3(qt_TexCoord0.x - lightPosX, qt_TexCoord0.y - lightPosY, 0.8 ));
                highp float diffuse = max(dot(normal, light_pos), 0.2);

                // boost a bit
                diffuse *= 2.5;

                highp vec3 color = diffuse * pix.rgb;
                gl_FragColor = vec4(color, pix.a) * qt_Opacity;
            }
        "
    }
}
