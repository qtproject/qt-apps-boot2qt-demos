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
import B2Qt.Wifi 1.0

Item {
    Component {
        id: listDelegate
        Rectangle {
            id: networkBox
            property bool expanded: false
            property bool isCurrentNetwork: WifiManager.currentSSID === ssid
            property bool connected: isCurrentNetwork && WifiManager.networkState === WifiManager.Connected
            property int notExpandedHeight: ssidLabel.height + bssidLabel.height + engine.mm(4)
            property int expandedHeight: notExpandedHeight + passwordInput.height + connectionButton.height + engine.mm(7)
            property int connectedExpandedHeight: notExpandedHeight + connectionButton.height + engine.mm(4)
            height: expanded ? (connected ? connectedExpandedHeight : expandedHeight) : notExpandedHeight
            width: parent.width
            clip: true
            color: "#5C5C5C"
            border.color: "black"
            border.width: 1

            Component.onDestruction: if (expanded) networkView.expandedNetworkBox = null
            onHeightChanged: if (expanded) networkView.positionViewAtIndex(index, ListView.Contain)

            Behavior on height { NumberAnimation { duration: 500; easing.type: Easing.InOutCubic } }

            Text {
                id: ssidLabel
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: engine.mm(1)
                anchors.leftMargin: engine.mm(2)
                font.pixelSize: engine.smallFontSize()
                font.bold: true
                color: "#E6E6E6"
                text: isCurrentNetwork ? ssid + networkView.networkStateText : ssid
                Component.onCompleted: networkView.setNetworkStateText(WifiManager.networkState)
            }

            Text {
                id: bssidLabel
                anchors.top: ssidLabel.bottom
                anchors.left: parent.left
                anchors.margins: engine.mm(1)
                anchors.leftMargin: engine.mm(6)
                text: bssid
                color: "#E6E6E6"
                font.pixelSize: ssidLabel.font.pixelSize * 0.8
            }

            Text {
                id: flagsLabel
                anchors.top: bssidLabel.top
                anchors.left: bssidLabel.right
                anchors.leftMargin: engine.mm(7)
                text: (supportsWPA2 ? "WPA2 " : "")
                     + (supportsWPA ? "WPA " : "")
                     + (supportsWEP ? "WEP " : "")
                     + (supportsWPS ? "WPS " : "");
                color: "#E6E6E6"
                font.pixelSize: ssidLabel.font.pixelSize * 0.8
                font.italic: true
            }

            Rectangle {
                id: signalStrengthBar
                height: engine.mm(3)
                radius: 20
                antialiasing: true
                anchors.margins: engine.mm(2)
                anchors.right: parent.right
                anchors.top: parent.top
                color: "#BF8888"
                border.color: "#212126"
                // ### TODO - Qt Wifi library should provide alternative methods
                // of describing signal strength besides dBm.
                property int strengthBarWidth: Math.max(100 + signalStrength, 0) / 100 * parent.width
                onStrengthBarWidthChanged: {
                    if (strengthBarWidth > parent.width * 0.55)
                        signalStrengthBar.width = parent.width * 0.55
                    else
                        signalStrengthBar.width = strengthBarWidth
                }

            }

            MouseArea {
                anchors.fill: parent
                onClicked: handleNetworkBoxExpanding()
            }

            function handleNetworkBoxExpanding()
            {
                expanded = !expanded
                if (expanded) {
                    if (networkView.hasExpandedNetworkBox)
                        networkView.expandedNetworkBox.expanded = false
                    networkView.expandedNetworkBox = networkBox
                } else {
                    networkView.expandedNetworkBox = null
                }
            }

            TextField {
                id: passwordInput
                anchors.top: flagsLabel.bottom
                anchors.topMargin: engine.mm(3)
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.36
                height: font.pixelSize * 2.4
                placeholderText: "Enter Password"
                visible: !connected
                font.pixelSize: engine.smallFontSize() * 0.8
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhNoPredictiveText
            }

            Button {
                id: connectionButton
                style: SettingsButtonStyle {}
                y: connected ? passwordInput.y
                             : passwordInput.y + passwordInput.height + engine.mm(2)
                width: passwordInput.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: connected ? "Disconnect" : "Connect"
                onClicked: {
                    if (connected) {
                        WifiManager.disconnect()
                    } else {
                        config.ssid = ssid;
                        config.passphrase = passwordInput.text
                        var supportedProtocols;
                        if (supportsWPA) supportedProtocols += "WPA "
                        if (supportsWPA2) supportedProtocols += "WPA2 "
                        if (supportsWEP) supportedProtocols += "WEP "
                        if (supportsWPS) supportedProtocols += "WPS "
                        config.protocol = supportedProtocols
                        if (!WifiManager.connect(config))
                            print("failed to connect: " + WifiManager.lastError)
                    }
                }
            }
        }
    }

    WifiConfiguration {
        id: config
    }

    ListView {
        id: networkView
        anchors.fill: parent
        model: WifiManager.networks
        delegate: listDelegate

        property string networkStateText: ""
        property QtObject expandedNetworkBox: null
        property bool hasExpandedNetworkBox: expandedNetworkBox !== null

        function setNetworkStateText(networkState) {
            if (networkState === WifiManager.ObtainingIPAddress)
                networkView.networkStateText = " (obtaining ip..)"
            else if (networkState === WifiManager.DhcpRequestFailed)
                networkView.networkStateText = " (dhcp request failed)"
            else if (networkState === WifiManager.Connected)
                networkView.networkStateText = " (connected)"
            else if (networkState === WifiManager.Authenticating)
                networkView.networkStateText = " (authenticating..)"
            else if (networkState === WifiManager.HandshakeFailed)
                networkView.networkStateText = " (wrong password)"
            else if (networkState === WifiManager.Disconnected)
                networkView.networkStateText = ""
        }

        Connections {
            target: WifiManager
            onNetworkStateChanged: networkView.setNetworkStateText(networkState)
        }
    }
}
