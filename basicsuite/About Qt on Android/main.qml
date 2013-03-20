import QtQuick 2.0
import QtQuick.Particles 2.0

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
        property real inertia: 0.4

        property real cellWidth;
        property real cellHeight;

        width: parent.width
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter

        contentHeight: content.height

        flickableDirection: Flickable.VerticalFlick

        property real topOvershoot: Math.max(0, contentItem.y);
        property real bottomOvershoot: Math.max(0, root.height - (contentItem.height + contentItem.y));
//        onTopOvershootChanged: print("Top Overshoot:", topOvershoot);
//        onBottomOvershootChanged: print("Bottom Overshoot:", bottomOvershoot);

        Item {
            id: shiftTrickery

            width: flick.width
            height: content.height

            Column {
                id: content;

                y: -flick.contentItem.y + offsetY;
                width: flick.width * 2 / 3
                anchors.horizontalCenter: parent.horizontalCenter

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

    ParticleSystem {

        anchors.fill: parent

        ImageParticle {
            id: imageParticle
            source: "particle.png"
            color: "#80c342"
            alpha: 0
            colorVariation: 0.3
            entryEffect: ImageParticle.None
        }

        Emitter {
            id: topEmitter
            width: root.width
            height: 1
            x: 0
            y: -1
            shape: EllipseShape { fill: true }

            emitRate: 300
            lifeSpan: 1000
            size: 20
            sizeVariation: 4
            endSize: 0

            enabled: flick.topOvershoot > 0

            velocity: PointDirection { xVariation: 10; yVariation: 50; y: Math.sqrt(flick.topOvershoot) * 10; }
            acceleration: PointDirection { y: 50 }
        }

        Emitter {
            id: bottomEmitter
            width: root.width
            height: 1
            x: 0
            y: root.height + 1
            shape: EllipseShape { fill: true }

            emitRate: 300
            lifeSpan: 1000
            size: 20
            sizeVariation: 4
            endSize: 0

            enabled: flick.bottomOvershoot > 0

            velocity: PointDirection { xVariation: 10; yVariation: -50; y: Math.sqrt(flick.bottomOvershoot) * -10; }
            acceleration: PointDirection { y: -50 }
        }
    }
}
