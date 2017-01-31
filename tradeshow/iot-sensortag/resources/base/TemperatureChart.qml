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

BaseChart {
    id: tempHolderRect

    property int temperatureSeriesIndex: 0
    property int maxNumOfTempReadings: 240
    property real minimum: 10
    property real maximum: 40

    property real minValue: Number.MAX_VALUE
    property real maxValue: Number.MIN_VALUE
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

        function updateTemperatureGraph() {
            avgTempSeries.append(temperatureSeriesIndex, sensor.infraredAmbientTemperature);

            if (temperatureSeriesIndex >= maxNumOfTempReadings) {
                avgTempSeries.remove(avgTempSeries.at(temperatureSeriesIndex-maxNumOfTempReadings));
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
            anchors.top: chartView.top
            anchors.topMargin: chartView.plotArea.y - 16
            width: childrenRect.width
            height: childrenRect.height

            Text {
                id: highValue

                text: "Highest\n" + (maxValue !== Number.MIN_VALUE ? maxValue : "--")
                lineHeight: 0.7
                width: 60
                horizontalAlignment: Text.Center
                anchors.horizontalCenter: reading.horizontalCenter
                color: "white"
            }

            Image {
                id: reading

                source: pathPrefix + "AmbientTemperature/ambTemp_display_amb.png"
                anchors.top: highValue.bottom
                anchors.topMargin: 10

                Text {
                    anchors.centerIn: parent
                    text: sensor ? sensor.infraredAmbientTemperature : ""
                    color: "white"
                }
            }

            Text {
                text: (minValue !== Number.MAX_VALUE ? minValue : "--") + "\nLowest"
                lineHeight: 0.8
                width: 60
                horizontalAlignment: Text.Center
                color: "white"
                anchors.top: reading.bottom
                anchors.topMargin: 6
                anchors.horizontalCenter: reading.horizontalCenter
            }

            Text {
                text: "Avg\n" + (sensor ? sensor.barometerTemperatureAverage.toFixed(1) : "")
                lineHeight: 0.8
                width: 60
                horizontalAlignment: Text.Center
                color: "white"
                anchors.left: reading.right
                anchors.verticalCenter: reading.verticalCenter
            }
        }

        ChartView {
            id: chartView

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: xLegend.height + 8
            anchors.left: parent.left
            anchors.leftMargin: -25
            anchors.right: valueReading.left
            anchors.rightMargin: -20
            antialiasing: true
            backgroundColor: "transparent"
            legend.visible: false
            margins.top: 0
            margins.bottom: 0
            margins.left: 0

            // Hide the value axis labels; labels are drawn separately.
            ValueAxis {
                id: valueAxisX

                labelsVisible: false
                min: 0
                max: maxNumOfTempReadings + 1
                tickCount: 6
                labelsColor: legendColor
                color: chartColor
                gridLineColor: chartColor
            }

            ValueAxis {
                id: valueAxisY

                labelsVisible: false
                min: minimum
                max: maximum
                tickCount: 7
                color: chartColor
                gridLineColor: chartColor
            }

            LineSeries {
                id: avgTempSeries

                axisX: valueAxisX
                axisY: valueAxisY
                color: chartColor
                width: 1
                useOpenGL: true
            }

            Column {
                id: col
                property int step: (valueAxisY.max - valueAxisY.min) / (valueAxisY.tickCount - 1)
                spacing: (valueAxisY.tickCount - 0.7) / 2
                y: chartView.plotArea.y - 10
                x: 24
                z: 5

                Repeater {
                    model: valueAxisY.tickCount

                    Text {
                        text: valueAxisY.max - index * col.step
                        horizontalAlignment: Text.AlignRight
                        width: 20
                        color: legendColor
                        font: fontMetrics.font
                    }
                }
            }

            Row {
                id: xLegend

                x: chartView.plotArea.x
                y: chartView.plotArea.y + chartView.plotArea.height + height + 6
                spacing: (chartView.plotArea.width) / (valueAxisX.tickCount - 0.7) + 1

                Repeater {
                    model: valueAxisX.tickCount

                    // Enclosing Text inside Item allows layouting Text correctly on the axis
                    Item {
                        width: 1
                        height: 1

                        Text {
                            id: legendText

                            text: index
                            color: legendColor
                            anchors.horizontalCenter: parent.horizontalCenter
                            font: fontMetrics.font
                        }
                    }
                }
            }

            Text {
                text: "°C"
                anchors.top: parent.top
                anchors.topMargin: chartView.plotArea.y - height - 4
                anchors.right: col.right
                color: legendColor
                font: fontMetrics.font
            }

            Text {
                text: "h"
                anchors.top: xLegend.top
                x: chartView.plotArea.x + chartView.plotArea.width + 16
                color: legendColor
                font: fontMetrics.font
            }
        }
    }

    // Create TextMetrics to allow easy use of the same font in the ChartView
    TextMetrics {
        id: fontMetrics

        font.family: "Titillium Web"
        font.pixelSize: 14
        text: "m"
    }
}
