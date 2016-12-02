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
import QtGraphicalEffects 1.0

Item {
    id: gauge

    property real min: 0
    property real max: 360
    property real value: 20
    property real stepCount: 18
    property bool discreteSteps: true

    property alias background: bgLoader.sourceComponent
    property alias foreground: fgLoader.sourceComponent

    property real increment: 360 / stepCount

    function incrementStep() {
        if (value < max - increment)
            value += increment
    }

    function decrementStep() {
        if (value > min + increment)
            value -= increment;
    }

    width: bgLoader.item.width
    height: bgLoader.item.height
    onValueChanged: maskCanvas.requestPaint()

    Loader {
        id: bgLoader
    }

    Loader {
        id: fgLoader

        visible: false
    }

    Item {
        id: mask

        property real range: max - min
        property real offsetAngle: -77
        property real startAngle: mask.offsetAngle / 360 * Math.PI * 2
        property real angleStep: Math.PI * 2 / stepCount

        width: fgLoader.item.width
        height: fgLoader.item.height
        visible: false

        Canvas {
            id: maskCanvas

            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");

                // could optimize this by clearing only when decrementing value
                ctx.clearRect(0, 0, width, height);

                var endAngle = mask.startAngle + (value - min) / mask.range * Math.PI * 2;
                if (discreteSteps)
                    endAngle = Math.floor(endAngle / mask.angleStep) * mask.angleStep;
                ctx.beginPath();
                ctx.arc(Math.floor(width / 2), Math.floor(height / 2), mask.width / 2, mask.startAngle, endAngle);
                ctx.lineTo(mask.width / 2, mask.height / 2)
                ctx.closePath();
                ctx.fill();
            }
        }
    }

    OpacityMask {
        width: mask.width
        height: mask.height
        source: fgLoader.item
        maskSource: mask
        anchors.centerIn: gauge
    }
}
