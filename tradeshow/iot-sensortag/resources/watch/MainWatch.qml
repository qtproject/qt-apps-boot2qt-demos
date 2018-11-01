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
import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import SensorTag.DataProvider 1.0
import "../base"

Item {
    id: main

    function startRescan(sensor) {
        // ### Only do this magic when a local device is connected
//        if (sensor.state === SensorTagData.NotFound)
//            dataProviderPool.startScanning();
//        else if (sensor.state === SensorTagData.Scanning)
//            dataProviderPool.disconnectProvider(sensor.providerId)
//        else if (sensor.state !== SensorTagData.Connected)
//            sensor.startServiceScan();
    }

    anchors.fill: parent

    Component.onCompleted: {
        localProviderPool.startScanning();
        remoteProviderPool.startScanning();
    }

    property int titleFontSize: 22

    SwipeView {
        id: swipePane
        currentIndex: 5
        anchors.left: main.left
        anchors.leftMargin: 8
        anchors.top: topToolbar.bottom
        anchors.bottom: main.bottom
        width: main.width
        height: main.height

        Item {
            RotationPage {
                scale: 0.35
                width: swipePane.width
                height: swipePane.height
            }
        }

        Item {
            Text {
                text: qsTr("Ambient Temperature")
                anchors.fill: parent
                color: "white"
                font.pixelSize: titleFontSize
            }
            TemperatureChart {
                id: ambientTemp
                width: swipePane.width
                height: swipePane.height
                onClicked: main.startRescan(sensor)
                scale: 0.85
                title: ""
            }
        }

        Item {
            Text {
                text: qsTr("Object Temperature")
                anchors.fill: parent
                color: "white"
                font.pixelSize: titleFontSize
            }
            ObjectTemperatureChart {
                id: objectTemp
                anchors.fill: parent
                anchors.leftMargin: -40
                onClicked: main.startRescan(sensor)
                scale: 0.8
                title: ""
            }
        }

        Item {
            Text {
                text: qsTr("Humidity")
                anchors.fill: parent
                color: "white"
                font.pixelSize: titleFontSize
            }
            HumidityChart {
                id: humidity
                onClicked: main.startRescan(sensor)
                title: ""
                scale: 0.80
                anchors.fill: parent
                anchors.leftMargin: -40
                anchors.topMargin: 17
            }
        }

        Item {
            Text {
                text: qsTr("Altitude")
                anchors.fill: parent
                color: "white"
                font.pixelSize: titleFontSize
            }
            AltitudeChart {
                id: airPressure
                width: swipePane.width
                height: swipePane.height
                onClicked: main.startRescan(sensor)
                title: ""
                scale: 0.80
            }
        }

        Item {
            Text {
                text: qsTr("Light Intensity")
                anchors.fill: parent
                color: "white"
                font.pixelSize: titleFontSize
            }
            LightChart {
                id: light
                height: swipePane.height
                width: swipePane.width*1.1
                scale: 0.70
                onClicked: main.startRescan(sensor)
                title: ""
            }
        }

        Item {
            Text {
                text: qsTr("Magnetometer")
                anchors.fill: parent
                color: "white"
                font.pixelSize: titleFontSize
            }
            MagnetometerChart {
                id: magnetometer
                width: swipePane.width
                height: swipePane.height
                onClicked: main.startRescan(sensor)
                title: ""
            }
        }

        Item {
            Text {
                text: qsTr("Gyroscope")
                anchors.fill: parent
                color: "white"
                font.pixelSize: titleFontSize
            }
            GyroChart {
                id: rotation
                width: swipePane.width
                height: swipePane.height
                onClicked: main.startRescan(sensor)
                title: ""
            }
        }

        Item {
            Text {
                text: qsTr("Accelometer")
                anchors.fill: parent
                color: "white"
                font.pixelSize: titleFontSize
            }
            AccelChart {
                id: accelometer
                width: swipePane.width
                height: swipePane.height
                onClicked: main.startRescan(sensor)
                title: ""
            }
        }

        Item {
            Text {
                text: qsTr("About")
                anchors.fill: parent
                color: "white"
                font.pixelSize: titleFontSize
            }

            Rectangle {
                id: aboutView
                width: swipePane.width
                height: swipePane.height
                color: "transparent"

                ColumnLayout {
                    id: aboutLayout
                    width: parent.width * 0.8
                    height: parent.width * 0.8
                    anchors.centerIn: parent

                    Image {
                        source: "images/BuiltWithQt.png"
                        fillMode: Image.PreserveAspectFit
                        width: parent.width
                        Layout.maximumWidth: parent.width - 20
                        Layout.maximumHeight: 100
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        id: qtLinkLabel
                        color: "white"
                        text: "Visit us at http://qt.io"
                        Layout.alignment: Qt.AlignHCenter
                        font.pixelSize: Style.indicatorTitleSize
                    }

                    Text {
                        color: "white"
                        text: "qt.io/demos/IoTScale"
                        Layout.alignment: Qt.AlignHCenter
                        font.pixelSize: Style.indicatorTitleSize
                    }
                }
            }
        }

    }

    TopToolbar {
        id: topToolbar
        anchors.top: main.top
        anchors.left: main.left
        anchors.right: main.right
        height: 48
        topbar.visible: false
        date.visible: false
        Image {
            id: quit
            source: "images/Toolbar/exit_button.png"
            fillMode: Image.PreserveAspectFit
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 5
            scale: 0.7
            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()
            }
        }
    }
}
