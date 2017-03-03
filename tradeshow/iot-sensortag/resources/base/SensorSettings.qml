/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
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
import QtQuick 2.0
import QtQuick.Layouts 1.1
import Style 1.0
import SensorTag.DataProvider 1.0

Rectangle {
    id: mainRect

    property alias listModelCount: list.count

    width: 620
    height: 480
    color: "black"

    Text {
        id: titleText
        color: "white"
        text: "SENSOR SETTINGS"
        font.pixelSize: Style.indicatorTitleFontSize
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 8
    }

    Image {
        id: icon

        anchors.top: titleText.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 8
        source: pathPrefix + "Toolbar/icon_topbar_sensor.png"
    }

    ListView {
        id: list
        anchors.top: icon.bottom
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 30
        orientation: ListView.Horizontal
        model: dataProviderPool.dataProviders
        height: parent.height
        clip: true
        snapMode: ListView.SnapToItem
        boundsBehavior: Flickable.StopAtBounds

        function getTagTypeStr(tagType) {
            var tagStr = "";
            if (tagType & SensorTagData.AmbientTemperature)
                tagStr += "Ambient Temperature\n";
            if (tagType & SensorTagData.ObjectTemperature)
                tagStr += "Object Temperature\n";
            if (tagType & SensorTagData.Humidity)
                tagStr += "Humidity\n";
            if (tagType & SensorTagData.Altitude)
                tagStr += "Altitude\n";
            if (tagType & SensorTagData.Light)
                tagStr += "Light\n";
            if (tagType & SensorTagData.Rotation)
                tagStr += "Gyroscope\n";
            if (tagType & SensorTagData.Magnetometer)
                tagStr += "Magnetometer\n";
            if (tagType & SensorTagData.Accelometer)
                tagStr += "Accelometer\n";

            return tagStr;
        }

        delegate: Item {
            id: listItem
            width: mainRect.width / 3
            height: childrenRect.height

            ColumnLayout {
                spacing: 8

                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    horizontalAlignment: Text.AlignHCenter
                    text: providerId
                    color: "white"
                    font.pixelSize: 16
                    elide: Text.ElideMiddle
                }

                BlinkingIcon {
                    id: sensorIcon

                    property bool canBlink: modelData.state === SensorTagData.Scanning

                    onCanBlinkChanged: {
                            if (canBlink)
                                sensorIcon.startBlinking();
                             else
                                sensorIcon.stopBlinking();
                    }

                    source: pathPrefix + "Toolbar/icon_topbar_sensor.png"
                    anchors.horizontalCenter: parent.horizontalCenter

                    Component.onDestruction: {
                        sensorIcon.stopBlinking()
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (modelData.state === SensorTagData.Connected)
                                dataProviderPool.disconnectProvider(modelData.providerId);
                            else if (modelData.state === SensorTagData.NotFound)
                                dataProviderPool.startScanning();
                            else if (modelData.state === SensorTagData.Scanning)
                                dataProviderPool.disconnectProvider(modelData.providerId)
                            else
                                modelData.startServiceScan();
                        }
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: modelData.state === SensorTagData.NotFound ? "\nNOT FOUND"
                          : (modelData.state === SensorTagData.Disconnected) ? "\nDISCONNECTED"
                          : (modelData.state === SensorTagData.Scanning) ? "\nCONNECTING"
                          : (modelData.state === SensorTagData.Connected) ? "\nCONNECTED"
                          : "Error"
                    color: "white"
                    font.pixelSize: 14
                }

                Item {
                    height: 30
                    width: 10
                }

                Text {
                    color: "white"
                    text: "Provides data for:"
                    font.pixelSize: 14
                }

                Text {
                    color: "white"
                    lineHeight: 0.7
                    text: list.getTagTypeStr(modelData.tagType())
                    font.pixelSize: 14
                }
            }
        }
    }
}
