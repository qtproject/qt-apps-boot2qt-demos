import QtQuick 2.0

MouseArea {
    id: buttonRoot
    property alias title: titleTxt.text
    property alias subtitle: valueTxt.text
    property bool toggled: false

    width: 78 * root.contentScale
    height: 78 * root.contentScale
    opacity: pressed ? 0.3 : 1.0
    rotation: root.contentRotation
    Behavior on rotation { NumberAnimation { } }

    Rectangle {
        anchors.fill: parent
        color: toggled ? "#8898c66c" : "#77333333"
        radius: 5 * root.contentScale
    }

    Column {
        id: expModeControls
        spacing: 2 * root.contentScale
        anchors.centerIn: parent

        Text {
            id: titleTxt
            anchors.horizontalCenter: expModeControls.horizontalCenter
            font.pixelSize: 22 * root.contentScale
            font.letterSpacing: -1
            color: "white"
            font.bold: true
        }

        Text {
            id: valueTxt
            anchors.horizontalCenter: expModeControls.horizontalCenter
            height: 22 * root.contentScale
            verticalAlignment: Text.AlignVCenter
            color: "white"

            Connections {
                target: root
                onContentScaleChanged: valueTxt.font.pixelSize = Math.round(18 * root.contentScale)
            }

            onTextChanged: font.pixelSize = Math.round(18 * root.contentScale)
            onPaintedWidthChanged: {
                if (paintedWidth > buttonRoot.width - (8 * root.contentScale))
                    font.pixelSize -= Math.round(2 * root.contentScale);
            }
        }
    }
}
