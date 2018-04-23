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
import QtDeviceUtilities.QtButtonImageProvider 1.0
import "settings.js" as Settings

FocusScope {
    id: applicationWindow
    focus: true

    property real buttonHeight: height * 0.05

    MouseArea {
        id: mouseActivityMonitor
        anchors.fill: parent

        hoverEnabled: true
        onClicked: {
            if (controlBar.state === "VISIBLE" && content.videoPlayer.mediaPlayer.status === MediaPlayer.Loaded) {
                controlBar.hide();
            } else {
                controlBar.show();
                controlBarTimer.restart();
            }
        }
    }

    signal resetTimer
    onResetTimer: {
        controlBar.show();
        controlBarTimer.restart();
    }

    Component.onCompleted: {
        init();
        forceActiveFocus();
    }

    Content {
        id: content
        anchors.fill: parent
    }

    Timer {
        id: controlBarTimer
        interval: 4000
        running: false

        onTriggered: {
            hideToolBars();
        }
    }

    ControlBar {
        id: controlBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: applicationWindow.bottom
        mediaPlayer: content.videoPlayer.mediaPlayer

        onOpenFile: {
            applicationWindow.openVideo();
        }

        onOpenURL: {
            applicationWindow.openURL();
        }

        onOpenFX: {
            applicationWindow.openFX();
        }
    }

    ParameterPanel {
        id: parameterPanel
        opacity: controlBar.opacity * 0.9
        visible: effectSelectionPanel.visible && model.count !== 0
        height: 116
        width: 500
        anchors {
            bottomMargin: 15
            bottom: controlBar.top
            right: effectSelectionPanel.left
            rightMargin: 15
        }
    }

    EffectSelectionPanel {
        id: effectSelectionPanel
        visible: false
        opacity: controlBar.opacity * 0.9
        anchors {
            bottom: controlBar.top
            right: controlBar.right
            bottomMargin: 15
        }
        width: 250
        height: 350
        itemHeight: 80
        onEffectSourceChanged: {
            content.effectSource = effectSource
            parameterPanel.model = content.effect.parameters
        }
    }

    UrlBar {
        id: urlBar
        opacity: 0
        visible: opacity != 0
        anchors.fill: parent
        onUrlAccepted: {
            urlBar.opacity = 0;
            if (text != "")
                content.openVideo(text)
        }
    }

    ImageButton{
        id: infoButton
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 32
        anchors.topMargin: 32
        width: 40
        height: 40
        imageSource: "images/info_icon.svg"
        onClicked: metadataView.opacity = 1
        visible: content.videoPlayer.mediaPlayer.status !== MediaPlayer.NoMedia && content.videoPlayer.mediaPlayer.status !== MediaPlayer.InvalidMedia
    }

    MetadataView {
        id: metadataView
        mediaPlayer: content.videoPlayer.mediaPlayer
    }

    property real volumeBeforeMuted: 1.0
    property bool isFullScreen: false

    FileBrowser {
        id: fileBrowser
        anchors.fill: parent
        onFileSelected: {
            if (file != "")
                content.openVideo(file);
        }
    }

    Keys.onPressed: {
        applicationWindow.resetTimer();
        if (event.key === Qt.Key_O && event.modifiers & Qt.ControlModifier) {
            openVideo();
            return;
        } else if (event.key === Qt.Key_N && event.modifiers & Qt.ControlModifier) {
            openURL();
            return;
        } else if (event.key === Qt.Key_E && event.modifiers & Qt.ControlModifier) {
            openFX();
            return;
        } else if (event.key === Qt.Key_F && event.modifiers & Qt.ControlModifier) {
            return;
        } else if (event.key === Qt.Key_Up || event.key === Qt.Key_VolumeUp) {
            content.videoPlayer.mediaPlayer.volume = Math.min(1, content.videoPlayer.mediaPlayer.volume + 0.1);
            return;
        } else if (event.key === Qt.Key_Down || event.key === Qt.Key_VolumeDown) {
            if (event.modifiers & Qt.ControlModifier) {
                if (content.videoPlayer.mediaPlayer.volume) {
                    volumeBeforeMuted = content.videoPlayer.mediaPlayer.volume;
                    content.videoPlayer.mediaPlayer.volume = 0
                } else {
                    content.videoPlayer.mediaPlayer.volume = volumeBeforeMuted;
                }
            } else {
                content.videoPlayer.mediaPlayer.volume = Math.max(0, content.videoPlayer.mediaPlayer.volume - 0.1);
            }
            return;
        } else if (applicationWindow.isFullScreen && event.key === Qt.Key_Escape) {
            return;
        }

        // What's next should be handled only if there's a loaded media
        if (content.videoPlayer.mediaPlayer.status !== MediaPlayer.Loaded
                && content.videoPlayer.mediaPlayer.status !== MediaPlayer.Buffered)
            return;

        if (event.key === Qt.Key_Space) {
            if (content.videoPlayer.mediaPlayer.playbackState === MediaPlayer.PlayingState)
                content.videoPlayer.mediaPlayer.pause()
            else if (content.videoPlayer.mediaPlayer.playbackState === MediaPlayer.PausedState
                     || content.videoPlayer.mediaPlayer.playbackState === MediaPlayer.StoppedState)
                content.videoPlayer.mediaPlayer.play()
        } else if (event.key === Qt.Key_Left) {
            content.videoPlayer.mediaPlayer.seek(Math.max(0, content.videoPlayer.mediaPlayer.position - 30000));
            return;
        } else if (event.key === Qt.Key_Right) {
            content.videoPlayer.mediaPlayer.seek(Math.min(content.videoPlayer.mediaPlayer.duration, content.videoPlayer.mediaPlayer.position + 30000));
            return;
        }
    }

    function init() {
        content.init()
        content.openVideo("file:///data/videos/Qt_video_720p.webm");
    }

    function openVideo() {
        fileBrowser.show()
    }

    function openCamera() {
        content.openCamera()
    }

    function openURL() {
        urlBar.opacity = urlBar.opacity === 0 ? 1 : 0
    }

    function openFX() {
        effectSelectionPanel.visible = !effectSelectionPanel.visible;
    }

    function close() {
    }

    function hideToolBars() {
        if (!controlBar.isMouseAbove && !parameterPanel.isMouseAbove && !effectSelectionPanel.isMouseAbove && content.videoPlayer.isPlaying)
            controlBar.hide();
    }
}
