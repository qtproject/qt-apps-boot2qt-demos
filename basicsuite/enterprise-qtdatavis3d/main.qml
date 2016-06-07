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
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtDataVisualization 1.0
import "."

Rectangle {
    id: mainview
    color: "black"
    Item {
        id: surfaceView
        width: mainview.width - buttonLayout.width
        height: mainview.height
        anchors.right: mainview.right;

        ColorGradient {
            id: layerOneGradient
            ColorGradientStop { position: 0.0; color: "black" }
            ColorGradientStop { position: 0.31; color: "tan" }
            ColorGradientStop { position: 0.32; color: "green" }
            ColorGradientStop { position: 0.40; color: "darkslategray" }
            ColorGradientStop { position: 1.0; color: "white" }
        }

        ColorGradient {
            id: layerTwoGradient
            ColorGradientStop { position: 0.315; color: "blue" }
            ColorGradientStop { position: 0.33; color: "white" }
        }

        ColorGradient {
            id: layerThreeGradient
            ColorGradientStop { position: 0.0; color: "red" }
            ColorGradientStop { position: 0.15; color: "black" }
        }

        Surface3D {
            id: surfaceLayers
            width: surfaceView.width
            height: surfaceView.height
            theme: Theme3D {
                type: Theme3D.ThemeEbony
                font.pointSize: 35
                colorStyle: Theme3D.ColorStyleRangeGradient
            }
            shadowQuality: AbstractGraph3D.ShadowQualityNone
            selectionMode: AbstractGraph3D.SelectionRow | AbstractGraph3D.SelectionSlice
            scene.activeCamera.cameraPreset: Camera3D.CameraPresetIsometricLeft
            axisY.min: 20
            axisY.max: 200
            axisX.segmentCount: 5
            axisX.subSegmentCount: 2
            axisX.labelFormat: "%i"
            axisZ.segmentCount: 5
            axisZ.subSegmentCount: 2
            axisZ.labelFormat: "%i"
            axisY.segmentCount: 5
            axisY.subSegmentCount: 2
            axisY.labelFormat: "%i"

            Surface3DSeries {
                id: layerOneSeries
                baseGradient: layerOneGradient
                HeightMapSurfaceDataProxy {
                    heightMapFile: "/data/user/qt/enterprise-qtdatavis3d/layer_1.png"
                }
                flatShadingEnabled: false
                drawMode: Surface3DSeries.DrawSurface
                visible: layerOneToggle.checked // bind to checkbox state
            }

            Surface3DSeries {
                id: layerTwoSeries
                baseGradient: layerTwoGradient
                HeightMapSurfaceDataProxy {
                    heightMapFile: "/data/user/qt/enterprise-qtdatavis3d/layer_2.png"
                }
                flatShadingEnabled: false
                drawMode: Surface3DSeries.DrawSurface
                visible: layerTwoToggle.checked // bind to checkbox state
            }

            Surface3DSeries {
                id: layerThreeSeries
                baseGradient: layerThreeGradient
                HeightMapSurfaceDataProxy {
                    heightMapFile: "/data/user/qt/enterprise-qtdatavis3d/layer_3.png"
                }
                flatShadingEnabled: false
                drawMode: Surface3DSeries.DrawSurface
                visible: layerThreeToggle.checked // bind to checkbox state
            }
        }
    }

    ColumnLayout {
        id: buttonLayout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        spacing: 0
        property int buttonWidth: Math.min(engine.centimeter(3), parent.height/7 - engine.mm(2))
        Column {
            Layout.fillWidth: true
            spacing: 5
            ToggleButton {
                id: layerOneToggle
                text: "Ground\n Layer"
                checked: true
                width: buttonLayout.buttonWidth
                height: width
                style: ToggleButtonStyle { }
            }

            ToggleButton {
                id: layerTwoToggle
                text: "Sea\n Layer"
                checked: true
                width: buttonLayout.buttonWidth
                height: width
                style: ToggleButtonStyle { }
            }

            ToggleButton {
                id: layerThreeToggle
                text: "Tectonic\n Layer"
                checked: true
                width: buttonLayout.buttonWidth
                height: width
                style: ToggleButtonStyle { }
            }
        }

        Column {
            Layout.fillWidth: true
            spacing: 5
            ToggleButton {
                id: layerOneGrid
                text: "Ground\n as\n Grid"
                width: buttonLayout.buttonWidth
                height: width
                style: ToggleButtonStyle { }
                onCheckedChanged: {
                    if (checked)
                        layerOneSeries.drawMode = Surface3DSeries.DrawWireframe
                    else
                        layerOneSeries.drawMode = Surface3DSeries.DrawSurface
                }
            }

            ToggleButton {
                id: layerTwoGrid
                text: "Sea\n as\n Grid"
                width: buttonLayout.buttonWidth
                height: width
                style: ToggleButtonStyle { }
                onCheckedChanged: {
                    if (checked)
                        layerTwoSeries.drawMode = Surface3DSeries.DrawWireframe
                    else
                        layerTwoSeries.drawMode = Surface3DSeries.DrawSurface
                }
            }

            ToggleButton {
                id: layerThreeGrid
                text: "Tectonic\n as\n Grid"
                width: buttonLayout.buttonWidth
                height: width

                style: ToggleButtonStyle { }
                onCheckedChanged: {
                    if (checked)
                        layerThreeSeries.drawMode = Surface3DSeries.DrawWireframe
                    else
                        layerThreeSeries.drawMode = Surface3DSeries.DrawSurface
                }
            }
        }

        Column {
            Layout.fillWidth: true
            spacing: 5
            ToggleButton {
                id: sliceButton
                text: "Slice\n All\n Layers"
                width: buttonLayout.buttonWidth
                height: width
                style: ToggleButtonStyle { }
                onClicked: {
                    if (surfaceLayers.selectionMode & AbstractGraph3D.SelectionMultiSeries) {
                        surfaceLayers.selectionMode = AbstractGraph3D.SelectionRow
                                | AbstractGraph3D.SelectionSlice
                        text = "Slice\n All\n Layers"
                    } else {
                        surfaceLayers.selectionMode = AbstractGraph3D.SelectionRow
                                | AbstractGraph3D.SelectionSlice
                                | AbstractGraph3D.SelectionMultiSeries
                        text = "Slice\n One\n Layer"
                    }
                }
            }
        }
    }
}
