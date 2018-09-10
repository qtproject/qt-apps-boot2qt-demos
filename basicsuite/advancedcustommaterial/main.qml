/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt3D module of the Qt Toolkit.
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
import QtQuick.Scene3D 2.0
import Qt3D.Render 2.0
import QtQuick.Controls 1.4

Rectangle {
    id: scene
    visible: true
    property bool colorChange: true
    anchors.fill: parent
    color: "#2d2d2d"

    transform: Rotation {
        id: sceneRotation
        axis.x: 1
        axis.y: 0
        axis.z: 0
        origin.x: scene.width / 2
        origin.y: scene.height / 2
    }
    Rectangle {
        id: controlsbg
        anchors { left: parent.left; top: parent.top; bottom:parent.bottom }
        width: parent.width * .3
        color: _backgroundColor

        Column {
            anchors.fill: parent

            ControlSlider {
                id: slidertexscale
                text: "TEXTURE SCALE"
                value: 1.0
                minimumValue: 0.3
            }
            ControlSlider {
                id: slidertexturespeed
                text: "TEXTURE SPEED"
                value: 1.1
                maximumValue: 4.0
                minimumValue: 0.0
            }
            ControlSlider {
                id: sliderspecularity
                text: "SPECULARITY"
                value: 1.0
                maximumValue: 3.0
                minimumValue: 0.0
            }
            ControlSlider {
                id: sliderdistortion
                text: "DISTORTION"
                value: 0.015
                maximumValue: 0.1
                minimumValue: 0.0
            }
            ControlSlider {
                id: slidernormal
                text: "NORMAL AMOUNT"
                value: 2.2
                maximumValue: 4.0
                minimumValue: 0.0
            }
            ControlSlider {
                id: sliderwavespeed
                text: "WAVE SPEED"
                value: 0.75
                maximumValue: 4.0
                minimumValue: 0.1
            }
            ControlSlider {
                id: sliderwaveheight
                text: "WAVE HEIGHT"
                value: 0.2
                maximumValue: 0.5
                minimumValue: 0.02
            }
            ControlSlider {
                id: slidermeshrotation
                text: "MESH ROTATION"
                value: 35.0
                maximumValue: 360.0
                minimumValue: 0.0
            }
        }
    }

    Scene3D {
        id: scene3d
        anchors { left: controlsbg.right; top:parent.top; right: parent.right; bottom: parent.bottom }
        focus: true
        aspects: ["input", "logic"]
        cameraAspectRatioMode: Scene3D.AutomaticAspectRatio

        SceneRoot {
            id: root
        }
    }
}

