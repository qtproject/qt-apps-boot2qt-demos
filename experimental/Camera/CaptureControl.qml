import QtQuick 2.0
import QtMultimedia 5.0

Rectangle {
    id: controlRoot

    signal clicked

    property bool videoMode: camera.captureMode === Camera.CaptureVideo

    width: 180 * root.contentScale
    height: width
    radius: width / 2
    color: mouser.pressed ? (controlRoot.videoMode ? "#77fa334f" : "#7798c66c") : "#77333333"
    visible: enabled

    Rectangle {
        id: center
        anchors.centerIn: parent
        width: parent.width * 0.45
        height: width
        radius: width / 2
        opacity: mouser.pressed ? 0.7 : 1
        color: controlRoot.videoMode ? "#fa334f" : "#98c66c"
    }

    Rectangle {
        anchors.centerIn: parent
        color: "white"
        visible: camera.videoRecorder.recorderStatus === CameraRecorder.RecordingStatus
        width: center.width * 0.3
        height: width
    }

    MouseArea {
        id: mouser
        anchors.fill: parent
        onClicked: controlRoot.clicked()
    }
}
