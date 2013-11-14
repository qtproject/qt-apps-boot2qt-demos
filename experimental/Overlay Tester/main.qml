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

Item {
    id: root

    property bool showImage: false;
    property bool showOpacity: false;

    width: 100
    height: 62

    Repeater {
        id: repeater

        model: 4

        Item {
            anchors.fill: parent

            Rectangle {
                width: root.width
                height: root.height
                color: "green"
                visible: root.showImage == false;
                opacity: root.showOpacity ? 0.1 : 1;
            }

            Image {
                width: root.width
                height: root.height
                source: "image.jpg"
                visible: root.showImage == true;
                opacity: root.showOpacity ? 0.1 : 1;
            }
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: 100
        height: 100
        color: "black"
        border.color: "red"
        border.width: 2
        antialiasing: true

        NumberAnimation on rotation { from: 0; to: 360; duration: 5000; loops: Animation.Infinite }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {

            if (mouseX < 100)
                root.showImage = !root.showImage
            else if (mouseX > root.width - 100)
                root.showOpacity = !root.showOpacity
            else if (mouseY > root.height / 2)
                repeater.model++
            else
                repeater.model--;
        }
    }

    Text {
        text: repeater.model
        anchors.centerIn: parent
        color: "white"
    }

    Text {
        color: "steelblue"
        style: Text.Outline
        styleColor: "lightsteelblue"
        text: "Add Layer"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        font.pixelSize: 24
    }

    Text {
        color: "steelblue"
        style: Text.Outline
        styleColor: "lightsteelblue"

        text: "Remove Layer"

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 40
        font.pixelSize: 24
    }


    Text {
        color: "steelblue"
        style: Text.Outline
        styleColor: "lightsteelblue"
        text: root.showOpacity ? "Translucent" : "Opaque"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        font.pixelSize: 24
    }


    Text {
        color: "steelblue"
        style: Text.Outline
        styleColor: "lightsteelblue"
        text: root.showImage ? "Images" : "Rectangles"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
        font.pixelSize: 24
    }


}
