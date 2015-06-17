/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://www.qt.io
**
** This file is part of the examples of the Qt Enterprise Embedded.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Enterprise.VirtualKeyboard.Settings 1.2
import B2Qt.Wifi 1.0
import B2Qt.Utils 1.0

Rectangle {
    anchors.fill: parent
    color: "#212126"


    Flickable {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: engine.mm(5)
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
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: engine.mm(4)

            GroupBox {
                id: powerOptions
                title: "Power"
                Layout.fillWidth: true
                style: SettingsGroupBoxStyle {}
                implicitWidth: 0
                height: implicitHeight

                RowLayout {
                    anchors.fill: parent

                    Button {
                        style: SettingsButtonStyle {}
                        text: "Shut Down"
                        Layout.fillWidth: true
                        onClicked: B2QtDevice.powerOff();
                    }

                    Button {
                        style: SettingsButtonStyle {}
                        text: "Reboot"
                        Layout.fillWidth: true
                        onClicked: B2QtDevice.reboot();
                    }
                }
            }

            GroupBox {
                id: displayOptions
                title: "Display"
                style: SettingsGroupBoxStyle {}
                Layout.fillWidth: true
                implicitWidth: 0
                height: implicitHeight

                GridLayout {
                    rows: 2
                    flow: GridLayout.TopToBottom
                    anchors.fill: parent

                    Label {
                        text: "Brightness: "
                        font.pixelSize: engine.smallFontSize() * 0.8
                        color: "white"
                    }

                    Label {
                        text: "Display FPS: "
                        font.pixelSize: engine.smallFontSize() * 0.8
                        color: "white"
                    }

                    Slider {
                        id: brightnessSlider
                        maximumValue: 255
                        minimumValue: 1
                        Layout.fillWidth: true
                        value: B2QtDevice.displayBrightness
                        style: SliderStyle {
                            handle: Rectangle {
                                anchors.centerIn: parent
                                color: "white"
                                border.color: "gray"
                                border.width: 2
                                width: engine.mm(6)
                                height: engine.mm(6)
                                radius: 20
                            }
                        }
                    }

                    CheckBox {
                        style: SettingsCheckBoxStyle {}
                        checked: engine.fpsEnabled
                        onCheckedChanged: engine.fpsEnabled = checked
                    }
                }
            }

            GroupBox {
                id: vkbOptions
                title: "Virtual Keyboard Style"
                style: SettingsGroupBoxStyle {}
                Layout.fillWidth: true

                function updateVKBStyle(styleRadioButton) {
                    VirtualKeyboardSettings.styleName = styleRadioButton.text.toLowerCase()
                }

                Row {
                    spacing: engine.mm(6)
                    ExclusiveGroup { id: vkbStyleGroup }
                    RadioButton {
                        id: defaultStyle
                        style: SettingsRadioButtonStyle {}
                        text: "Default"
                        exclusiveGroup: vkbStyleGroup
                        onClicked: vkbOptions.updateVKBStyle(defaultStyle)
                    }
                    RadioButton {
                        id: retroStyle
                        style: SettingsRadioButtonStyle {}
                        text: "Retro"
                        exclusiveGroup: vkbStyleGroup
                        onClicked: vkbOptions.updateVKBStyle(retroStyle)
                    }
                }

                Binding {
                    target: B2QtDevice
                    property: "displayBrightness"
                    value: brightnessSlider.value
                }

                Component.onCompleted: {
                   if (VirtualKeyboardSettings.styleName == "default")
                       defaultStyle.checked = true
                   if (VirtualKeyboardSettings.styleName == "retro")
                       retroStyle.checked = true
                }
            }

            GroupBox {
                id: networkOptions
                title: "Network"
                style: SettingsGroupBoxStyle {}
                Layout.fillWidth: true
                implicitWidth: 0
                height: implicitHeight

                GridLayout {
                    rows: 2
                    columns: 3
                    flow: GridLayout.TopToBottom
                    anchors.fill: parent

                    Label {
                        text: "Hostname: "
                        font.pixelSize: engine.smallFontSize() * 0.8
                        color: "white"
                    }

                    Label {
                        text: "IP address: "
                        font.pixelSize: engine.smallFontSize() * 0.8
                        color: "white"
                    }

                    TextField {
                        id: hostname
                        text: B2QtDevice.hostname
                        placeholderText: "Enter hostname"
                        font.pixelSize: engine.smallFontSize()
                        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhPreferLowercase | Qt.ImhNoPredictiveText
                        Layout.fillWidth: true
                        Layout.preferredHeight: font.pixelSize * 2.4
                        onAccepted: {
                            Qt.inputMethod.commit()
                            Qt.inputMethod.hide()
                            B2QtDevice.setHostname(hostname.text)
                            hostname.focus = false
                        }
                    }

                    Label {
                        text: B2QtDevice.ipAddress
                        font.pixelSize: engine.smallFontSize()
                        color: "white"
                        Layout.columnSpan: 2
                    }

                    Button {
                        id: hostnameButton
                        style: SettingsButtonStyle {}
                        text: "Change hostname"
                        onClicked: hostname.accepted()
                    }
                }
            }

            GroupBox {
                id: dpiOptions
                title: "Physical screen size"
                style: SettingsGroupBoxStyle {}
                Layout.fillWidth: true
                implicitWidth: 0
                height: implicitHeight

                GridLayout {
                    rows: 2
                    columns: 2
                    anchors.fill: parent

                    RowLayout {
                        Layout.columnSpan: 2
                        Label {
                            text: "Override (needs restart)"
                            font.pixelSize: engine.smallFontSize() * 0.8
                            color: "white"
                        }
                        CheckBox {
                            id: physSizeCb
                            style: SettingsCheckBoxStyle {}
                            checked: B2QtDevice.physicalScreenSizeOverride
                            onCheckedChanged: B2QtDevice.physicalScreenSizeOverride = checked
                        }
                    }

                    Label {
                        visible: physSizeCb.checked
                        text: "Size: " + physSizeSlider.value + " inches"
                        font.pixelSize: engine.smallFontSize() * 0.8
                        color: "white"
                    }

                    Slider {
                        visible: physSizeCb.checked
                        id: physSizeSlider
                        maximumValue: 60
                        minimumValue: 4
                        Layout.fillWidth: true
                        value: B2QtDevice.physicalScreenSizeInch
                        stepSize: 1
                        style: SliderStyle {
                            handle: Rectangle {
                                anchors.centerIn: parent
                                color: "white"
                                border.color: "gray"
                                border.width: 2
                                width: engine.mm(6)
                                height: engine.mm(6)
                                radius: 20
                            }
                        }
                    }
                    Binding {
                        target: B2QtDevice
                        property: "physicalScreenSizeInch"
                        value: physSizeSlider.value
                    }
                }
            }

            GroupBox {
                id: wifiOptions
                title: "Wifi"
                style: SettingsGroupBoxStyle {}
                Layout.fillWidth: true
                visible: false

                function createWifiGroupBox()
                {
                    if (WifiDevice.wifiSupported()) {
                        var component = Qt.createComponent("WifiGroupBox.qml")
                        var wifi = component.createObject(wifiOptions.contentItem)
                        if (wifi)
                            wifiOptions.visible = true
                        else
                            print("Error creating WifiGroupBox")
                    }
                }

                Component.onCompleted: wifiOptions.createWifiGroupBox()
            }
        }
    }
}
