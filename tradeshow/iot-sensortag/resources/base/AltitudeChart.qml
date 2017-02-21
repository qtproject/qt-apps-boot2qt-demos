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
import QtGraphicalEffects 1.0

BaseChart {
    property real altitude: sensor ? sensor.altitude : 0
    property real altitudeRounded
    property real maxAltitude

    readonly property real maxValueOnBar: 3

    antialiasing: true
    title: qsTr("Altitude")

    onClicked: {
        if (sensor) {
            maxAltitude = 0;
            sensor.recalibrate();
        }
    }

    onAltitudeChanged: {
        altitudeRounded = Math.floor(altitude + 0.5).toFixed(0)
        if (altitudeRounded > maxAltitude)
            maxAltitude = altitudeRounded
    }

    content: Item {
        id: container

        anchors.fill: parent

        Image {
            id: maxAltBar

            source: pathPrefix + "Altitude/Height_bar.png"
            anchors.verticalCenter: gauge.verticalCenter
            anchors.right: gauge.left
            width: 10
            height: 100
            visible: false
        }

        Item {
            id: mask

            anchors.fill: maxAltBar
            visible: false

            Rectangle {
                width: parent.width
                anchors.bottom: parent.bottom
                height: maxAltitude ? (altitude / maxAltitude) * parent.height : 0
            }
        }

        OpacityMask {
            anchors.fill: maxAltBar
            source: maxAltBar
            maskSource: mask
        }

        Image {
            id: gauge

            source: pathPrefix + "Altitude/Altitude_base_gauge_outer.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right

            Image {
                source: pathPrefix + "Altitude/Altitude_base_gauge.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 30

                Column {
                    anchors.centerIn: parent
                    spacing: -10

                    Text {
                        id: pressureText

                        text: altitudeRounded
                        horizontalAlignment: Text.AlignHCenter
                        color: "white"
                        font.pixelSize: 26
                    }

                    Text {
                        text: "m"
                        color: "white"
                        font.pixelSize: 16
                        anchors.horizontalCenter: pressureText.horizontalCenter
                    }
                }
            }

            Text {
                id: maxPressureText

                text: "Max\n" + maxAltitude
                horizontalAlignment: Text.AlignHCenter
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 74
                color: "white"
            }
        }
    }
}
