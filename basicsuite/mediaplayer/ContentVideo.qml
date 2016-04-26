/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Mobility Components.
**
** $QT_BEGIN_LICENSE:LGPL21$
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
** General Public License version 2.1 or version 3 as published by the Free
** Software Foundation and appearing in the file LICENSE.LGPLv21 and
** LICENSE.LGPLv3 included in the packaging of this file. Please review the
** following information to ensure the GNU Lesser General Public License
** requirements will be met: https://www.gnu.org/licenses/lgpl.html and
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** As a special exception, The Qt Company gives you certain additional
** rights. These rights are described in The Qt Company LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtMultimedia 5.0

VideoOutput {
    id: videoOutput
    source: mediaPlayer
    fillMode: VideoOutput.PreserveAspectFit
    property alias mediaSource: mediaPlayer.source
    property alias mediaPlayer: mediaPlayer
    property bool isPlaying: false

    MediaPlayer {
        id: mediaPlayer
        autoLoad: true
        autoPlay: true

        onPlaybackRateChanged: {
            //console.debug("playbackRate: " + playbackRate);
        }

        onPlaybackStateChanged: {
            //console.debug("playbackState = " + mediaPlayer.playbackState);
            if (playbackState === MediaPlayer.PlayingState)
                videoOutput.isPlaying = true;
            else
                videoOutput.isPlaying = false;
        }

        onAvailabilityChanged: {
            //console.debug("availability = " + mediaPlayer.availability);
        }

        onErrorChanged: {
            //console.debug("error = " + mediaPlayer.error);
        }

        onStatusChanged: {
            console.debug("status = " + mediaPlayer.status);
            if ((mediaPlayer.status == MediaPlayer.Loaded) || (mediaPlayer.status == MediaPlayer.Buffered)) {
                //now that media is loaded, we should know its size, and should request a resize
                //if we are not fullscreen, then the window should resize to the native size of the video
                //TODO: automatically resize video window to native move size
            }
        }

        onBufferProgressChanged: {
            //console.debug("buffer progress = " + mediaPlayer.bufferProgress);
        }
    }
    function play() { mediaPlayer.play() }
    function stop() { mediaPlayer.stop() }
}
