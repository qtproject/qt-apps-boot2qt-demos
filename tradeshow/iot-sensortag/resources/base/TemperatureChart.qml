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

    property int maxNumOfTempReadings: 30
    property real minimum: 10
    property real maximum: 40

    property real defaultAvgValue: (maximum + minimum) / 2
    property real minValue: defaultAvgValue
    property real maxValue: defaultAvgValue
    property real value: sensor ? sensor.infraredAmbientTemperature : 0

    readonly property color legendColor: "white"
    readonly property color chartColor: "#15bdff"

    onValueChanged: {
        if (minValue > value)
            minValue = value;
        if (maxValue < value)
            maxValue = value;
    }

    title: qsTr("Ambient Temperature")

    content: Item {
        anchors.fill: parent

        Connections {
            target: mainWindow
            onSeriesStorageChanged: {
                if (seriesStorage)
                    seriesStorage.setTemperatureSeries(avgTempSeries);
            }
        }

        Item {
            id: valueReading

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height - 32
            width: reading.width + avgText.width

            Text {
                id: highValue

                text: "Hi " + (maxValue !== Number.MIN_VALUE ? maxValue.toFixed(1) : "--")
                lineHeight: 0.7
                width: contentWidth
                height: contentHeight
                horizontalAlignment: Text.Center
                anchors.horizontalCenter: reading.horizontalCenter
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
                    text: sensor ? sensor.infraredAmbientTemperature.toFixed(1) : ""
                    color: "white"
                    font.pixelSize: 26
                }
            }

            Text {
                id: lowValue

                text: "Lo " + (minValue !== Number.MAX_VALUE ? minValue.toFixed(1) : "--")
                lineHeight: 0.8
                width: contentWidth
                horizontalAlignment: Text.Center
                color: "white"
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: reading.horizontalCenter
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

        ChartView {
            id: chartView

            anchors.top: valueReading.top
            anchors.topMargin: 25
            height: reading.height
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: valueReading.left
            anchors.rightMargin: -27
            antialiasing: true
            backgroundColor: "transparent"
            legend.visible: false
            margins.top: 0
            margins.bottom: 0
            margins.left: 0
            margins.right: 0

            // Hide the value axis labels; labels are drawn separately.
            ValueAxis {
                id: valueAxisX

                min: 0
                max: maxNumOfTempReadings - 1
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
                width: 2
                useOpenGL: true
            }
        }
    }
}
