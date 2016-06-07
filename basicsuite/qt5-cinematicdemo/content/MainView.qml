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
import QtGraphicalEffects 1.0

Item {
    id: root

    // Set this to blur the mainView when showing something on top of it
    property real blurAmount: 0

    // Updates the blur shader source, best called right before adding blurAmount
    function scheduleUpdate() {
        mainContentSource.scheduleUpdate();
    }

    anchors.fill: parent

    // Update blur shader source when width/height changes
    onHeightChanged: {
        root.scheduleUpdate();
    }
    onWidthChanged: {
        root.scheduleUpdate();
    }

    Item {
        id: mainViewArea
        anchors.fill: parent

        Background {
            id: background
        }

        ListView {
            id: listView

            property real globalLightPosX: lightImage.x / root.width
            property real globalLightPosY: lightImage.y / root.height

            // Normal-mapped cover shared among delegates
            ShaderEffectSource {
                id: coverNmapSource
                sourceItem: Image { source: "images/cover_nmap.png" }
                hideSource: true
                visible: false
            }

            anchors.fill: parent
            spacing: -60
            model: moviesModel
            delegate: DelegateItem {
                name: model.name
            }
            highlightFollowsCurrentItem: true
            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightMoveDuration: 400
            preferredHighlightBegin: root.height * 0.5 - 140
            preferredHighlightEnd: root.height * 0.5 - 140
            cacheBuffer: 4000
        }

        Text {
            id: titleText
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -40
            anchors.horizontalCenter: parent.horizontalCenter
            width: 180 + parent.width * 0.25
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            text: listView.currentIndex+1 + ". " + listView.currentItem.name
            color: "#ffffff"
            style: Text.Outline
            styleColor: "#b0a030"
            font.pixelSize: settings.fontL
            Behavior on text {
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation { target: titleText; property: "opacity"; duration: 100; to: 0; easing.type: Easing.InOutQuad }
                        NumberAnimation { target: titleText; property: "scale"; duration: 100; to: 0.6; easing.type: Easing.InOutQuad }
                    }
                    PropertyAction { target: titleText; property: "text" }
                    ParallelAnimation {
                        NumberAnimation { target: titleText; property: "opacity"; duration: 100; to: 1; easing.type: Easing.InOutQuad }
                        NumberAnimation { target: titleText; property: "scale"; duration: 100; to: 1; easing.type: Easing.InOutQuad }
                    }
                }
            }
        }

        Image {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 32
            anchors.horizontalCenter: parent.horizontalCenter
            source: "images/qt_logo.png"
            opacity: listView.atYEnd
            Behavior on opacity {
                NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
            }
        }

        // Shooting star + animation + particles
        AnimatedSprite {
            id: lightImage
            width: 128
            height: 128
            frameWidth: 128
            frameHeight: 128
            frameCount: 16
            frameRate: 15
            source: "images/planet_sprite.png"
            interpolate: true
            loops: Animation.Infinite
            visible: settings.showLighting || settings.showShootingStarParticles
            running: !detailsView.isShown && !infoView.isShown && (settings.showLighting || settings.showShootingStarParticles)
        }

        PathAnimation {
            target: lightImage
            duration: 5000
            orientation: PathAnimation.RightFirst
            anchorPoint: Qt.point(lightImage.width/2, lightImage.height/2)
            running: true
            paused: detailsView.isShown || infoView.isShown || (!settings.showLighting && !settings.showShootingStarParticles)
            loops: Animation.Infinite
            path: Path {
                id: lightAnimPath
                property int w: root.width > 0 ? root.width : 1
                property int h: root.height > 0 ? root.height : 1
                startX: w*0.4; startY: h*0.3
                PathCurve { x: lightAnimPath.w*0.8; y: lightAnimPath.h*0.2 }
                PathCurve { x: lightAnimPath.w*0.8; y: lightAnimPath.h*0.7 }
                PathCurve { x: lightAnimPath.w*0.1; y: lightAnimPath.h*0.6 }
                PathCurve { x: lightAnimPath.w*0.4; y: lightAnimPath.h*0.3 }
            }
        }

        ParticleSystem {
            anchors.fill: parent
            paused: detailsView.isShown || infoView.isShown

            // Shooting star particles
            ImageParticle {
                source: "images/particle.png"
                color: "#ffefaf"
                colorVariation: settings.showColors ? 1.0 : 0.1
                alpha: 0
            }
            Emitter {
                id: shootingStarEmitter
                emitRate: settings.showShootingStarParticles ? 100 : 0
                lifeSpan: 2000
                x: lightImage.x + lightImage.width/2
                y: lightImage.y + lightImage.height/2
                velocity: PointDirection {xVariation: 8; yVariation: 8;}
                acceleration: PointDirection {xVariation: 12; yVariation: 12;}
                size: 32
                sizeVariation: 16
            }
            Emitter {
                id: shootingStarBurst
                emitRate: 0
                lifeSpan: 2000
                x: lightImage.x + lightImage.width/2
                y: lightImage.y + lightImage.height/2
                velocity: PointDirection {xVariation: 60; yVariation: 60;}
                acceleration: PointDirection {xVariation: 40; yVariation: 40;}
                size: 24
                sizeVariation: 16
            }

            // Dust/Smoke particles
            ImageParticle {
                groups: ["smoke"]
                source: "images/smoke.png"
                color: "#ffffff"
                alpha: 0.9
                opacity: 0.8
                colorVariation: settings.showColors ? 0.9 : 0.0
                rotationVariation: 180
            }
            Emitter {
                y: root.height * 0.85
                anchors.horizontalCenter: parent.horizontalCenter
                width: 200 + parent.width * 0.1
                height: root.height * 0.3
                emitRate: settings.showFogParticles ? 8 : 0
                lifeSpan: 2000
                lifeSpanVariation: 1000
                group: "smoke"
                size: 192
                sizeVariation: 64
                acceleration: PointDirection { y: -80; xVariation: 20 }
            }
            Emitter {
                y: root.height * 0.9
                anchors.horizontalCenter: parent.horizontalCenter
                width: 200 + parent.width * 0.1
                height: root.height * 0.2
                emitRate: settings.showFogParticles ? 10 : 0
                lifeSpan: 2000
                group: "smoke"
                size: 192
                sizeVariation: 64
                acceleration: PointDirection { y: -20; xVariation: 40 }
            }
            Turbulence {
                groups: ["smoke"]
                width: parent.width
                height: parent.height * 0.8
                strength: 60
            }
        }

        SettingsView {
            id: settingsView
        }
    }

    FastBlur {
        anchors.fill: mainViewArea
        radius: root.blurAmount
        visible: root.blurAmount
        source: ShaderEffectSource {
            id: mainContentSource
            anchors.fill: parent
            sourceItem: mainViewArea
            hideSource: false
            live: false
            visible: root.blurAmount
        }
    }
}
