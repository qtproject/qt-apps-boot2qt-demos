/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt 3D Studio Demos.
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

import QtQuick 2.8

SliderControl {
    id: tempSlider
    property real redColor
    property real blueColor
    property real greenColor
    property bool economy: currentValue < 22 ? true : false

    currentValue: 15
    sliderColor: "#0000ff"

    text: currentValue + "°"
    iconSource: "qml/images/icon_temp.png"

    onPositionChanged: {
        updateCurrentTemp()
        setNewTempColor()
    }

    onMoved: {
        var position = 0.6;
        if (currentValue > 17 && currentValue < 26)
            position = 0.45;
        else if (currentValue >= 26)
            position = 0.30;
        knxBackend.colorSwitch(position)
        console.log('moved color slider!'+ position)
    }

    function setPositionByColor(color)
    {
        if (Qt.colorEqual(color, "magenta")) {
            value = 0.5
        }
        else if (Qt.colorEqual(color, "red")) {
            value = 1
        }
        else if (Qt.colorEqual(color, "blue")) {
            value = 0
        }
    }

    function updateCurrentTemp() {
        // Temperature range from 15 to 30
        // Slider range form 0 to 1
        var newTempValue = 15 + 15 * tempSlider.position
        tempSlider.currentValue = newTempValue.toFixed(0)
    }

    function setNewTempColor() {
        var position = tempSlider.position * 100
        // From blue to red
        var r = Math.floor((255 * Math.sqrt(Math.sin(position * Math.PI / 200))))
        var b = Math.floor((255 * Math.sqrt(Math.cos(position * Math.PI / 200))))
        var g = 0
        redColor = r / 255
        blueColor = b / 255
        greenColor = 0
        sliderColor = rgbToHex(r, g, b)

    }
}
