/****************************************************************************
**
** Copyright (C) 2020 The Qt Company Ltd.
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

import QtQuick 2.12
import QtQuick.Controls 2.15
import StartupScreen 1.0

ApplicationWindow {
    id: bootUI
    visible: true

    property bool isPortrait: false // true //
    property int resolution: 1

    width: Constants.smallWidth
    height: Constants.smallHeight

    // for testing
    Item {
        anchors.fill: parent
        focus: true
        Keys.onPressed: {
            // rotate: toggle portrait/landscape
            if (event.key === Qt.Key_R) {
                isPortrait? isPortrait = false: isPortrait = true
            }

            // navigate from splash to main
            else if (event.key === Qt.Key_Space){
                splash.opacity= 0
                main.opacity=1
            }

            // change window size
            else if (event.key === Qt.Key_1) {
                resolution = 1
            }
            else if (event.key === Qt.Key_2) {
                resolution = 2
            }
            else if (event.key === Qt.Key_3) {
                resolution = 3
            }

            // set width
            if (resolution == 1){
                bootUI.width = isPortrait? Constants.smallHeight: Constants.smallWidth
                bootUI.height= isPortrait? Constants.smallWidth: Constants.smallHeight
                isPortrait? main.state = "smallPortrait": main.state = ""
            }
            else if (resolution == 2){
                bootUI.width = isPortrait? Constants.mediumHeight: Constants.mediumWidth
                bootUI.height = isPortrait? Constants.mediumWidth: Constants.mediumHeight
                isPortrait? main.state = "mediumPortrait": main.state = "mediumLandscape"

            }
            else{
                bootUI.width = isPortrait? Constants.largeHeight: Constants.largeWidth
                bootUI.height = isPortrait? Constants.largeWidth: Constants.largeHeight
                isPortrait? main.state = "largePortrait": main.state = "largeLandscape"
            }
        }
    }

    SplashView {
        id: splash
        width: bootUI.width
        height: bootUI.height
    }

    MainView {
        id: main
        width: bootUI.width
        height: bootUI.height

        opacity: 0
    }
}


