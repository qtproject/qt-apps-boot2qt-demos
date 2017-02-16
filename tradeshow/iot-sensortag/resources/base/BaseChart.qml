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
import Style 1.0
import SensorTag.DataProvider 1.0

Item {
    id: baseChart

    property var sensor: null
    property string title
    property alias contentItem: loader.item
    property alias content: loader.sourceComponent
    property bool rightSide: false
    property alias titlePaneHeight: titleIcon.height
    property bool hasData: baseChart.sensor ? baseChart.sensor.state === SensorTagData.Connected : false
    property int sensorState: sensor ? sensor.state : SensorTagData.NotFound

    signal clicked

    onSensorStateChanged: {
        if (sensorState === SensorTagData.Scanning)
            sensorIcon.startBlinking();
        else
            sensorIcon.stopBlinking();
    }

    Image {
        id: titleIcon

        anchors.top: parent.top
        source: pathPrefix + "General/icon_sensor.png"
    }

    Text {
        color: "white"
        text: title.toUpperCase()
        font.pixelSize: Style.indicatorTitleFontSize
        anchors.left: titleIcon.right
        anchors.leftMargin: 14
        anchors.top: parent.top
        anchors.topMargin: -8
    }

    Loader {
        id: loader

        anchors.top: titleIcon.bottom
        anchors.bottom: separator.bottom
        anchors.bottomMargin: 16
        anchors.left: parent.left
        anchors.right: parent.right
        visible: sensorState === SensorTagData.Connected
    }

    Item {
        anchors.top: titleIcon.bottom
        anchors.bottom: separator.bottom
        anchors.bottomMargin: 16
        anchors.left: parent.left
        anchors.right: parent.right
        visible: sensorState === SensorTagData.Scanning ||
                 sensorState === SensorTagData.Disconnected ||
                 sensorState === SensorTagData.Error ||
                 sensorState === SensorTagData.NotFound

        Column {
            anchors.centerIn: parent
            spacing: 20

            BlinkingIcon {
                id: sensorIcon

                source: pathPrefix + "Toolbar/icon_topbar_sensor.png"
                anchors.horizontalCenter: parent.horizontalCenter
                visible: sensorState === SensorTagData.Scanning
            }

            Text {
                id: stateText

                color: "white"
                text: sensorState === SensorTagData.Scanning ? "Connecting to sensor..."
                        : sensorState === SensorTagData.Disconnected ? "Disconnected"
                        : sensorState === SensorTagData.NotFound ? "Device not found"
                        : ""
            }
        }
    }

    Image {
        id: separator

        source: pathPrefix + "General/separator.png"
        anchors.bottom: parent.bottom
        transform: Rotation {
            origin.x: separator.width / 2
            origin.y: separator.height / 2
            axis.x: 0
            axis.y: 1
            axis.z: 0
            angle: rightSide ? 180 : 0
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: baseChart.clicked()
    }
}
