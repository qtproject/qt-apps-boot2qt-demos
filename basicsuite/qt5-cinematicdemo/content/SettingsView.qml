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

    property bool isShown: false

    anchors.fill: parent

    function show() {
        isShown = true;
        hideAnimation.stop();
        showAnimation.restart();
    }
    function hide() {
        isShown = false;
        showAnimation.stop();
        hideAnimation.restart();
    }

    SequentialAnimation {
        id: showAnimation
        PropertyAction { target: backgroundItem; property: "visible"; value: true }
        ParallelAnimation {
            NumberAnimation { target: backgroundItem; property: "opacity"; to: 1; duration: 250; easing.type: Easing.InOutQuad }
            NumberAnimation { target: backgroundItem; property: "scale"; to: 1; duration: 500; easing.type: Easing.OutBack }
        }
    }
    SequentialAnimation {
        id: hideAnimation
        ParallelAnimation {
            NumberAnimation { target: backgroundItem; property: "opacity"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
            NumberAnimation { target: backgroundItem; property: "scale"; to: 0.6; duration: 500; easing.type: Easing.InOutQuad }
        }
        PropertyAction { target: backgroundItem; property: "visible"; value: false }
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.isShown
        onClicked: {
            root.hide();
        }
    }

    Image {
        id: settingsIcon
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        source: "images/settings.png"
        opacity: backgroundItem.opacity + 0.4
        MouseArea {
            anchors.fill: parent
            anchors.margins: -20
            onClicked: {
                if (root.isShown) {
                    root.hide();
                } else {
                    root.show();
                }
            }
        }
    }

    BorderImage {
        id: backgroundItem
        anchors.left: settingsIcon.horizontalCenter
        anchors.bottom: settingsIcon.verticalCenter
        width: Math.min(480, parent.width - 60)
        height: settingsContentColumn.height + 36
        source: "images/panel_bg.png"
        border.left : 22
        border.right : 10
        border.top : 5
        border.bottom : 26

        transformOrigin: Item.BottomLeft
        visible: false
        opacity: 0
        scale: 0.6

        Column {
            id: settingsContentColumn
            width: parent.width
            y: 8
            Switch {
                text: "Show movies cover lighting?"
                checked: settings.showLighting
                onCheckedChanged: {
                    settings.showLighting = checked;
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 32
                height: 1
                color: "#404040"
            }
            Switch {
                text: "Show shooting star particles?"
                checked: settings.showShootingStarParticles
                onCheckedChanged: {
                    settings.showShootingStarParticles = checked;
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 32
                height: 1
                color: "#404040"
            }
            Switch {
                text: "Show fog particles?"
                checked: settings.showFogParticles
                onCheckedChanged: {
                    settings.showFogParticles = checked;
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 32
                height: 1
                color: "#404040"
            }
            Switch {
                text: "Do you l-o-v-e colors?"
                checked: settings.showColors
                textOn: "Yes"
                textOff: "No!"
                onCheckedChanged: {
                    settings.showColors = checked;
                }
            }
        }
    }
}
