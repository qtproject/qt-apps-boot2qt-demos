/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://qt.digia.com/
**
** This file is part of the examples of the Qt Enterprise Embedded.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
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
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
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

Rectangle {
    id: root
    color: "#111111"

//    Image {
//        anchors.fill: parent
//        source: "images/gradient.png"
//    }

    Image {
        id: logo
        anchors.centerIn: root
        anchors.verticalCenterOffset: -60
        source: "images/qt-logo.png"
        opacity: 0.5

    }
//    Rectangle {
//        id: button
//        opacity: mouse.containsMouse ? 1 : 0
//        Behavior on opacity {NumberAnimation{duration: 100}}
//        color: mouse.pressed ? "#11000000" : "#11ffffff"
//        anchors.top: logo.bottom
//        anchors.horizontalCenter: parent.horizontalCenter
//        border.color: "#33ffffff"
//        width: text.width + 40
//        height: text.height + 4
//        antialiasing: true
//        radius: 4
//        MouseArea {
//            id: mouse
//            anchors.fill: parent
//            hoverEnabled: true
//            onClicked: applicationWindow.openVideo()
//        }
//    }

//    Text {
//        id: text
//        color: "#44ffffff"
//        text: "Open File"
//        font.bold: true
//        font.pixelSize: 18
//        anchors.centerIn: button
//    }
}
