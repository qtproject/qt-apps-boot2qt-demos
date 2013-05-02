import QtQuick 2.0

Item {
    id: root

    width: 100
    height: 62

    Repeater {
        id: repeater

        model: 4

        Rectangle {
            width: root.width
            height: root.height
            color: "white"
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
            if (mouseY > root.height / 2)
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

}
