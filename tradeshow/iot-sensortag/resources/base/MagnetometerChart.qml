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

    property int magneticSeriesIndex: 0
    property int maxNumOfMagnReadings: 24

    readonly property color chartColor: "#15bdff"
    readonly property string xColor: "#15bdff"
    readonly property string yColor: "white"
    readonly property string zColor: "red"
    readonly property color textColor: "white"

    onSensorChanged: if (sensor) sensor.magnetometerMicroTChanged.connect(contentItem.updateMagneticGraph)

    title: qsTr("Magnetometer")
    rightSide: true

    content: Item {
        anchors.fill: parent

        function updateMagneticGraph()
        {
            magnSeriesX.append(magneticSeriesIndex, sensor.magnetometerMicroT_xAxis);
            magnSeriesY.append(magneticSeriesIndex, sensor.magnetometerMicroT_yAxis);
            magnSeriesZ.append(magneticSeriesIndex, sensor.magnetometerMicroT_zAxis);

            if (magneticSeriesIndex >= maxNumOfMagnReadings) {
                magnSeriesX.remove(magnSeriesX.at(magneticSeriesIndex-maxNumOfMagnReadings));
                magnSeriesY.remove(magnSeriesY.at(magneticSeriesIndex-maxNumOfMagnReadings));
                magnSeriesZ.remove(magnSeriesY.at(magneticSeriesIndex-maxNumOfMagnReadings));
                valueAxisX.min++;
                valueAxisX.max++;
            }
            magneticSeriesIndex++;
        }

        Image {
            anchors.fill: parent
            source: pathPrefix + "Magnetometer/grid.png"
        }

        Glow {
            anchors.fill: chartView
            radius: 18
            samples: 30
            color: "red"
            source: chartView
        }


        PolarChartView {
            id: chartView

            anchors.top: parent.top
            anchors.topMargin: -8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -10
            anchors.left: parent.left
            anchors.leftMargin: -60
            anchors.right: parent.right
            anchors.rightMargin: 30
            antialiasing: true
            backgroundColor: "transparent"
            legend.visible: false
            margins.top: 0
            margins.right: 0

            // Hide the value axis labels; labels are drawn separately.
            ValueAxis {
                id: valueAxisX
                min: 0
                max: maxNumOfMagnReadings
                visible: false
            }

            ValueAxis {
                id: valueAxisY

                min: -1000
                max: 1000
                visible: false
            }

            SplineSeries {
                id: magnSeriesX
                axisX: valueAxisX
                axisY: valueAxisY
                color: xColor
                name: "Magnet X"
                useOpenGL: true
            }
            SplineSeries {
                id: magnSeriesY
                axisX: valueAxisX
                axisY: valueAxisY
                color: yColor
                name: "Magnet Y"
                useOpenGL: true
            }
            SplineSeries {
                id: magnSeriesZ
                axisX: valueAxisX
                axisY: valueAxisY
                color: zColor
                name: "Magnet Z"
                useOpenGL: true
            }
        }

        Column {
            id: labelColumn
            anchors.fill: parent
            anchors.rightMargin: 20

            Repeater {
                model: 3

                Item {
                    height: labelColumn.height / 3
                    width: labelColumn.width

                    Text {
                        id: coordText
                        text: (index == 0) ? "X" : ((index == 1) ? "Y" : "Z")
                        color: "white"
                        anchors.right: parent.right
                        anchors.top: parent.top
                        horizontalAlignment: Text.AlignRight
                        width: contentWidth
                    }

                    Rectangle {
                        color: (index == 0) ? xColor : ((index == 1) ? yColor : zColor)
                        anchors.right: parent.right
                        anchors.top: coordText.bottom
                        height: 1
                        width: parent.width / 8
                    }

                    Text {
                        text: sensor ? ((index == 0) ? sensor.magnetometerMicroT_xAxis :
                                             ((index == 1) ? sensor.magnetometerMicroT_yAxis :
                                                             sensor.magnetometerMicroT_zAxis) ) :
                                       ""
                        color: "white"
                        anchors.right: parent.right
                        anchors.top: coordText.bottom
                        horizontalAlignment: Text.AlignRight
                        width: contentWidth
                    }
                }
            }
        }
    }
}
