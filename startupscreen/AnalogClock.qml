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

Item {
    id: clock

    property int hours
    property int minutes
    property int seconds

    // for clock scaling
    property int clockRadius
    property int wideDial: 3
    property int narrowDial: 1

    function timeChanged() {
        var date = new Date;
        hours = date.getHours()
        minutes = date.getMinutes()
        seconds = date.getUTCSeconds();
    }

    clockRadius: width/2

    Timer {
        interval: 100
        running: true
        repeat: true;
        onTriggered: clock.timeChanged()
    }

    Item {
        id: analogClock

        width: clock.width
        height: clock.height
        anchors.centerIn: parent

        Image {
            id: background
            source: "assets/clockFace.png"
            width: clock.width
            height: clock.height
            anchors.centerIn: parent
        }

        Rectangle {
            id: hourDial
            x: clockRadius - (wideDial/2)
            y: clockRadius/2
            width: wideDial
            height: clockRadius/2
            color: "#53586b"
            radius: width/2

            transform: Rotation {
                id: hourRotation
                origin.x: wideDial / 2
                origin.y: clockRadius/2
                angle: (clock.hours * 30) + (clock.minutes * 0.5)
                Behavior on angle {
                    SpringAnimation {
                        spring: 2
                        damping: 0.2
                        modulus: 360
                    }
                }
            }
        }
        Rectangle {
            id: minuteDial
            x: clockRadius - (wideDial/2)
            y: clockRadius * 0.3
            width: wideDial
            height: clockRadius * 0.7
            color: "#53586b"
            radius: width/2

            transform: Rotation {
                id: minuteRotation
                origin.x: wideDial / 2
                origin.y: clockRadius * 0.7
                angle: clock.minutes * 6
                Behavior on angle {
                    SpringAnimation {
                        spring: 2
                        damping: 0.2
                        modulus: 360
                    }
                }
            }
        }

        Rectangle  {
            id: secondHand
            x: clockRadius - (narrowDial/2)
            y: clockRadius * 0.1
            width: narrowDial
            height: clockRadius * 0.9
            color: "red"
            radius: width/2

            transform: Rotation {
                id: secondRotation
                origin.x: narrowDial / 2
                origin.y: clockRadius * 0.9
                angle: clock.seconds * 6
                Behavior on angle {
                    SpringAnimation {
                        spring: 2
                        damping: 0.2
                        modulus: 360
                    }
                }
            }
        }

        Rectangle {
            id: center
            width: narrowDial + wideDial
            height: width
            color: "black"
            radius: width / 2
            anchors.centerIn: parent
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:100;width:100}
}
##^##*/
