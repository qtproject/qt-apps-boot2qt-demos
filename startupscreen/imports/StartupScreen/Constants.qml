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

pragma Singleton
import QtQuick 2.10
import StartupScreen 1.0

QtObject {
    // readonly property int width: 640
    // readonly property int height: 480

    // resolutions
    readonly property int smallWidth: 640
    readonly property int smallHeight: 480
    readonly property int mediumWidth: 1280
    readonly property int mediumHeight: 720
    readonly property int largeWidth: 1920
    readonly property int largeHeight: 1080

    // clock sizes
    readonly property int smallClock: 180
    readonly property int mediumClock: 320
    readonly property int largeClock: 540

    // panel width
    readonly property int smallPanelWidth: 420
    readonly property int mediumPanelWidth: 660
    readonly property int largePanelWidth: 1000

    // header height
    readonly property int smallHeaderHeight: 92
    readonly property int mediumHeaderHeight: 160
    readonly property int largeHeaderHeight: 260

    // body height
    readonly property int smallBodyHeight: 172
    readonly property int mediumBodyHeight: 260
    readonly property int largeBodyHeight: 480

    // icon button sizes
    readonly property int smallButton: 100
    readonly property int mediumButton: 148
    readonly property int largeButton: 200

    // text button sizes
    readonly property int smallTextButton: 60
    readonly property int mediumTextButton: 92
    readonly property int largeTextButton: 140

    readonly property color backgroundColor: "#c2c2c2"
}
