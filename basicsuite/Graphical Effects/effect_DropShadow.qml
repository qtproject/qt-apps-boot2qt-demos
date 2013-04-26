import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    id: root

    property real inputX: 0.5;
    property real inputY: 0.2;

    property real feedbackX: effect.radius
    property real feedbackY: effect.spread

    property string nameX: "Radius"
    property string nameY: "Spread"

    Image {
        id: image
        source: "images/butterfly.png"
        anchors.centerIn: parent
        visible: false
    }

    DropShadow {
        id: effect;

        source: image
        anchors.fill: source

        scale: source.height > root.height * 0.8 ? root.height / source.height * 0.8 : 1;

        samples: 4

        radius: root.inputX * 7
        spread: root.inputY;

        color: Qt.rgba(0, 0, 0, 0.4);

        verticalOffset: 30.5
        horizontalOffset: 30.5
    }

}
