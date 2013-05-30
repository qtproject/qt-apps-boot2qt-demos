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

Slide
{
    id: slide

    title: "Qt Quick 2 Interactive Demos"
    shouldTimeout: false

    Row {
        id: exampleRow
        anchors.centerIn: parent
        height: parent.height
        width: item1.width + spacing * 3 + (item2.visible ? item2.width : 0) + (item3.visible ? item3.width : 0)

        spacing: Math.max(10, (width - 320 * 3) / 2)

        Item {
            id: item1
            width: 320
            height: 480
            clip: true
            MouseArea {
                anchors.fill: parent

                Loader {
                    id: load1
                }
            }

        }

        Item {
            id: item2
            width: 320
            height: 480
            visible: masterWidth > masterHeight
            clip: true;
            MouseArea {
                anchors.fill: parent
                Loader {
                    id: load2
                }
            }
        }

        Item {
            id: item3
            width: 320
            height: 480
            visible: masterWidth > masterHeight
            clip: true;
            MouseArea {
                Loader {
                    id: load3
                }
                anchors.fill: parent
            }
        }
    }      

    Text {
        id: showMore
        text: "Rotate the device for more"
        color: textColor
        anchors.top: exampleRow.bottom
        font.family: slides[currentSlide].fontFamily
        font.pixelSize: slides[currentSlide].fontSize * 0.6
        visible: masterWidth < masterHeight
        anchors.horizontalCenter: parent.horizontalCenter
    }

    onVisibleChanged: {
        if (visible) {
            load1.source = "maroon/Maroon.qml"
            load2.source = "samegame/Samegame.qml"
            load3.source = "calqlatr/Calqlatr.qml"
        } else {
            load1.source = ""
            load2.source = ""
            load3.source = ""
        }
    }
}
