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

Rectangle {
    id: controlBar
    height: parent.height * 0.225
    color: defaultBackground

    property MediaPlayer mediaPlayer: null
    property bool isMouseAbove: false

    signal openFile()
    signal openCamera()
    signal openURL()
    signal openFX()
    signal toggleFullScreen()

    state: "VISIBLE"

    onMediaPlayerChanged: {
        if (mediaPlayer === null)
            return;
        volumeControl.volume = mediaPlayer.volume;
    }

    MouseArea {
        anchors.fill: controlBar
        hoverEnabled: true

        onEntered: controlBar.isMouseAbove = true;
        onExited: controlBar.isMouseAbove = false;
    }

    function statusString(stat)
    {
        if (stat === MediaPlayer.NoMedia)
            return "No Media";
        else if (stat === MediaPlayer.Loading)
            return "Loading";
        else if (stat === MediaPlayer.Loaded)
            return "Loaded";
        else if (stat === MediaPlayer.Buffering)
            return "Buffering";
        else if (stat === MediaPlayer.Stalled)
            return "Stalled";
        else if (stat === MediaPlayer.Buffered)
            return "Buffered";
        else if (stat === MediaPlayer.EndOfMedia)
            return "EndOfMedia";
        else if (stat === MediaPlayer.InvalidMedia)
            return "InvalidMedia";
        else if (stat === MediaPlayer.UnknownStatus)
            return "UnknownStatus";
    }

    //Playback Controls
    PlaybackControl {
        id: playbackControl
        anchors.left: controlBar.left
        anchors.top: controlBar.top
        anchors.bottom: controlBar.bottom

        onPlayButtonPressed: {
            if (isPlaying) {
                mediaPlayer.pause();
            } else {
                mediaPlayer.play();
            }
        }

        onReverseButtonPressed: {
            if (mediaPlayer.seekable) {
                //Subtract 10 seconds
                mediaPlayer.seek(normalizeSeek(Math.round(-mediaPlayer.duration * 0.1)));
            }
        }

        onForwardButtonPressed: {
            if (mediaPlayer.seekable) {
                //Add 10 seconds
                mediaPlayer.seek(normalizeSeek(Math.round(mediaPlayer.duration * 0.1)));
            }
        }

        onStopButtonPressed: mediaPlayer.stop();
    }

    //Seek controls
    SeekControl {
        id: seekControl
        anchors.bottom: controlBar.bottom
        anchors.bottomMargin: controlBar.height * 0.1
        anchors.right: volumeControl.left
        anchors.left: playbackControl.right
        anchors.rightMargin: 15
        anchors.leftMargin: 15
        enabled: playbackControl.isPlaybackEnabled

        duration: mediaPlayer.duration

        onSeekValueChanged: {
            mediaPlayer.seek(newPosition);
            position = mediaPlayer.position;
        }

        Component.onCompleted: {
            seekable = mediaPlayer.seekable;
        }
    }

    //Toolbar Controls
    Row {
        id: toolbarMenuButtons
        anchors.right: volumeControl.left
        anchors.rightMargin: 15
        anchors.bottom: seekControl.top
        spacing: 22

        ImageButton {
            id: fxButton
            imageSource: "images/FXButton.png"
            checkable: true
            checked: effectSelectionPanel.visible
            onClicked: {
                openFX();
            }
        }
        ImageButton {
            id: fileButton
            imageSource: "images/FileButton.png"
            onClicked: {
                openFile();
            }
        }
        ImageButton {
            id: urlButton
            imageSource: "images/UrlButton.png"
            onClicked: {
                openURL();
            }
        }
    }

    VolumeControl {
        id: volumeControl
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        onVolumeChanged: mediaPlayer.volume = volume

        Connections {
            target: mediaPlayer
            onVolumeChanged: volumeControl.volume = mediaPlayer.volume
        }
    }

    Connections {
        target: mediaPlayer
        onPositionChanged: {
            if (!seekControl.pressed) seekControl.position = mediaPlayer.position;
        }
        onStatusChanged: {
            if ((mediaPlayer.status == MediaPlayer.Loaded) || (mediaPlayer.status == MediaPlayer.Buffered) || mediaPlayer.status === MediaPlayer.Buffering || mediaPlayer.status === MediaPlayer.EndOfMedia)
                playbackControl.isPlaybackEnabled = true;
            else
                playbackControl.isPlaybackEnabled = false;
        }
        onPlaybackStateChanged: {
            if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                playbackControl.isPlaying = true;
                applicationWindow.resetTimer();
            } else {
                show();
                playbackControl.isPlaying = false;
            }
        }

        onSeekableChanged: {
            seekControl.seekable = mediaPlayer.seekable;
        }
    }

    function hide() {
        controlBar.state = "HIDDEN";
    }

    function show() {
        controlBar.state = "VISIBLE";
    }

    //Usage: give the value you wish to modify position,
    //returns a value between 0 and duration
    function normalizeSeek(value) {
        var newPosition = mediaPlayer.position + value;
        if (newPosition < 0)
            newPosition = 0;
        else if (newPosition > mediaPlayer.duration)
            newPosition = mediaPlayer.duration;
        return newPosition;
    }

    states: [
        State {
            name: "HIDDEN"
            PropertyChanges {
                target: controlBar
                opacity: 0.0
            }
        },
        State {
            name: "VISIBLE"
            PropertyChanges {
                target: controlBar
                opacity: 0.95
            }
        }
    ]

    transitions: [
        Transition {
            from: "HIDDEN"
            to: "VISIBLE"
            NumberAnimation {
                id: showAnimation
                target: controlBar
                properties: "opacity"
                from: 0.0
                to: 1.0
                duration: 200
            }
        },
        Transition {
            from: "VISIBLE"
            to: "HIDDEN"
            NumberAnimation {
                id: hideAnimation
                target: controlBar
                properties: "opacity"
                from: 0.95
                to: 0.0
                duration: 200
            }
        }
    ]
}
