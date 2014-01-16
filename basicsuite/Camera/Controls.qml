/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://qt.digia.com/
**
** This file is part of the examples of the Qt Enterprise Embedded.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
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
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
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
import QtQuick 2.0
import QtMultimedia 5.0

Item {
    id: controlsRoot
    anchors.fill: parent

//    property alias cameraMode: cameraModeControl.selectedValue

    property alias requestedZoom: zoomControl.requestedZoom
    property alias actualZoom: zoomControl.actualZoom
    property alias maximumZoom: zoomControl.maximumZoom

    property alias flashMode: flashControl.selectedValue
    property alias focusMode: focusModeControl.selectedValue
    property alias exposureMode: expModeControl.selectedValue
    property alias exposureCompensation: expCompControl.selectedValue
    property alias whiteBalanceMode: wbControl.selectedValue
    property alias resolution: resControl.selectedValue

    property bool captureReady: false

    signal capture
    signal searchAndLock

    FocusControl {
        id: focusControl
        anchors.fill: parent
        onSearchAndLock: controlsRoot.searchAndLock()
        enabled: camera.captureMode === Camera.CaptureStillImage
    }

    ZoomControl {
        id: zoomControl
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
    }

//    CameraSetting {
//        id: cameraModeControl
//        anchors.right: parent.right
//        anchors.rightMargin: 20
//        anchors.bottom: parent.bottom
//        anchors.bottomMargin: 20
//        title: "MODE"
//        model: ListModel {
//            ListElement {
//                name: "Picture"
//                value: Camera.CaptureStillImage
//            }
//            ListElement {
//                name: "Video"
//                value: Camera.CaptureVideo
//            }
//        }
//        onCountChanged: currentIndex = 0
//        enabled: controlsRoot.captureReady
//    }

    RecordingTime {
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60 * root.contentScale
        visible: camera.videoRecorder.recorderStatus === CameraRecorder.RecordingStatus
    }

    Row {
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20
        height: 84
        spacing: 20

        CameraSetting {
            id: flashControl
            title: "FLASH"
            model: cameraUtils.supportedFlashModes
        }

        CameraSetting {
            id: focusModeControl
            title: "FOCUS"
            model: cameraUtils.supportedFocusModes
            enabled: camera.captureMode === Camera.CaptureStillImage
        }

        CameraSetting {
            id: expModeControl
            title: "SCENE"
            model: cameraUtils.supportedSceneModes
        }

        CameraSetting {
            id: expCompControl
            title: "EV"
            model: ListModel {
                ListElement {
                    name: "+2"
                    value: 2
                }
                ListElement {
                    name: "+1"
                    value: 1
                }
                ListElement {
                    name: "0"
                    value: 0
                }
                ListElement {
                    name: "-1"
                    value: -1
                }
                ListElement {
                    name: "-2"
                    value: -2
                }
            }
        }

        CameraSetting {
            id: wbControl
            title: "WB"
            model: cameraUtils.supportedWhiteBalanceModes
        }

        CameraSetting {
            id: resControl
            title: "SIZE"
            model: cameraUtils.supportedCaptureResolutions
//            onCountChanged: currentIndex = 1

            Component.onCompleted: currentIndex = 1

            Connections {
                target: camera
                onCaptureModeChanged: {
                    if (camera.captureMode === Camera.CaptureStillImage) {
                        resControl.model = cameraUtils.supportedCaptureResolutions;
                    } else {
                        resControl.model = cameraUtils.supportedVideoResolutions;
                    }
                }
            }
        }
    }

    CaptureControl {
        id: captureControl
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: -30
        enabled: controlsRoot.captureReady || camera.videoRecorder.recorderStatus === CameraRecorder.RecordingStatus

        onClicked: controlsRoot.capture()
    }
}
