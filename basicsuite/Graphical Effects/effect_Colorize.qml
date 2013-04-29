import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root

    property real inputX: 0.6;
    property real feedbackX: effect.hue
    property string nameX: "Hue"

    property real inputY: 0.7
    property real feedbackY: effect.saturation
    property string nameY: "Saturation"

    Image {
        id: image
        source: "images/bug.jpg"
        width: Math.min(root.width, root.height) * 0.8;
        height: width
        sourceSize: Qt.size(width, height);
        anchors.centerIn: parent
    }

    Colorize {
        id: effect;

        source: image
        anchors.fill: source
        scale: source.height > root.height * 0.8 ? root.height / source.height * 0.8 : 1;

        hue: root.inputX * 2 - 1;
        saturation: root.inputY
    }
}
