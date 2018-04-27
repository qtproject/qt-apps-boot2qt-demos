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
    property string arrowSource: "images/nav_nodir.png"
    property string address: "-"
    property string distance: "0"
    property string unit: "m"

    width: UILayout.naviPageGuideRadius * 2
    height: width
    radius: width
    color: Colors.naviPageGuideBackground
    z: 1

    Rectangle {
        width: UILayout.naviPageGuideRadius
        height: width
        radius: 10
        color: Colors.naviPageGuideBackground
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    Image {
        id: guideArrow
        anchors {
            top: parent.top
            topMargin: UILayout.naviPageGuideArrowTopMargin
            left: parent.left
            leftMargin: UILayout.naviPageGuideArrowLeftMargin
        }
        source: arrowSource
        width: UILayout.naviPageGuideArrowWidth
        height: UILayout.naviPageGuideArrowHeight
    }

    Text {
        id: naviAddressText
        anchors {
            baseline: parent.bottom
            baselineOffset: -UILayout.naviPageGuideAddressBaselineMargin
            right: parent.right
            rightMargin: UILayout.naviPageGuideAddressRightMargin
        }
        width: 123
        horizontalAlignment: Text.AlignRight
        color: Colors.naviPageGuideAddressColor
        font {
            family: "Montserrat, Medium"
            weight: Font.Medium
            pixelSize: UILayout.naviPageGuideAddressTextSize
        }
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
        minimumPixelSize: 9
        text: address
    }

    Text {
        id: naviUnit
        anchors {
            baseline: naviAddressText.baseline
            baselineOffset: -UILayout.naviPageGuideDistanceBaselineMargin
            right: naviAddressText.right
        }
        color: Colors.naviPageGuideUnitColor
        font {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: UILayout.naviPageGuideUnitTextSize
        }
        text: datastore.smallUnit
    }

    Text {
        id: naviDistance
        anchors {
            baseline: naviUnit.baseline
            right: naviUnit.left
            rightMargin: 10
        }
        color: Colors.naviPageGuideTextColor
        font {
            family: "Montserrat, Bold"
            weight: Font.Bold
            pixelSize: UILayout.naviPageGuideDistanceTextSize
        }
        text: Math.round(datastore.convertSmallDistance(distance) / 10) * 10
    }

    Image {
        source: "images/navigation_widget_shadow.png"
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            horizontalCenterOffset: 1
            verticalCenterOffset: 1
        }
        z: -1
    }
}
