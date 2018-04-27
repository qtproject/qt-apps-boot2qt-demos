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

Item {
    property alias musicPlayerSwitch: musicPlayerSwitch

    signal resetDemo

    Column {
        anchors.left: parent.left
        anchors.right: parent.right

        Text {
            height: UILayout.configurationItemHeight
            width: parent.width
            text: qsTr("VIEW")
            font {
                family: "Montserrat, Medium"
                weight: Font.Medium
                pixelSize: UILayout.configurationTitleSize
            }
            color: Colors.tabTitleColor
            verticalAlignment: Text.AlignVCenter
        }

        ColumnSpacer {
            color: Colors.tabItemBorder
        }

        ConfigurationItem {
            description: qsTr("Show FPS")

            ToggleSwitch {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }
                checked: fps.visible
                onCheckedChanged: fps.visible = checked
            }
        }

        ColumnSpacer {
            color: Colors.tabItemBorder
        }

        ConfigurationItem {
            description: qsTr("Audio controls")

            ToggleSwitch {
                id: musicPlayerSwitch
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }
                checked: false
                onCheckedChanged: musicPlayer.state = (checked ? "" : "hidden")
            }
        }

        ColumnSpacer {
            color: Colors.tabItemBorder
        }

        ConfigurationItem {
            description: qsTr("Reset demo")

            RoundButton {
                id: resetButton
                width: UILayout.unitButtonWidthMargin * 2 + mphText.implicitWidth
                height: UILayout.unitButtonHeight
                radius: height / 2
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                }

                background: Rectangle {
                    anchors.fill: parent
                    color: parent.down ? Colors.statsButtonPressed : "transparent"
                    radius: parent.radius
                    border.color: Colors.statsButtonActive
                    border.width: parent.down ? 0 : 1
                }

                contentItem: Text {
                    id: mphText
                    text: "RESET DEMO"
                    font {
                        family: "Montserrat, Medium"
                        weight: Font.Medium
                        pixelSize: UILayout.unitFontSize
                    }
                    color: Colors.statsButtonActiveText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: resetDemo()
            }
        }

        ColumnSpacer {
            color: Colors.tabItemBorder
        }
    }
}
