import QtQuick 2.0

Column {
    width: 400 * root.contentScale
    spacing: 20 * root.contentScale
    visible: maximumZoom > 1

    property alias maximumZoom: zoomSlider.maximum
    property alias requestedZoom: zoomSlider.value
    property real actualZoom: 1

    Rectangle {
        anchors.horizontalCenter: zoomSlider.horizontalCenter
        width: zoomText.width + 10 * root.contentScale
        height: zoomText.height + 10 * root.contentScale
        color: "#77333333"
        radius: 5 * root.contentScale
        rotation: root.contentRotation
        Behavior on rotation { NumberAnimation { } }

        Text {
            id: zoomText
            anchors.centerIn: parent
            font.pixelSize: Math.round(24 * root.contentScale)
            color: "white"
            font.bold: true
            text: (Math.round(actualZoom * 100) / 100) + "x"
        }
    }

    Slider {
        id: zoomSlider
        width: parent.width
        rotation: root.contentRotation === -90 ? 180 : (root.contentRotation === 90 ? 0 : root.contentRotation)

        minimum: 1
        maximum: 1
        value: 1
    }
}
