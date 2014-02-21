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
import Qt.labs.wifi 0.1

// ### TODO
// - only 1 delagate open at the time

Item {
    Component {
        id: listDelegate
        Rectangle {
            id: delegateBackground
            property bool expanded: false
            property bool connected: wifiManager.connectedSSID == network.ssid
            property variant networkModel: model
            property alias ssidText: ssidLabel.text
            height: (expanded ? (connected ? 180: 260) : 70)
            clip: true // ### fixme
            color: "#5C5C5C"
            border.color: "black"
            border.width: 1

            Behavior on height { NumberAnimation { duration: 500; easing.type: Easing.InOutCubic } }

            width: parent.width

            Text {
                id: ssidLabel
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                font.pixelSize: 20
                font.bold: true
                color: "#E6E6E6"
                text: network.ssid + (connected ? " (connected)" : "");
            }

            Text {
                id: bssidLabel
                anchors.top: ssidLabel.bottom
                anchors.left: parent.left
                anchors.margins: 5
                anchors.leftMargin: 40
                text: network.bssid
                color: "#E6E6E6"
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
                color: "#E6E6E6"
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
                color: "#BF8888"
                border.color: "#212126"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.expanded = !expanded
                }
            }

            TextField {
                id: passwordInput
                y: 100
                height: 50
                width: 300
                placeholderText: "Enter Password"
                visible: !connected
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 18
            }

            Button {
                style: root.buttonStyle
                y: passwordInput.visible ? passwordInput.y + passwordInput.height + 20 : passwordInput.y
                anchors.horizontalCenter: parent.horizontalCenter
                text: connected ? "Disconnect" : "Connect"
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
