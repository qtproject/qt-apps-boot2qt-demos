/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the E-Bike demo project.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.7

import "./BikeStyle"

Rectangle {
    id: musicPlayer
    width: UILayout.musicPlayerWidth
    height: UILayout.musicPlayerHeight + UILayout.musicPlayerCorner
    radius: UILayout.musicPlayerCorner
    color: Colors.musicPlayerBackground
    anchors {
        horizontalCenter: parent.horizontalCenter
        bottom: parent.bottom
        bottomMargin: -UILayout.musicPlayerCorner
    }
    state: "hidden"
    property bool isPlaying: false
    property var songList: [
        ["Post Malone - Rockstar", 218],
        ["Ed Sheeran - Perfect", 263],
        ["Imagine Dragons - Thunder", 187]
    ]
    property int currentSong: 0

    function setupSong() {
        var dur = songList[currentSong][1];
        timeAnimation.stop();
        songTimeText.songDuration = dur;
        timeAnimation.from = dur;
        timeAnimation.to = 0;
        timeAnimation.duration = dur * 1000;
        if (isPlaying)
            timeAnimation.start();
    }

    function previousSong() {
        if (currentSong === 0)
            currentSong = songList.length - 1;
        else
            currentSong -= 1;
        setupSong();
    }

    function nextSong() {
        if (currentSong >= (songList.length - 1))
            currentSong = 0;
        else
            currentSong += 1;
        setupSong();
    }

    Component.onCompleted: setupSong()

    Image {
        id: playIcon
        width: UILayout.musicPlayerIconWidth
        height: UILayout.musicPlayerIconHeight
        source: isPlaying
                ? (playIconArea.pressed ? "images/pause_pressed.png" : "images/pause.png")
                : (playIconArea.pressed ? "images/play_pressed.png" : "images/play.png")
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: UILayout.musicPlayerIconBottom + UILayout.musicPlayerCorner
        }

        MouseArea {
            id: playIconArea
            anchors {
                fill: parent
                margins: -UILayout.musicPlayerIconSpacing / 2
            }
            onClicked: {
                isPlaying = !isPlaying
                if (isPlaying) {
                    if (timeAnimation.running)
                        timeAnimation.resume()
                    else
                        timeAnimation.start()
                } else
                    timeAnimation.pause()
            }
        }
    }

    Image {
        id: previousIcon
        width: UILayout.musicPlayerIconWidth
        height: UILayout.musicPlayerIconHeight
        source: previousIconArea.pressed ? "images/prevsong_pressed.png" : "images/prevsong.png"
        anchors {
            right: playIcon.left
            rightMargin: UILayout.musicPlayerIconSpacing
            bottom: playIcon.bottom
        }

        MouseArea {
            id: previousIconArea
            anchors {
                fill: parent
                margins: -UILayout.musicPlayerIconSpacing / 2
            }
            onClicked: previousSong()
        }
    }

    Image {
        id: nextIcon
        width: UILayout.musicPlayerIconWidth
        height: UILayout.musicPlayerIconHeight
        source: nextIconArea.pressed ? "images/nextsong_pressed.png" : "images/nextsong.png"
        anchors {
            left: playIcon.right
            leftMargin: UILayout.musicPlayerIconSpacing
            bottom: playIcon.bottom
        }

        MouseArea {
            id: nextIconArea
            anchors {
                fill: parent
                margins: -UILayout.musicPlayerIconSpacing / 2
            }
            onClicked: nextSong()
        }
    }

    Text {
        id: songTitleText
        anchors {
            left: previousIcon.left
            right: nextIcon.right
            rightMargin: songTimeText.width + 5
            baseline: previousIcon.top
            baselineOffset: -UILayout.musicPlayerTextBottom
        }

        color: Colors.musicPlayerSongText
        font {
            family: "Montserrat, Regular"
            weight: Font.Normal
            pixelSize: UILayout.musicPlayerTextSize
        }
        text: songList[currentSong][0]
        elide: Text.ElideRight
    }

    // Function for pretty-printing duration
    function splitDuration(duration) {
        var minutes = Math.floor(duration / 60);
        var seconds = Math.floor(duration % 60);
        if (seconds < 10)
            seconds = "0" + seconds;
        return minutes + ":" + seconds;
    }

    Text {
        property int songDuration
        id: songTimeText
        anchors {
            right: nextIcon.right
            baseline: nextIcon.top
            baselineOffset: -UILayout.musicPlayerTextBottom
        }

        color: Colors.musicPlayerTimeText
        font {
            family: "Montserrat, Regular"
            weight: Font.Normal
            pixelSize: UILayout.musicPlayerTextSize
        }
        text: splitDuration(songDuration)

        NumberAnimation {
            id: timeAnimation
            target: songTimeText
            property: "songDuration"
            onStopped: {
                if (isPlaying)
                    nextSong();
            }
        }
    }

    states: State {
        name: "hidden"
        PropertyChanges {
            target: musicPlayer
            anchors.bottomMargin: -musicPlayer.height
        }
    }

    transitions: Transition {
        from: ""
        to: "hidden"
        reversible: true
        NumberAnimation {
            properties: "anchors.bottomMargin"
            duration: 250
            easing.type: Easing.InOutQuad
        }
    }
}
