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
