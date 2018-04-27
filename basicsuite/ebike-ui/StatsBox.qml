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
    width: 320
    height: UILayout.topViewHeight

    Image {
        id: tripIcon
        width: UILayout.statsIconWidth
        height: UILayout.statsIconHeight
        source: "images/trip.png"
        anchors {
            top: parent.top
            left: parent.left
            topMargin: UILayout.statsIconTop
            leftMargin: UILayout.statsIconLeft
        }
    }

    Text {
        id: tripText
        color: Colors.distanceText
        anchors {
            top: tripIcon.top
            topMargin: UILayout.statsTextTopOffset
            left: tripIcon.right
            leftMargin: UILayout.statsTextSeparator
        }
        font {
            family: "Montserrat, Bold"
            weight: Font.Bold
            pixelSize: UILayout.statsTextSize
        }
        text: datastore.trip.toFixed(1)
    }

    Text {
        id: tripUnitText
        color: Colors.distanceUnit
        anchors {
            baseline: tripIcon.bottom
            baselineOffset: -UILayout.statsUnitBaselineOffset
            left: tripIcon.right
            leftMargin: UILayout.statsTextSeparator
        }
        font {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: UILayout.statsTextSize
        }
        text: datastore.unit === DataStore.Kmh ? "km" : "mi."
    }

    Image {
        id: calIcon
        width: UILayout.statsIconWidth
        height: UILayout.statsIconHeight
        source: "images/calories.png"
        anchors {
            top: tripIcon.bottom
            left: parent.left
            topMargin: UILayout.statsIconSeparator
            leftMargin: UILayout.statsIconLeft
        }
    }

    Text {
        id: calText
        color: Colors.distanceText
        anchors {
            top: calIcon.top
            topMargin: UILayout.statsTextTopOffset
            left: calIcon.right
            leftMargin: UILayout.statsTextSeparator
        }
        font {
            family: "Montserrat, Bold"
            weight: Font.Bold
            pixelSize: UILayout.statsTextSize
        }
        text: datastore.calories.toFixed(0)
    }

    Text {
        id: calUnitText
        color: Colors.distanceUnit
        anchors {
            baseline: calIcon.bottom
            baselineOffset: -UILayout.statsUnitBaselineOffset
            left: calIcon.right
            leftMargin: UILayout.statsTextSeparator
        }
        font {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: UILayout.statsTextSize
        }
        text: "kcal"
    }

    Rectangle {
        width: UILayout.horizontalViewSeparatorWidth
        height: UILayout.horizontalViewSeparatorHeight
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: Colors.separator
    }

    Rectangle {
        width: UILayout.verticalViewSeparatorWidth
        height: UILayout.verticalViewSeparatorHheightTop
        anchors.top: parent.top
        anchors.right: parent.right
        color: Colors.separator
    }
}
