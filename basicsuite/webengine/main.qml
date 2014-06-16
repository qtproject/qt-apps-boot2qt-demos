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
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtWebEngine 0.9

import "ui"

Rectangle {
    id: root
    z: 0
    visible: true
    color: "black"

    width: 1280
    height: 800

    property url defaultUrl: Qt.resolvedUrl("content/index.html")
    function load(url) { mainWebView.url = url }

    WebEngineView {
        id: mainWebView
        anchors.fill: parent
        url: defaultUrl
        onLoadingChanged: {
            if (!loading) {
                addressBar.cursorPosition = 0
                toolBar.state = "address"
            }
        }
    }

    MultiPointTouchArea {
        z: showToolBarButton.z
        width: parent.width
        height: showToolBarButton.height + 15
        enabled: toolBar.state == "hidden"

        anchors.top: parent.top
        onGestureStarted: {
            showToolBarButton.clicked()
        }
        onReleased: {
            showToolBarButton.clicked()
        }
    }

    Rectangle {
        z: 1
        id: toolBar
        color: "black"
        opacity: 1

        height: addressBar.height + showToolBarButton.height + 50
        y: 0

        Behavior on y {
            enabled: toolBar.state != ""
            NumberAnimation { duration: 250 }
        }

        Behavior on opacity {
            enabled: toolBar.state != ""
            NumberAnimation { duration: 250 }
        }

        anchors {
            left: parent.left
            right: parent.right
        }

        Timer {
            id: hideTimer
            interval: 3000
            running: (toolBar.state == "address" || toolBar.state == "") && !addressBar.activeFocus
            onTriggered: {
                if (toolBar.state == "address")
                    toolBar.state = "hidden"
                if (toolBar.state == "")
                    toolBar.state = "address"
            }
        }

        state: ""

        states: [
            State {
                name: "hidden"
                PropertyChanges { target: toolBar; y: showToolBarButton.height - toolBar.height }
                PropertyChanges { target: toolBar; opacity: 0.5 }
            },
            State {
                name: "address"
                PropertyChanges { target: toolBar; y: 0 }
                PropertyChanges { target: toolBar; opacity: 1 }
            }
        ]

        RowLayout {
            id: addressRow
            height: 65
            anchors {
                top: parent.top
                bottom: showToolBarButton.top
                left: parent.left
                right: parent.right
                margins: 10
                topMargin: 40
            }
            ToolButton {
                id: backButton
                Layout.fillHeight: true
                iconSource: "ui/icons/go-previous.png"
                onClicked: mainWebView.goBack()
                enabled: mainWebView.canGoBack
            }
            ToolButton {
                id: forwardButton
                Layout.fillHeight: true
                iconSource: "ui/icons/go-next.png"
                onClicked: mainWebView.goForward()
                enabled: mainWebView.canGoForward
            }
            ToolButton {
                id: reloadButton
                Layout.fillHeight: true
                iconSource: mainWebView.loading ? "ui/icons/process-stop.png" : "ui/icons/view-refresh.png"
                onClicked: mainWebView.loading ? mainWebView.stop() : mainWebView.reload()
            }
            ToolButton {
                id: homeButton
                width: 20
                Layout.fillHeight: true
                iconSource: "ui/icons/home.png"
                onClicked: {
                    load(defaultUrl)
                }
            }
            TextField {
                id: addressBar
                focus: true
                textColor: "black"
                implicitHeight: 40
                font.pointSize: 10
                inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhNoPredictiveText
                Image {
                    anchors {
                        right: parent.right
                        verticalCenter: addressBar.verticalCenter
                        rightMargin: 5
                    }
                    verticalAlignment: Image.AlignLeft
                    z: 2
                    id: faviconImage
                    width: 20; height: 20
                    source: mainWebView.icon
                }
                Layout.fillWidth: true
                text: mainWebView.url
                onAccepted: {
                    mainWebView.url = engine.fromUserInput(text)
                }
            }
        }

        ToolButton {
            id: showToolBarButton
            height: 25
            iconSource: (toolBar.state == "hidden") ? "ui/icons/down.png" : "ui/icons/up.png"
            onClicked: {
                if (toolBar.state == "hidden")
                    toolBar.state = "address"
                else
                    toolBar.state = "hidden"
            }
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: (toolBar.state == "hidden") ? 0 : 5
            }
        }
    }
    ProgressBar {
        id: progressBar
        height: 5
        z: toolBar.z + 1
        visible: value != 0
        anchors {
            top: toolBar.bottom
            left: parent.left
            right: parent.right
        }
        minimumValue: 0
        maximumValue: 100
        value: (mainWebView.loadProgress < 100) ? mainWebView.loadProgress : 0
    }
}
