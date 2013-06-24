import QtQuick 2.0

Rectangle {
    id: root
    anchors.fill: parent
    color: "black"
    opacity: 0
    enabled: opacity !== 0

    property string previewSrc: ""

    onOpacityChanged: {
        if (opacity === 1 && previewSrc !== "") {
            previewImage.source = previewSrc;
            previewSrc = "";
        }
    }

    Behavior on opacity { NumberAnimation { duration: 100 } }

    function show() {
        previewImage.source = "";
        opacity = 1;
    }

    function setPreview(preview) {
        if (root.opacity === 1)
            previewImage.source = preview;
        else
            root.previewSrc = preview;
    }

    Image {
        id: previewImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.opacity = 0;
        }
    }
}
