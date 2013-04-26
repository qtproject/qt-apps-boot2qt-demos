import QtQuick 2.0

Item {
    id: root

    property real inputX: 0.9;
    property real feedbackX: shader.zrot
    property string nameX: "Rotation"

    property real inputY: 0.7
    property real feedbackY: shader.amp
    property string nameY: "Amplitude"


    ShaderEffect {
        id: shader
        width: height
        height: parent.height
        anchors.centerIn: parent;
        scale: height > root.height * 0.8 ? root.height * 0.8 / height : 1;

        blending: true

        mesh: "50x50"

        property variant size: Qt.size(width, height);

        property variant source: Image { source: "images/bug.jpg" }

        property real amp: root.inputY * 0.1;

        property real xrot: 2 / 8 * Math.PI;

        property real zrot: -root.inputX * Math.PI * 2

        property real time: 0
        NumberAnimation on time {
            id: timeAnimation
            from: 0;
            to: Math.PI * 2;
            duration: 3457;
            loops: Animation.Infinite
            running: true;
        }

        vertexShader: "
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;
        uniform highp mat4 qt_Matrix;
        uniform highp float xrot;
        uniform highp float zrot;
        uniform highp vec2 size;
        uniform highp float time;
        uniform highp float amp;
        varying lowp vec2 v_TexCoord;
        varying lowp float v_light;
        void main() {
            highp float xcosa = cos(xrot);
            highp float xsina = sin(xrot);

            highp mat4 xrot = mat4(1, 0, 0, 0,
                                   0, xcosa, xsina, 0,
                                   0, -xsina, xcosa, 0,
                                   0, 0, 0, 1);

            highp float zcosa = cos(zrot);
            highp float zsina = sin(zrot);

            highp mat4 zrot = mat4(zcosa, zsina, 0, 0,
                                   -zsina, zcosa, 0, 0,
                                   0, 0, 1, 0,
                                   0, 0, 0, 1);

            highp float near = 2.;
            highp float far = 6.;
            highp float fmn = far - near;

            highp mat4 proj = mat4(near, 0, 0, 0,
                                   0, near, 0, 0,
                                   0, 0, -(far + near) / fmn, -1.,
                                   0, 0, -2. * far * near / fmn, 1);

            highp mat4 model = mat4(2, 0, 0, 0,
                                    0, 2, 0, 0,
                                    0, 0, 2, 0,
                                    0, -.5, -4, 1);

            vec4 nLocPos = vec4(qt_Vertex.xy * 2.0 / size - 1.0, 0, 1);
            nLocPos.z = cos(nLocPos.x * 5. + time) * amp;

            vec4 pos = proj * model * xrot * zrot * nLocPos;
            pos = vec4(pos.xyx/pos.w, 1);

            gl_Position = qt_Matrix * vec4((pos.xy + 1.0) / 2.0 * size , 0, 1);

            v_TexCoord = qt_MultiTexCoord0;


            v_light = dot(normalize(vec3(-sin(nLocPos.x * 5.0 + time) * 5.0 * amp, 0, -1)), vec3(0, 0, -1));
        }
        "

        fragmentShader: "
            uniform lowp sampler2D source;
            uniform lowp float qt_Opacity;
            varying highp vec2 v_TexCoord;
            varying lowp float v_light;
            void main() {
                highp vec4 c = texture2D(source, v_TexCoord);
                gl_FragColor = (vec4(pow(v_light, 16.0)) * 0.3 + c) * qt_Opacity;
            }
        "

    }

}


