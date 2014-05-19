/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://qt.digia.com/
**
** This file is part of the examples of the Qt Enterprise Embedded.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
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
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
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

Column {
    id: root

    width: parent.width

    spacing: engine.smallFontSize()

    Title {
        text: "Boot to Qt vs Qt for Android"
    }

    ContentText {
        width: parent.width
        text: '<p align="justify">Qt for Android is a port of the Qt Framework to be used
               for application development on the Android platform. Its
               purpose is to enable development of applications that
               can run on Android devices. For developers writing applications
               for the Android ecosystem, Qt for Android is the right choice.

               <p align="justify"><b>Boot to Qt for embedded Android</b> tries to strip down
               the Android stack to the bare minimum, relying only on basic Linux features.
               The majority of the Android stack, such as <i>Dalvik virtual machine</i> is
               not running in Boot to Qt, resulting in faster startup times, lower memory consumption
               and overall better performance.'
    }

    Column {
        id: diagram
        spacing: 1
        width: parent.width * 0.66
        anchors.horizontalCenter: parent.horizontalCenter
        Box { text: "Application"; accentColor: "coral" }
        Box { text: "Qt for Android"; accentColor: Qt.rgba(0.64, 0.82, 0.15) }
        Row {
            width: parent.width
            height: b.height
            Box { id: b; width: parent.width / 2; text: "Qt Framework"; accentColor: Qt.rgba(0.64, 0.82, 0.15) }
            Box { width: parent.width / 2; text: "Android (Dalvik)"; accentColor: "steelblue" }
        }

        Box { text: "Android Baselayer"; accentColor: "steelblue" }
        Box { text: "Embedded Hardware"; accentColor: "steelblue"}
    }

    ContentText {
        width: parent.width
        text: '<p align="justify"><b>Boot to Qt for embedded Linux</b> is build from scratch using
               Yocto tools to contain only components required in the embedded device,
               resulting in smaller image sizes while keeping valuable development tools available.'
    }
}
