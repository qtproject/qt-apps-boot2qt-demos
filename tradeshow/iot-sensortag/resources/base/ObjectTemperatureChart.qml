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
import QtQuick 2.5
import SensorTag.DataProvider 1.0

BaseChart {
    id: objTempHolderRect

    property real minValue: Number.MAX_VALUE
    property real maxValue: Number.MIN_VALUE
    property real value

    function updateTemps(){
        value = sensor.infraredObjectTemperature.toFixed(1);
        if (minValue > value)
            minValue = value;
        if (maxValue < value)
            maxValue = value;
    }

    title: qsTr("Object Temperature")

    onSensorChanged: if (sensor) {
        sensor.infraredObjectTemperatureChanged.connect(updateTemps)
    }

    content: Item {
        id: container

        anchors.fill: parent

        CircularGauge {
            id: gauge

            min: 10
            max: 40
            value: objTempHolderRect.value
            anchors.centerIn: parent
            background: Image {
                    source: pathPrefix + "ObjectTemperature/objTemp_base_circle.png"
                }
            foreground: Image {
                    source: pathPrefix + "ObjectTemperature/objTemp_display_obj.png"
                }
        }

        Text {
            text: (minValue !== Number.MAX_VALUE ? minValue : "--") + "\nLowest"
            lineHeight: 0.7
            width: 60
            horizontalAlignment: Text.Center
            color: "white"
            anchors.bottom: gauge.bottom
            anchors.bottomMargin: 24
            anchors.right: gauge.left
            anchors.rightMargin: 12
        }

        Text {
            text: value
            color: "white"
            anchors.centerIn: gauge
        }

        Text {
            text: "Highest\n" + (maxValue !== Number.MIN_VALUE ? maxValue : "--")
            lineHeight: 0.8
            width: 60
            horizontalAlignment: Text.Center
            color: "white"
            anchors.top: gauge.top
            anchors.topMargin: 24
            anchors.left: gauge.right
            anchors.leftMargin: 12
        }

    }
}
