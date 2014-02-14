/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://qt.digia.com/
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
import QtQuick 2.0

import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Controls.Private 1.0

Rectangle {
    id: root
    width: 1280
    height: 800
    color: "#212126"
    property int margin: 10
    property alias buttonStyle: buttonStyle

    // ******************************* STYLES **********************************
    Component {
        id: buttonStyle
        ButtonStyle {
            panel: Item {
                implicitHeight: 50
                implicitWidth: 320
                BorderImage {
                    anchors.fill: parent
                    antialiasing: true
                    border.bottom: 8
                    border.top: 8
                    border.left: 8
                    border.right: 8
                    anchors.margins: control.pressed ? -4 : 0
                    source: control.pressed ? "images/button_pressed.png" : "images/button_default.png"
                    Text {
                        text: control.text
                        anchors.centerIn: parent
                        color: "white"
                        font.pixelSize: 23
                        renderType: Text.NativeRendering
                    }
                }
            }
        }
    }

    // GroupBoxStyle currently is not available as a public API, so we write our own...
    Component {
        id: groupBoxStyle
        Style {
            // The margin from the content item to the groupbox
            padding {
                top: (control.title.length > 0 ? TextSingleton.implicitHeight : 0) + 30
                left: 8
                right: 8
                bottom: 8
            }
            // The groupbox frame
            property Component panel: Item {
                anchors.fill: parent

                Text {
                    id: label
                    anchors.bottom: borderImage.top
                    anchors.margins: 2
                    text: control.title
                    font.pixelSize: 22
                    color: "white"
                    renderType: Text.NativeRendering
                }

                BorderImage {
                    id: borderImage
                    anchors.fill: parent
                    anchors.topMargin: padding.top - 7
                    source: "images/groupbox.png"
                    border.left: 4
                    border.right: 4
                    border.top: 4
                    border.bottom: 4
                }
            }
        }
    }

    // ******************************** UI ****************************************
    Loader { id: rebootActionLoader; source: "RebootAction.qml" }
    Loader { id: poweroffActionLoader; source: "PoweroffAction.qml" }
    Loader { id: brightnessControllerLoader; source: "BrightnessController.qml" }
    Loader { id: networkControllerLoader; source: "NetworkController.qml" }
    Loader { id: wifiControllerLoader; source: "WifiController.qml" }

    Flickable {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: margin
        anchors.topMargin: 50
        height: parent.height
        width: mainLayout.width
        contentHeight: mainLayout.height + 100
        contentWidth: mainLayout.width
        flickableDirection: Flickable.VerticalFlick

        ColumnLayout {
            id: mainLayout
            width: 800
            height: implicitHeight
            anchors.left: parent.left
            anchors.right: parent.right

            GroupBox {
                id: powerOptions
                title: "Power"
                Layout.fillWidth: true
                style: groupBoxStyle

                RowLayout {
                    id: powerButtonRow

                    anchors.fill: parent

                    Button {
                        style: buttonStyle
                        text: "Shut Down"
                        Layout.fillWidth: true
                        action: poweroffActionLoader.item;
                        enabled: action != undefined

                    }

                    Button {
                        style: buttonStyle
                        text: "Reboot"
                        Layout.fillWidth: true
                        action: rebootActionLoader.item;
                        enabled: action != undefined
                    }
                }

            }

            GroupBox {
                id: displayOptions
                title: "Display"
                style: groupBoxStyle
                Layout.fillWidth: true

                GridLayout {
                    id: displayGrid

                    rows: 2
                    flow: GridLayout.TopToBottom
                    anchors.fill: parent

                    Label { text: "Brightness: "; font.pixelSize: 18; color: "white" }
                    Label { text: "Display FPS: "; font.pixelSize: 18; color: "white" }

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

            GroupBox {
                id: networkOptions
                title: "Network"
                style: groupBoxStyle
                Layout.fillWidth: true

                GridLayout {
                    id: networkGrid

                    rows: 2
                    columns: 3
                    flow: GridLayout.TopToBottom
                    anchors.fill: parent

                    Label { text: "Hostname: "; font.pixelSize: 18; color: "white" }
                    Label { text: "IP address: "; font.pixelSize: 18; color: "white"}

                    TextField {
                        id: hostname
                        implicitHeight: hostnameButton.height - 8
                        text: if (networkControllerLoader.item != undefined) { networkControllerLoader.item.getHostname(); }
                        font.pixelSize: 18
                        Layout.fillWidth: true
                    }

                    Label {
                        text: if (networkControllerLoader.item != undefined) { networkControllerLoader.item.getIPAddress(); }
                        font.pixelSize: 18
                        color: "white"
                    }

                    Button {
                        id: hostnameButton
                        style: buttonStyle
                        text: "Change hostname"
                        onClicked: networkControllerLoader.item.setHostname(hostname.text);
                        enabled: networkControllerLoader.item != undefined
                    }

                }
            }

            GroupBox {
                id: wifiOptions
                title: "Wifi"
                style: groupBoxStyle
                Layout.fillWidth: true
            }

            Component.onCompleted: {
                if (wifiControllerLoader.item != undefined)
                    wifiControllerLoader.item.createWifiGroupBox()
                else
                    wifiOptions.visible = false
            }
        }
    }
}
