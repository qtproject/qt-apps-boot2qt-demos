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
import QtDeviceUtilities.QtButtonImageProvider 1.0
import QtQuick.Controls 2.2

Item {
    id: root
    width: parent.width * 0.1
    height: parent.height
    property alias volume: volumeSlider.value
    property bool muted: root.volume == 0.0
    property bool volumeItemUp: volumeItem.y == (volumeItem.height + volumeItem.height * 0.05)

    //Volume Controls
    QtButton{
        id: toggleVolumeButton
        width: controlBar.width * 0.06
        height: width
        anchors.bottom: parent.bottom
        anchors.bottomMargin: controlBar.width * 0.02
        anchors.horizontalCenter: parent.horizontalCenter
        fillColor: _primaryGreen

        Image{
            anchors.centerIn: parent
            width: parent.width * 0.5
            height: width
            source: !muted ? "images/volume_icon.svg" : "images/mute_icon.svg"
            sourceSize.width: parent.width
            sourceSize.height: parent.height
        }
        onClicked: {
            if (volumeItem.opacity == 0)
                volumeItem.opacity = 1;
            else if (volumeItem.opacity > 0)
                volumeItem.opacity = 0;

            if (volumeItem.y === 0)
                volumeItem.y -= (volumeItem.height + volumeItem.height * 0.05);
            else if (volumeItem !== 0)
                volumeItem.y = 0;
        }
    }

    Item{
        id: volumeItem
        height: applicationWindow.height * 0.4
        anchors.right: toggleVolumeButton.left //?
        opacity: 0
        y: 0
        z: -1000
        QtButton{
            id: muteVolumeButton
            width: controlBar.width * 0.06
            height: width
            anchors.bottom: parent.bottom
            fillColor: _primaryGrey
            borderColor: "transparent"
            Image{
                anchors.centerIn: parent
                width: parent.width * 0.5
                height: parent.height * 0.5
                source: "images/mute_icon.svg"
                sourceSize.width: parent.width
                sourceSize.height: parent.height
            }
            onClicked: {
                root.volume = 0.0
            }
        }

        Slider {
            id: volumeSlider
            anchors.bottom: muteVolumeButton.top
            anchors.bottomMargin: parent.height * 0.05
            anchors.top: parent.top
            anchors.horizontalCenter: muteVolumeButton.horizontalCenter
            orientation: Qt.Vertical

            background: Rectangle{
                id: sliderBackground
                x: volumeSlider.leftPadding + volumeSlider.availableWidth / 2 - width / 2
                y: volumeSlider.bottomPadding
                implicitWidth: 5
                implicitHeight: 200
                height: volumeSlider.availableHeight
                width: implicitWidth
                radius: 2
                color: "white"
                Rectangle{
                    height: volumeSlider.visualPosition * parent.height
                    width: parent.width
                    color: _primaryGrey
                    radius: 2
                }
            }
            handle: Rectangle{
                x: volumeSlider.leftPadding + volumeSlider.availableWidth / 2 - width / 2
                y: volumeSlider.bottomPadding + volumeSlider.visualPosition * (volumeSlider.availableHeight - height)
                width: sliderBackground.width * 7
                height: width
                radius: height * 0.5
                color: _primaryGreen
            }
        }

        Behavior on opacity { NumberAnimation { duration: 100 } }
        Behavior on y { NumberAnimation { duration: 100 } }
    }
}
