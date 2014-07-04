/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://qt.digia.com/
**
** This file is part of the examples of the Qt Enterprise Embedded.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
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
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
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
import QtSensors 5.0

Rectangle {
    id: bg
    Image {
        id: avatar
        width: parent.width * 0.9
        height: parent.height * 0.9
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
    }
    Text {
        id: illuminanceLevel
        font.pointSize: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
    }

    AmbientLightSensor {
        active: true
        onReadingChanged: {
            if (reading.lightLevel === AmbientLightReading.Dark) {
                avatar.source = "3.png"
                bg.color = "#1947A3"
            } else if (reading.lightLevel === AmbientLightReading.Twilight
                       || reading.lightLevel === AmbientLightReading.Light) {
                avatar.source = "2.png"
                bg.color = "steelblue"
            } else if (reading.lightLevel === AmbientLightReading.Bright
                       || reading.lightLevel === AmbientLightReading.Sunny) {
                avatar.source = "1.png"
                bg.color = "#FFFF75"
            } else {
                avatar.text = "Unknown light level"
            }
        }
    }

    LightSensor {
        active: true
        onReadingChanged: {
            illuminanceLevel.text = "Illuminance: " + reading.illuminance.toFixed(2);
        }
    }
}
