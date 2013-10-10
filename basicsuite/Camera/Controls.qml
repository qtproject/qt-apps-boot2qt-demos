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
