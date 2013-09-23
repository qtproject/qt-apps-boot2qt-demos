import QtQuick 2.0
import QtSensors 5.0

Item {
    Rectangle {
        id: field
        color: "lightblue"
        border.width: 1
        border.color: "darkblue"
        width: parent.width
        height: parent.height
        Accelerometer {
            id: accel
            active:true
            onReadingChanged: {
                var newX = (bubble.x + calcRoll(accel.reading.x, accel.reading.y, accel.reading.z) * .1)
                var newY = (bubble.y - calcPitch(accel.reading.x, accel.reading.y, accel.reading.z) * .1)

                if (newX < 0)
                    newX = 0
                if (newY < 0)
                    newY = 0

                var right = field.width - bubble.width
                var bottom = field.height - bubble.height

                if (newX > right)
                    newX = right
                if (newY > bottom)
                    newY = bottom

                bubble.x = newX
                bubble.y = newY
            }
        }

        Image {
            id: bubble
            source: "bluebubble.png"
            property real centerX: parent.width / 2
            property real centerY: parent.height / 2;
            property real bubbleCenter: bubble.width / 2
            x: centerX - bubbleCenter
            y: centerY - bubbleCenter
            smooth: true

            Behavior on y {
                SmoothedAnimation {
                    easing.type: Easing.Linear
                    duration: 100
                }
            }
            Behavior on x {
                SmoothedAnimation {
                    easing.type: Easing.Linear
                    duration: 100
                }
            }
        }
    }

    function calcPitch(x,y,z) {
        return Math.atan(y / Math.sqrt(x*x + z*z)) * 57.2957795;
    }
    function calcRoll(x,y,z) {
         return Math.atan(x / Math.sqrt(y*y + z*z)) * 57.2957795;
    }
}
