/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
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
import QtCharts 2.0

Item {
    anchors.fill: parent
    //![1]
    BaseChart {
        id: chart
        title: "Production costs"
        legend.visible: false
        anchors.fill: parent
        PieSeries {
            id: pieOuter
            size: 0.96
            holeSize: 0.7

            PieSlice { id: slice; label: "Alpha"; value: 19511; color: defaultGreen; borderColor: "#163430" }
            PieSlice { label: "Epsilon"; value: 11105; color: defaultGrey; borderColor: "#3B391C" }
            PieSlice { label: "Psi"; value: 9352; color: darkGrey2; borderColor: "#13060C" }
        }

        PieSeries {
            size: 0.7
            id: pieInner
            holeSize: 0.25
            PieSlice { label: "Materials"; value: 10334; color: mediumGreen; borderColor: "#163430" }
            PieSlice { label: "Employee"; value: 3066; color: darkGreen; borderColor: "#163430" }
            PieSlice { label: "Logistics"; value: 6111; color: mediumGreen; borderColor: "#163430" }

            PieSlice { label: "Materials"; value: 7371; color: mediumGrey2; borderColor: "#3B391C" }
            PieSlice { label: "Employee"; value: 2443; color: mediumGrey; borderColor: "#3B391C" }
            PieSlice { label: "Logistics"; value: 1291; color: mediumGrey2; borderColor: "#3B391C" }

            PieSlice { label: "Materials"; value: 4022; color: secondaryGrey; borderColor: "#13060C" }
            PieSlice { label: "Employee"; value: 3998; color: darkGrey; borderColor: "#13060C" }
            PieSlice { label: "Logistics"; value: 1332; color: secondaryGrey; borderColor: "#13060C" }
        }
    }

    Component.onCompleted: {
        // Set the common slice properties dynamically for convenience
        for (var i = 0; i < pieOuter.count; i++) {
            pieOuter.at(i).labelPosition = PieSlice.LabelOutside;
            pieOuter.at(i).labelVisible = true;
            pieOuter.at(i).borderWidth = 3;
            pieOuter.at(i).labelColor = "white";
            pieOuter.at(i).labelFont = appFont;
        }
        for (var i = 0; i < pieInner.count; i++) {
            pieInner.at(i).labelPosition = PieSlice.LabelInsideNormal;
            pieInner.at(i).labelVisible = true;
            pieInner.at(i).borderWidth = 2;
            pieInner.at(i).labelColor = "white";
            pieInner.at(i).labelFont = appFont;
        }
    }
    //![1]
}
