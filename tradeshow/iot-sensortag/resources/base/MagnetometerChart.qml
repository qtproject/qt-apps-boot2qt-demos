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
    id: magnetHolderRect

    property int maxNumOfMagnReadings: 24

    readonly property color chartColor: "#15bdff"
    readonly property string xColor: "#4db300"
    readonly property string yColor: "white"
    readonly property string zColor: "#f64405"
    readonly property color textColor: "white"

    title: qsTr("Magnetometer")
    rightSide: true

    content: Item {
        anchors.fill: parent

        Connections {
            target: mainWindow
            onSeriesStorageChanged: {
                if (seriesStorage)
                    seriesStorage.setMagnetoMeterSeries(magnSeriesX, magnSeriesY, magnSeriesZ);
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
            antialiasing: true
            backgroundColor: "transparent"
            legend.visible: false
            margins.top: 0
            margins.right: 0

            // Hide the value axis labels; labels are drawn separately.
            ValueAxis {
                id: valueAxisX
                min: 0
                max: maxNumOfMagnReadings + 1
                visible: false
            }

            ValueAxis {
                id: valueAxisY
                min: -2000
                max: 2000
                visible: false
            }

            LineSeries {
                id: magnSeriesX
                axisX: valueAxisX
                axisY: valueAxisY
                color: xColor
                name: "Magnet X"
                useOpenGL: true
                width: 2
            }
            LineSeries {
                id: magnSeriesY
                axisX: valueAxisX
                axisY: valueAxisY
                color: yColor
                name: "Magnet Y"
                useOpenGL: true
                width: 2
            }
            LineSeries {
                id: magnSeriesZ
                axisX: valueAxisX
                axisY: valueAxisY
                color: zColor
                name: "Magnet Z"
                useOpenGL: true
                width: 2
            }
        }

        Row {
            id: labelRow
            anchors.fill: parent
            anchors.leftMargin: 16

            Repeater {
                model: 3

                Item {
                    height: labelRow.height
                    width: labelRow.width / 3

                    Text {
                        id: coordText
                        text: (index == 0) ? "X" : ((index == 1) ? "Y" : "Z")
                        color: (index == 0) ? xColor : ((index == 1) ? yColor : zColor)
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                    }

                    Text {
                        text: sensor ? ((index == 0) ? sensor.magnetometerMicroT_xAxis :
                                             ((index == 1) ? sensor.magnetometerMicroT_yAxis :
                                                             sensor.magnetometerMicroT_zAxis) ) :
                                       ""
                        color: "white"
                        anchors.left: coordText.right
                        anchors.leftMargin: 16
                        anchors.bottom: parent.bottom
                    }
                }
            }
        }
    }
}
