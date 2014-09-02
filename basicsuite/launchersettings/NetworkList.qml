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

Item {
    Component {
        id: listDelegate
        Rectangle {
            id: delegateBackground
            property bool expanded: false
            property bool connected: wifiManager.connectedSSID == network.ssid
            property bool actingNetwork: networkView.currentNetworkSsid == network.ssid
            height: (expanded ? (connected ? 180: 260) : 70)
            width: parent.width
            clip: true // ### fixme
            color: "#5C5C5C"
            border.color: "black"
            border.width: 1

            onExpandedChanged: {
                if (expanded) {
                    if (networkView.hasExpandedDelegate)
                        networkView.expandedDelegate.expanded = false
                    networkView.expandedDelegate = this
                } else {
                    networkView.expandedDelegate = 0
                }
            }

            Component.onDestruction: if (expanded) networkView.expandedDelegate = 0
            onHeightChanged: if (expanded) networkView.positionViewAtIndex(index, ListView.Contain)

            Behavior on height { NumberAnimation { duration: 500; easing.type: Easing.InOutCubic } }

            Text {
                id: ssidLabel
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                font.pixelSize: 20
                font.bold: true
                color: "#E6E6E6"
                text: network.ssid + (actingNetwork ? networkView.networkStateText : "");
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
                id: signalStrengthBar
                height: 20
                radius: 10
                antialiasing: true
                anchors.margins: 20
                anchors.right: parent.right
                anchors.top: parent.top
                color: "#BF8888"
                border.color: "#212126"

                property int strengthBarWidth: Math.max(100 + network.signalStrength, 0) / 100 * parent.width
                onStrengthBarWidthChanged: {
                    if (strengthBarWidth > parent.width * 0.7)
                        signalStrengthBar.width = parent.width * 0.7
                    else
                        signalStrengthBar.width = strengthBarWidth
                }

            }

            MouseArea {
                anchors.fill: parent
                onClicked: parent.expanded = !expanded
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
                inputMethodHints: Qt.ImhNoPredictiveText
            }

            Button {
                style: root.buttonStyle
                y: passwordInput.visible ? passwordInput.y + passwordInput.height + 20 : passwordInput.y
                anchors.horizontalCenter: parent.horizontalCenter
                text: connected ? "Disconnect" : "Connect"
                onClicked: connected ? wifiManager.disconnect()
                                     : wifiManager.connect(network, passwordInput.text);
            }
        }
    }

    ListView {
        id: networkView
        anchors.fill: parent
        model: wifiManager.networks
        delegate: listDelegate

        property string networkStateText: ""
        property string currentNetworkSsid: ""
        property variant expandedDelegate: 0
        property bool hasExpandedDelegate: expandedDelegate != 0

        Connections {
            target: wifiManager
            onNetworkStateChanged: {
                networkView.currentNetworkSsid = network.ssid
                var networkStateText = ""
                var state = wifiManager.networkState
                if (state == WifiManager.ObtainingIPAddress)
                    networkStateText = " (obtaining ip..)"
                else if (state == WifiManager.DhcpRequestFailed)
                    networkStateText = " (dhcp request failed)"
                else if (state == WifiManager.Connected)
                    networkStateText = " (connected)"
                else if (state == WifiManager.Authenticating)
                    networkStateText = " (authenticating..)"
                else if (state == WifiManager.HandshakeFailed)
                    networkStateText = " (wrong password)"
                networkView.networkStateText = networkStateText
            }
        }
    }
}
