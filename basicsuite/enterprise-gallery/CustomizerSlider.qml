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

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0

Slider {
    id: slider
    width: parent.width
    height: root.toPixels(0.1)

    style: SliderStyle {
        handle: Rectangle {
            height: root.toPixels(0.06)
            width: height
            radius: width/2
            color: "#fff"
        }

        groove: Rectangle {
            implicitHeight: root.toPixels(0.015)
            implicitWidth: 100
            radius: height/2
            border.color: "#333"
            color: "#222"
            Rectangle {
                height: parent.height
                width: styleData.handlePosition
                implicitHeight: 6
                implicitWidth: 100
                radius: height/2
                color: "#555"
            }
        }

    }
}
