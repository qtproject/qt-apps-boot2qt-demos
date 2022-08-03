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
    id: networkSettingsRoot
    anchors.fill: parent

    Component.onCompleted: NetworkSettingsManager.interfacesChanged()

    Connections {
        target: NetworkSettingsManager
        function onInterfacesChanged() {
            if (NetworkSettingsManager.interface(NetworkSettingsType.Wifi, 0) !== null) {
                wifiSwitch.visible = true
                wifiSwitch.checked = Qt.binding(function() { return NetworkSettingsManager.interface(NetworkSettingsType.Wifi, 0).powered })
            } else {
                wifiSwitch.visible = false
            }
        }
    }

    Text {
        id: wlanText
        visible: wifiSwitch.visible
        text: qsTr("WiFi")
        font.pixelSize: networkSettingsRoot.height * viewSettings.subTitleFontSize
        font.family: viewSettings.appFont
        font.styleName: "SemiBold"
        color: "white"
        anchors.top: networkSettingsRoot.top
        anchors.left: networkSettingsRoot.left
    }

    CustomSwitch {
        id: wifiSwitch
        anchors.top: wlanText.bottom
        anchors.left: wlanText.left
        height: networkSettingsRoot.height * viewSettings.buttonHeight
        indicatorWidth: networkSettingsRoot.height * viewSettings.buttonWidth
        indicatorHeight: networkSettingsRoot.height * viewSettings.buttonHeight
        checkable: visible && !wifiSwitchTimer.running

        onCheckedChanged: {
            // Power on/off all WiFi interfaces
            for (var i = 0; NetworkSettingsManager.interface(NetworkSettingsType.Wifi, i) !== null; i++) {

                NetworkSettingsManager.interface(NetworkSettingsType.Wifi, i).powered = checked
                wifiSwitchTimer.start()
            }
        }

        // At least 1s between switching on/off
        Timer {
            id: wifiSwitchTimer
            interval: 1000
            running: false
        }
    }

    Text {
        id: networkListTextItem
        text: qsTr("Available networks:")
        font.pixelSize: networkSettingsRoot.height * viewSettings.subTitleFontSize
        font.family: viewSettings.appFont
        font.styleName: "SemiBold"
        visible: wifiSwitch.checked
        color: "white"
        anchors.top: (wifiSwitch.visible === true) ? wifiSwitch.bottom : networkSettingsRoot.top
        anchors.topMargin: font.pixelSize
    }

    NetworkListView {
        id: networkList
        anchors.top: networkListTextItem.bottom
        anchors.left: networkListTextItem.left
        width: networkSettingsRoot.width
        anchors.bottom: networkSettingsRoot.bottom
    }

    // Popup for entering passphrase
    PassphraseEnter {
        id: passphraseEnter
    }
}

