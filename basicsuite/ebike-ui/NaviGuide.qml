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

    width: root.width * 0.14
    height: width
    radius: width
    color: Colors.naviPageGuideBackground
    z: 1

    Rectangle {
        width: parent.width / 2
        height: width
        radius: width * 0.1
        color: Colors.naviPageGuideBackground
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    Image {
        id: guideArrow
        anchors {
            top: parent.top
            topMargin: parent.height * 0.075
            horizontalCenter: parent.horizontalCenter
        }
        source: arrowSource
        width: parent.width * 0.5
        height: width
    }

    Text {
        id: naviAddressText
        anchors {
            top: naviDistance.bottom
            topMargin: parent.height * 0.025
            right: parent.right
            rightMargin: parent.width * 0.1
        }
        width: parent.width * 0.725
        horizontalAlignment: Text.AlignRight
        color: Colors.naviPageGuideAddressColor
        font {
            family: "Montserrat, Medium"
            weight: Font.Medium
            pixelSize: parent.height * 0.075
        }
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
        minimumPixelSize: 5
        text: address
    }

    Text {
        id: naviUnit
        anchors {
            bottom: naviDistance.bottom
            right: naviAddressText.right
        }
        verticalAlignment: Text.AlignBottom
        color: Colors.naviPageGuideUnitColor
        font {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: parent.height * 0.125
        }
        text: datastore.smallUnit
    }

    Text {
        id: naviDistance
        anchors {
            top: guideArrow.bottom
            right: naviUnit.left
            rightMargin: parent.width * 0.05
        }
        verticalAlignment: Text.AlignBottom
        color: Colors.naviPageGuideTextColor
        font {
            family: "Montserrat, Bold"
            weight: Font.Bold
            pixelSize: parent.height * 0.175
        }
        text: Math.round(datastore.convertSmallDistance(distance) / 10) * 10
    }

    Image {
        source: "images/navigation_widget_shadow.png"
        width: parent.width * 1.05
        height: width
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            horizontalCenterOffset: parent.width * 0.025
            verticalCenterOffset: parent.height * 0.025
        }
        z: -1
    }
}
