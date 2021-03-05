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

import QtQuick 2.7
import QtQuick.Controls 2.0
import DataStore 1.0

import "./BikeStyle"

// Top-left corner, stats
Item {
    width: parent.width * 0.425
    height: parent.height * 0.45
    property real imageMargin: Math.min(width, height) * 0.3

    Image {
        id: tripIcon
        width: Math.min(parent.width, parent.height) * 0.15
        height: width
        source: "images/trip.png"
        fillMode: Image.PreserveAspectFit
        anchors {
            left: parent.left
            leftMargin: imageMargin
            top: parent.top
            topMargin: imageMargin
        }
    }

    Text {
        id: tripText
        clip: clipDynamicText
        color: Colors.distanceText
        anchors {
            bottom: tripIcon.verticalCenter
            bottomMargin: -imageMargin * 0.05
            left: tripIcon.right
        }
        font {
            family: "Montserrat, Bold"
            weight: Font.Bold
            pixelSize: parent.height * 0.1
        }
        text: datastore.trip.toFixed(1)
        verticalAlignment: Text.AlignBottom
    }

    Text {
        id: tripUnitText
        color: Colors.distanceUnit
        anchors {
            top: tripText.bottom
            left: tripIcon.right
        }
        font {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: parent.height * 0.065
        }
        verticalAlignment: Text.AlignTop
        text: datastore.unit === DataStore.Kmh ? "km" : "mi."
    }

    Image {
        id: calIcon
        width: Math.min(parent.width, parent.height) * 0.15
        height: width
        source: "images/calories.png"
        anchors {
            left: parent.left
            leftMargin: imageMargin
            top: tripIcon.bottom
            topMargin: imageMargin * 0.25
        }
    }

    Text {
        id: calText
        clip: clipDynamicText
        color: Colors.distanceText
        anchors {
            bottom: calIcon.verticalCenter
            bottomMargin: -imageMargin * 0.05
            left: calIcon.right
        }
        font {
            family: "Montserrat, Bold"
            weight: Font.Bold
            pixelSize: parent.height * 0.1
        }
        text: datastore.calories.toFixed(0)
    }

    Text {
        id: calUnitText
        color: Colors.distanceUnit
        anchors {
            top: calText.bottom
            left: calIcon.right
        }
        font {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: parent.height * 0.065
        }
        text: "kcal"
    }

    Rectangle {
        width: parent.width * 0.775
        height: UILayout.horizontalViewSeparatorHeight
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: Colors.separator
    }

    Rectangle {
        width: UILayout.verticalViewSeparatorWidth
        height: parent.height * 0.475
        anchors.top: parent.top
        anchors.right: parent.right
        color: Colors.separator
    }
}
