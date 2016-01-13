/******************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Enterprise Embedded.
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
import QtQuick.Controls 1.4
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
            property int expandedHeight: notExpandedHeight + connectionButton.height + engine.mm(8)
            height: expanded ? expandedHeight : notExpandedHeight
            width: parent.width
            clip: true

            Component.onDestruction: if (expanded) networkView.expandedNetworkBox = null
            onHeightChanged: if (expanded) networkView.positionViewAtIndex(index, ListView.Contain)

            Behavior on height { NumberAnimation { duration: 500; easing.type: Easing.InOutCubic } }

            CheckBox {
                id: connectedCheckBox
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: engine.mm(1)
                anchors.leftMargin: engine.mm(2)
                checked: connected
            }

            Label {
                id: ssidLabel
                anchors.top: parent.top
                anchors.left: connectedCheckBox.right
                anchors.margins: engine.mm(1)
                anchors.leftMargin: engine.mm(2)
                font.pixelSize: engine.smallFontSize()
                font.bold: true
                color: "black"
                text: isCurrentNetwork ? ssid + networkView.networkStateText : ssid
                Component.onCompleted: networkView.setNetworkStateText(WifiManager.networkState)
            }

            Label {
                id: bssidLabel
                anchors.top: ssidLabel.bottom
                anchors.left: connectedCheckBox.right
                anchors.margins: engine.mm(1)
                anchors.leftMargin: engine.mm(2)
                text: bssid
                color: "black"
                font.pixelSize: ssidLabel.font.pixelSize
            }

            Label {
                id: flagsLabel
                anchors.top: bssidLabel.top
                anchors.right: parent.right
                text: (supportsWPA2 ? qsTr("WPA2 ") : "")
                      + (supportsWPA ? qsTr("WPA ") : "")
                      + (supportsWEP ? qsTr("WEP ") : "")
                      + (supportsWPS ? qsTr("WPS ") : "");
                color: "black"
                font.pixelSize: ssidLabel.font.pixelSize
                font.bold: true
            }

            ProgressBar {
                id: signalStrengthBar
                height: engine.mm(3)
                width: networkBox.width * 0.25
                anchors.margins: engine.mm(2)
                anchors.right: parent.right
                anchors.top: parent.top
                minimumValue: 0
                maximumValue: 100
                property int level: signalStrength
                onLevelChanged: signalStrengthBar.value = level
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
                anchors.topMargin: engine.mm(6)
                anchors.right: connectionButton.left
                anchors.rightMargin: mainLayout.defaultMargin * .25
                anchors.left: ssidLabel.left
                placeholderText: qsTr("Enter Password")
                visible: !connected
                font.pixelSize: engine.smallFontSize()
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhNoPredictiveText
            }

            Button {
                id: connectionButton
                width: parent.width * .4
                anchors.right: parent.right
                anchors.top: flagsLabel.bottom
                anchors.topMargin: engine.mm(6)
                text: connected ? qsTr("Disconnect") : qsTr("Connect")
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

    GroupBox {
        anchors.fill: parent

        Item {
            anchors.fill: parent
            clip: true

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
                        networkView.networkStateText = qsTr(" (obtaining ip..)")
                    else if (networkState === WifiManager.DhcpRequestFailed)
                        networkView.networkStateText = qsTr(" (dhcp request failed)")
                    else if (networkState === WifiManager.Connected)
                        networkView.networkStateText = qsTr(" (connected)")
                    else if (networkState === WifiManager.Authenticating)
                        networkView.networkStateText = qsTr(" (authenticating..)")
                    else if (networkState === WifiManager.HandshakeFailed)
                        networkView.networkStateText = qsTr(" (wrong password)")
                    else if (networkState === WifiManager.Disconnected)
                        networkView.networkStateText = ""
                }

                Connections {
                    target: WifiManager
                    onNetworkStateChanged: networkView.setNetworkStateText(networkState)
                }
            }
        }
    }
}
