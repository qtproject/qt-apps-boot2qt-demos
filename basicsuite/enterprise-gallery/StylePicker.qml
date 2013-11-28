/****************************************************************************
**
** Copyright (C) 2013 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://qt.digia.com
**
** This file is part of the QtQuick Enterprise Controls Add-on.
**
** $QT_BEGIN_LICENSE$
** Licensees holding valid Qt Commercial licenses may use this file in
** accordance with the Qt Commercial License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://qt.digia.com
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Enterprise.Controls 1.0
import QtQuick.Enterprise.Controls.Styles 1.0

ListView {
    id: stylePicker
    width: parent.width
    height: root.height * 0.06
    interactive: false
    spacing: -1

    orientation: ListView.Horizontal

    readonly property string currentStylePath: stylePicker.model.get(stylePicker.currentIndex).path
    readonly property bool currentStyleDark: stylePicker.model.get(stylePicker.currentIndex).dark !== undefined
        ? stylePicker.model.get(stylePicker.currentIndex).dark
        : true

    ExclusiveGroup {
        id: styleExclusiveGroup
    }

    delegate: Button {
        width: stylePicker.width / stylePicker.model.count
        height: stylePicker.height
        checkable: true
        checked: index == ListView.view.currentIndex
        exclusiveGroup: styleExclusiveGroup

        onCheckedChanged: {
            if (checked) {
                ListView.view.currentIndex = index;
            }
        }

        style: ButtonStyle {
            background: Rectangle {
                readonly property color checkedColor: currentStyleDark ? "#444" : "#777"
                readonly property color uncheckedColor: currentStyleDark ? "#222" : "#bbb"
                color: checked ? checkedColor : uncheckedColor
                border.color: checkedColor
                border.width: 1
                radius: 1
            }

            label: Text {
                text: name
                color: currentStyleDark ? "white" : (checked ? "white" : "black")
                font.pixelSize: root.toPixels(0.04)
                font.family: openSans.name
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
