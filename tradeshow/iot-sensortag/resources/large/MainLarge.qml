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
import QtQuick 2.6
import SensorTag.DataProvider 1.0
import "../base"

Item {
    id: main

    width: 1920
    height: 1080

    Component.onCompleted: {
        dataProviderPool.startScanning()
    }

    Connections {
        target: dataProviderPool
        onScanFinished: {
            ambientTemp.sensor = dataProviderPool.getProvider(SensorTagData.AmbientTemperature);
            objectTemp.sensor = dataProviderPool.getProvider(SensorTagData.ObjectTemperature);
            humidity.sensor = dataProviderPool.getProvider(SensorTagData.Humidity);
            //airPressure.sensor = dataProviderPool.getProvider(SensorTagData.AirPressure);
            light.sensor = dataProviderPool.getProvider(SensorTagData.Light);
            magnetometer.sensor = dataProviderPool.getProvider(SensorTagData.Magnetometer);
            rotation.sensor = dataProviderPool.getProvider(SensorTagData.Rotation);
        }
    }

    Column {
        id: leftPane

        property int indicatorHeight: height / 4 - spacing

        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.top: main.top
        anchors.bottom: main.bottom
        width: 360
        spacing: 16

        TemperatureChart {
            id: ambientTemp

            width: leftPane.width
            height: leftPane.indicatorHeight
        }

        ObjectTemperatureChart {
            id: objectTemp

            width: leftPane.width
            height: leftPane.indicatorHeight
        }

        HumidityChart {
            id: humidity

            width: leftPane.width
            height: leftPane.indicatorHeight
       }

//        AirPressureChart {
//            id: airPressure

//            width: leftPane.width
//            height: leftPane.indicatorHeight
//        }
    }

    Column {
        id: rightPane

        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.top: main.top
        anchors.bottom: main.bottom
        width: 360
        spacing: 16

        LightChart {
            id: light

            width: rightPane.width
            height: leftPane.height / 4
        }

        MagnetometerChart {
            id: magnetometer

            width: rightPane.width
            height: leftPane.height / 4
        }

        GyroPage {
            id: rotation

            width: rightPane.width
            height: leftPane.height / 4
            onClicked: mainContainer.source = "../base/GyroPage.qml"
        }
    }

    Loader {
        id: mainContainer

        anchors.top: topToolbar.bottom
        anchors.left: leftPane.right
        anchors.leftMargin: 32
        anchors.right: rightPane.left
        anchors.rightMargin: 32
        anchors.bottom: bottomToolbar.top
    }

    TopToolbar {
        id: topToolbar

        anchors.left: leftPane.right
        anchors.right: rightPane.left
    }

    BottomToolbar {
        id: bottomToolbar

        anchors.left: leftPane.right
        anchors.right: rightPane.left
        anchors.bottom: main.bottom
        height: 30
    }
}
