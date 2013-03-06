import QtQuick 2.0

Rectangle {
    width: 200
    height: 200
    color: "black"

    Text {
        anchors.fill: parent
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: "More to come..."
        font.pixelSize: Math.min(width, height) * 0.03
    }
}
