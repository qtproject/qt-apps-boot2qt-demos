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
        id: title
        text: "Qt Enterprise Embedded"
    }

    ContentText {
        id: brief
        width: parent.width
        text: '<p align="justify">Qt Enterprise Embedded provides a fully-integrated solution
               to get you started immediately with software development on your embedded device
               with a tailored user experience for embedded Linux and embedded Android. It
               supports your key requirements for high performance, minimal footprint together
               with Qt’s flexible full-framework modular architecture to deliver unparalleled
               scalability.'
    }

    Column {
        id: diagram
        spacing: 1
        width: parent.width * 0.5
        anchors.horizontalCenter: parent.horizontalCenter
        Box { text: "Application"; accentColor: "coral" }
        Box { text: "Qt Framework"; accentColor: Qt.rgba(0.64, 0.82, 0.15) }
        Box { text: "Android/Linux Baselayer"; accentColor: "steelblue" }
        Box { text: "Embedded Hardware"; accentColor: "steelblue"}
    }

    ContentText {
        id: description

        width: parent.width

        text: '<p align="justify">Qt Enterprise Embedded gives you shorter time-to-market
               providing you with the productivity-enhancing tools and value-adding components.
               You are up-to-speed with development and prototyping since day one. You can just
               focus on writing your application with Qt.<br>
               <p align="justify">Qt Enterprise Embedded provides you with the following:
               <ul>
                 <li><b>A full-blown, productivity enhancing development environment</b>,
                     installed on a Linux development desktop. This self-contained environment
                     is installed and updated through one online installer and features the Qt
                     Creator Enterprise IDE, with features that facilitate the whole product
                     creation lifecycle: UI designer, code editor, direct device deployment
                     via USB or IP, emulator, on-device debugging and profiling.</li><br>
                 <li><b>Shorter time-to-market with the Boot to Qt Software Stack</b>. A
                     light-weight, Qt-optimized, full software stack that is installed into
                     the actual target device. The stack comes in two flavors, Embedded Android
                     and Embedded Linux. The pre-built stack gets you up-to-speed with prototyping
                     in no time and with our professional tooling you can customize the stack into
                     your exact production needs.</li><br>
                 <li><b>Full power and scalability of Qt on Embedded</b>. Leverage the
                     cross-platform C++ native APIs for maximum performance on both beautiful
                     user interfaces as well as non-GUI operations. With C++, you have full control
                     over your application code. You can also configure Qt Enterprise Embedded
                     directly from the source codes into a large variety of supported hardware and
                     operating systems. As with any Qt project, the same application can be deployed
                     natively to desktop and mobile OS targets as well.</li><br>
                 <li><b>Value-Adding Components</b>. No need to re-implement the wheel! Full Qt
                     Enterprise libraries give you a shortcut on development time providing ready-made
                     solutions, such as a comprehensive virtual keyboard, charts and industrial UI
                     controls.
               </ul>

               <p align="justify">Qt Enterprise Embedded includes <b>Boot to Qt</b>, a light-weight,
               Qt-optimized, full software stack for embedded systems that is installed into the actual
               target device. The Boot to Qt stack can be made to run on a variety of hardware - Qt
               Enterprise Embedded comes with pre-built images for several reference devices.
              '
    }
}
