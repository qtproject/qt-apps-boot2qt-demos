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
import QtQuick.Particles 2.0

Item {
    id: dialerRoot
    property var sensor: null
    anchors.fill: parent
    focus: true

    Image {
        id: outerRing
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: pathPrefix + "Gyro/ring_outer.png"
        z: parent.z + 1
    }
    Image {
        id: largeRing
        anchors.centerIn: parent
        width: outerRing.width * 0.8
        fillMode: Image.PreserveAspectFit
        source: pathPrefix + "Gyro/ring_large.png"
        rotation: sensor.rotationX
        z: parent.z + 2
        Behavior on rotation {
            RotationAnimation {
                easing.type: Easing.Linear
                duration: sensor.rotationUpdateInterval
                direction: RotationAnimation.Shortest
            }
        }
    }
    Image {
        id: mediumRing
        anchors.centerIn: parent
        width: outerRing.width * 0.6
        fillMode: Image.PreserveAspectFit
        source: pathPrefix + "Gyro/ring_medium.png"
        rotation: sensor.rotationY
        z: parent.z + 3
        Behavior on rotation {
            RotationAnimation {
                easing.type: Easing.Linear
                duration: sensor.rotationUpdateInterval
                direction: RotationAnimation.Shortest
            }
        }
    }
    Image {
        id: centerRing
        anchors.centerIn: parent
        width: outerRing.width * 0.4
        fillMode: Image.PreserveAspectFit
        source: pathPrefix + "Gyro/ring_small.png"
        rotation: sensor.rotationZ
        z: parent.z + 4
        Behavior on rotation {
            RotationAnimation {
                easing.type: Easing.Linear
                duration: sensor.rotationUpdateInterval
                direction: RotationAnimation.Shortest
            }
        }
    }
    ParticleSystem {
        id: particles
        anchors.fill: parent
        z: parent.z + 5
        ImageParticle {
            source: pathPrefix + "Gyro/particle.png"
            alpha: 0
            colorVariation: 0.2
        }
        Emitter {
            property int rateToEmit: Math.abs(sensor.gyroscopeZ_degPerSec) * 4
            id: centerEmitter
            x: centerRing.x
            y: centerRing.y
            width: centerRing.width
            height: centerRing.height
            emitRate: rateToEmit > 400 ? rateToEmit : 0
            lifeSpan: 1000
            enabled: true
            shape: EllipseShape {
                fill: false
            }
            velocity: AngleDirection{
                magnitude: 100
                angleVariation: 0
                angle: 90
            }
            size: particles.width / 200
            sizeVariation: 3
        }
        Emitter {
            property int rateToEmit: Math.abs(sensor.gyroscopeY_degPerSec) * 4
            id: midEmitter
            x: mediumRing.x
            y: mediumRing.y
            width: mediumRing.width
            height: mediumRing.height
            emitRate: rateToEmit > 400 ? rateToEmit : 0
            lifeSpan: 1000
            enabled: true
            shape: EllipseShape {
                fill: false
            }
            velocity: AngleDirection{
                magnitude: 100
                angleVariation: 0
                angle: 90
            }
            size: particles.width / 200
            sizeVariation: 3
        }
        Emitter {
            property int rateToEmit: Math.abs(sensor.gyroscopeX_degPerSec) * 4
            id: largeEmitter
            x: largeRing.x
            y: largeRing.y
            width: largeRing.width
            height: largeRing.height
            emitRate: rateToEmit > 400 ? rateToEmit : 0
            lifeSpan: 1000
            enabled: true
            shape: EllipseShape {
                fill: false
            }
            velocity: AngleDirection{
                magnitude: 100
                angleVariation: 0
                angle: 90
            }
            size: particles.width / 200
            sizeVariation: 3
        }
    }
}
