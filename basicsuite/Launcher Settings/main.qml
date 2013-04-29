import QtQuick 2.0

import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Rectangle {
    id: root;

    gradient: Gradient {
        GradientStop { position: 0; color: "white" }
        GradientStop { position: 1; color: "lightgray" }
    }

    width: 1280
    height: 800

    property int margin: 10

    Loader {
        id: rebootActionLoader
        source: "RebootAction.qml"
    }

    Loader {
        id: poweroffActionLoader
        source: "PoweroffAction.qml"
    }

    Loader {
        id: brightnessControllerLoader
        source: "BrightnessController.qml"
    }

    Flickable {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: margin
        anchors.topMargin: 50
        height: parent.height
        width: mainLayout.width

        contentHeight: mainLayout.height
        contentWidth: mainLayout.width

        ColumnLayout {
            id: mainLayout

            height: implicitHeight;
            width: Math.min(root.width, root.height);

            GroupBox {
                id: powerOptions
                title: "Power Options"

                Layout.fillWidth: true

                contentWidth: powerButtonColumn.implicitWidth
                contentHeight: powerButtonColumn.implicitHeight

                RowLayout {
                    id: powerButtonColumn

                    anchors.fill: parent

                    Button {
                        text: "Shut Down"
                        Layout.fillWidth: true
                        action: poweroffActionLoader.item;
                        enabled: action != undefined
                    }

                    Button {
                        text: "Reboot"
                        Layout.fillWidth: true
                        action: rebootActionLoader.item;
                        enabled: action != undefined
                    }
                }

            }

            GroupBox {
                id: displayOptions
                title: "Display Options"

                Layout.fillWidth: true

                contentWidth: displayGrid.implicitWidth
                contentHeight: displayGrid.implicitHeight

                GridLayout {
                    id: displayGrid

                    rows: 2
                    flow: GridLayout.TopToBottom
                    anchors.fill: parent

                    Label { text: "Brightness: " }
                    Label { text: "Display FPS: " }

                    Slider {
                        maximumValue: 255
                        minimumValue: 1
                        value: 255
                        Layout.fillWidth: true
                        onValueChanged: {
                            if (brightnessControllerLoader.item != undefined) {
                                brightnessControllerLoader.item.setBrightness(value);
                            }
                        }
                    }
                    CheckBox {
                        onCheckedChanged: engine.fpsEnabled = checked;
                    }
                }
            }
        }
    }
}