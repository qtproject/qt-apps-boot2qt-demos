import QtQuick 2.0
import QtSensors 5.0

Item {
    id: root
    width: 800
    height: 1280
    Rectangle {
        id: main
        width: root.height
        height: root.width
        anchors.centerIn: parent
        rotation: 90
        border.width: 1

        Light {
            id: lys
            width: main.width
            height: main.height / 2
        }

        Accelbubble {
            width: main.width
            height: main.height / 2
            anchors.top: lys.bottom
        }
    }
}
