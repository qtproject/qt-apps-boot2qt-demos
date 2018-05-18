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
import QtMultimedia 5.0
import "settings.js" as Settings

Rectangle {
    id: root

    property variant mediaPlayer: null

    anchors.fill: parent
    color: "#AA000000"
    Behavior on opacity { NumberAnimation { } }
    opacity: 0

    Rectangle {
        height: column.height + 30
        width: 500
        color: Settings.backgroundColor
        opacity: 0.9
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -50
        border.color: Settings.primaryGrey
        border.width: 2

        Column {
            id: column
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 15
            spacing: 12

            Text {
                text: "Media Type: " + (mediaPlayer ? mediaPlayer.metaData.mediaType : "")
                visible: mediaPlayer && mediaPlayer.metaData.mediaType !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Title: " + (mediaPlayer ? mediaPlayer.metaData.title : "")
                visible: mediaPlayer && mediaPlayer.metaData.title !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Artist: " + (mediaPlayer ? mediaPlayer.metaData.leadPerformer : "")
                visible: mediaPlayer && mediaPlayer.metaData.leadPerformer !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Artist: " + (mediaPlayer ? mediaPlayer.metaData.contributingArtist : "")
                visible: mediaPlayer && mediaPlayer.metaData.contributingArtist !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Album: " + (mediaPlayer ? mediaPlayer.metaData.albumTitle : "")
                visible: mediaPlayer && mediaPlayer.metaData.albumTitle !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Album Artist: " + (mediaPlayer ? mediaPlayer.metaData.albumArtist : "")
                visible: mediaPlayer && mediaPlayer.metaData.albumArtist !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Author: " + (mediaPlayer ? mediaPlayer.metaData.author : "")
                visible: mediaPlayer && mediaPlayer.metaData.author !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Composer: " + (mediaPlayer ? mediaPlayer.metaData.composer : "")
                visible: mediaPlayer && mediaPlayer.metaData.composer !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Writer: " + (mediaPlayer ? mediaPlayer.metaData.writer : "")
                visible: mediaPlayer && mediaPlayer.metaData.writer !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Genre: " + (mediaPlayer ? mediaPlayer.metaData.genre : "")
                visible: mediaPlayer && mediaPlayer.metaData.genre !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Track Number: " + (mediaPlayer ? mediaPlayer.metaData.trackNumber : "")
                visible: mediaPlayer && mediaPlayer.metaData.trackNumber !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Year: " + (mediaPlayer ? mediaPlayer.metaData.year : "")
                visible: mediaPlayer && mediaPlayer.metaData.year !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Duration: " + (mediaPlayer ? Qt.formatTime(new Date(mediaPlayer.metaData.duration), mediaPlayer.metaData.duration >= 3600000 ? "H:mm:ss" : "m:ss") : "")
                visible: mediaPlayer && mediaPlayer.metaData.duration !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Resolution: " + (mediaPlayer && mediaPlayer.metaData.resolution !== undefined ? (mediaPlayer.metaData.resolution.width + "x" + mediaPlayer.metaData.resolution.height) : "")
                visible: mediaPlayer && mediaPlayer.metaData.resolution !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Audio Bitrate: " + (mediaPlayer ? Math.round(mediaPlayer.metaData.audioBitRate / 1000) + " kbps"  : "")
                visible: mediaPlayer && mediaPlayer.metaData.audioBitRate !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Video Bitrate: " + (mediaPlayer ? Math.round(mediaPlayer.metaData.videoBitRate / 1000) + " kbps" : "")
                visible: mediaPlayer && mediaPlayer.metaData.videoBitRate !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Text {
                text: "Date: " + (mediaPlayer ? Qt.formatDate(mediaPlayer.metaData.date) : "")
                visible: mediaPlayer && mediaPlayer.metaData.date !== undefined
                color: "white"
                font.pixelSize: 24
                font.family: appFont
                width: parent.width
                wrapMode: Text.WordWrap
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.opacity = 0
        enabled: root.opacity !== 0
    }
}
