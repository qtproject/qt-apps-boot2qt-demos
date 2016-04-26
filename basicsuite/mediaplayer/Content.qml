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

Rectangle {
    id: root
    property alias effect: effectLoader.item
    property string effectSource
    property alias videoPlayer: videoContent
    signal contentSizeChanged(size contentSize)

    color: "black"

    ShaderEffectSource {
        id: theSource
        smooth: true
        hideSource: true
    }

    Intro {
        id: introBackground
        anchors.fill: root
        visible: videoContent.mediaSource == "" ? true : false
    }

    ContentVideo {
        id: videoContent
        anchors.fill: root
        visible: mediaSource == "" ? false : true

        onSourceRectChanged: {
            contentSizeChanged(Qt.size(sourceRect.width, sourceRect.height));
        }
    }

    Loader {
        id: effectLoader
        source: effectSource
    }

    onWidthChanged: {
        if (effectLoader.item)
            effectLoader.item.targetWidth = root.width
    }

    onHeightChanged: {
        if (effectLoader.item)
            effectLoader.item.targetHeight = root.height
    }

    onEffectSourceChanged: {
        effectLoader.source = effectSource
        effectLoader.item.parent = root
        effectLoader.item.targetWidth = root.width
        effectLoader.item.targetHeight = root.height
        updateSource()
        effectLoader.item.source = theSource
    }

    function init() {
        theSource.sourceItem = introBackground
        root.effectSource = "Effects/EffectPassThrough.qml"
    }

    function updateSource() {

        theSource.sourceItem = videoContent.mediaSource == "" ? introBackground : videoContent
        if (effectLoader.item)
            effectLoader.item.anchors.fill = videoContent
    }

    function openVideo(path) {
        stop();
        videoContent.mediaSource = path;
        updateSource();
    }

    function stop() {
        theSource.sourceItem = introBackground
        if (videoContent.mediaSource !== undefined) {
            videoContent.stop();
        }
    }
}
