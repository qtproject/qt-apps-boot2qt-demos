import QtQuick 2.0

Item {
    id: root

    property bool showImage: false;
    property bool showOpacity: false;

    width: 100
    height: 62

    Repeater {
        id: repeater

        model: 4

        Item {
            anchors.fill: parent

            Rectangle {
                width: root.width
                height: root.height
                color: "green"
                visible: root.showImage == false;
                opacity: root.showOpacity ? 0.1 : 1;
            }

            Image {
                width: root.width
                height: root.height
                source: "image.jpg"
                visible: root.showImage == true;
                opacity: root.showOpacity ? 0.1 : 1;
            }
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: 100
        height: 100
        color: "black"
        border.color: "red"
        border.width: 2
        antialiasing: true

        NumberAnimation on rotation { from: 0; to: 360; duration: 5000; loops: Animation.Infinite }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {

            if (mouseX < 100)
                root.showImage = !root.showImage
            else if (mouseX > root.width - 100)
                root.showOpacity = !root.showOpacity
            else if (mouseY > root.height / 2)
                repeater.model++
            else
                repeater.model--;
        }
    }

    Text {
        text: repeater.model
        anchors.centerIn: parent
        color: "white"
    }

    Text {
        color: "steelblue"
        style: Text.Outline
        styleColor: "lightsteelblue"
        text: "Add Layer"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        font.pixelSize: 24
    }

    Text {
        color: "steelblue"
        style: Text.Outline
        styleColor: "lightsteelblue"

        text: "Remove Layer"

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 40
        font.pixelSize: 24
    }


    Text {
        color: "steelblue"
        style: Text.Outline
        styleColor: "lightsteelblue"
        text: root.showOpacity ? "Translucent" : "Opaque"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        font.pixelSize: 24
    }


    Text {
        color: "steelblue"
        style: Text.Outline
        styleColor: "lightsteelblue"
        text: root.showImage ? "Images" : "Rectangles"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
        font.pixelSize: 24
    }


}
