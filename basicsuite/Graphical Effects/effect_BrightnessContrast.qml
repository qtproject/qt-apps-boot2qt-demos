import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    id: root

    property real inputX: 0.7;
    property real feedbackX: effect.brightness
    property string nameX: "Brightness"

    property real inputY: 0.8;
    property real feedbackY: effect.contrast
    property string nameY: "Contrast"

    Image {
        id: image
        source: "images/bug.jpg"
        anchors.centerIn: parent
        visible: false
    }

    BrightnessContrast {
        id: effect;

        source: image
        anchors.fill: source

        scale: source.height > root.height * 0.8 ? root.height / source.height * 0.8 : 1;

        brightness: inputX * 2 - 1;
        contrast: inputY * 2 - 1;
    }

}
