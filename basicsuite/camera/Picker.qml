/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://www.qt.io
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

MouseArea {
    id: pickerRoot

    parent: root
    anchors.fill: parent

    onClicked: visible = false
    visible: false

    property alias contentWidth: back.width
    property real contentHeight: 350 * root.contentScale
    property alias model: list.model
    property variant value: null
    property string name: ""
    property alias currentIndex: list.currentIndex
    property alias count: list.count

    onValueChanged: {
        for (var i = 0; i < list.count; ++i) {
            var data = list.model[i];
            if (data === undefined)
                data = list.model.get(i);
            if (data.value === pickerRoot.value) {
                list.currentIndex = i;
                return;
            }
        }
        list.currentIndex = -1;
    }

    Rectangle {
        id: back
        color: "#77333333"
        width: 200 * root.contentScale
        height: Math.min(pickerRoot.contentHeight, list.contentHeight + list.anchors.margins * 2)
        anchors.centerIn: parent
        property int itemHeight: 25 * root.contentScale
        rotation: root.contentRotation
        Behavior on rotation { NumberAnimation { } }

        ListView {
            id: list
            anchors.fill: parent
            clip: true
            anchors.margins: 14 * root.contentScale

            currentIndex: -1

            onCurrentIndexChanged: {
                if (list.currentIndex >= 0) {
                    var data = list.model[list.currentIndex];
                    if (data === undefined)
                        data = list.model.get(list.currentIndex);
                    pickerRoot.value = data.value;
                    pickerRoot.name = data.name;
                } else {
                    pickerRoot.value = null
                    pickerRoot.name = ""
                }
            }

            delegate: Item {
                height: 40 * root.contentScale
                width: parent.width
                Rectangle {
                    anchors.fill: parent
                    border.color: index == list.currentIndex ? "#44ffffff" : "transparent"
                    color: index == list.currentIndex ? "#22ffffff" : "transparent"
                    radius: 3 * root.contentScale
                    Text {
                        color: "white"
                        text: (typeof modelData === 'undefined' ? name : modelData.name)
                        anchors.centerIn: parent
                        font.pixelSize: Math.round(20 * root.contentScale)
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked:  {
                            list.currentIndex = index;
                        }
                    }
                }
            }
        }
    }
}

