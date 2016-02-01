/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of Qt for Device Creation.
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

import QtQuick 2.6

Rectangle {
    id: theButton

    //radius: 10
    color: "magenta"
    property color grooveColor: "cyan"
    property color textColor: "#777"
    property alias icon: iconImage
    property double iconSize: 32

    property alias text: buttonText.text
    signal triggered()

    property int percent : 0
    state: "UNPRESSED"

    states: [
        State {
            name: "UNPRESSED"
        },
        State {
            name: "PRESSED"
        },
        State {
            name: "TRIGGERED"
        }

    ]

    transitions: [ Transition {
        from: "UNPRESSED"
        to: "PRESSED"
            NumberAnimation {
                target: theButton
                property: "percent"
                to: 100
                duration: 1500
            }
    },
        Transition {
                from: "PRESSED"
                to: "UNPRESSED"
                    NumberAnimation {
                        target: theButton
                        property: "percent"
                        to: 0
                        duration: 100
                    }
                }
    ]
    Rectangle {
        id: timeIndicator
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 10
        color: grooveColor
        Rectangle {
            color: "#e41e25"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * percent / 100
            visible: percent > 0
        }
    }

    Item {
        anchors.top: timeIndicator.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        Item {
            id: iconRect
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 5
            width: iconSize
            height: iconSize
            Image {
                anchors.centerIn: parent
                id: iconImage
            }
        }


        Text {
            id: buttonText
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: iconRect.right
            anchors.right: parent.right
            anchors.leftMargin: 10

            color: textColor
            text: "[Uninitialized]"
            font.bold: true
        }

    }


    MouseArea {
        id: mouser
        anchors.fill: parent

        Timer {
            id: timer
            interval: 1000
        }

        onPressed: parent.state = "PRESSED"

        onReleased: {
            if (containsMouse && parent.percent >= 100) {
                parent.triggered()
                parent.state = "TRIGGERED"
            } else {
                parent.state = "UNPRESSED"
            }
        }

        onPositionChanged: {
            parent.state = containsMouse ? "PRESSED" : "UNPRESSED"
        }
    }
}
