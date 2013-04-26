import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    id: root

    property real inputX: 0.5;
    property real inputY: 1

    property real feedbackX: effect.radius
    property real feedbackY: effect.deviation

    property string nameX: "Radius"
    property string nameY: "Deviation"

    Image {
        id: image
        source: "images/bug.jpg"
        width: Math.min(root.width, root.height) * 0.8;
        height: width
        sourceSize: Qt.size(width, height);
        anchors.centerIn: parent
    }

    GaussianBlur {
        id: effect;

        source: image
        anchors.fill: source

        scale: source.height > root.height * 0.8 ? root.height / source.height * 0.8 : 1;
        samples: 4

        deviation: root.inputY * 20;
        radius: root.inputX * 7
    }

}
