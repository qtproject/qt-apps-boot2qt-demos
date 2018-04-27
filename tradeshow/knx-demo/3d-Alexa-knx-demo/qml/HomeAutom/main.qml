/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt 3D Studio Demos.
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

import QtQuick 2.8
import Style 1.0

// Main Item
Item {
    id: main
    width: sizesMap.screenWidth
    height: sizesMap.screenHeight

    // onPresentationReady() signal should be restored to 3D studio code so that we can hide
    // the splashscreen without a timer, https://bugreports.qt.io/browse/QT3DS-414
    Timer {
        id: showSplashScreenTimer
        interval: 1000
        running: false
        repeat: false

        onTriggered: hideSplashScreen()
    }

    Loader {
        id: appLoader
        anchors.fill: parent
        visible: false
//        asynchronous: true // https://bugreports.qt.io/browse/QTBUG-50992
    }

    Connections {
        target: appLoader.item
        onStudio3DPresentationReady: hideSplashScreen()
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: knxBackend.reconnect()
    }

    SplashScreen {
        id: splashScreenLoader
        visible: true
        anchors.fill: parent
        Component.onCompleted: {
            appLoader.setSource("HomeView.qml")
            showSplashScreenTimer.start()
        }
    }

    function hideSplashScreen() {
        if (appLoader.status === Loader.Ready) {
            splashScreenLoader.visible = false
            appLoader.visible = true
        }
    }
}
