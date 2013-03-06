import QtQuick 2.0

Rectangle {
    id: root

    width: parent.width
    height: label.font.pixelSize * 3

    radius: height * 0.2

    antialiasing: true

    property alias text: label.text;

    property color accentColor: "palegreen"

    gradient: Gradient {
        GradientStop { position: 0; color: root.accentColor; }
        GradientStop { position: 1; color: "black"; }
    }

    Text {
        id: label
        font.pixelSize: engine.smallFontSize()
        font.bold: true;
        color: "white"
        anchors.centerIn: parent
    }

}
