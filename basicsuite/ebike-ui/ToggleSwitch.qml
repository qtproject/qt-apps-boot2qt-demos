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
import QtQuick.Controls 2.2

import "./BikeStyle"

Switch {
    id: control

    implicitWidth: indicator.implicitWidth
    implicitHeight: indicator.implicitHeight

    indicator: Rectangle {
        implicitWidth: UILayout.switchWidth
        implicitHeight: UILayout.switchHeight
        radius: height / 2
        y: parent.height / 2 - height / 2
        color: control.checked ? Colors.switchBackgroundOn : Colors.switchBackgroundOff

        Rectangle {
            x: control.checked ? parent.width - width : 0
            y: UILayout.switchHeight / 2 - UILayout.switchIndicatorRadius
            width: 2 * UILayout.switchIndicatorRadius
            height: 2 * UILayout.switchIndicatorRadius
            radius: UILayout.switchIndicatorRadius
            color: control.checked ? Colors.switchOn : Colors.switchOff
        }
    }

    contentItem: Text {}
}