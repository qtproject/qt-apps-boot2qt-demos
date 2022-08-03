/****************************************************************************
**
** Copyright (C) 2022 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick
import QtQuick.VirtualKeyboard

Image {
    id: root
    anchors.fill: parent
    source: "../assets/background.png"

    property int margin: viewSettings.margin(root.width)

    signal closed()

    ViewSettings {
        id: viewSettings
    }

    NetworkSettings {
        anchors.margins: margin
    }

    Image {
        id: backButton
        source: "../assets/icon_nok.png"
        anchors.top: parent.top
        anchors.right: parent.right
        scale: 0.5
        opacity: 0.5
        MouseArea {
            anchors.fill: parent
            anchors.margins: -width
            onPressed: backButton.scale = 0.4
            onReleased: backButton.scale = 0.5
            onClicked: loader.source = ""
        }
    }

    /*  Keyboard input panel.
        The keyboard is anchored to the bottom of the application.
    */
    InputPanel {
        id: inputPanel
        z: 99
        y: root.height
        anchors.left: root.left
        anchors.right: root.right

        states: State {
            name: "visible"
            when: Qt.inputMethod.visible
            PropertyChanges {
                target: inputPanel
                y: root.height - inputPanel.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}

