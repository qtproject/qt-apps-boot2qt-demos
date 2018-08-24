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
import "./BikeStyle"
// Permanent placeholder for time display
Item {
    width: backgroundImage.width
    height: backgroundImage.height
    z: 1

    // Timer that will show the current time at the top of the screen
    Timer {
        interval: 500; running: true; repeat: true
        onTriggered: timeLabel.text = new Date().toLocaleTimeString(Qt.locale("en_US"), Locale.ShortFormat)
    }

    Image {
        id: backgroundImage
        source: "images/top_curtain_drag.png"
        anchors.centerIn: parent
    }

    Text {
        id: timeLabel
        anchors {
            horizontalCenter: parent.horizontalCenter
            baseline: parent.top
            baselineOffset: UILayout.clockBaselineMargin
        }
        color: Colors.clockText
        text: "--:--"
        font {
            family: "Montserrat, Medium"
            weight: Font.Medium
            pixelSize: UILayout.clockFontSize
        }
    }
}
