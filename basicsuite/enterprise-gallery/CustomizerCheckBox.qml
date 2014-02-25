/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
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

CheckBox {
    id: checkBox
    anchors.horizontalCenter: parent.horizontalCenter
    width: root.width * 0.04
    height: width

    style: CheckBoxStyle {
        indicator: Rectangle {
            color: "#666"
            height: control.height
            width: height

            Rectangle {
                anchors.fill: parent
                anchors.margins: Math.round(checkBox.width * 0.1)
                color: "#111"
                visible: control.checked
            }
        }
    }
}
