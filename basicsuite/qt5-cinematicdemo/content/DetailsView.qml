/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
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

Item {
    id: root

    property bool isShown: false
    property string image
    property string name
    property string year
    property string director
    property string cast
    property string overview
    property alias rating: ratingsItem.rating

    anchors.fill: parent
    opacity: 0
    visible: opacity
    scale: 0.3

    function show() {
        mainView.scheduleUpdate();
        root.isShown = true;
        showAnimation.restart();
    }
    function hide() {
        hideAnimation.restart();
    }

    Binding {
        target: mainView
        property: "blurAmount"
        value: 40 * root.opacity
        when: root.isShown
    }

    ParallelAnimation {
        id: showAnimation
        NumberAnimation { target: root; property: "opacity"; to: 1.0; duration: 500; easing.type: Easing.InOutQuad }
        NumberAnimation { target: root; property: "scale"; to: 1.0; duration: 500; easing.type: Easing.InOutQuad }
    }
    SequentialAnimation {
        id: hideAnimation
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
            NumberAnimation { target: root; property: "scale"; to: 0.3; duration: 500; easing.type: Easing.InOutQuad }
        }
        PropertyAction { target: root; property: "isShown"; value: false }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.hide();
        }
    }

    Rectangle {
        id: backgroundItem
        anchors.centerIn: parent
        width: Math.min(620, parent.width - 32)
        height: Math.min(840, parent.height - 32)
        border.color: "#808080"
        border.width: 1
        opacity: 0.9
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#101010" }
            GradientStop { position: 0.3; color: "#404040" }
            GradientStop { position: 1.0; color: "#090909" }
        }
    }

    Flickable {
        anchors.top: backgroundItem.top
        anchors.left: backgroundItem.left
        anchors.right: backgroundItem.right
        anchors.bottom: bottomSeparator.top
        anchors.margins: 1
        anchors.bottomMargin: 0

        contentWidth: backgroundItem.width
        contentHeight: ratingsItem.y + descriptionTextItem.height + 64
        flickableDirection: Flickable.VerticalFlick
        clip: true

        Image {
            id: movieImageItem
            x: 8
            y: 24
            width: 192
            height: 192
            source: root.image ? "images/" + root.image : ""
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        Column {
            id: topColumn
            y: 20
            anchors.left: movieImageItem.right
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 26
            spacing: 8
            Text {
                id: titleTextItem
                width: parent.width
                wrapMode: Text.WordWrap
                color: "#ffffff"
                font.pixelSize: text.length < 12 ? settings.fontL  : settings.fontMM
                text: root.name
            }
            Text {
                id: yearTextItem
                width: parent.width
                wrapMode: Text.WordWrap
                color: "#ffffff"
                font.pixelSize: settings.fontS
                text: "<b>Published:</b> " + root.year
            }
            Text {
                id: directorsTextItem
                width: parent.width
                wrapMode: Text.WordWrap
                color: "#ffffff"
                font.pixelSize: settings.fontS
                text: "<b>Director:</b> " + root.director
            }
            Text {
                id: castTextItem
                width: parent.width
                wrapMode: Text.WordWrap
                color: "#ffffff"
                font.pixelSize: settings.fontS
                text: "<b>Cast:</b> " + root.cast
            }
        }

        RatingsItem {
            id: ratingsItem
            x: 10
            y: Math.max(topColumn.height, movieImageItem.height) + 40
            rating: root.rating
        }

        Text {
            id: descriptionTextItem
            anchors.top: ratingsItem.bottom
            anchors.topMargin: 16
            width: parent.width - 32
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WordWrap
            color: "#ffffff"
            font.pixelSize: settings.fontM
            text: "<b>Description:</b> " + root.overview
        }
    }

    Rectangle {
        id: bottomSeparator
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: backgroundItem.bottom
        anchors.bottomMargin: 80
        width: backgroundItem.width - 16
        height: 1
        color: "#808080"
    }

    Button {
        anchors.bottom: backgroundItem.bottom
        anchors.bottomMargin: 8
        anchors.left: backgroundItem.left
        anchors.leftMargin: 32
        text: "Back"
        effectsOn: false
        onClicked: {
            root.hide();
        }
    }
    Button {
        anchors.bottom: backgroundItem.bottom
        anchors.bottomMargin: 8
        anchors.right: backgroundItem.right
        anchors.rightMargin: 32
        effectsOn: root.visible
        text: "Order"
        onClicked: {
            console.debug("Order! TODO: implement");
        }
    }
}
