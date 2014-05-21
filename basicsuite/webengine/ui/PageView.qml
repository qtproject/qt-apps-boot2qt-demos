/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
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

import QtQuick 2.1
import QtQuick.Layouts 1.1

Rectangle {
    id: root
    color: "#AAAAAA"
    visible: true

    property real fontPointSize: 13

    function show() {
        enabled = true
        opacity = 1
    }
    function hide() {
        enabled = false
        opacity = 0
    }
    anchors {
        fill: parent
    }
    ColumnLayout {
        id: links
        anchors {
            bottom: parent.bottom
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            margins: 50
        }
        Text {
            text: "http://www.google.com"
            font.pointSize: fontPointSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    load(Qt.resolvedUrl(parent.text))
                    hide()
                }
            }
        }
        Text {
            text: "http://qt.digia.com"
            font.pointSize: fontPointSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    load(Qt.resolvedUrl(parent.text))
                    hide()
                }
            }
        }
        Text {
            text: "http://qt-project.org/doc/qt-5"
            font.pointSize: fontPointSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    load(Qt.resolvedUrl(parent.text))
                    hide()
                }
            }
        }
    RowLayout {
        id: localContent
        anchors {
            margins: 50
        }
        Image {
            sourceSize.width: 300
            sourceSize.height: 175
            source: "../content/webgl/screenshot.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    load(Qt.resolvedUrl("../content/webgl/helloqt.html"))
                    hide()
                }
            }
        }
        Image {
            sourceSize.width: 300
            sourceSize.height: 175
            source: "../content/csstetrahedron/screenshot.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    load(Qt.resolvedUrl("../content/csstetrahedron/index.html"))
                    hide()
                }
            }
        }
    } // RowLayout
    } // ColumnLayout
}
