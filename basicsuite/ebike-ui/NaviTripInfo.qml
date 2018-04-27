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

Rectangle {
    property real remainingDistance: 0
    property real remainingTravelTime: 0
    property var remainingDistanceSplit: datastore.splitDistance(remainingDistance, true)
    property var remainingTravelTimeSplit: datastore.splitDuration(remainingTravelTime)

    width: UILayout.naviPageTripWidth
    height: UILayout.naviPageTripHeight
    radius: UILayout.naviPageTripRadius
    color: Colors.naviPageTripBackground

    Rectangle {
        width: UILayout.naviPageTripDividerWidth
        height: UILayout.naviPageTripDividerHeight
        radius: 2
        color: Colors.naviPageTripDivider
        anchors.centerIn: parent
    }

    Item {
        height: parent.height
        width: naviTripDistanceRemainingText.width + 5 + naviTripDistanceUnitText.width
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: -parent.width / 4
        }

        Text {
            id: naviTripDistanceRemainingText
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.naviPageGuideTextColor
            font {
                family: "Montserrat, Medium"
                weight: Font.Medium
                pixelSize: UILayout.naviPageTripTotalTextSize
            }
            text: remainingDistanceSplit.decimal ? remainingDistanceSplit.value.toFixed(1) : remainingDistanceSplit.value.toFixed(0)
        }

        Text {
            id: naviTripDistanceUnitText
            anchors {
                verticalCenter: parent.verticalCenter
                left: naviTripDistanceRemainingText.right
                leftMargin: 5
            }
            color: Colors.naviPageGuideUnitColor
            font {
                family: "Montserrat, Light"
                weight: Font.Light
                pixelSize: UILayout.naviPageTripTotalUnitSize
            }
            text: remainingDistanceSplit.unit
        }
    }


    Item {
        height: parent.height
        width: naviTripTimeRemainingText.width + 5 + naviTripTimeUnitText.width
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: parent.width / 4
        }

        Text {
            id: naviTripTimeRemainingText
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.naviPageGuideTextColor
            font {
                family: "Montserrat, Medium"
                weight: Font.Medium
                pixelSize: UILayout.naviPageTripTotalTextSize
            }
            text: remainingTravelTimeSplit.value.toFixed(0)
        }

        Text {
            id: naviTripTimeUnitText
            anchors {
                verticalCenter: parent.verticalCenter
                left: naviTripTimeRemainingText.right
                leftMargin: 5
            }
            color: Colors.naviPageGuideUnitColor
            font {
                family: "Montserrat, Light"
                weight: Font.Light
                pixelSize: UILayout.naviPageTripTotalUnitSize
            }
            text: remainingTravelTimeSplit.unit
        }
    }

    Image {
        source: "images/small_input_box_shadow.png"
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            horizontalCenterOffset: 1
            verticalCenterOffset: 1
        }
        z: -1
    }
}
