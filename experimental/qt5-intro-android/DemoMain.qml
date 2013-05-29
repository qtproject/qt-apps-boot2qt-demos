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

Item {
     id: demoMain;

    property bool useDropShadow: true;
    property bool useSwirls: true;
    property bool useSimpleGradient: false;
    property bool autorun: false;

    width: 1280
    height: 720

    NoisyGradient {
        anchors.fill: parent;
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0.64 * 0.6, 0.82 * 0.6, 0.15 * 0.6) }
            GradientStop { position: 1.0; color: "black" }
        }
        visible: !parent.useSimpleGradient
    }

    Rectangle {
        anchors.fill: parent;
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0.64, 0.82, 0.15) }
            GradientStop { position: 1.0; color: "black" }
        }
        visible: parent.useSimpleGradient;
    }

    Rectangle {
        id: colorTable
        width: 1
        height: 46
        color: "transparent"

        Column {
            spacing: 2
            y: 1
            Rectangle { width: 1; height: 10; color: "white" }
            Rectangle { width: 1; height: 10; color: Qt.rgba(0.64 * 1.4, 0.82 * 1.4, 0.15 * 1.4, 1); }
            Rectangle { width: 1; height: 10; color: Qt.rgba(0.64, 0.82, 0.15); }
            Rectangle { width: 1; height: 10; color: Qt.rgba(0.64 * 0.7, 0.82 * 0.7, 0.15 * 0.7); }
        }

        layer.enabled: true
        layer.smooth: true
        visible: false;
    }


    Swirl
    {
        x: 0;
        width: parent.width
        height: Math.min(parent.height, parent.width) * 0.2
        anchors.bottom: parent.bottom;
        amplitude: height * 0.2;
        colorTable: colorTable;
        speed: 0.2;
        opacity: 0.3
        visible: parent.useSwirls;
    }

    Timer {
        interval: 20000
        running: parent.autorun
        repeat: true

        onTriggered: {
            var from = slides.currentSlide;
            var to = from == slides.slides.length - 1 ? 1 : from + 1;
            slides.switchSlides(slides.slides[from], slides.slides[to], true);
            slides.currentSlide = to;
	}
    }

    SlideDeck {
        id: slides
        titleColor: "white"
        textColor: "white"
        anchors.fill: parent
        layer.enabled: parent.useDropShadow
        layer.effect: DropShadow {
            horizontalOffset: slides.width * 0.005;
            verticalOffset: slides.width * 0.005;
            radius: 16.0
            samples: 16
            fast: true
            color: Qt.rgba(0.0, 0.0, 0.0, 0.7);
        }
    }



}
