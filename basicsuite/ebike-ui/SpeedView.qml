/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the E-Bike demo project.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.9
import DataStore 1.0
import "./BikeStyle"

Rectangle {
    id: speedViewItem
    width: root.width * 0.35
    height: width
    color: "transparent"
    radius: width
    z: 1
    anchors{
        verticalCenter: parent.verticalCenter
        horizontalCenter: parent.horizontalCenter
    }
    property int dotcount: UILayout.speedViewDots
    property int curvewidth: Math.min(width, height) * 0.0425
    property int speedTextSize: height * 0.4
    property int speedBaselineOffset: height * 0.45
    property int innerRadius: width * 0.45
    property int speedUnitsSize: height * 0.05
    property int speedUnitBaselineOffset: height * 0.075
    property int speedIconsOffset: width * 0.25
    property int speedInfoTextsOffset: 0
    property int speedInfoTextsSize: speedTextSize * 0.45
    property int speedInfoUnitsOffset: height * 0.075
    property int assistPowerIconOffset: height * 0.175
    property bool enlarged: false
    property alias cornerRectangle: cornerRectangle
    property bool showZero: false

    signal showMain()

    // Speed info
    Text {
        id: speedText
        anchors {
            horizontalCenter: speedView.horizontalCenter
            baseline: speedView.bottom
            baselineOffset: -speedBaselineOffset
        }

        color: Colors.speedText
        font {
            family: "Teko, Light"
            weight: Font.Light
            pixelSize: speedTextSize
        }
        text: showZero ? "0" : datastore.speed.toFixed(0)
    }

    Text {
        id: speedUnit
        anchors {
            horizontalCenter: speedText.horizontalCenter
            baseline: speedText.baseline
            baselineOffset: speedUnitBaselineOffset
        }

        color: Colors.speedUnit
        font {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: speedUnitsSize
        }
        text: datastore.unit === DataStore.Kmh ? qsTr("km/h") : qsTr("mph")
    }

    // Average speed info
    Text {
        id: averageSpeedText
        anchors {
            baseline: speedText.baseline
            baselineOffset: speedInfoTextsOffset
            horizontalCenter: speedText.horizontalCenter
            horizontalCenterOffset: -speedIconsOffset
        }
        visible: speedView.state !== "CORNERED"

        color: Colors.averageSpeedText
        font {
            family: "Teko, Light"
            weight: Font.Light
            pixelSize: speedInfoTextsSize
        }
        text: datastore.averagespeed.toFixed(0)
    }

    Text {
        id: averageSpeedUnit
        anchors {
            horizontalCenter: averageSpeedText.horizontalCenter
            baseline: averageSpeedText.baseline
            baselineOffset: speedInfoUnitsOffset
        }
        visible: speedView.state !== "CORNERED"

        color: Colors.averageSpeedUnit
        font {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: speedUnitsSize
        }
        horizontalAlignment: Text.AlignHCenter
        text: datastore.unit === DataStore.Kmh ? qsTr("AVG\nkm/h") : qsTr("AVG\nmph")
    }

    Image {
        id: averageSpeedIcon
        width: parent.width * 0.075
        height: width
        fillMode: Image.PreserveAspectFit
        source: "images/speed.png"
        anchors {
            horizontalCenter: averageSpeedText.horizontalCenter
            bottom: averageSpeedText.top
        }
        visible: speedView.state !== "CORNERED"
    }

    // Assist info
    Text {
        id: assistDistanceText
        anchors {
            baseline: speedText.baseline
            baselineOffset: speedInfoTextsOffset
            horizontalCenter: speedText.horizontalCenter
            horizontalCenterOffset: speedIconsOffset
        }
        visible: speedView.state !== "CORNERED"

        color: Colors.assistDistanceText
        font {
            family: "Teko, Light"
            weight: Font.Light
            pixelSize: speedInfoTextsSize
        }
        text: datastore.assistdistance.toFixed(0)
    }

    Text {
        id: assistDistanceUnit
        anchors {
            horizontalCenter: assistDistanceText.horizontalCenter
            baseline: assistDistanceText.baseline
            baselineOffset: speedInfoUnitsOffset
        }
        visible: speedView.state !== "CORNERED"

        color: Colors.assistDistanceUnit
        font {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: speedUnitsSize
        }
        horizontalAlignment: Text.AlignHCenter
        text: datastore.unit === DataStore.Kmh ? qsTr("km\nassist\nleft") : qsTr("mi.\nassist\nleft")
    }

    Image {
        id: assistDistanceIcon
        width: parent.width * 0.075
        height: width
        fillMode: Image.PreserveAspectFit
        source: "images/battery.png"
        anchors {
            horizontalCenter: assistDistanceText.horizontalCenter
            bottom: assistDistanceText.top
        }
        visible: speedView.state !== "CORNERED"
    }

    // Assist power icon
    Image {
        id: assistPowerIcon
        width: parent.width * 0.125
        height: width
        fillMode: Image.PreserveAspectFit
        source: "images/assist.png"
        anchors {
            horizontalCenter: speedView.horizontalCenter
            top: parent.verticalCenter
            topMargin: assistPowerIconOffset
        }
        visible: speedView.state !== "CORNERED"
    }

    Gradient {
        id: assistPowerGradient
        GradientStop { position: 0.0; color: Colors.assistPowerGradientStart }
        GradientStop { position: 1.0; color: Colors.assistPowerGradientEnd }
    }

    // Assist power circles
    Rectangle {
        id: assistPowerIcon1
        width: parent.width * 0.0375
        height: width
        radius: parent.width * 0.0375
        anchors {
            right: assistPowerIcon2.left
            rightMargin: UILayout.assistPowerCircleOffset
            bottom: assistPowerIcon2.bottom
            bottomMargin: UILayout.assistPowerCircleVerticalOffset
        }
        color: Colors.assistPowerEmpty
        gradient: datastore.assistpower > 2.0 ? assistPowerGradient : null
        visible: speedView.state !== "CORNERED"
    }

    Rectangle {
        id: assistPowerIcon2
        width: parent.width * 0.0375
        height: width
        radius: parent.width * 0.0375
        anchors {
            right: parent.horizontalCenter
            rightMargin: UILayout.assistPowerCircleOffset / 2
            top: assistPowerIcon.bottom
            topMargin: parent.height * 0.02
        }
        color: Colors.assistPowerEmpty
        gradient: datastore.assistpower > 25.0 ? assistPowerGradient : null
        visible: speedView.state !== "CORNERED"
    }

    Rectangle {
        id: assistPowerIcon3
        width: parent.width * 0.0375
        height: width
        radius: parent.width * 0.0375
        anchors {
            left: parent.horizontalCenter
            leftMargin: UILayout.assistPowerCircleOffset / 2
            top: assistPowerIcon.bottom
            topMargin: parent.height * 0.02
        }
        color: Colors.assistPowerEmpty
        gradient: datastore.assistpower > 50.0 ? assistPowerGradient : null
        visible: speedView.state !== "CORNERED"
    }

    Rectangle {
        id: assistPowerIcon4
        width: parent.width * 0.0375
        height: width
        radius: parent.width * 0.0375
        anchors {
            left: assistPowerIcon3.right
            leftMargin: UILayout.assistPowerCircleOffset
            bottom: assistPowerIcon3.bottom
            bottomMargin: UILayout.assistPowerCircleVerticalOffset
        }
        color: Colors.assistPowerEmpty
        gradient: datastore.assistpower > 75.0 ? assistPowerGradient : null
        visible: speedView.state !== "CORNERED"
    }

    // Numbers for speed and battery level
    Text {
        anchors {
            baseline: parent.bottom
            baselineOffset: parent.height * 0.04
            right: parent.horizontalCenter
            rightMargin: parent.width * 0.02
        }
        visible: speedView.state !== "CORNERED"

        color: Colors.dottedRing
        font {
            family: "Montserrat, Regular"
            weight: Font.Normal
            pixelSize: parent.height * 0.04
        }
        text: "0"
    }

    Text {
        anchors {
            baseline: parent.bottom
            baselineOffset: parent.height * 0.04
            left: parent.horizontalCenter
            leftMargin: parent.width * 0.02
        }
        visible: speedView.state !== "CORNERED"

        color: Colors.dottedRing
        font {
            family: "Montserrat, Regular"
            weight: Font.Normal
            pixelSize: parent.height * 0.04
        }
        text: "0 %"
    }

    Text {
        anchors {
            baseline: parent.verticalCenter
            right: parent.left
            rightMargin: parent.width * 0.02
        }
        visible: speedView.state !== "CORNERED"

        color: Colors.dottedRing
        font {
            family: "Montserrat, Regular"
            weight: Font.Normal
            pixelSize: parent.height * 0.04
        }
        text: "30"
    }

    Text {
        anchors {
            baseline: parent.verticalCenter
            left: parent.right
            leftMargin: parent.width * 0.02
        }
        visible: speedView.state !== "CORNERED"

        color: Colors.dottedRing
        font {
            family: "Montserrat, Regular"
            weight: Font.Normal
            pixelSize: parent.height * 0.04
        }
        text: "50 %"
    }

    Text {
        anchors {
            baseline: parent.top
            baselineOffset: -parent.height * 0.02
            right: parent.horizontalCenter
            rightMargin: parent.width * 0.02
        }
        visible: speedView.state !== "CORNERED"

        color: Colors.dottedRing
        font {
            family: "Montserrat, Regular"
            weight: Font.Normal
            pixelSize: parent.height * 0.04
        }
        text: "60"
    }

    Text {
        anchors {
            baseline: parent.top
            baselineOffset: -parent.height * 0.02
            left: parent.horizontalCenter
            leftMargin: parent.width * 0.02
        }
        visible: speedView.state !== "CORNERED"

        color: Colors.dottedRing
        font {
            family: "Montserrat, Regular"
            weight: Font.Normal
            pixelSize: parent.height * 0.04
        }
        text: "100 %"
    }

    Rectangle {
        id: cornerRectangle
        width: parent.width / 2
        height: width
        // By default this is centered, and invisible
        anchors.horizontalCenter: speedView.horizontalCenter
        anchors.verticalCenter: speedView.verticalCenter
        color: "transparent"
        radius: width * 0.1
        z: -1

        Image {
            source: "images/small_speedometer_arrow.png"
            width: parent.width * 0.25
            height: width
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.075
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.075
            visible: swipeView.currentIndex != 1
        }
    }

    Image {
        source: "images/small_speedometer_shadow.png"
        width: parent.width * 1.05
        height: width
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            horizontalCenterOffset: parent.width * 0.025
            verticalCenterOffset: parent.height * 0.025
        }
        z: -1

        visible: speedView.state == "CORNERED"
    }

    Canvas {
        id: speedArc
        anchors.fill: speedView

        Component.onCompleted: {
            datastore.onSpeedChanged.connect(speedArc.requestPaint)
            datastore.onBatterylevelChanged.connect(speedArc.requestPaint)
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

            var currentRadius = (speedView.width - 2) / 2;
            var centerX = speedView.width / 2;
            var centerY = speedView.height / 2;

            // Draw the dotted circle (if not in corner mode)
            if (speedView.state !== "CORNERED") {
                ctx.fillStyle = Colors.dottedRing;
                var angleStep = Math.PI * 2.0 / dotcount;
                for (var angle = 0; angle <= Math.PI * 2; angle += angleStep) {
                    var x = currentRadius * Math.cos(angle);
                    var y = currentRadius * Math.sin(angle);
                    ctx.fillRect(centerX + x, centerY + y, 2, 2);
                }
            }

            // Draw speed and battery view bases
            ctx.lineCap = "round";
            ctx.strokeStyle = Colors.dottedRing;
            ctx.lineWidth = curvewidth;
            ctx.beginPath();
            ctx.arc(centerX, centerY, innerRadius,
                    UILayout.speedViewSpeedStart, UILayout.speedViewSpeedEnd);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(centerX, centerY, innerRadius,
                    UILayout.speedViewBatteryStart, UILayout.speedViewBatteryEnd, true);
            ctx.stroke();

            // Draw speed gradient
            if (!showZero) {
                var speedArcLength = UILayout.speedViewSpeedEnd - UILayout.speedViewSpeedStart;
                var speedAngle = Math.min(UILayout.speedViewSpeedEnd,
                                          UILayout.speedViewSpeedStart + speedArcLength * (datastore.speed / 60));
                var speedAngleX = Math.cos(speedAngle) * innerRadius;
                var speedAngleY = Math.sin(speedAngle) * innerRadius;
                var speedGradient = ctx.createLinearGradient(centerX, centerY + innerRadius,
                                                             centerX + speedAngleX, centerY + speedAngleY);
                speedGradient.addColorStop(0.0, Colors.speedGradientStart);
                speedGradient.addColorStop(1.0, Colors.speedGradientEnd);
                ctx.strokeStyle = speedGradient;
                ctx.beginPath();
                ctx.arc(centerX, centerY, innerRadius,
                        UILayout.speedViewSpeedStart, speedAngle);
                ctx.stroke();
            }

            // Draw battery gradient
            var batteryArcLength = UILayout.speedViewBatteryEnd - UILayout.speedViewBatteryStart;
            var batteryAngle = Math.max(UILayout.speedViewBatteryEnd,
                                       UILayout.speedViewBatteryStart + batteryArcLength * (datastore.batterylevel / 100));
            var batteryAngleX = Math.cos(batteryAngle) * innerRadius;
            var batteryAngleY = Math.sin(batteryAngle) * innerRadius;
            var batteryGradient = ctx.createLinearGradient(centerX, centerY + innerRadius,
                                                           centerX + batteryAngleX, centerY + batteryAngleY);
                                                           //centerX, centerY - innerRadius);
            batteryGradient.addColorStop(0.0, Colors.batteryGradientStart);
            batteryGradient.addColorStop(1.0, Colors.batteryGradientEnd);
            ctx.strokeStyle = batteryGradient;
            ctx.beginPath();
            ctx.arc(centerX, centerY, innerRadius,
                    UILayout.speedViewBatteryStart, batteryAngle, true);
            ctx.stroke();
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (enlarged)
                enlarged = false
            else if (swipeView.currentIndex === 1)
                enlarged = true
            else
                speedView.showMain()
        }
    }
}
