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
import DataStore 1.0

import "./BikeStyle"

// Bottom-right corner, mode
Item {
    width: parent.width * 0.425
    height: parent.height * 0.45

    Text {
        id: sportModeText
        clip: clipDynamicText
        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height * 0.3
            left: parent.horizontalCenter
        }
        color: datastore.mode == DataStore.Sport ? Colors.modeSelected : Colors.modeUnselected
        font {
            family: "Montserrat, Medium"
            weight: Font.Medium
            pixelSize: parent.height * 0.1
        }
        text: qsTr("SPORT")
    }

    Text {
        id: cruiseModeText
        clip: clipDynamicText
        anchors {
            bottom: sportModeText.top
            bottomMargin: parent.height * 0.025
            horizontalCenter: sportModeText.horizontalCenter
        }
        color: datastore.mode == DataStore.Cruise ? Colors.modeSelected : Colors.modeUnselected
        font {
            family: "Montserrat, Medium"
            weight: Font.Medium
            pixelSize: parent.height * 0.1
        }
        text: qsTr("CRUISE")
    }

    MouseArea {
        anchors.fill: parent
        onClicked: datastore.toggleMode()
    }

    Rectangle {
        width: parent.width * 0.775
        height: UILayout.horizontalViewSeparatorHeight
        anchors.top: parent.top
        anchors.right: parent.right
        color: Colors.separator
    }

    Rectangle {
        width: UILayout.verticalViewSeparatorWidth
        height: parent.height * 0.475
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: Colors.separator
    }
}
