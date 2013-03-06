import QtQuick 2.0

Item {
    id: root

    width: 1280
    height: 800

//    Rectangle {
//        anchors.fill: parent
//        color: "black"
//    }

    Flickable {
        id: flick
        property real inertia: 0.2

        property real cellWidth;
        property real cellHeight;

        width: parent.width * 2 / 3
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter

        contentHeight: content.height

        flickableDirection: Flickable.VerticalFlick

        Item {
            id: shiftTrickery

            width: content.width
            height: content.height

            Column {
                id: content;

                y: -flick.contentItem.y + offsetY;
                width: flick.width

                property real offsetY: 0;
                property real inertia: flick.inertia;
                property real t;
                NumberAnimation on t {
                    id: animation;
                    from: 0;
                    to: 1;
                    duration: 1000;
                    loops: Animation.Infinite
                    running: Math.abs(content.y) > 0.001 || Math.abs(content.x) > 0.001
                }

                onTChanged: {
                    offsetY += (flick.contentItem.y - offsetY) * inertia
                }


                spacing: engine.smallFontSize() * 2

                Item { width: 1; height: engine.smallFontSize() }
                AboutBoot2Qt { }
                QtFramework { }
                QtForAndroid { }
                Image {
                    id: codeLessImage
                    source: "codeless.png"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Item { width: 1; height: engine.smallFontSize() }
            }

        }
    }
}
