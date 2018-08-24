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
import QtQuick.Extras 1.4

import "./BikeStyle"

// Bottom-left corner, controls
Item {
    width: 320
    height: UILayout.bottomViewHeight

    Image {
        id: lightsIcon
        width: UILayout.lightsIconWidth
        height: UILayout.lightsIconHeight
        source: datastore.lights ? "images/lights_on.png" : "images/lights_off.png"
        fillMode: Image.PreserveAspectFit
        anchors {
            left: parent.left
            leftMargin: UILayout.lightsIconLeft
            bottom: parent.bottom
            bottomMargin: UILayout.lightsIconBottom
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: datastore.lights = !datastore.lights
    }

    Rectangle {
        width: UILayout.horizontalViewSeparatorWidth
        height: UILayout.horizontalViewSeparatorHeight
        anchors.top: parent.top
        anchors.left: parent.left
        color: Colors.separator
    }

    Rectangle {
        width: UILayout.verticalViewSeparatorWidth
        height: UILayout.verticalViewSeparatorHeightBottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        color: Colors.separator
    }
}
