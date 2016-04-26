/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
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
import QtQuick 2.1
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import QtQuick.Window 2.1
import QtDataVisualization 1.0
import Freenect 1.0

Rectangle {
    id: root
    width: 1280
    height: 800
    color: 'black'

    FreenectState {
        id: freenectState
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 20
        columnSpacing: 10
        rowSpacing: 10
        columns: 2
        rows: 2
        Panel {
            Layout.rowSpan: 2
            // Put "pressure" to overweigh all implicitWidths of the right column.
            Layout.preferredWidth: 999999
            title: "Depth"

            ColumnLayout {
                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Surface3D {
                        id: surfaceGraph
                        anchors.fill: parent
                        theme: Theme3D {
                            type: Theme3D.ThemeIsabelle
                            colorStyle: Theme3D.ColorStyleRangeGradient
                            baseGradients: [thermalGradient]
                            ColorGradient {
                                id: thermalGradient
                                ColorGradientStop { position: 0; color: "black" }
                                ColorGradientStop { position: 1/3; color: "blue" }
                                ColorGradientStop { position: 2/3; color: "red" }
                                ColorGradientStop { position: 1; color: "yellow" }
                            }
                        }
                        shadowQuality: AbstractGraph3D.ShadowQualityNone
                        selectionMode: AbstractGraph3D.SelectionNone
                        scene.activeCamera.cameraPreset: Camera3D.CameraPresetFrontHigh
                        scene.activeCamera.zoomLevel: 175
                        axisY.min: clipSlider.maximumValue - clipSlider.highValue
                        axisY.max: clipSlider.maximumValue - clipSlider.lowValue
                        axisY.labelFormat: "%i"
                        axisX.labelFormat: ""
                        axisZ.labelFormat: ""

                        Surface3DSeries {
                            id: surfaceSeries
                            flatShadingEnabled: false
                            drawMode: Surface3DSeries.DrawSurface
                            dataProxy: FreenectDepthDataProxy {
                                highClip: surfaceGraph.axisY.max
                            }
                        }
                    }
                    ErrorPanel {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        text: freenectState.errorString
                        visible: text
                    }
                }
                RowLayout {
                    spacing: 10
                    Label {
                        color: "lightgrey"
                        text: "Near"
                    }
                    RangeSlider {
                        id: clipSlider
                        Layout.fillWidth: true
                    }
                    Label {
                        color: "lightgrey"
                        text: "Far"
                    }
                }
            }
        }
        Panel {
            id: videoCell
            Layout.preferredHeight: 1
            ColumnLayout {
                RowLayout {
                    Header {
                        text: "Video"
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: "IR: "
                        color: "lightgrey"
                    }
                    Switch { id: streamTypeSwitch }
                }
                FreenectVideoOutput {
                    id: videoOutput
                    Layout.fillHeight: true
                    Layout.preferredWidth: height * 4 / 3
                    Layout.alignment: Qt.AlignHCenter
                    streamType: streamTypeSwitch.checked ? FreenectVideoOutput.VideoIR : FreenectVideoOutput.VideoRGB
                    Noise {
                        anchors.fill: parent
                        visible: !videoOutput.streaming
                    }
                }
            }
        }
        Panel {
            title: "Tilt"
            Layout.preferredHeight: videoCell.Layout.preferredHeight
            RowLayout {
                Item { Layout.fillWidth: true }
                AttitudeIndicator {
                    id: attitude
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 200
                    accel: freenectState.accelVector
                }
                Slider {
                    id: tiltSlider
                    Layout.fillHeight: true
                    orientation: Qt.Vertical

                    minimumValue: freenectState.minMotorTilt
                    maximumValue: freenectState.maxMotorTilt
                    Binding { target: freenectState; property: "motorTilt"; value: tiltSlider.value }
                }
            }
        }
    }
}
