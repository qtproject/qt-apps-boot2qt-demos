/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
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
import QtQuick.Enterprise.Controls.Styles 1.1

CircularGaugeStyle {
    id: root
    tickmarkStepSize: 10
    minorTickmarkCount: 2
    labelStepSize: 40
    tickmarkInset: outerRadius * 0.06
    minorTickmarkInset: tickmarkInset
    labelInset: outerRadius * 0.23

    background: Image {
        source: "images/background-light.png"
    }

    needle: Image {
        id: needleImage
        source: "images/needle-light.png"
        transformOrigin: Item.Bottom
        scale: {
            var distanceFromLabelToRadius = labelInset / 2;
            var idealHeight = outerRadius - distanceFromLabelToRadius;
            var originalImageHeight = needleImage.sourceSize.height;
            idealHeight / originalImageHeight;
        }
    }

    foreground: Item {
        Image {
            anchors.centerIn: parent
            source: "images/center-light.png"
            scale: (outerRadius * 0.25) / sourceSize.height
        }
    }

    tickmark: Rectangle {
        width: outerRadius * 0.01
        antialiasing: true
        height: outerRadius * 0.04
        color: "#999"
    }

    minorTickmark: Rectangle {
        width: outerRadius * 0.01
        antialiasing: true
        height: outerRadius * 0.02
        color: "#bbb"
    }

    tickmarkLabel: Text {
        font.family: "Helvetica neue"
        font.pixelSize: Math.max(6, outerRadius * 0.1)
        text: styleData.value
        color: "#333"
    }
}
