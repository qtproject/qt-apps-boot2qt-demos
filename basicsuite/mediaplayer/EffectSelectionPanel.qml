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

Rectangle {
    id: root
    color: _backgroundColor
    property int itemHeight: 25
    property string effectSource: ""
    property bool isMouseAbove: mouseAboveMonitor.containsMouse

    Keys.onEscapePressed: visible = false

    signal clicked
    QtObject {
        id: d
        property Item selectedItem
    }

    ListModel {
        id: sources
        ListElement { name: "No effect"; source: "Effects/EffectPassThrough.qml" }
        ListElement { name: "Billboard"; source: "Effects/EffectBillboard.qml" }
        ListElement { name: "Black & white"; source: "Effects/EffectBlackAndWhite.qml" }
        ListElement { name: "Blur"; source: "Effects/EffectGaussianBlur.qml" }
        ListElement { name: "Edge detection"; source: "Effects/EffectSobelEdgeDetection1.qml" }
        ListElement { name: "Emboss"; source: "Effects/EffectEmboss.qml" }
        ListElement { name: "Glow"; source: "Effects/EffectGlow.qml" }
        ListElement { name: "Isolate"; source: "Effects/EffectIsolate.qml" }
        //ListElement { name: "Magnify"; source: "Effects/EffectMagnify.qml" }
        //        ListElement { name: "Page curl"; source: "Effects/EffectPageCurl.qml" }
        ListElement { name: "Pixelate"; source: "Effects/EffectPixelate.qml" }
        ListElement { name: "Posterize"; source: "Effects/EffectPosterize.qml" }
        //        ListElement { name: "Ripple"; source: "Effects/EffectRipple.qml" }
        ListElement { name: "Sepia"; source: "Effects/EffectSepia.qml" }
        ListElement { name: "Sharpen"; source: "Effects/EffectSharpen.qml" }
        ListElement { name: "Shockwave"; source: "Effects/EffectShockwave.qml" }
        //        ListElement { name: "Tilt shift"; source: "Effects/EffectTiltShift.qml" }
        ListElement { name: "Toon"; source: "Effects/EffectToon.qml" }
        ListElement { name: "Warhol"; source: "Effects/EffectWarhol.qml" }
        ListElement { name: "Wobble"; source: "Effects/EffectWobble.qml" }
        ListElement { name: "Vignette"; source: "Effects/EffectVignette.qml" }
    }

    Component {
        id: sourceDelegate
        Item {
            id: sourceDelegateItem
            width: root.width
            height: itemHeight

            Text {
                id: sourceSelectorItem
                anchors.centerIn: parent
                width: 0.9 * parent.width
                height: 0.8 * itemHeight
                text: name
                color: "white"
                font.family: appFont
            }

            states: [
                State {
                    name: "selected"
                    PropertyChanges {
                        target: sourceSelectorItem
                        bgColor: "#ff8888"
                    }
                }
            ]

            transitions: [
                Transition {
                    from: "*"
                    to: "*"
                    ColorAnimation {
                        properties: "color"
                        easing.type: Easing.OutQuart
                        duration: 500
                    }
                }
            ]
        }
    }

    MouseArea {
        id: mouseAboveMonitor
        anchors.fill: parent
        hoverEnabled: true
    }

    ListView {
        id: list
        anchors.fill: parent
        clip: true
        anchors.margins: itemMargin
        model: sources
        focus: root.visible && root.opacity && urlBar.opacity === 0

        currentIndex: 0

        onCurrentIndexChanged : {
            effectSource = model.get(currentIndex).source
            root.clicked()
            applicationWindow.resetTimer()
        }

        delegate: Item {
            height: itemHeight
            width: parent.width
            property bool isSelected: list.currentIndex == index
            Text {
                color: parent.isSelected ? _primaryGreen : "white"
                text: name
                anchors.centerIn: parent
                font.pixelSize: defaultFontSize
                font.family: appFont
                font.styleName: parent.isSelected ? "Bold" : "Regular"
            }
            MouseArea {
                anchors.fill: parent
                onClicked:  list.currentIndex = index
            }
        }
    }
}
