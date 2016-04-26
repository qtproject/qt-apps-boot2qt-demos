/******************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
******************************************************************************/
import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Enterprise.VirtualKeyboard.Settings 2.0
import B2Qt.Wifi 1.0
import B2Qt.Utils 1.0

Rectangle {
    anchors.fill: parent
    color: "white"

    Flickable {
        anchors.top: parent.top
        anchors.topMargin: engine.mm(5)
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height
        width: parent.width
        contentHeight: mainLayout.height + engine.centimeter(2)
        contentWidth: mainLayout.width
        flickableDirection: Flickable.VerticalFlick
        leftMargin: (width - contentWidth) * 0.5

        ColumnLayout {
            id: mainLayout
            width: Math.min(engine.screenWidth(), engine.screenHeight())
            height: implicitHeight
            anchors.horizontalCenter: parent.horizontalCenter

            property int defaultMargin: width * .1
            property int column1Width: width * .25

            Label {
                text: qsTr("Demo Launcher Settings")
                font.pixelSize: engine.titleFontSize()
                Layout.topMargin: height
                Layout.bottomMargin: height
            }

            SettingTitle {
                titleText: qsTr("Network")
                iconSource: "images/Network_icon.png"
                smallText: qsTr("Current hostname: %1").arg(B2QtDevice.hostname)
            }

            GridLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                Layout.bottomMargin: engine.mm(3)
                columns: 3
                rows: 3

                Label {
                    text: qsTr("Change Hostname:")
                    font.pixelSize: engine.smallFontSize()
                    Layout.preferredWidth: mainLayout.column1Width
                    Layout.leftMargin: mainLayout.defaultMargin
                }

                TextField {
                    id: hostname
                    text: B2QtDevice.hostname
                    placeholderText: qsTr("Enter hostname")
                    font.pixelSize: engine.smallFontSize()
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhPreferLowercase | Qt.ImhNoPredictiveText
                    Layout.fillWidth: true
                    Layout.rightMargin: mainLayout.defaultMargin * .25
                    onAccepted: {
                        Qt.inputMethod.commit()
                        Qt.inputMethod.hide()
                        B2QtDevice.setHostname(hostname.text)
                        hostname.focus = false
                    }
                }

                Button {
                    id: hostnameButton

                    anchors.right: parent.right
                    text: qsTr("Change")

                    onClicked: hostname.accepted()
                }

                Label {
                    text: qsTr("IP Address:")
                    Layout.preferredWidth: parent.width * .2
                    font.pixelSize: engine.smallFontSize()
                    Layout.leftMargin: mainLayout.defaultMargin
                }

                Label {
                    text: B2QtDevice.ipAddress
                    font.pixelSize: engine.smallFontSize()
                }
            }

            ColumnLayout {
                id: wifiOptions
                Layout.fillWidth: true
                Layout.leftMargin: mainLayout.defaultMargin
                visible: false

                function createWifiGroupBox()
                {
                    if (WifiDevice.wifiSupported()) {
                        var component = Qt.createComponent("WifiGroupBox.qml")
                        var wifi = component.createObject(wifiOptions)
                        if (wifi) {
                            wifiOptions.visible = true
                        } else {
                            print("Error creating WifiGroupBox")
                        }
                    }
                }
                Component.onCompleted: wifiOptions.createWifiGroupBox()
            }

            Spacer {}

            SettingTitle {
                id: vKBSettingsTitle
                titleText: qsTr("Virtual Keyboard Style")
                iconSource: "images/Keyboard_icon.png"
                smallText: qsTr("Preview:")
            }

            RowLayout {
                id: row1
                spacing: 0
                anchors.left: parent.left
                anchors.right: parent.right

                GridLayout {
                    id: vKBStyleSelection
                    anchors.left: parent.left
                    anchors.right: parent.horizontalCenter
                    columns: 2
                    rows: 2

                    function updateVKBStyle(style) {
                        VirtualKeyboardSettings.styleName = style.toLowerCase()
                    }

                    ExclusiveGroup { id: vkbStyleGroup }

                    Label {
                        text: qsTr("Default")
                        Layout.preferredWidth: mainLayout.column1Width
                        font.pixelSize: engine.smallFontSize()
                        Layout.leftMargin: mainLayout.defaultMargin
                    }

                    RadioButton {
                        id: defaultStyle
                        exclusiveGroup: vkbStyleGroup
                        checked: VirtualKeyboardSettings.styleName === "default"
                        onClicked: vKBStyleSelection.updateVKBStyle("default")
                    }

                    Label {
                        text: qsTr("Retro")
                        Layout.preferredWidth: mainLayout.column1Width
                        font.pixelSize: engine.smallFontSize()
                        Layout.leftMargin: mainLayout.defaultMargin
                    }

                    RadioButton {
                        id: retroStyle
                        exclusiveGroup: vkbStyleGroup
                        checked: VirtualKeyboardSettings.styleName === "retro"
                        onClicked: vKBStyleSelection.updateVKBStyle("retro")
                    }
                }

                Image {
                    id: vKBPreviewThumbnail
                    anchors.right: parent.right
                    Layout.preferredWidth: mainLayout.width *.4
                    Layout.leftMargin: mainLayout.defaultMargin
                    source: VirtualKeyboardSettings.styleName === "retro" ?
                                "images/Keyboard_Thumb_retro.png" :
                                "images/Keyboard_Thumb_default.png"

                    fillMode: Image.PreserveAspectFit
                }
            }

            Spacer {}

            SettingTitle {
                titleText: qsTr("Display")
                iconSource: "images/Display_icon.png"
            }

            GridLayout {
                id: gridLayout
                anchors.left: parent.left
                anchors.right: parent.right
                columns: 3
                rows: 3

                Label {
                    text: qsTr("Brightness:")
                    font.pixelSize: engine.smallFontSize()
                    Layout.preferredWidth: mainLayout.column1Width
                    Layout.leftMargin: mainLayout.defaultMargin
                }

                Slider {
                    id: brightnessSlider
                    maximumValue: 255
                    minimumValue: 1
                    Layout.preferredWidth: physicalSizeSlider.width
                    value: B2QtDevice.displayBrightness
                }

                Binding {
                    target: B2QtDevice
                    property: "displayBrightness"
                    value: brightnessSlider.value
                }

                Text {
                    text: qsTr("%1%").arg(Math.round(brightnessSlider.value / brightnessSlider.maximumValue * 100))
                    font.pixelSize: engine.smallFontSize()
                    Layout.leftMargin: mainLayout.width * .05
                }

                Label {
                    text: qsTr("Display FPS:")
                    font.pixelSize: engine.smallFontSize()
                    Layout.preferredWidth: parent.width * .2
                    Layout.leftMargin: mainLayout.defaultMargin
                }

                CheckBox {
                    checked: engine.fpsEnabled
                    onCheckedChanged: engine.fpsEnabled = checked
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: mainLayout.defaultMargin
                anchors.right: parent.right
                height: advancedDisplaySettings.height + engine.mm(6)
                color: "#efefef"

                GridLayout {
                    id: advancedDisplaySettings
                    anchors { left: parent.left; top:parent.top; right: parent.right }
                    anchors.margins: engine.mm(3)
                    columns: 3
                    rows: 3

                    Label {
                        text: qsTr("Physical Screen Size:")
                        font.pixelSize: engine.smallFontSize()
                        wrapMode: Text.WordWrap
                        Layout.preferredWidth: mainLayout.width * .25 - advancedDisplaySettings.anchors.margins
                    }

                    Slider {
                        id: physicalSizeSlider
                        maximumValue: 60
                        minimumValue: 4
                        Layout.fillWidth: true
                        value: B2QtDevice.physicalScreenSizeInch
                    }

                    Text {
                        text: qsTr("%1 inches").arg(Math.round(physicalSizeSlider.value))
                        font.pixelSize: engine.smallFontSize()
                        Layout.preferredWidth: mainLayout.width * .1
                        Layout.leftMargin: mainLayout.width * .05
                    }

                    Label {
                        text: qsTr("Override\n(needs restart):")
                        font.pixelSize: engine.smallFontSize()
                        wrapMode: Text.WordWrap
                        Layout.preferredWidth: mainLayout.width * .25 - advancedDisplaySettings.anchors.margins
                    }

                    CheckBox {
                        checked: B2QtDevice.physicalScreenSizeOverride
                        onCheckedChanged: B2QtDevice.physicalScreenSizeOverride = checked
                    }
                }
            }

            Spacer {}

            SettingTitle {
                titleText: qsTr("Power")
                iconSource: "images/Power_icon.png"
            }

            RowLayout {
                spacing: mainLayout.defaultMargin *.25

                Button {
                    text: qsTr("Shut Down")
                    Layout.leftMargin: mainLayout.defaultMargin
                    onClicked: B2QtDevice.powerOff();
                }

                Button {
                    text: qsTr("Reboot")
                    onClicked: B2QtDevice.reboot();
                }
            }
        }
    }
}
