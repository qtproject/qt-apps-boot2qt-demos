/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
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
//import QtSensors 5.0
import CameraUtils 1.0

Rectangle {
    id: root
    color: "black"

    property real contentScale: root.width / 1280
    property int contentRotation: 0

    Text {
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 30
        text: "Camera service is not available..."
        visible: camera.cameraStatus === Camera.UnavailableStatus
    }

    CameraUtils {
        id: cameraUtils
    }

    Camera {
        id: camera
        property bool updateFocusPointMode: true
        property bool captureWhenLocked: false

        Component.onCompleted: cameraUtils.setCamera(camera)

        digitalZoom: controls.requestedZoom
        captureMode: Camera.CaptureStillImage

        onCaptureModeChanged: {
            if (camera.captureMode === Camera.CaptureVideo) {
                controls.focusMode = Camera.FocusContinuous;
                camera.unlock();
            } else {
                controls.focusMode = Camera.FocusAuto;
            }
        }

        onLockStatusChanged: {
            if (camera.lockStatus === Camera.Locked && captureWhenLocked) {
                camera.imageCapture.captureToLocation("/data/images/");
                captureWhenLocked = false;
            }
        }

        focus {
            onFocusModeChanged: {
                camera.unlock();
                if (camera.updateFocusPointMode)
                    camera.focus.focusPointMode = Camera.FocusPointAuto
            }
            onCustomFocusPointChanged: {
                if (camera.focus.focusPointMode === Camera.FocusPointCustom
                        && camera.focus.focusMode !== Camera.FocusAuto
                        && camera.focus.focusMode !== Camera.FocusMacro) {
                    camera.updateFocusPointMode = false;
                    camera.focus.focusMode = Camera.FocusAuto
                    controls.focusMode = Camera.FocusAuto
                    camera.updateFocusPointMode = true;
                }
            }
        }

        onCameraStatusChanged: {
            if (cameraStatus === Camera.ActiveStatus) {
                controls.exposureMode = camera.exposure.exposureMode
                controls.exposureCompensation = camera.exposure.exposureCompensation
                controls.whiteBalanceMode = camera.imageProcessing.whiteBalanceMode
                controls.flashMode = Camera.FlashAuto
                if (camera.captureMode === Camera.CaptureStillImage)
                    controls.focusMode = camera.focus.focusMode
                else
                    camera.focus.focusMode = Camera.FocusContinuous
            }
        }

        imageCapture {
            onImageExposed: capturePreview.show()
            onImageCaptured: {
                camera.unlock();
                capturePreview.setPreview(preview);
            }
            onCaptureFailed: print(requestId + " " + message)
        }

        videoRecorder {
            //            mediaContainer: "mp4"
            //            audioCodec: "aac"
            //            audioSampleRate: 48000
            //            audioBitRate: 192000
            //            audioChannels: 2
            //            videoCodec: "h264"
            //            resolution: Qt.size(960, 720)
            onResolutionChanged: {
                if (camera.videoRecorder.resolution == Qt.size(1920, 1080))
                    camera.videoRecorder.videoBitRate = 20000000;
                else if (camera.videoRecorderresolution == Qt.size(1280, 720))
                    camera.videoRecorder.videoBitRate = 10000000;
                else
                    camera.videoRecorder.videoBitRate = 5000000;
            }
        }

    }

    VideoOutput {
        id: viewfinder
        source: camera
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectFit
    }

    //    OrientationSensor {
    //        active: true
    //        onReadingChanged: {
    //            if (reading.orientation === OrientationReading.TopUp)
    //                root.contentRotation = -90;
    //            else if (reading.orientation === OrientationReading.RightUp)
    //                root.contentRotation = 0;
    //            else if (reading.orientation === OrientationReading.LeftUp)
    //                root.contentRotation = 180;
    //            else if (reading.orientation === OrientationReading.TopDown)
    //                root.contentRotation = 90;
    //        }
    //    }

    //    RotationSensor {
    //        active: (camera.cameraStatus === Camera.ActiveStatus)
    //        dataRate: 20
    //        property real lastxvalue: 0
    //        property real lastyvalue: 0
    //        property real lastzvalue: 0

    //        onActiveChanged: {
    //            lastxvalue = 0
    //            lastyvalue = 0
    //            lastzvalue = 0
    //        }

    //        onReadingChanged: {
    //            if (lastxvalue != 0 && camera.focus.focusMode === Camera.FocusContinuous && camera.lockStatus === Camera.Locked && camera.imageCapture.ready) {
    //                if (Math.abs(reading.x - lastxvalue) > 3 || Math.abs(reading.y - lastyvalue) > 3 || Math.abs(reading.z - lastzvalue) > 3)
    //                    camera.unlock();
    //            }
    //            lastxvalue = reading.x;
    //            lastyvalue = reading.y;
    //            lastzvalue = reading.z;
    //        }
    //    }

    Controls {
        id: controls
        visible: camera.cameraStatus === Camera.ActiveStatus

        actualZoom: camera.digitalZoom
        maximumZoom: camera.maximumDigitalZoom

        //onCameraModeChanged: camera.captureMode = controls.cameraMode

        onFlashModeChanged: if (visible) camera.flash.mode = controls.flashMode
        onFocusModeChanged: if (visible) camera.focus.focusMode = controls.focusMode
        onExposureModeChanged: if (visible) camera.exposure.exposureMode = controls.exposureMode
        onExposureCompensationChanged: if (visible) camera.exposure.exposureCompensation = controls.exposureCompensation
        onWhiteBalanceModeChanged: if (visible) camera.imageProcessing.whiteBalanceMode = controls.whiteBalanceMode
        onResolutionChanged: {
            if (controls.resolution != null) {
                if (camera.captureMode === Camera.CaptureStillImage)
                    camera.imageCapture.resolution = controls.resolution;
                else
                    camera.videoRecorder.resolution = controls.resolution;
            }
        }

        onSearchAndLock: {
            camera.searchAndLock();
        }

        captureReady: camera.imageCapture.ready
        onCapture: {
            if (camera.captureMode === Camera.CaptureVideo) {
                if (camera.videoRecorder.recorderState === CameraRecorder.RecordingState) {
                    camera.videoRecorder.stop();
                } else {
                    camera.videoRecorder.record();
                }
            } else {
                if ((camera.focus.focusMode === Camera.FocusAuto || camera.focus.focusMode === Camera.FocusMacro)
                        && camera.focus.focusPointMode === Camera.FocusPointAuto
                        && camera.lockStatus === Camera.Unlocked) {
                    camera.captureWhenLocked = true;
                    camera.searchAndLock();
                } else {
                    camera.imageCapture.captureToLocation("/data/images/");
                }
            }
        }
    }

    //    CameraControlButton {
    //        anchors.left: parent.left
    //        anchors.leftMargin: 30
    //        anchors.bottom: parent.bottom
    //        anchors.bottomMargin: 20
    //        title: camera.cameraStatus === Camera.ActiveStatus ? "Stop" : "Start"

    //        onClicked: {
    //            if (camera.cameraStatus === Camera.ActiveStatus)
    //                camera.cameraState = Camera.UnloadedState
    //            else
    //                camera.start();
    //        }
    //    }

    CapturePreview {
        id: capturePreview
    }

}
