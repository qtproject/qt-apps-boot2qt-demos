/****************************************************************************
**
** Copyright (C) 2020 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
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
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
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

import QtQuick
import StartupScreen
import QtDeviceUtilities.NetworkSettings

Item {
    id: root
    scale: mouseArea.pressed ? .9 : 1.0
    signal pressed()

    Component.onCompleted: NetworkSettingsManager.services.type = NetworkSettingsType.Wifi;

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.pressed()
    }

    // icons for signal strengths (from 0 to 3)

    property int signalStrength: NetworkSettingsManager.currentWifiConnection ? NetworkSettingsManager.currentWifiConnection.wirelessConfig.signalStrength / 25 : 0

    Image {
        id: icon_signal
        height: parent.height * 0.9
        source: "assets/icon_wifi_" + signalStrength + ".png"
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
    }

    Image {
        id: markerBackground
        height: parent.height * 0.5
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        source: "assets/icon_markerBackground.png"
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        fillMode: Image.PreserveAspectFit

        Image {
            id: icon
            height: parent.height * 0.5
            anchors.centerIn: parent
            source: NetworkSettingsManager.currentWifiConnection ? "assets/icon_ok.png" : "assets/icon_error.png"
            fillMode: Image.PreserveAspectFit
            opacity: 1
        }
    }
}
