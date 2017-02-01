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
import QtQuick 2.5
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtCharts 2.1
import SensorTag.DataProvider 1.0
import QtQuick.Extras 1.4

BaseChart {
    property int humiditySeriesIndex: 0
    property int maxNumOfHumiReadings: 30
    property real humidityValue: 0

    antialiasing: true
    title: qsTr("Humidity")

    onSensorChanged: if (sensor) {
        sensor.relativeHumidityChanged.connect(contentItem.getMaxOchMinHum)
    }

    content: Item {
        anchors.fill: parent

        property alias humiText: humidityMainText.text
        property real maxHumi: 0
        property real minHumi: 1000

        function getMaxOchMinHum()
        {
            humidityValue = sensor.relativeHumidity;
            contentItem.humiText = humidityValue.toFixed(1) + " %";

            if (humidityValue > contentItem.maxHumi)
            {
                contentItem.maxHumi = humidityValue
            }

            if (humidityValue < contentItem.minHumi)
            {
                contentItem.minHumi = humidityValue;
            }
        }

        Image {
            id: humidityMainImg

            source: pathPrefix + "Humidity/humidity_base_gauge.png"
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.bottom: parent.bottom
            width: height

            Text {
                id: humidityMainText

                anchors.centerIn: parent
                color: "white"
            }
        }

        Image {
            source: pathPrefix + "Humidity/humidity_min_hum.png"
            anchors.left: humidityMainImg.right
            anchors.leftMargin: -7
            anchors.bottom: humidityMainImg.bottom

            Text {
                anchors.bottom: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -10
                text: "min"
                color: "white"
            }

            Text{
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 10
                text: minHumi.toFixed(1) + " %"
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                color: "white"
            }
        }

        Image {
            source: pathPrefix + "Humidity/humidity_max_hum.png"
            anchors.left: humidityMainImg.right
            anchors.leftMargin: -18
            anchors.top: parent.top

            Text {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -10
                text: "max"
                color: "white"
            }

            Text{
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: maxHumi.toFixed(1) + "%"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignRight
                color: "white"
            }
        }
    }
}
