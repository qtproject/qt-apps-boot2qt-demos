import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    id: root

    Image {
        id: image
        source: "images/bug.jpg"
        anchors.centerIn: parent
        visible: false
    }

    Image {
        id: mask
        source: "images/butterfly.png"
        visible: false
    }

    OpacityMask {
        id: effect;

        source: image
        maskSource: mask
        anchors.fill: source

        scale: source.height > root.height * 0.8 ? root.height / source.height * 0.8 : 1;
    }
}
