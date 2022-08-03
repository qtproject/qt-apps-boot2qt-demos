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
import QtQuick 2.0
import QtDeviceUtilities.NetworkSettings

Item {
    id: networkDelegate
    width: list.width
    height: networkName.height * 3
    property alias nameLabelText: networkName.text
    property alias ipLabelText: ipAddressLabel.text
    property alias ipText: ipAddress.text
    property bool isConnected: false

    signal clicked()

    Column {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 0.5

        Text {
            id: networkName
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: networkSettingsRoot.height * viewSettings.subTitleFontSize
            font.family: viewSettings.appFont
            color: isConnected ? viewSettings.buttonGreenColor : "white"
            text: (modelData.type === NetworkSettingsType.Wired) ? modelData["name"] + " (" + modelData["id"] + ")" : name
        }

        Row {
            id: ipRow
            height: networkDelegate.height * 0.275 * opacity
            spacing: networkDelegate.width * 0.0075
            Item {
                width: viewSettings.margin(list.width)
                height: 1
            }

            Text {
                id: ipAddressLabel
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("IP Address:")
                color: isConnected ? viewSettings.buttonGreenColor : "white"
                font.pixelSize: networkSettingsRoot.height * viewSettings.valueFontSize
                font.family: viewSettings.appFont
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }

            Text {
                id: ipAddress
                width: root.width * 0.15
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                color: isConnected ? viewSettings.buttonGreenColor : "white"
                text: qsTr("Not connected")
                font.pixelSize: networkSettingsRoot.height * viewSettings.valueFontSize
                font.family: viewSettings.appFont
                font.styleName: isConnected ? "SemiBold" : "Regular"
            }
        }
    }

    QtButton {
        id: connectButton
        fontFamily: viewSettings.appFont
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        fillColor: isConnected ? viewSettings.buttonGrayColor : viewSettings.buttonGreenColor
        borderColor: "transparent"
        text: isConnected ? qsTr("DISCONNECT") : qsTr("CONNECT")
        enabled: true
        onClicked: networkDelegate.clicked()
    }

    Rectangle {
        id: delegateBottom
        width: networkDelegate.width
        color: viewSettings.borderColor
        height: 2
        anchors.bottom: networkDelegate.bottom
        anchors.horizontalCenter: networkDelegate.horizontalCenter
    }

    Behavior on height { NumberAnimation { duration: 200} }
}
