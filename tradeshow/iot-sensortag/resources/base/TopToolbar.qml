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

    CloudSettings {
        id: cloudSettings

        x: cloudItem.x
        y: topToolbar.height
        visible: false
    }

    SensorSettings {
        id: sensorList

        x: sensorItem.x
        y: topToolbar.height
        visible: false
    }

    Item {
        id: cloudItem

        height: topToolbar.height
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 8
        width: icon.width + cloudText.width + 3 * anchors.leftMargin
        opacity: dataProviderPool.name === "Cloud" || dataProviderPool.name === "Demo" ? 1.0 : 0.0

        Image {
            id: icon
            width: 58
            height: 40
            anchors.top: parent.top
            anchors.margins: 8
            source: pathPrefix + "Toolbar/icon_topbar_cloud.png"
        }

        Text {
            id: cloudText
            color: "white"
            text: "CLOUD"
            width: contentWidth
            font.pixelSize: Style.topToolbarSmallFontSize
            anchors.verticalCenter: icon.verticalCenter
            anchors.left: icon.right
            anchors.margins: 8
        }

        MouseArea {
            anchors.fill: parent
            onClicked: clickBait.activate(cloudSettings)
        }
    }

    Item {
        id: sensorItem
        height: topToolbar.height
        anchors.top: parent.top
        anchors.left: cloudItem.right
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
                text: sensorList.listModelCount
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
    }

    Timer {
        interval: 60000 // Update time once a minute
        running: true
        repeat: true
        onTriggered: timeLabel.text = Qt.formatTime(new Date, "HH:mm")
    }

    Text {
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
}
