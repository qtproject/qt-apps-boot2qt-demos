/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
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
import QtQuick.Layouts 1.1
import Style 1.0
import SensorTag.DataProvider 1.0

Rectangle {
    id: sourceSelector
    property alias sensorCount : sensorListView.count
    property color selectedBackgroundColor : "#15bdff"
    property color deselectedBackgroundColor: "transparent"

    color: "transparent"
    width: 800
    height: 800
    anchors.horizontalCenter: parent.horizontalCenter

    Image {
        source: "images/bg_blue.jpg"
        anchors.fill: parent
    }

    Image {
        id: separator
        source: pathPrefix + "General/separator.png"
        anchors.top: parent.top
        width: parent.width
        transform: Rotation {
            origin.x: separator.width / 2
            origin.y: separator.height / 2
            angle: 180
        }
    }

    Rectangle {
        id: buttonRect
        anchors.top: separator.bottom
        anchors.margins: 20
        color: "transparent"
        width: parent.width - 20
        height: 40

        Rectangle {
            border.color: "white"
            color: localSelected ? sourceSelector.selectedBackgroundColor : sourceSelector.deselectedBackgroundColor
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.width / 2
            height: 30
            Text {
                text: "Local"
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 26
            }
        }

        Rectangle {
            border.color: "white"
            color: !localSelected ? sourceSelector.selectedBackgroundColor : sourceSelector.deselectedBackgroundColor
            anchors.top: parent.top
            anchors.right: parent.right
            width: parent.width / 2
            height: 30
            Text {
                text: "Remote"
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 26
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: localSelected = !localSelected
        }
    }

    ListView {
        id: sensorListView
        model: localSelected ? (localProviderPool ? localProviderPool.dataProviders : 0)
                                            : (remoteProviderPool ? remoteProviderPool.dataProviders : 0)

        width: buttonRect.width
        anchors.top: buttonRect.bottom
        anchors.bottom: connectButton.top
        focus: true
        clip: true

        delegate: Rectangle {
            border.color: "white"
            color: ListView.isCurrentItem ? sourceSelector.selectedBackgroundColor
                                          : sourceSelector.deselectedBackgroundColor
            radius: 5
            height: 30
            width: parent.width
            Text {
                text: providerId
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 26
            }
            MouseArea {
                anchors.fill: parent
                onClicked: sensorListView.currentIndex = index
            }
        }
    }

    Rectangle {
        id: connectButton
        width: buttonRect.width / 2
        height: 30
        anchors.bottom: bottomSeparator.top
        anchors.right: parent.right
        color: sensorListView.currentIndex != -1 ? sourceSelector.selectedBackgroundColor : "transparent"
        border.color: "white"
        Text {
            text: "Connect"
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 26
        }
        MouseArea {
            id: connectButtonArea
            anchors.fill: parent
            enabled: sensorListView.currentIndex != -1
            onClicked: {
                clickBait.deactivate()

                var currentPool = getCurrentPool();
                if (currentPool.dataProviders[sensorListView.currentIndex] === singleSensorSource) {
                    console.log("Same data provider selected, nothing to change...")
                    return;
                }

                if (singleSensorSource)
                    singleSensorSource.endDataFetching();
                // UI gets information about the intended setup of the
                // sensor even though they have not been really discovered yet
                if (currentPool) {
                    singleSensorSource = currentPool.dataProviders[sensorListView.currentIndex]
                    currentPool.currentProviderIndex = sensorListView.currentIndex

                    seriesStorage.setDataProviderPool(currentPool);
                    seriesStorage.dataProviderPoolChanged();

                    singleSensorSource.startDataFetching()
                }
            }
        }
    }

    Image {
        id: bottomSeparator
        source: pathPrefix + "General/separator.png"
        anchors.bottom: parent.bottom
        width: parent.width
    }
}
