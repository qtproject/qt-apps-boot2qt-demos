/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt 5 launch demo.
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
import QtGraphicalEffects 1.0

import "presentation"

OpacityTransitionPresentation {
    id: presentation

    width: 1280
    height: 720

    transitionTime: 1000


    /********************************************************************************
     *
     * Introduction
     *
     */

/*
    Rectangle {
        id: openingSlideBlackout
        color: "black"
        anchors.fill: parent;
        Behavior on opacity { NumberAnimation { duration: 1000 } }
    }

    onCurrentSlideChanged: {
        if (currentSlide < 2)
            openingSlideBlackout.opacity = 1;
        else
            openingSlideBlackout.opacity = 0;
    }


    Slide {

    }
*/

    Slide {
        id: introSlide

        writeInText: "The following is a quick tour of what is new in Qt 5.

It is an application written with Qt Quick, based on Qt 5.

We hope you will enjoy Qt 5 as much as we have enjoyed creating it.

[tap to advance]"

//        Image {
//            source: "images/qt-logo.png"
//            opacity: 0.4
//            z: -1
//            anchors.centerIn: parent
//        }
    }

    Slide {
        centeredText: "Introducing"
        fontScale: 2
    }

    Slide {
        centeredText: "Qt 5"
        fontScale: 4;
    }


    Slide {
        writeInText: "OpenGL-based scene graph for Qt Quick 2.0 - providing velvet animations, particles and impressive graphical effects

Multimedia support

Preliminary support for Android and iOS"
    }

    Slide {
        writeInText: "C++ language features - template-based connect(), C++11 support

Connectivity and Networking - DNS lookup, improved IPv6 support

JSON Support - Fast parser and writer, binary format support"
    }

    Slide {
        writeInText: "Modularization of the Qt libraries - sanitizing our codebase and simplifying deployment

Qt Platform Abstraction - Unifying the Qt codebase across platforms, minimizing the porting effort for new platforms

Wayland support - Wayland-compatible Qt backend and compositor framework"
    }

    Slide {
         title: "Qt for Android"
         writeInText:
 "
 Qt 5.1 allows you to write Android apps using Qt Quick or Qt Widgets.

 We support QML media player functionality, as well as a set of commonly used sensors in QtSensors.

 With Qt Creator you can develop your apps, deploy them directly to a device, and debug them on the device.
 "
     }

 Slide {
     writeInText:
 "For this preliminary release, we are focusing on the developer experience, working to enable Qt developers to easily run and test their applications on Android devices.

 You can easily deploy your app to an app store with Qt 5.1, but we recommend waiting until Qt 5.2 for an even smoother experience."
     }


    /********************************************************************************
     *
     * Qt Quick Graphics Stack
     *
     */
    ExamplesSlide { }

    FontSlide { }
    CanvasSlide { }
    ParticleSlide { }
    ShaderSlide { }



    /********************************************************************************
     *
     * Qt Graphical Effects
     *
     */

    EffectsSlide {}

//    /********************************************************************************
//     *
//     * Multimedia
//     *
//     */

//    Slide {
//        title: "Qt Multimedia"
//        writeInText: "The Qt Multimedia module is implemented on all our major platforms, including Windows, Mac OS X and Linux.

//It contains both a C++ API for use with existing Qt Widgets based applications and a QML API for use with Qt Quick 2.0.

//The features include recording and playback of video and audio and also use of camera.

//It also integrates nicely with the Qt Graphical Effects module."
//    }

    VideoSlide { }
//    CameraSlide { }




    /********************************************************************************
     *
     * WebKit
     *
     */

//    WebkitSlide { }



    /********************************************************************************
     *
     * The End
     *
     */

    Slide {
        title: "Links"
        contentFormat: Text.RichText
        content: [
            "Qt Project: <a href=\"http://qt-project.org\">qt-project.org</a>",
            "Qt by Digia: <a href=\"http://qt.digia.com\">qt.digia.com</a>",
            "Follow us on Twitter",
            "  <a href=\"https://twitter.com/qtproject\">@QtProject</a>",
            "  <a href=\"https://twitter.com/QtbyDigia\">@QtByDigia</a>",
            "Find us on Facebook:",
            "  <a href=\"https://www.facebook.com/QtProject\">Qt Project</a>",
            "  <a href=\"https://www.facebook.com/Qt\">Qt by Digia</a>",
                 ];

        Image {
            z: -1
            opacity: 0.7
            source: "images/qt-logo.png"
            width: parent.width / 3
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.15
            fillMode: Image.PreserveAspectFit
        }

    }

}
