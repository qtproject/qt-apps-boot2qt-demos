/****************************************************************************
**
** Copyright (C) 2022 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick
import QtDeviceUtilities.NetworkSettings


Item {
    id: root

    property var connectingService: null
    property bool retryConnectAfterIdle: false

    Connections {
        target: NetworkSettingsManager.userAgent
        function onShowUserCredentialsInput() {
            passphraseEnter.visible = true;
        }
    }

    function connectBySsid() {
        passphraseEnter.showSsid = true
        passphraseEnter.visible = true
    }

    function connectingServiceStateChange() {
        if (connectingService) {
            if (connectingService.state === NetworkSettingsState.Failure) {
                // If authentication failed, request connection again. That will
                // initiate new passphrase request.
                retryConnectAfterIdle = true
            } else if (connectingService.state === NetworkSettingsState.Ready) {
                // If connection succeeded, we no longer have service connecting
                connectingService = null;
                retryConnectAfterIdle = false;
            } else if (connectingService.state === NetworkSettingsState.Idle) {
                if (retryConnectAfterIdle) {
                    passphraseEnter.extraInfo = qsTr("Invalid passphrase");
                    connectingService.connectService();
                }
                retryConnectAfterIdle = false;
            }
        }
    }

    NetworkDelegate {
        id: manualConnectionPane
        anchors.top: parent.top
        anchors.right: parent.right
        visible: wifiSwitch.checked
        nameLabelText: qsTr("Manual connection")
        ipLabelText: qsTr("Add a new connection manually")
        ipText: ""
        isConnected: false
        onClicked: connectBySsid()
    }

    ListView {
        id: list
        clip: true
        focus: true
        boundsBehavior: Flickable.DragOverBounds
        model: NetworkSettingsManager.services

        anchors.top: manualConnectionPane.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: wifiSwitch.checked

        delegate: NetworkDelegate {
            isConnected: connected
            ipText: isConnected ? NetworkSettingsManager.services.itemFromRow(index).ipv4.address
                                : (NetworkSettingsManager.services.itemFromRow(index).state === NetworkSettingsState.Idle) ?
                                      qsTr("Not connected") : qsTr("Connecting")
            onClicked: {
                if (isConnected) {
                    NetworkSettingsManager.services.itemFromRow(index).disconnectService();
                } else {
                    root.connectingService = NetworkSettingsManager.services.itemFromRow(index)
                    if (root.connectingService) {
                        passphraseEnter.extraInfo = "";
                        root.connectingService.connectService();
                        root.connectingService.stateChanged.connect(connectingServiceStateChange);
                    }
                }
            }
        }
    }
}
