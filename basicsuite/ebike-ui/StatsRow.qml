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

import "./BikeStyle"

Item {
    property string leftTitle
    property string leftValue
    property string rightTitle
    property string rightValue
    height: parent.height / 3
    width: parent.width
    property int rowTextSize: height * 0.5

    Text {
        text: leftTitle
        anchors.left: parent.left
        height: parent.height
        color: Colors.statsDescriptionText
        verticalAlignment: Text.AlignVCenter
        font {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: rowTextSize
        }
    }

    Text {
        text: leftValue
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: parent.width * 0.0125
        height: parent.height
        color: Colors.statsValueText
        verticalAlignment: Text.AlignVCenter
        font {
            family: "Montserrat, Bold"
            weight: Font.Bold
            pixelSize: rowTextSize
        }
    }

    Text {
        text: rightTitle
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: parent.width * 0.0125
        height: parent.height
        color: Colors.statsDescriptionText
        verticalAlignment: Text.AlignVCenter
        font {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: rowTextSize
        }
    }

    Text {
        text: rightValue
        anchors.right: parent.right
        height: parent.height
        color: Colors.statsValueText
        verticalAlignment: Text.AlignVCenter
        font {
            family: "Montserrat, Bold"
            weight: Font.Bold
            pixelSize: rowTextSize
        }
    }
}
