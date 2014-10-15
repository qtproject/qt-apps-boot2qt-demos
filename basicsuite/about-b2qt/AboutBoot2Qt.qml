/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://www.qt.io
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

    spacing: engine.smallFontSize() * 2

    property color qtlightgreen: '#80c342'
    property color qtmediumgreen: '#328930'
    property color qtdarkgreen: '#006325'
    property color qtdarkblue: '#14148c'
    property color qtlightblue: '#14aaff'
    property color qtpurple: '#ae32a0'
    property color qtred: '#b40000'

    ColouredTitle {
        text: "MEET Qt ENTERPRISE EMBEDDED"
    }

    ContentText {
        id: brief
        width: parent.width
        text: '<p align="justify">Qt Enterprise Embedded provides a fully-integrated solution
               to get you started immediately with software development on your embedded device
               with a tailored user experience for embedded Linux and embedded Android. It
               supports your key requirements for high performance and minimal footprint, and together
               with Qt - a full framework with modular architecture - delivers unparalleled
               scalability. The development cycle is as rapid as it gets with fully integrated
               embedded tooling, pre-configured software stack and a collection of value-add components.</p>'
    }

    // Large overview picture
    Column {
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Box{ text: "Cross-Platform Qt Libraries"; width: parent.width; accentColor: qtlightgreen }
        Box{ text: "Value-Add Components"; width: parent.width; accentColor: qtlightgreen }

        Row {
            id: row1
            spacing: 10
            width: parent.width

            Box{ text: "Complete\nDevelopment Environment\nwith Qt Creator IDE";
                width: (row1.width - row1.spacing) / 2; height: column1.height; accentColor: qtmediumgreen }

            Column {
                id: column1
                width: (row1.width - row1.spacing ) / 2
                spacing: row1.spacing


                Box{ text: "Boot to Qt\nSoftware Stack\nfor HW"; accentColor: qtdarkblue; height: b2.height * 3 }
                Box{ id: b2; text: "Build-Your-Own-Stack Tooling"; accentColor: qtdarkblue; }
            }
        }
    } // end overview picture

    ColouredTitle {
        text: "POWER OF CROSS-PLATFORM Qt"
    }

    ContentText {
        width: parent.width
        text: '<p align="justify">Leverage the cross-platform C++ native APIs for maximum performance on both beautiful
                         user interfaces as well as non-GUI operations. With C++, you have full control
                         over your application code and direct device access. You can also create custom configurations
                         of Qt Enterprise Embedded, targeting a large variety of supported hardware and
                         operating systems with ease. As with any Qt project, the same application can be deployed
                         natively to desktop and mobile OS targets as well.</p>'
    }

    HighlightText {
        text: "Velvet-Like Native UIs, HTML5 or Both!"
    }

    ContentText {
        width: parent.width
        text: '<p align="justify">With <strong>Qt Quick</strong> you can create beautiful and modern touch-based UIs
            with maximum performance. Just like everything you find from this demo launcher!</p>
            <p align="justify">Should you want dynamic web content and HTML5, the <strong>Qt WebEngine</strong> gives you a
            Chromium-based browser engine with comprehensive HTML5 feature support. Mix and match with Qt Quick to get the best
            of both worlds!</p>'
    }

    ColouredTitle {
        text: "SHORTER TIME-TO-MARKET"
    }

    HighlightText {
        text: "Full Embedded Development Environment"
    }

    ContentText {
        width: parent.width
        text: '<p align="justify">A full-blown, productivity enhancing development environment,
        installed on a Linux development desktop. This self-contained environment
        is installed and updated through one online installer and features the Qt
        Creator Enterprise IDE, with features that facilitate the whole product
        creation lifecycle: UI designer, code editor, direct device deployment
        via USB or IP, emulator, on-device debugging and profiling.</p>'
    }


    HighlightText {
        text: "Boot to Qt Software Stack -\nEmbedded Prototyping Couldn't Get Any Simpler!"
    }

    Row {
        width: parent.width
        spacing: 30

        ContentText {
            width: (parent.width - parent.spacing ) / 2

            text: '<p align="justify">The <strong>Boot to Qt</strong> software stack gets you
               immediately started with software development on your embedded device
               with a tailored user experience for embedded Linux and embedded Android. It
               supports your key requirements for high performance, minimal footprint together
               with Qt’s flexible full-framework modular architecture to deliver unparalleled
               scalability.</p><p align="justify">The Boot to Qt stack can be made to run on a variety
               of hardware with the provided <strong>Build-Your-Own-Stack</strong> tooling. It comes
               pre-built for several reference devices with the installation of Qt Enterprise Embedded.</p>'
        }

        Column {
            spacing: 5
            width: ( parent.width - parent.spacing ) / 2
            Box { text: "Application"; accentColor: qtpurple }
            Box { text: "Qt Framework"; accentColor: qtlightgreen }
            Box { text: "Android/Linux Baselayer"; accentColor: qtdarkblue }
            Box { text: "Embedded Hardware"; accentColor: qtdarkblue }
        }


    }

    HighlightText {
        text: "Value-Add Components - No Need to Re-Invent the Wheel!"
    }
    ContentText {
        width: parent.width
        text: '<p align="justify">The Qt libraries come with a lot of high-level functionality for
               various parts of your application. On top of that, we\'ve extended Qt Enterprise Embedded
               to contain all the important things you need to create your embedded device, such as:</p>'
    }


    // The "grid" layout for key add-ons
    Row {
        width: parent.width * 0.9
        spacing: 30
        anchors.horizontalCenter: parent.horizontalCenter

        Column {
            spacing: 10
            width: parent.width * 0.4

            HighlightText {
                color: qtlightgreen
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: engine.smallFontSize()
                text: "Virtual Keyboard"
            }
            HighlightText {
                color: qtlightgreen
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: engine.smallFontSize()

                text: "Dynamic and Static Charting"
            }
            HighlightText {
                color: qtlightgreen
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: engine.smallFontSize()

                text: "Pre-Built UI Controls"
            }
        }
        Column {
            spacing: 10
            width: parent.width * 0.4
            HighlightText {
                color: qtlightgreen
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: engine.smallFontSize()
                text: "3D Data Visualization"
            }
            HighlightText {
                color: qtlightgreen
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: engine.smallFontSize()
                text: "Qt Quick Compiler"
            }
            HighlightText {
                color: qtlightgreen
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: engine.smallFontSize()
                text: "Additional Tooling"
            }
        }
    } // end of "grid" layout

    ColouredTitle {
        text: "TRUSTED TECHNOLOGY PARTNER"
    }
    ContentText {
        width: parent.width
        text: '<p align="justify">Qt is powering millions of everyday embedded devices used by over 70 industries. The Qt developer
               community consists of hundreds of thousands of enthusiastic developers.</p>'
    }
    ContentText {
        width: parent.width
        text: '<p align="justify">With Qt Enterprise Embedded you are never alone with your device creation. You get
               <strong>full support and portfolio of Digia Qt Professional Services</strong>
               to help you pass all obstacles and reach your markets faster with outstanding quality.</p>'
    }

    ColouredTitle {
        text: "GETTING STARTED WITH DEVELOPMENT"
    }
    ContentText {
        width: parent.width
        text: '<p align="justify">Play around with the demos in this launcher to see the power of Qt and get your
                free evaluation version of Qt Enterprise Embedded with the Boot to Qt images
                for common developer boards from</p>'
    }
    HighlightText {
        text: "http://www.qt.io"
        color: qtpurple
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
    }
    ContentText {
        width: parent.width
        text: '<p align="justify">With an online installer, you\'ll get the out-of-the-box
                pre-configured development environment, Qt Creator IDE, and you can start your
                embedded development immediately!</p>'
    }

}
