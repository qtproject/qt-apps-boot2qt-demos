/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the E-Bike demo project.
**
** $QT_BEGIN_LICENSE:LGPL3$
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
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.7
import QtQuick.Window 2.10
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.1
import QtQml 2.2
import DataStore 1.0

import "./BikeStyle"

Window {
    id: window
    visible: true
    color: "#111520"
    readonly property int portraitRotation: 90
    property real rotation: Screen.orientation === Qt.PortraitOrientation ? portraitRotation : 0
    property bool rotate: Screen.orientation === Qt.PortraitOrientation ? true : false
    contentOrientation: (Screen.orientation === Qt.PortraitOrientation) ? Qt.LandscapeOrientation : Qt.PrimaryOrientation
    width: appConf.width
    height: appConf.height

    Rectangle {
        id: container
        transform: Rotation { origin.x: (width/2); origin.y: (width/2); angle: window.rotation}
        color: "transparent"
        width: rotate ? parent.height : parent.width
        height: rotate ? parent.width : parent.height

        // Permanent placeholder for time display
        ClockView {
            id: clockButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top

            MouseArea {
                anchors.rightMargin: -20
                anchors.leftMargin: -20
                anchors.bottomMargin: -20
                anchors.fill: parent
                onClicked: {
                    drawer.open()
                }
            }
        }

        FpsItem {
            anchors.top: parent.top
            anchors.left: parent.left
            visible: fps.visible
        }

        // The always-visible speed view
        SpeedView {
            id: speedView
            onShowMain: swipeView.currentIndex = 1
            showZero: naviPage.targetEdit.activeFocus
            property real enlargedMultiplier: 1.19
            property real corneredMultiplier: 0.25
            states: [
                State {
                    name: "CORNERED"
                    when: swipeView.currentIndex != 1
                    PropertyChanges {
                        target: speedView
                        width: parent.width * 0.14
                        height: width
                        anchors.leftMargin: parent.width * 0.015
                        anchors.bottomMargin: anchors.leftMargin
                        color: Colors.speedViewBackgroundCornered
                        dotcount: UILayout.speedViewDotsMinified
                        speedTextSize: height * 0.475
                        speedBaselineOffset: height * 0.4
                        innerRadius: width * 0.45 * 0.875
                        speedUnitBaselineOffset: height * 0.1
                        speedUnitsSize: height * 0.09
                        curvewidth: Math.min(width, height) * 0.055
                    }
                    AnchorChanges {
                        target: speedView
                        anchors.horizontalCenter: undefined
                        anchors.top: undefined
                        anchors.verticalCenter: undefined
                        anchors.left: swipeView.left
                        anchors.bottom: swipeView.bottom
                    }
                    PropertyChanges {
                        target: speedView.cornerRectangle
                        color: Colors.speedViewBackgroundCornered
                    }
                    AnchorChanges {
                        target: speedView.cornerRectangle
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: undefined
                        anchors.left: speedView.left
                        anchors.bottom: speedView.bottom
                    }
                    StateChangeScript {
                        script: {
                            musicPlayer.lastMusicPlayerState = musicPlayer.state;
                            musicPlayer.state = "hidden";
                        }
                    }
                },
                State {
                    name: "ENLARGED"
                    when: swipeView.currentIndex == 1 && speedView.enlarged
                    PropertyChanges {
                        target: speedView
                        width: parent.width * 0.35 * enlargedMultiplier
                        height: width
                        dotcount: UILayout.speedViewDotsEnlarged
                        speedTextSize: height * 0.4 * enlargedMultiplier
                        innerRadius: width * 0.45
                        speedUnitsSize: height * 0.05 * 1.125
                        speedUnitBaselineOffset: height * 0.075 * enlargedMultiplier
                        speedIconsOffset: width * 0.25
                        speedInfoTextsOffset: 0
                        speedInfoTextsSize: speedTextSize * 0.45 * enlargedMultiplier
                        speedInfoUnitsOffset: height * 0.075 * enlargedMultiplier
                        assistPowerIconOffset: height * 0.175 * enlargedMultiplier
                    }
                    PropertyChanges {
                        target: mainPage.statsButton
                        anchors.leftMargin: -mainPage.statsButton.width
                        anchors.topMargin: -mainPage.statsButton.height
                    }
                    PropertyChanges {
                        target: mainPage.naviButton
                        anchors.rightMargin: -mainPage.naviButton.width
                        anchors.topMargin: -mainPage.naviButton.height
                    }
                    PropertyChanges {
                        target: mainPage.lightsButton
                        anchors.leftMargin: -mainPage.statsButton.width
                        anchors.bottomMargin: -mainPage.statsButton.height
                    }
                    PropertyChanges {
                        target: mainPage.modeButton
                        anchors.rightMargin: -mainPage.statsButton.width
                        anchors.bottomMargin: -mainPage.statsButton.height
                    }
                    PropertyChanges {
                        target: clockButton
                        anchors.topMargin: -clockButton.height
                    }
                    AnchorChanges {
                        target: speedView
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    StateChangeScript {
                        script: {
                            musicPlayer.lastMusicPlayerState = musicPlayer.state;
                            musicPlayer.state = "hidden";
                        }
                    }
                }
            ]

            transitions: [
                Transition {
                    from: ""; to: "ENLARGED"
                    NumberAnimation {
                        properties: "anchors.leftMargin,anchors.rightMargin,anchors.topMargin,anchors.bottomMargin"
                        duration: 250
                    }
                    NumberAnimation {
                        properties: "width,height,dotcount,speedTextSize,speedBaselineOffset,innerRadius,speedUnitsSize,speedUnitBaselineOffset,speedIconsOffset,speedInfoTextsOffset,speedInfoTextsSize,speedInfoUnitsOffset,assistPowerIconOffset"
                        duration: 250
                    }
                    AnchorAnimation {
                        duration: 250
                    }
                },
                Transition {
                    from: "ENLARGED"; to: ""
                    NumberAnimation {
                        properties: "anchors.leftMargin,anchors.rightMargin,anchors.topMargin,anchors.bottomMargin"
                        easing.type: Easing.OutBack
                        duration: 250
                    }
                    NumberAnimation {
                        properties: "width,height,dotcount,speedTextSize,speedBaselineOffset,innerRadius,speedUnitsSize,speedUnitBaselineOffset,speedIconsOffset,speedInfoTextsOffset,speedInfoTextsSize,speedInfoUnitsOffset,assistPowerIconOffset"
                        duration: 250
                    }
                    AnchorAnimation {
                        duration: 250
                    }
                },
                Transition {
                    NumberAnimation {
                        properties: "width,height,curvewidth,speedTextSize,speedBaselineOffset,innerRadius,speedUnitMargin"
                        easing.type: Easing.OutBack
                        duration: 250
                    }
                    ColorAnimation {
                        duration: 250
                    }
                    AnchorAnimation {
                        easing.type: Easing.OutBack
                        duration: 250
                    }
                }
            ]
        }

        // Configuration and settings drawer
        ConfigurationDrawer {
            id: drawer
            height: parent.height * 0.475
            width: parent.width
            edge: Qt.TopEdge
            dragMargin: 20
        }

        // Inactive swipe view, for animations
        SwipeView {
            id: swipeView
            anchors.fill: parent
            currentIndex: 1
            interactive: false

            // List of pages
            StatsPage {
            }
            MainPage {
                id: mainPage
                naviGuideArrowSource: naviPage.naviGuideArrowSource
                naviGuideDistance: naviPage.naviGuideDistance
                naviGuideAddress: naviPage.naviGuideAddress
            }
            NaviPage {
                id: naviPage
            }
        }

        // Music player
        MusicPlayer {
            id: musicPlayer
            property string lastMusicPlayerState: "unknown"
            z: 1
        }

        Connections {
            target: datastore
            function onDemoReset() { drawer.close() }
        }
    }

    InputPanel {
        id: inputPanel
        active: !window.rotate
        visible: false
        z: 99
        y: container.height
        anchors.left: container.left
        anchors.right: container.right

        states: State {
            name: "visible"
            when: Qt.inputMethod.visible && !window.rotate
            PropertyChanges {
                target: inputPanel
                y: container.height - inputPanel.height
                visible: true
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
