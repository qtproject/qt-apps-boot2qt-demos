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
import QtQuick.Layouts 1.3
import "./BikeStyle"

Drawer {
    property alias bikeInfoTab: bikeInfoTab
    property alias generalTab: generalTab
    property alias viewTab: viewTab

    background: Rectangle {
        color: Colors.curtainBackground
        width: parent.width
        height: parent.height
    }

    TabBar {
        id: bar
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: UILayout.curtainMargin
            rightMargin: UILayout.curtainMargin
        }
        height: UILayout.tabBarTabHeight
        background: Rectangle {
            color: Colors.curtainBackground
        }

        IconifiedTabButton {
            id: bikeInfoTabButton
            height: parent.height
            bar: bar
            deselectedIcon: "images/info.png"
            selectedIcon: "images/info_selected.png"
        }

        IconifiedTabButton {
            id: configurationTabButton
            height: parent.height
            bar: bar
            deselectedIcon: "images/settings.png"
            selectedIcon: "images/settings_selected.png"
        }

        IconifiedTabButton {
            id: viewTabButton
            height: parent.height
            bar: bar
            deselectedIcon: "images/list.png"
            selectedIcon: "images/list_selected.png"
        }
    }

    StackLayout {
        id: stackLayout
        anchors {
            left: parent.left
            right: parent.right
            top: bar.bottom
            leftMargin: UILayout.curtainMargin
            rightMargin: UILayout.curtainMargin
        }
        height: 290
        currentIndex: bar.currentIndex

        BikeInfoTab {
            id: bikeInfoTab
        }

        GeneralTab {
            id: generalTab
        }

        ViewTab {
            id: viewTab

            onResetDemo: {
                // Reset trip data
                datastore.resetDemo()
                // Reset navigation
                naviPage.resetDemo()
            }
        }
    }

    Rectangle {
        id: drawerClose
        anchors {
            top: stackLayout.bottom
            left: parent.left
            right: parent.right
        }

        width: parent.width
        height: drawerCloseImage.implicitHeight
        color: "transparent"

        Image {
            id: drawerCloseImage
            source: "images/curtain_shadow_handle.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
        }

        MouseArea {
            anchors.fill: parent
            onClicked: drawer.close()
        }
    }
}
