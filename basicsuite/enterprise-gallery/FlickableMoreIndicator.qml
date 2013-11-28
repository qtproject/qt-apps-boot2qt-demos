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

Rectangle {
    anchors.top: atTop ? flickable.top : undefined
    anchors.bottom: atTop ? undefined : flickable.bottom
    anchors.left: isScreenPortrait ? parent.left : parent.horizontalCenter
    anchors.right: parent.right
    height: 30
    visible: flickable.visible
    opacity: atTop
        ? (flickable.contentY > showDistance ? 1 : 0)
        : (flickable.contentY < flickable.contentHeight - showDistance ? 1 : 0)
    scale: atTop ? 1 : -1

    readonly property real showDistance: 0
    property Flickable flickable
    property color gradientColor
    /*! \c true if this indicator is at the top of the item */
    property bool atTop

    Behavior on opacity {
        NumberAnimation {
        }
    }

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: gradientColor
        }
        GradientStop {
            position: 1.0
            color: "transparent"
        }
    }
}
