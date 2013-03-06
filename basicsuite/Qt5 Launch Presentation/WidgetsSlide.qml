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
import Qt.labs.presentation 1.0

Slide {
    id: slide

    writeInText: "The Qt Widgets are working better than ever with accessibility\nimprovements and retina display support."

    property int slamTime: 800;
    property int waitTime: 500;

    y: parent.height * 0.1

    SequentialAnimation {
        id: widgetAnimation
        ScriptAction { script: {
                boxesImage.opacity = 0;
                mainwindowsImage.opacity = 0;
                chipsWindow.opacity = 0;
                stylesWindow.opacity = 0;
            }
        }
        PauseAnimation { duration: 3000 }
        ParallelAnimation {
            NumberAnimation { target: boxesImage; property: "opacity"; from: 0; to: 1; duration: slide.slamTime; easing.type: Easing.OutBack }
            NumberAnimation { target: boxesImage; property: "rotation"; from: 20; to: 10; duration: slide.slamTime; easing.type: Easing.OutBack }
            NumberAnimation { target: boxesImage; property: "scale"; from: 2; to: 1.5; duration: slide.slamTime; easing.type: Easing.OutBack }
        }
        PauseAnimation { duration: slide.waitTime }
        ParallelAnimation {
            NumberAnimation { target: mainwindowsImage; property: "opacity"; from: 0; to: 1; duration: slide.slamTime; easing.type: Easing.OutBack }
            NumberAnimation { target: mainwindowsImage; property: "rotation"; from: -35; to: -20; duration: slide.slamTime; easing.type: Easing.OutBack}
            NumberAnimation { target: mainwindowsImage; property: "scale"; from: 2; to: 1.5; duration: slide.slamTime; easing.type: Easing.OutBack }
        }
        PauseAnimation { duration: slide.waitTime }
        ParallelAnimation {
            NumberAnimation { target: chipsWindow; property: "opacity"; from: 0; to: 1; duration: slide.slamTime; easing.type: Easing.InOutCubic }
            NumberAnimation { target: chipsWindow; property: "rotation"; from: 10; to: 25; duration: slide.slamTime; easing.type: Easing.OutBack}
            NumberAnimation { target: chipsWindow; property: "scale"; from: 2.5; to: 1.6; duration: slide.slamTime; easing.type: Easing.OutBack }
        }
        PauseAnimation { duration: slide.waitTime }
        ParallelAnimation {
            NumberAnimation { target: stylesWindow; property: "opacity"; from: 0; to: 1; duration: slide.slamTime; easing.type: Easing.InOutCubic }
            NumberAnimation { target: stylesWindow; property: "rotation"; from: 30; to: -15; duration: slide.slamTime; easing.type: Easing.OutBack}
            NumberAnimation { target: stylesWindow; property: "scale"; from: 1.8; to: 1.4; duration: slide.slamTime; easing.type: Easing.OutBack }
        }
        running: false
    }

    onVisibleChanged: {
        widgetAnimation.running = slide.visible;
    }

    Row {
        x: slide.width * 0.05
        y: slide.height * 0.65;
        width: parent.width
        Image {
            id: boxesImage;
            source: "images/widgets_boxes.png"
            fillMode: Image.PreserveAspectFit
            width: slide.width * .2
            antialiasing: true
            opacity: 0;
            y: -slide.height * 0.2
            rotation: 10
            scale: 1.5;
        }
        Image {
            id: mainwindowsImage
            source: "images/widgets_mainwindows.png"
            fillMode: Image.PreserveAspectFit
            width: slide.width * .2
	    antialiasing: true
            opacity: 0
        }
        Image {
            id: chipsWindow
            source: "images/widgets_chips.png"
            fillMode: Image.PreserveAspectFit
            width: slide.width * .2
            x: slide.width * -0.05
            y: -slide.height * 0.2
            antialiasing: true
            opacity: 0
        }

        Image {
            id: stylesWindow
            source: "images/widgets_styles_fusion.png"
            fillMode: Image.PreserveAspectFit
            width: slide.width * .2

            x: slide.width * 1
            y: -slide.height * 0.1
            antialiasing: true
            opacity: 0

            Image {
                source: "images/widgets_styles_macstyle.png"
                fillMode: Image.PreserveAspectFit
                width: slide.width * .2

                x: parent.width * 0.3
                y: parent.width * 0.1
                rotation: -20
                antialiasing: true
            }
        }
    }
}

