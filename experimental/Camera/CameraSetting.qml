import QtQuick 2.0

Item {
    width: button.width
    height: button.height
    visible: enabled && picker.count > 1

    property alias title: button.title
    property alias selectedValue: picker.value
    property alias currentIndex: picker.currentIndex
    property alias model: picker.model
    property alias count: picker.count

    CameraControlButton {
        id: button
        anchors.centerIn: parent

        subtitle: picker.name
        toggled: picker.visible

        onClicked: picker.visible = true
    }

    Picker {
        id: picker
    }

}
