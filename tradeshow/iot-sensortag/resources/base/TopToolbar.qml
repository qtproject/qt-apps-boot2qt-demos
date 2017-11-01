/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.0
import SensorTag.DataProvider 1.0
import Style 1.0

Item {
    id: topToolbar

    height: 100
    width: implicitWidth

    property alias topbar: topbar
    property alias date: dateLabel

    SensorSettings {
        id: sensorList

        x: sensorItem.x
        y: topToolbar.height
        width: Math.min(mainWindow.width, 800)
        height: mainWindow.height - topToolbar.height
        visible: true
    }

    Image {
        id: logWindow
        source: "images/bg_blue.jpg"
        x: sensorItem.x
        y: topToolbar.height
        width: Math.min(mainWindow.width, 600)
        height: Math.min(mainWindow.height - topToolbar.height, 400)
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        Text {
            clip: true
            color: "white"
            font.pixelSize: 26
            text: mainWindow.loggingOutput ? mainWindow.loggingOutput : "...debug..."
            anchors.fill: parent
            anchors.margins: 15
        }
    }


    Item {
        id: sensorItem
        height: topToolbar.height
        anchors.top: parent.top
        anchors.left: parent.left //cloudItem.right
        anchors.leftMargin:  8
        width: sensorIcon.width + sensorButton.width + 3 * anchors.leftMargin

        Image {
            id: sensorIcon

            width: 40
            height: 40
            anchors.top: parent.top
            anchors.margins: 8
            source: pathPrefix + "Toolbar/icon_topbar_sensor.png"

            Text {
                anchors.centerIn: parent
                text: sensorList.sensorCount
                color: "white"
                font.pixelSize: Style.topToolbarSmallFontSize
            }
        }

        Text {
            id: sensorButton

            color: "white"
            text: "SENSORS"
            font.pixelSize: Style.topToolbarSmallFontSize
            anchors.verticalCenter: sensorIcon.verticalCenter
            anchors.left: sensorIcon.right
            anchors.margins: 8
        }

        MouseArea {
            anchors.fill: parent
            onClicked: clickBait.activate(sensorList)
        }
    }

    Text {
        id: dateLabel
        property bool showAddress : false
        text: showAddress ? mainWindow.addresses : Qt.formatDateTime(new Date, "dddd, MMMM d, yyyy")
        color: "white"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        anchors.right: timeLabel.left
        anchors.rightMargin: 16
        horizontalAlignment: Text.AlignRight
        font.pixelSize: Style.topToolbarSmallFontSize
        font.capitalization: Font.AllUppercase
        visible: rotationMain.visible
        MouseArea {
            anchors.fill: parent
            onClicked: parent.showAddress = !parent.showAddress
        }
    }

    Text {
        id: timeLabel
        text: Qt.formatTime(new Date, "HH:mm")
        color: "white"
        font.pixelSize: Style.topToolbarLargeFontSize
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        MouseArea {
            anchors.fill: parent
            onClicked: clickBait.activate(logWindow)
        }
    }

    Timer {
        interval: 60000 // Update time once a minute
        running: true
        repeat: true
        onTriggered: timeLabel.text = Qt.formatTime(new Date, "HH:mm")
    }

    Text {
        id: utcGmt
        text: "UTC/GMT"
        color: "white"
        anchors.left: timeLabel.right
        anchors.leftMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        font.pixelSize: Style.topToolbarSmallFontSize
        Component.onCompleted: {
            var date = new Date
            var offsetString = -date.getTimezoneOffset() / 60
            if (offsetString < 0)
                text = text + "-"
            else
                text = text + "+"
            text = text + offsetString
        }
    }

    Image {
        id: topbar
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -18
        source: pathPrefix + "Toolbar/topbar_all.png"
    }

    MouseArea {
        id: clickBait

        property var menu

        function activate(menuItem) {
            menu = menuItem;
            menuItem.visible = true;
            menuItem.parent = clickBait;
        }

        function deactivate() {
            menu.parent = topToolbar;
            menu.visible = false;
            menu = null;
        }

        width: main.width
        height: main.height
        enabled: menu ? true : false
        onClicked: {
            if (!childAt(mouseX, mouseY))
                deactivate();
        }
    }

    Component.onCompleted: clickBait.activate(sensorList)
}
