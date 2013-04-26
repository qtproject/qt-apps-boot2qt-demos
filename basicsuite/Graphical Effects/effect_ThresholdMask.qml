import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    id: root

    property real inputX: 0.5;
    property real inputY: 0.2;

    property real feedbackX: effect.threshold
    property real feedbackY: effect.spread

    property string nameX: "Threshold"
    property string nameY: "Spread"

    Image {
        id: image
        source: "images/bug.jpg"
        anchors.centerIn: parent
        visible: false
    }

    Image {
        id: mask
        source: "images/fog.png"
        visible: false
    }

    ThresholdMask {
        id: effect;

        source: image
        maskSource: mask;
        anchors.fill: source

        scale: source.height > root.height * 0.8 ? root.height / source.height * 0.8 : 1;

        threshold: root.inputX
        spread: root.inputY
    }

}
