/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
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
        text: "Boot to Qt"
    }

    ContentText {
        id: brief
        width: parent.width
        text: '<p align="justify">Boot to Qt is a light-weight UI stack for embedded systems, based on the Qt Framework by Digia,
               offering an elegant means of developing beautiful and performant embedded devices. It supports two different
               operating systems:
               <ul>
                 <li><b>Boot to Qt for embedded Android</b> places Qt on top of an Android (version 4.1 or higher)
                 kernel/baselayer.</li>
                 <li><b>Boot to Qt for embedded Linux</b> places Qt on top of an Linux kernel/baselayer, built using
                 Yocto 1.4 \'Dylan\' release.</li>
               </ul>
               Both versions have been tested and verified on a number of different hardware configurations.
               Boot to Qt support is not limited to the devices used as reference platforms, it can be made to run on a
               variety of hardware.

               <p align="justify">Boot to Qt is part of a commercial-only SDK offering which includes a ready-made stack
               with full Qt Creator integration. The SDK allows building and running on device
               with just a button. Embedded development has never been this easy!'
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

        text: '<p align="justify">Boot to Qt has been tested and verified on
               a number of different hardware configurations, including:
               <ul>
                 <li>Google Nexus 7 - NVIDIA Tegra3 Quad Core, 1 GB RAM</li>
                 <li>Beagle Board xM - ARM Coretex A8 1GHz, 512 MB RAM, PowerVR SGX 530</li>
                 <li>Freescale i.MX 6 - ARM Cortex A9 1.2GHz, 1 GB RAM, Vivante GC2000</li>
               </ul>
               Rough minimal requirements for running Boot to Qt are:
               <ul>
                 <li>256Mb of RAM</li>
                 <li>500Mhz CPU, 1Ghz preferred for 60 FPS velvet UIs</li>
                 <li>OpenGL ES 2.0 support</li>
                 <li>Android 4.0+ compatible hardware</li>
               </ul>
              '
    }
}
