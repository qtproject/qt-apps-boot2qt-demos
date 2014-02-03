/****************************************************************************
**
** Copyright (C) 2013 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://qt.digia.com
**
** This file is part of the QtQuick Enterprise Controls Add-on.
**
** $QT_BEGIN_LICENSE$
** Licensees holding valid Qt Commercial licenses may use this file in
** accordance with the Qt Commercial License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://qt.digia.com
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Enterprise.Controls.Styles 1.0

DashboardGaugeStyle {
    id: fuelGaugeStyle
    minimumValueAngle: 300
    maximumValueAngle: 60
    tickmarkStepSize: 1
    labelStepSize: 1
    labelInset: toPixels(-0.25)
    minorTickmarkCount: 3

    needleLength: toPixels(0.85)
    needleBaseWidth: toPixels(0.08)
    needleTipWidth: toPixels(0.03)

    halfGauge: true

    property string icon: ""
    property color minWarningColor: "transparent"
    property color maxWarningColor: "transparent"
    readonly property real minWarningStartAngle: minimumValueAngle - 90
    readonly property real maxWarningStartAngle: maximumValueAngle - 90

    tickmark: Rectangle {
        width: toPixels(0.06)
        antialiasing: true
        height: toPixels(0.2)
        color: "#c8c8c8"
    }

    minorTickmark: Rectangle {
        width: toPixels(0.03)
        antialiasing: true
        height: toPixels(0.15)
        color: "#c8c8c8"
    }

    background: Item {
        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                paintBackground(ctx);

                if (minWarningColor != "transparent") {
                    ctx.beginPath();
                    ctx.lineWidth = fuelGaugeStyle.toPixels(0.08);
                    ctx.strokeStyle = minWarningColor;
                    ctx.arc(outerRadius, outerRadius,
                        // Start the line in from the decorations, and account for the width of the line itself.
                        outerRadius - tickmarkInset - ctx.lineWidth / 2,
                        degToRad(minWarningStartAngle),
                        degToRad(minWarningStartAngle + angleRange / (minorTickmarkCount + 1)), false);
                    ctx.stroke();
                }
                if (maxWarningColor != "transparent") {
                    ctx.beginPath();
                    ctx.lineWidth = fuelGaugeStyle.toPixels(0.08);
                    ctx.strokeStyle = maxWarningColor;
                    ctx.arc(outerRadius, outerRadius,
                        // Start the line in from the decorations, and account for the width of the line itself.
                        outerRadius - tickmarkInset - ctx.lineWidth / 2,
                        degToRad(maxWarningStartAngle - angleRange / (minorTickmarkCount + 1)),
                        degToRad(maxWarningStartAngle), false);
                    ctx.stroke();
                }
            }
        }

        Image {
            source: icon
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: toPixels(0.3)
            anchors.horizontalCenter: parent.horizontalCenter
            width: toPixels(0.3)
            height: width
            fillMode: Image.PreserveAspectFit
        }
    }
}
