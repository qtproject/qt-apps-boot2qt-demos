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
import QtQuick 2.7
import QtCharts 2.1
import SensorTag.DataProvider 1.0
import QtGraphicalEffects 1.0

BaseChart {
    id: tempHolderRect

    property int temperatureSeriesIndex: 0
    property int maxNumOfTempReadings: 30
    property real minimum: 10
    property real maximum: 40

    property real defaultAvgValue: 25
    property real minValue: defaultAvgValue
    property real maxValue: defaultAvgValue
    readonly property real avgValue: (maxValue - minValue) / 2
    property real value

    readonly property color legendColor: "white"
    readonly property color chartColor: "#15bdff"

    onSensorChanged: if (sensor) {
        sensor.infraredAmbientTemperatureChanged.connect(contentItem.updateTemperatureGraph)
    }

    title: qsTr("Ambient Temperature")

    content: Item {
        anchors.fill: parent

        Component.onCompleted: {
            // Initialize series
            var i = 0
            while (i < maxNumOfTempReadings) {
                avgTempSeries.append(i, defaultAvgValue)
                i++
            }
            temperatureSeriesIndex = i
        }

        function updateTemperatureGraph() {
            // Make sure defaultAvgValue is the last valuea in the series
            avgTempSeries.remove(temperatureSeriesIndex - 1, defaultAvgValue);
            avgTempSeries.append(temperatureSeriesIndex - 1, sensor.infraredAmbientTemperature);
            avgTempSeries.append(temperatureSeriesIndex, defaultAvgValue);

            if (temperatureSeriesIndex >= maxNumOfTempReadings) {
                avgTempSeries.remove(avgTempSeries.at(temperatureSeriesIndex - maxNumOfTempReadings));
                valueAxisX.min++;
                valueAxisX.max++;
            }
            temperatureSeriesIndex++;

            var value = sensor.infraredAmbientTemperature;
            if (minValue > value)
                minValue = value;
            if (maxValue < value)
                maxValue = value;
        }

        Item {
            id: valueReading

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height - 32

            Text {
                id: highValue

                text: "Highest\n" + (maxValue !== Number.MIN_VALUE ? maxValue : "--")
                lineHeight: 0.7
                width: contentWidth
                height: contentHeight
                horizontalAlignment: Text.Center
                anchors.right: reading.left
                anchors.top: parent.top
                color: "white"
            }

            Image {
                id: reading
                source: pathPrefix + "Accelometer/outer_ring.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: avgText.left

                Text {
                    anchors.centerIn: parent
                    text: sensor ? sensor.infraredAmbientTemperature : ""
                    color: "white"
                    font.pixelSize: 26
                }
            }

            Text {
                text: (minValue !== Number.MAX_VALUE ? minValue : "--") + "\nLowest"
                lineHeight: 0.8
                width: contentWidth
                horizontalAlignment: Text.Center
                color: "white"
                anchors.bottom: parent.bottom
                anchors.right: reading.left
            }

            Text {
                id: avgText
                text: "Avg\n" + (sensor ? sensor.barometerTemperatureAverage.toFixed(1) : "")
                lineHeight: 0.8
                width: contentWidth
                horizontalAlignment: Text.Center
                color: "white"
                anchors.right: parent.right
                anchors.verticalCenter: reading.verticalCenter
            }
        }

        Image {
            source: pathPrefix + "AmbientTemperature/temp_sensor.png"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        Glow {
            anchors.fill: chartView
            radius: 18
            samples: 30
            color: "#15bdff"
            source: chartView
        }

        ChartView {
            id: chartView

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: valueReading.left
            anchors.rightMargin: 112
            antialiasing: true
            backgroundColor: "transparent"
            legend.visible: false
            margins.top: 0
            margins.bottom: 0
            margins.left: 0

            // Hide the value axis labels; labels are drawn separately.
            ValueAxis {
                id: valueAxisX

                min: 0
                max: maxNumOfTempReadings + 1
                visible: false
            }

            ValueAxis {
                id: valueAxisY

                min: minimum
                max: maximum
                visible: false
            }

            LineSeries {
                id: avgTempSeries

                axisX: valueAxisX
                axisY: valueAxisY
                color: chartColor
                width: 1
                useOpenGL: true
            }
        }
    }
}
