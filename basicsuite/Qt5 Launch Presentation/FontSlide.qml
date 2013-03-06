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
    id: fontSlide;
    title: "Qt Quick -  Fonts"
    writeInText: "The default font rendering in Qt Quick 2.0 uses distance fields, making\nit possible to do fully transformable text with subpixel positioning and\nsubpixel antialiasing.

Native font rendering is also an option for applications that want to look native."

    Rectangle {
        id: textRoot
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: parent.width * 0.2
        anchors.verticalCenterOffset: parent.width * 0.1

        width: 120
        height: 40

        color: "transparent"
        border.color: "white"
        border.width: 1

        Text {
            anchors.centerIn: parent

            text: "Awesome!"
            color: "white"

            font.pixelSize: 20;

            SequentialAnimation on scale {
                NumberAnimation { to: 4; duration: 2508; easing.type: Easing.OutElastic }
                NumberAnimation { to: 1; duration: 2508; easing.type: Easing.OutElastic }
                PauseAnimation { duration: 1000 }
                loops: Animation.Infinite
                running: fontSlide.visible
            }

            NumberAnimation on rotation { from: 0; to: 360; duration: 10000; loops: Animation.Infinite; easing.type: Easing.InOutCubic; running: fontSlide.visible }
        }
    }

    ShaderEffectSource {
        width: textRoot.width
        height: textRoot.height
        sourceItem: textRoot
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        smooth: false
        transformOrigin: Item.BottomLeft;

        visible: true

        scale: 4;
    }

}
