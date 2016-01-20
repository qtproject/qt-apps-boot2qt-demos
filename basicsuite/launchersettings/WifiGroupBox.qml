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
import QtQuick.Layouts 1.0
import B2Qt.Wifi 1.0

ColumnLayout {

    RowLayout {

        Label {
            text: qsTr("Wi-Fi")
            font.pixelSize: engine.titleFontSize() *.8
            Layout.leftMargin: 0
            Layout.preferredWidth: mainLayout.column1Width
        }

        Switch {
            id: wifiOnOffButton
            Layout.bottomMargin: 0

            onCheckedChanged: {
                if (checked && WifiManager.backendState === WifiManager.NotRunning) {
                    WifiManager.start()
                    return
                }

                if (!checked && WifiManager.backendState === WifiManager.Running) {
                    if (networkList.visible)
                        networkList.visible = false
                    WifiManager.stop()
                }
            }

            function updateButtonText(backendState)
            {
                if (backendState === WifiManager.Initializing) {
                    wifiOnOffText.text = qsTr("Initializing...")
                } else if (backendState === WifiManager.Terminating) {
                    wifiOnOffText.text = qsTr("Terminating...")
                } else if (backendState === WifiManager.NotRunning) {
                    wifiOnOffText.text = qsTr("Off")
                    wifiOnOffButton.checked = false
                } else if (backendState === WifiManager.Running) {
                    wifiOnOffText.text = qsTr("On")
                    wifiOnOffButton.checked = true
                }
            }

            Component.onCompleted: updateButtonText(WifiManager.backendState)

            Connections {
                target: WifiManager
                onBackendStateChanged: wifiOnOffButton.updateButtonText(backendState)
            }
        }

        Text {
            id: wifiOnOffText
            font.pixelSize: engine.smallFontSize()
            Layout.leftMargin: mainLayout.width * .05
        }
    }

    Binding {
        target: WifiManager
        property: "scanning"
        value: networkList.visible
    }

    Button {
        id: listNetworksButton
        Layout.leftMargin: mainLayout.column1Width
        Layout.topMargin: engine.mm(6)
        Layout.preferredWidth: mainLayout.width * .4
        visible: WifiManager.backendState === WifiManager.Running
        text: networkList.visible ? qsTr("Hide Wi-Fi networks")
                                  : qsTr("List available Wi-Fi networks")
        onClicked: networkList.visible = !networkList.visible
    }

    WifiNetworkList {
        id: networkList
        implicitHeight: engine.centimeter(7)
        Layout.fillWidth: true
        Layout.leftMargin: mainLayout.column1Width
        visible: false
        clip: true
    }
}
