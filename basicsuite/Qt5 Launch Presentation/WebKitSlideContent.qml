import QtQuick 2.0
import QtQuick.Particles 2.0
import QtWebKit 3.0

Item {
    id: slide

    anchors.fill: parent;

    WebView {
        id: browser
        anchors.fill: parent
        url: editor.text

    // This works around rendering bugs in webkit. CSS animations
    // and webGL content gets a bad offset, but this hack
    // clips it so it is not visible. Not ideal, but it kinda works
    // for now.
        layer.enabled: true
        layer.smooth: true
    }

    Rectangle {
        border.width: 2
        border.color: "black"
        opacity: 0.5
        color: "black"
        anchors.fill: editor
        anchors.margins: -editor.height * 0.2;

        radius: -anchors.margins
        antialiasing: true
    }

    TextInput {
        id: editor
        anchors.top: browser.bottom;
        anchors.horizontalCenter: browser.horizontalCenter
        font.pixelSize: slide.height * 0.05;
        text: "http://qt.digia.com"
        onAccepted: browser.reload();
        color: "white"

        onCursorPositionChanged: {
            var rect = positionToRectangle(cursorPosition);
            emitter.x = rect.x;
            emitter.y = rect.y;
            emitter.width = rect.width;
            emitter.height = rect.height;
            emitter.burst(10);
        }

        ParticleSystem {
            id: sys1
            running: slide.visible
        }

        ImageParticle {
            system: sys1
            source: "images/particle.png"
            color: "white"
            colorVariation: 0.2
            alpha: 0
        }

        Emitter {
            id: emitter
            system: sys1

            enabled: false

            lifeSpan: 2000

            velocity: PointDirection { xVariation: 30; yVariation: 30; }
            acceleration: PointDirection {xVariation: 30; yVariation: 30; y: 100 }

            endSize: 0

            size: 8
            sizeVariation: 2
        }
    }

}
