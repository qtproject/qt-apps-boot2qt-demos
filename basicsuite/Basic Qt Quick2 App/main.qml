import QtQuick 2.0

Rectangle {
    width: 600
    height: 400

    gradient: Gradient {
        GradientStop { position: 0; color: "aquamarine" }
        GradientStop { position: 1; color: "black" }
    }

    Text {
        anchors.centerIn: parent
        text: "Basic Application"
        font.pixelSize: parent.height * 0.1
        color: "white"
        style: Text.Raised
    }

    Rectangle {
        border.width: 1
        border.color: "lightsteelblue"
        color: "steelblue"

        antialiasing: true

        width: 100
        height: 100

        anchors.bottom: parent.bottom
        anchors.left: parent.left

        anchors.margins: 100

        NumberAnimation on rotation { from: 0; to: 360; duration: 5000; loops: Animation.Infinite }
    }
}
