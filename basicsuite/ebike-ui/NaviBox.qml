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

import "./BikeStyle"

// Top-right corner, navi
Item {
    width: 320
    height: UILayout.topViewHeight
    property string arrowSource: "images/nav_right.png"
    property string distance: "0"
    property string unit: "m"

    Image {
        id: naviIcon
        width: UILayout.naviIconWidth
        height: UILayout.naviIconHeight
        source: arrowSource
        anchors {
            top: parent.top
            topMargin: UILayout.naviIconTop
            horizontalCenter: parent.right
            horizontalCenterOffset: -UILayout.naviModeCenterMargin
        }
    }

    Item {
        id: container
        anchors.horizontalCenter: naviIcon.horizontalCenter
        anchors.top: naviIcon.bottom
        height: 30
        width: naviText.width + 5 + naviUnit.width
        visible: navigation.active

        Text {
            id: naviText
            anchors.baseline: container.bottom
            color: Colors.distanceText
            font {
                family: "Montserrat, Bold"
                weight: Font.Bold
                pixelSize: UILayout.naviTextSize
            }
            text: Math.round(datastore.convertSmallDistance(distance) / 10) * 10
        }

        Text {
            id: naviUnit
            anchors {
                baseline: container.bottom
                left: naviText.right
                leftMargin: 5
            }
            color: Colors.distanceUnit
            font {
                family: "Montserrat, Light"
                weight: Font.Light
                pixelSize: UILayout.naviTextSize
            }
            text: datastore.smallUnit
        }
    }

    Text {
        id: navigateText
        anchors.horizontalCenter: naviIcon.horizontalCenter
        anchors.top: naviIcon.bottom
        visible: !navigation.active
        color: Colors.modeUnselected
        font {
            family: "Montserrat, Medium"
            weight: Font.Medium
            pixelSize: UILayout.modeTextSize
        }
        text: qsTr("NAVIGATE")
    }

    Rectangle {
        width: UILayout.horizontalViewSeparatorWidth
        height: UILayout.horizontalViewSeparatorHeight
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        color: Colors.separator
    }

    Rectangle {
        width: UILayout.verticalViewSeparatorWidth
        height: UILayout.verticalViewSeparatorHeightTop
        anchors.top: parent.top
        anchors.left: parent.left
        color: Colors.separator
    }
}
