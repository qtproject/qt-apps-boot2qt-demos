import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    id: root

    property real inputX: 0.1;

    property real feedbackX: effect.displacement

    property string nameX: "Displacement"

    Image {
        id: image
        source: "images/bug.jpg"
        anchors.centerIn: parent
        visible: false
    }

    Image {
        id: displacementMap
        source: "images/glass_normal.png"
        smooth: true
        visible: false
    }

    Displace {
        id: effect;

        source: image
        displacementSource: displacementMap
        anchors.fill: source

        scale: source.height > root.height * 0.8 ? root.height / source.height * 0.8 : 1;

        displacement: inputX
    }

}
