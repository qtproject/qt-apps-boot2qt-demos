import QtQuick 2.0

MouseArea {
    id: pickerRoot

    parent: root
    anchors.fill: parent

    onClicked: visible = false
    visible: false

    property alias contentWidth: back.width
    property real contentHeight: 350 * root.contentScale
    property alias model: list.model
    property variant value: null
    property string name: ""
    property alias currentIndex: list.currentIndex
    property alias count: list.count

    onValueChanged: {
        for (var i = 0; i < list.count; ++i) {
            var data = list.model[i];
            if (data === undefined)
                data = list.model.get(i);
            if (data.value === pickerRoot.value) {
                list.currentIndex = i;
                return;
            }
        }
        list.currentIndex = -1;
    }

    Rectangle {
        id: back
        color: "#77333333"
        width: 200 * root.contentScale
        height: Math.min(pickerRoot.contentHeight, list.contentHeight + list.anchors.margins * 2)
        anchors.centerIn: parent
        property int itemHeight: 25 * root.contentScale
        rotation: root.contentRotation
        Behavior on rotation { NumberAnimation { } }

        ListView {
            id: list
            anchors.fill: parent
            clip: true
            anchors.margins: 14 * root.contentScale

            currentIndex: -1

            onCurrentIndexChanged: {
                if (list.currentIndex >= 0) {
                    var data = list.model[list.currentIndex];
                    if (data === undefined)
                        data = list.model.get(list.currentIndex);
                    pickerRoot.value = data.value;
                    pickerRoot.name = data.name;
                } else {
                    pickerRoot.value = null
                    pickerRoot.name = ""
                }
            }

            delegate: Item {
                height: 40 * root.contentScale
                width: parent.width
                Rectangle {
                    anchors.fill: parent
                    border.color: index == list.currentIndex ? "#44ffffff" : "transparent"
                    color: index == list.currentIndex ? "#22ffffff" : "transparent"
                    radius: 3 * root.contentScale
                    Text {
                        color: "white"
                        text: (typeof modelData === 'undefined' ? name : modelData.name)
                        anchors.centerIn: parent
                        font.pixelSize: Math.round(20 * root.contentScale)
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked:  {
                            list.currentIndex = index;
                        }
                    }
                }
            }
        }
    }
}

