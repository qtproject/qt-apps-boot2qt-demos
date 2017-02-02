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
import QtCharts 2.1
import SensorTag.DataProvider 1.0
import QtGraphicalEffects 1.0

BaseChart {
    id: gyroHolderRect

    // Replace with actual gyro properties
    property int gyroSeriesIndex: 0
    property int maxGyroReadings: 24

    readonly property string xColor: "#15bdff"
    readonly property string yColor: "white"
    readonly property string zColor: "fuchsia"
    readonly property color textColor: "white"

    onSensorChanged: {
            if (sensor) {
                sensor.rotationValuesChanged.connect(contentItem.updateRotation);
            }
    }

    title: qsTr("Gyroscope")
    rightSide: true

    content: Item {
        anchors.fill: parent

        function updateRotation() {
            gyroSeriesX.append(gyroSeriesIndex, sensor.rotationX);
            gyroSeriesY.append(gyroSeriesIndex, sensor.rotationY);
            gyroSeriesZ.append(gyroSeriesIndex, sensor.rotationZ);

            if (gyroSeriesIndex >= maxGyroReadings) {
                gyroSeriesX.remove(gyroSeriesX.at(gyroSeriesIndex-maxGyroReadings));
                gyroSeriesY.remove(gyroSeriesY.at(gyroSeriesIndex-maxGyroReadings));
                gyroSeriesZ.remove(gyroSeriesZ.at(gyroSeriesIndex-maxGyroReadings));
                valueAxisX.min++;
                valueAxisX.max++;
            }
            gyroSeriesIndex++;
        }

        Glow {
            anchors.fill: chartView
            radius: 30
            samples: 30
            color: "orange"
            source: chartView
        }

        ChartView {
            id: chartView

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 25
            anchors.left: parent.left
            anchors.leftMargin: -20
            anchors.right: parent.right
            anchors.rightMargin: -15
            antialiasing: true
            backgroundColor: "transparent"
            legend.visible: false
            margins.top: 0
            margins.right: 0

            // Hide the value axis labels; labels are drawn separately.
            ValueAxis {
                id: valueAxisX
                labelsVisible: false
                min: 0
                max: maxGyroReadings + 1
                tickCount: 13
                visible: false
            }

            ValueAxis {
                id: valueAxisY
                labelsVisible: false
                min: 0
                max: 360
                tickCount: 11
                visible: false
            }
            ScatterSeries {
                id: gyroSeriesX
                axisX: valueAxisX
                axisY: valueAxisY
                color: xColor
                borderColor: xColor
                markerSize: 8
                name: "Gyro X"
            }
            ScatterSeries {
                id: gyroSeriesY
                axisX: valueAxisX
                axisY: valueAxisY
                color: yColor
                borderColor: yColor
                markerSize: 8
                name: "Gyro Y"
            }
            ScatterSeries {
                id: gyroSeriesZ
                axisX: valueAxisX
                axisY: valueAxisY
                color: zColor
                borderColor: zColor
                markerSize: 8
                name: "Gyro Z"
            }
        }

        Row {
            id: xLabelRow
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            anchors.left: parent.left
            anchors.leftMargin: chartView.plotArea.x - 40
            anchors.right: parent.right

            Text {
                id: xLabel
                horizontalAlignment: Text.AlignHCenter
                text: "<font color=\"" + xColor + "\">Roll<br><font color=\"white\">" + (sensor ? sensor.rotationX.toFixed(0) : 0)
                lineHeight: 0.7
                width: (gyroHolderRect.width - xLabelRow.x) / 3
            }

            Text {
                horizontalAlignment: Text.AlignHCenter
                text: "<font color=\"" + yColor + "\">Pitch<br><font color=\"white\">" + (sensor ? sensor.rotationY.toFixed(0) : 0)
                lineHeight: 0.7
                width: xLabel.width
            }

            Text {
                horizontalAlignment: Text.AlignHCenter
                text: "<font color=\"" + zColor + "\">Yaw<br><font color=\"white\">" + (sensor ? sensor.rotationZ.toFixed(0) : 0)
                lineHeight: 0.7
                width: xLabel.width
            }
        }
    }
}
