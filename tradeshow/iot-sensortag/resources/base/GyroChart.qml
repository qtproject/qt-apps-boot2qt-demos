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
import QtQml 2.2

BaseChart {
    id: gyroHolderRect

    // Replace with actual gyro properties
    property int maxGyroReadings: 24

    readonly property string xColor: "#15bdff"
    readonly property string yColor: "white"
    readonly property string zColor: "red"
    readonly property color textColor: "white"

    onClicked: {
        if (sensor)
            sensor.recalibrate();
    }

    title: qsTr("Gyroscope")
    rightSide: true

    content: Item {
        anchors.fill: parent

        Connections {
            target: mainWindow
            onSeriesStorageChanged: {
                if (seriesStorage)
                    seriesStorage.setGyroSeries(gyroSeriesX, gyroSeriesY, gyroSeriesZ);
            }
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
                min: 0
                max: maxGyroReadings + 1
                visible: false
            }

            ValueAxis {
                id: valueAxisY
                min: 0
                max: 360
                visible: false
            }
            SplineSeries {
                id: gyroSeriesX
                axisX: valueAxisX
                axisY: valueAxisY
                color: xColor
                name: "Gyro X"
                useOpenGL: true
                width: 2
            }
            SplineSeries {
                id: gyroSeriesY
                axisX: valueAxisX
                axisY: valueAxisY
                color: yColor
                name: "Gyro Y"
                useOpenGL: true
                width: 2
            }
            SplineSeries {
                id: gyroSeriesZ
                axisX: valueAxisX
                axisY: valueAxisY
                color: zColor
                name: "Gyro Z"
                useOpenGL: true
                width: 2
            }
        }

        Row {
            id: xLabelRow
            anchors.fill: parent
            anchors.leftMargin: 16

            Repeater {
                model: 3

                Item {
                    height: xLabelRow.height
                    width: xLabelRow.width / 3

                    Text {
                        id: coordText
                        text: (index == 0) ? "X" : ((index == 1) ? "Y" : "Z")
                        color: "white"
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                    }

                    Text {
                        text: sensor ? ((index == 0) ? sensor.rotationX.toFixed(0) :
                                             ((index == 1) ? sensor.rotationY.toFixed(0) :
                                                             sensor.rotationZ.toFixed(0))) :
                                       ""
                        color: (index == 0) ? xColor : ((index == 1) ? yColor : zColor)
                        anchors.left: coordText.right
                        anchors.leftMargin: 16
                        anchors.bottom: parent.bottom
                    }
                }
            }
        }
    }
}
