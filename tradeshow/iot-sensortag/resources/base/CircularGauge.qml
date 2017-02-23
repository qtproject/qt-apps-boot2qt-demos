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

Item {
    id: gauge

    property real min: 0
    property real max: 360
    property real value: 20
    property real stepCount: 18

    property real increment: (max - min) / stepCount
    property real prevValue: min

    property int currentColorSection
    property var colorSections: ["ObjectTemperature/objTemp_display_obj_blue.png",
                                 "ObjectTemperature/objTemp_display_obj_green.png",
                                 "ObjectTemperature/objTemp_display_obj_orange.png",
                                 "ObjectTemperature/objTemp_display_obj_red.png"]

    onValueChanged: {
        currentColorSection = Math.floor((value - min) / (max - min) * 3);
        if (currentColorSection < 0)
            currentColorSection = 0;

        if (value > prevValue) {
            prevValue = value;
            rotateAnimation.from = 0;
            rotateAnimation.to = 360;
            rotateAnimation.start();
        }
        else {
            prevValue = value;
            rotateAnimation.from = 360;
            rotateAnimation.to = 0;
            rotateAnimation.start();
        }
    }

    width: bg.width
    height: bg.height

    Image {
        id: bg

        source: pathPrefix + "ObjectTemperature/objTemp_outer_inner_ring.png"
    }

    Image {
        id: fg

        anchors.centerIn: bg
        source: pathPrefix + colorSections[currentColorSection]
    }

    RotationAnimator {
        id: rotateAnimation

        target: fg
        duration: 500
    }
}
