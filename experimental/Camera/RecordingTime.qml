import QtQuick 2.0

Rectangle {
    id: recRoot
    width: row.width + 14 * root.contentScale
    height: circle.height + 14 * root.contentScale
    color: "#77333333"
    radius: 5 * root.contentScale
    rotation: root.contentRotation
    Behavior on rotation { NumberAnimation { } }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 10 * root.contentScale

        Item {
            anchors.verticalCenter: timeText.verticalCenter
            width: 18 * root.contentScale
            height: width

            Rectangle {
                id: circle
                width: parent.width
                height: parent.height
                radius: width / 2
                color: "#fa334f"

                SequentialAnimation {
                    loops: Animation.Infinite
                    running: recRoot.visible
                    PropertyAction { target: circle; property: "visible"; value: true }
                    PauseAnimation { duration: 1000 }
                    PropertyAction { target: circle; property: "visible"; value: false }
                    PauseAnimation { duration: 1000 }
                }
            }
        }

        Text {
            id: timeText
            color: "white"
            font.pixelSize: 24 * root.contentScale
            text: formatTime(camera.videoRecorder.duration)
        }
    }

    function formatTime(time) {
         time = time / 1000
         var hours = Math.floor(time / 3600);
         time = time - hours * 3600;
         var minutes = Math.floor(time / 60);
         var seconds = Math.floor(time - minutes * 60);

         if (hours > 0)
             return formatTimeBlock(hours) + ":" + formatTimeBlock(minutes) + ":" + formatTimeBlock(seconds);
         else
             return formatTimeBlock(minutes) + ":" + formatTimeBlock(seconds);

     }

     function formatTimeBlock(time) {
         if (time === 0)
             return "00"
         if (time < 10)
             return "0" + time;
         else
             return time.toString();
     }
}
