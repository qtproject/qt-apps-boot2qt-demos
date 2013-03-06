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

import Qt.labs.presentation 1.0

Slide {
    id: slide

    title: "Qt Graphical Effects"
    writeInText: "The Qt Graphical Effects module includes a wide range of effects:"

    property real t;
    SequentialAnimation on t {
        NumberAnimation { from: 0; to: 1; duration: 5000; easing.type: Easing.InOutCubic }
        NumberAnimation { from: 1; to: 0; duration: 5000; easing.type: Easing.InOutCubic }
        loops: Animation.Infinite
        running: slide.visible;
    }

    SequentialAnimation {
        PropertyAction { target: grid; property: "opacity"; value: 0 }
        PauseAnimation { duration: 1500 }
        NumberAnimation { target: grid; property: "opacity"; to: 1; duration: 2000; easing.type: Easing.InOutCubic }
        running: slide.visible;
    }

    Grid {
        id: grid;

        opacity: 0;

        width: parent.width
        height: parent.height * 0.84
        anchors.bottom: parent.bottom;

        property real cw: width / columns
        property real ch: height / rows;

        property int fontSize: slide.baseFontSize * 0.5

        columns: 4
        rows: 2

        Item {
            width: grid.cw
            height: grid.ch
            Text { text: "Original"; color: "white"; font.pixelSize: grid.fontSize; anchors.horizontalCenter: noEffect.horizontalCenter }
            Image {
                id: noEffect;
                source: "images/butterfly.png"
                width: grid.cw * 0.9
                fillMode: Image.PreserveAspectFit
            }
        }

        Column {
            Glow {
                id: glowEffect
                radius: 4
                samples: 4
                spread: slide.t
                source: noEffect
                width: grid.cw * 0.9
                height: width;
                Text { text: "Glow"; color: "white"; font.pixelSize: grid.fontSize; anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter; }
            }
        }

        Column {
            InnerShadow {
                id: innerShadowEffect
                radius: slide.t * 16;
                samples: 16
                color: "black"
                source: noEffect
                width: grid.cw * 0.9
                height: width;
                Text { text: "InnerShadow"; color: "white"; font.pixelSize: grid.fontSize; anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter; }
            }
        }

        Column {
            GaussianBlur {
                id: blurEffect
                radius: slide.t * samples;
                samples: 8
                source: noEffect
                width: grid.cw * 0.9
                height: width;
                Text { text: "GaussianBlur"; color: "white"; font.pixelSize: grid.fontSize; anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter; }
            }
        }

        Column {
            ThresholdMask {
                id: thresholdEffect
                maskSource: Image { source: "images/fog.png" }
                threshold: slide.t * 0.5 + 0.2;
                spread: 0.2
                source: noEffect
                width: grid.cw * 0.9
                height: width;
                Text { text: "ThresholdMask"; color: "white"; font.pixelSize: grid.fontSize; anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter; }
            }
        }

        Column {
            BrightnessContrast {
                id: brightnessEffect
                brightness: Math.sin(slide.t * 2 * Math.PI) * 0.5;
                contrast: Math.sin(slide.t * 4 * Math.PI) * 0.5;
                source: noEffect
                width: grid.cw * 0.9
                height: width;
                Text { text: "BrightnessContrast"; color: "white"; font.pixelSize: grid.fontSize; anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter; }
            }
        }

        Column {
            Colorize {
                id: colorizeEffect
                hue: slide.t
                source: noEffect
                width: grid.cw * 0.9
                height: width;
                Text { text: "Colorize"; color: "white"; font.pixelSize: grid.fontSize; anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter; }
            }
        }

        Column {
            OpacityMask {

                Item {
                    id: maskSource;
                    anchors.fill: parent;
                    Rectangle {
                        anchors.fill: parent;
                        opacity: slide.t;
                    }

                    Text {
                        text: "Qt 5"
                        font.pixelSize: parent.height * 0.15
                        font.bold: true;
                        font.underline: true;
                        anchors.centerIn: parent;
                        rotation: 70
                    }
                    visible: false;
                }

                id: opacityMaskEffect
                source: noEffect
                maskSource: maskSource;
                width: grid.cw * 0.9
                height: width;
                Text { text: "OpacityMask"; color: "white"; font.pixelSize: grid.fontSize; anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter; }
            }
        }
    }

}
