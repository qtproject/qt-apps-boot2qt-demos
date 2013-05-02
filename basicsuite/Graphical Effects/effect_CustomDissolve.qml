import QtQuick 2.0

Item {


    width: 700
    height: 600
    id: root

    property real inputX: 0.5;
    property real feedbackX: inputX
    property string nameX: "Dissolution"

    property real inputY: 0.5;
    property real feedbackY: effect.amplitude
    property string nameY: "Amplitude"

    Rectangle {
        id: sourceItem
        anchors.centerIn: parent
        width: text.width + 50
        height: text.height + 20
        gradient: Gradient {
            GradientStop { position: 0; color: "steelblue" }
            GradientStop { position: 1; color: "black" }
        }
        border.color: "lightsteelblue"
        border.width: 2

//?        color: "transparent"

        radius: 10

        layer.enabled: true
        layer.smooth: true
        layer.sourceRect: Qt.rect(-1, -1, width + 2, height + 2);

        visible: false

        Text {
            id: text
            font.pixelSize: root.height * 0.08
            anchors.centerIn: parent;
            text: "Code Less, Create More!"
            color: "lightsteelblue"
            style: Text.Raised

        }
    }

    ShaderEffect {

        id: effect

        anchors.fill: sourceItem;

        property variant source: sourceItem;

        property real t: (1 + tlength) * (1 - root.inputX) - tlength;
        property real tlength: 1.0
        property real amplitude: 2.0 * height * root.inputY;

        mesh: "40x4"

        vertexShader:
            "
            uniform highp mat4 qt_Matrix;
            uniform lowp float t;
            uniform lowp float tlength;
            uniform highp float amplitude;

            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;

            varying highp vec2 vTexCoord;
            varying lowp float vOpacity;

            void main() {
                vTexCoord = qt_MultiTexCoord0;

                vec4 pos = qt_Vertex;

                lowp float tt = smoothstep(t, t+tlength, qt_MultiTexCoord0.x);

                vOpacity = 1.0 - tt;

                pos.y += (amplitude * (qt_MultiTexCoord0.y * 2.0 - 1.0) * (-2.0 * tt)
                          + 3.0 * amplitude * (qt_MultiTexCoord0.y * 2.0 - 1.0)
                          + amplitude * sin(0.0 + tt * 2.14152 * qt_MultiTexCoord0.x)
                          + amplitude * sin(0.0 + tt * 7.4567)
                         ) * tt;

                pos.x += amplitude * sin(6.0 + tt * 4.4567) * tt;

                gl_Position = qt_Matrix * pos;
            }
            "
        fragmentShader:
            "
            uniform sampler2D source;

            uniform lowp float t;
            uniform lowp float tlength;
            uniform lowp float qt_Opacity;

            varying highp vec2 vTexCoord;
            varying lowp float vOpacity;

            // Noise function from: http://stackoverflow.com/questions/4200224/random-noise-functions-for-glsl
            highp float rand(vec2 n) {
                return fract(sin(dot(n.xy, vec2(12.9898, 78.233))) * 43758.5453);
            }

            void main() {
                lowp vec4 tex = texture2D(source, vTexCoord);
                lowp float opacity = 1.0 - smoothstep(0.9, 1.0, vOpacity);
                lowp float particlify = smoothstep(1.0 - vOpacity, 1.0, rand(vTexCoord)) * vOpacity;
                gl_FragColor = tex * mix(vOpacity, particlify, opacity) * qt_Opacity;
            }

            "

    }

}
