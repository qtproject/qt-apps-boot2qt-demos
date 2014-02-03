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

BlackButtonBackground {
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: root.height * 0.125

    signal customizeClicked

    gradient: Gradient {
        GradientStop {
            color: "#333"
            position: 0
        }
        GradientStop {
            color: "#222"
            position: 1
        }
    }

    Button {
        id: back
        width: parent.height
        height: parent.height
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        onClicked: stackView.pop()

        style: BlackButtonStyle {
        }

        Image {
            source: "images/icon-go.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            scale: -1
        }
    }

    Button {
        id: customize
        width: parent.height
        height: parent.height
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: customizer

        style: BlackButtonStyle {
        }

        onClicked: customizeClicked()

        Image {
            source: "images/icon-settings.png"
            anchors.centerIn: parent
            scale: -1
        }
    }
}
