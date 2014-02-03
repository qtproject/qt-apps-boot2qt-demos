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
import Qt.labs.wifi 0.1

Item {
    Component {
        id: listDelegate
        Rectangle {
            id: delegateBackground
            property bool expanded: false
            property bool connected: wifiManager.connectedSSID == network.ssid
            property variant networkModel: model
            property alias ssidText: ssidLabel.text
            height: expanded ? 300 : 70
            clip: true // ### fixme

            Behavior on height { NumberAnimation { duration: 500; easing.type: Easing.InOutCubic } }

            width: parent.width

            gradient: Gradient {
                GradientStop { position: 0; color: "white" }
                GradientStop { position: 1; color: "lightgray" }
            }

            Text {
                id: ssidLabel
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                font.pixelSize: 20
                font.bold: true
                text: network.ssid + (connected ? " (connected)" : "");
            }

            Text {
                id: bssidLabel
                anchors.top: ssidLabel.bottom
                anchors.left: parent.left
                anchors.margins: 5
                anchors.leftMargin: 40
                text: network.bssid
                color: "gray"
                font.pixelSize: ssidLabel.font.pixelSize * 0.5
            }

            Text {
                id: flagsLabel
                x: 200
                anchors.top: bssidLabel.top
                text: (network.supportsWPA2 ? "WPA2 " : "")
                      + (network.supportsWPA ? "WPA " : "")
                      + (network.supportsWEP ? "WEP " : "")
                      + (network.supportsWPS ? "WPS " : "");
                color: "gray"
                font.pixelSize: ssidLabel.font.pixelSize * 0.5
                font.italic: true
            }

            Rectangle {
                width: Math.max(100 + network.signalStrength, 0) / 100 * parent.width;
                height: 20
                radius: 10
                antialiasing: true
                anchors.margins: 20
                anchors.right: parent.right
                anchors.top: parent.top
                color: "lightblue"
                border.color: "lightgray"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.expanded = !expanded
                }
            }

            Rectangle {
                id: passwordInputBackground
                anchors.fill: passwordInput
                anchors.margins: -5
                color: "white"
                radius: 5
                border.color: "gray"
            }

            TextInput {
                id: passwordInput
                y: 100
                width: 300
                height: 50
                text: ""
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 18
            }

            Rectangle {
                id: connectButton
                anchors.top: passwordInput.bottom
                anchors.margins: 20
                anchors.horizontalCenter: parent.horizontalCenter
                width: passwordInput.width
                height: passwordInputBackground.height
                enabled: wifiManager.networkState != WifiManager.ObtainingIPAddress

                gradient: Gradient {
                    GradientStop { position: 0; color: "white" }
                    GradientStop { position: 1; color: buttonMouse.pressed ? "steelblue" : "lightsteelblue" }
                }

                border.color: "gray"

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 24
                    text: connected ? "Disconnect" : "Connect"
                }
                MouseArea {
                    id: buttonMouse
                    anchors.fill: parent
                    onClicked: {
                        networkView.currentIndex = index
                        if (connected) {
                            wifiManager.disconnect()
                        } else {
                            networkView.activeNetwork = networkView.currentItem
                            wifiManager.connect(network, passwordInput.text);
                        }
                    }
                }
            }

        }
    }

    ListView {
        id: networkView
        anchors.fill: parent
        model: wifiManager.networks
        delegate: listDelegate

        property variant activeNetwork: ""
        property variant networkState: wifiManager.networkState

        onNetworkStateChanged: {
            if (activeNetwork) {
                var ssid = activeNetwork.networkModel.ssid
                var state = ""
                if (networkState == WifiManager.ObtainingIPAddress)
                    state = " (obtaining ip..)"
                else if (networkState == WifiManager.DhcpRequestFailed)
                    state = " (dhcp request failed)"
                else if (networkState == WifiManager.Connected)
                    state = " (connected)"
                activeNetwork.ssidText = ssid + state
            }
        }
    }
}
