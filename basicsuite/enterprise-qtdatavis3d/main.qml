/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://www.qt.io
**
** This file is part of the QtDataVisualization module.
**
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://www.qt.io
**
****************************************************************************/

import QtQuick 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtDataVisualization 1.0
import "."

Item {
    id: mainview

    function toPixels(percentage) {
        return percentage * Math.min(mainview.width, mainview.height);
    }

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
        Column {
            Layout.fillWidth: true
            spacing: 5
            ToggleButton {
                id: layerOneToggle
                text: "Ground\n Layer"
                checked: true
                width: toPixels(0.12)
                height: width
                style: ToggleButtonStyle { }
            }

            ToggleButton {
                id: layerTwoToggle
                text: "Sea\n Layer"
                checked: true
                width: toPixels(0.12)
                height: width
                style: ToggleButtonStyle { }
            }

            ToggleButton {
                id: layerThreeToggle
                text: "Tectonic\n Layer"
                checked: true
                width: toPixels(0.12)
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
                width: toPixels(0.12)
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
                width: toPixels(0.12)
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
                width: toPixels(0.12)
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
                width: toPixels(0.12)
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
