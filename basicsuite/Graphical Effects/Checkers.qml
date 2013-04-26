import QtQuick 2.0


// The checkers background
ShaderEffect {

    property real tileSize: 16
    property color color1: Qt.rgba(0.7, 0.7, 0.7, 1);
    property color color2: Qt.rgba(0.6, 0.6, 0.6, 1);

    property size _pixelSize: Qt.size(Math.PI * width / tileSize, Math.PI * height / tileSize);

    fragmentShader:
        "
        uniform lowp vec4 color1;
        uniform lowp vec4 color2;
        uniform lowp float qt_Opacity;
        uniform highp vec2 _pixelSize;
        varying highp vec2 qt_TexCoord0;
        void main() {
            highp vec2 tc = sign(sin(qt_TexCoord0 * _pixelSize));
            if (tc.x != tc.y)
                gl_FragColor = color1 * qt_Opacity;
            else
                gl_FragColor = color2 * qt_Opacity;
        }
        "
}
