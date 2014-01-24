/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
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

    Loader {
        id: networkControllerLoader
        source: "NetworkController.qml"
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

                GridLayout {
                    id: displayGrid

                    rows: 2
                    flow: GridLayout.TopToBottom
                    anchors.fill: parent

                    Label { text: "Brightness: "; }
                    Label { text: "Display FPS: "; }

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
                title: "Network Options"

                Layout.fillWidth: true

                GridLayout {
                    id: networkGrid

                    rows: 2
                    columns: 3
                    flow: GridLayout.TopToBottom
                    anchors.fill: parent

                    Label { text: "Hostname: "; }
                    Label { text: "IP address: "; }

                    TextField {
                        id: hostname
                        text: if (networkControllerLoader.item != undefined) { networkControllerLoader.item.getHostname(); }
                        Layout.fillWidth: true
                    }

                    Label { text: if (networkControllerLoader.item != undefined) { networkControllerLoader.item.getIPAddress(); } }

                    Button {
                        text: "Change hostname"
                        onClicked: networkControllerLoader.item.setHostname(hostname.text);
                        enabled: networkControllerLoader.item != undefined
                    }

                }
            }
        }
    }
}
