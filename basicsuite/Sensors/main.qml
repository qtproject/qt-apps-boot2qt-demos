import QtQuick 2.0
import QtSensors 5.0
import QtSensors 5.0 as Sensors

Item {
    id: root
    width: 800
    height: 1280

    Component {
        id: sensorExample
        Rectangle {
            id: main
            width: root.height
            height: root.width
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

    Component {
        id: message
        Rectangle {
            width: root.width
            height: root.height
            Text {
                font.pixelSize: 22
                anchors.centerIn: parent
                text: "It appears that this device doesn't provide the required sensors!"
            }
        }
    }

    Loader {
        id: pageLoader
        anchors.centerIn: parent
    }

    Component.onCompleted: {
        var typesList = Sensors.QmlSensors.sensorTypes();
        var count = 0
        for (var i = 0; i < typesList.length; ++i) {
            if (typesList[i] == "QAccelerometer")
                count++
            if (typesList[i] == "QLightSensor")
                count++
        }

        if (count > 1)
            pageLoader.sourceComponent = sensorExample
        else
            pageLoader.sourceComponent = message
    }
}
