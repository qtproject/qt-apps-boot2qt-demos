import QtQuick 2.0
import QtSensors 5.0

Item {
    rotation: 180
    Rectangle {
        id: bg
        width: parent.width
        height: parent.height
        Text {
            id: illuminanceLevel
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 26
            anchors.top: parent.top
        }
        Image {
            id: avatar
            anchors.top: illuminanceLevel.bottom
            anchors.topMargin: 30
            anchors.centerIn: parent
        }

        AmbientLightSensor {
            active: true
            onReadingChanged: {
                if (reading.lightLevel === AmbientLightReading.Dark) {
                    avatar.source = "3.png"
                    bg.color = "midnightblue"
                } else if (reading.lightLevel === AmbientLightReading.Twilight
                           || reading.lightLevel === AmbientLightReading.Light) {
                    avatar.source = "2.png"
                    bg.color = "steelblue"
                } else if (reading.lightLevel === AmbientLightReading.Bright
                         || reading.lightLevel === AmbientLightReading.Sunny) {
                    avatar.source = "1.png"
                    bg.color = "yellow"
                } else {
                    avatar.text = "Unknown light level"
                }
            }
        }

        LightSensor {
            active: true
            onReadingChanged: {
                illuminanceLevel.text = "Illuminance: " + reading.illuminance
            }
        }
    }
}
