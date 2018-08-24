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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.1
import QtQml 2.2
import DataStore 1.0

import "./BikeStyle"

Rectangle {
    visible: true
    width: 640
    height: 480
    color: "#111520"
    id: root

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
            onClicked: drawer.open()
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

        states: [
            State {
                name: ""
                when: swipeView.currentIndex == 1 && (!speedView.enlarged)
                PropertyChanges {
                    target: speedView
                    width: UILayout.speedViewRadius * 2 + 2
                    height: UILayout.speedViewRadius * 2 + 2
                    anchors.topMargin: UILayout.speedViewTop
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                    color: "transparent"
                    dotcount: UILayout.speedViewDots
                    curvewidth: UILayout.speedViewInnerWidth
                    speedTextSize: UILayout.speedTextSize
                    speedBaselineOffset: UILayout.speedBaselineOffset + 1
                    innerRadius: UILayout.speedViewInnerRadius
                    speedUnitsSize: UILayout.speedUnitsSize
                    speedUnitBaselineOffset: UILayout.speedTextUnitMargin
                    speedIconsOffset: UILayout.speedIconsCenterOffset
                    speedInfoTextsOffset: 0
                    speedInfoTextsSize: UILayout.speedInfoTextsSize
                    speedInfoUnitsOffset: UILayout.speedInfoUnitsOffset
                    assistPowerIconOffset: UILayout.assistPowerIconOffset
                }
                AnchorChanges {
                    target: speedView
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.left: undefined
                    anchors.bottom: undefined
                }
                PropertyChanges {
                    target: speedView.cornerRectangle
                    color: "transparent"
                }
                AnchorChanges {
                    target: speedView.cornerRectangle
                    anchors.horizontalCenter: speedView.horizontalCenter
                    anchors.verticalCenter: speedView.verticalCenter
                    anchors.left: undefined
                    anchors.bottom: undefined
                }
                StateChangeScript {
                    script: {
                        if (musicPlayer.lastMusicPlayerState === "" && (!drawer.viewTab.musicPlayerSwitch.checked))
                            musicPlayer.state = "";
                    }
                }
            },
            State {
                name: "CORNERED"
                when: swipeView.currentIndex != 1
                PropertyChanges {
                    target: speedView
                    width: UILayout.speedViewRadiusMinified * 2
                    height: UILayout.speedViewRadiusMinified * 2
                    anchors.topMargin: 0
                    anchors.leftMargin: UILayout.speedViewCornerLeftMargin
                    anchors.bottomMargin: UILayout.speedViewCornerBottomMargin
                    color: Colors.speedViewBackgroundCornered
                    dotcount: UILayout.speedViewDotsMinified
                    curvewidth: UILayout.speedViewInnerWidthMinified
                    speedTextSize: UILayout.speedTextSizeMinified
                    speedBaselineOffset: UILayout.speedBaselineOffsetMinified
                    innerRadius: UILayout.speedViewInnerRadiusMinified
                    speedUnitBaselineOffset: UILayout.speedTextUnitMarginMinified
                }
                AnchorChanges {
                    target: speedView
                    anchors.horizontalCenter: undefined
                    anchors.top: undefined
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
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
                    width: UILayout.speedViewRadiusEnlarged * 2
                    height: UILayout.speedViewRadiusEnlarged * 2
                    anchors.topMargin: 35
                    dotcount: UILayout.speedViewDotsEnlarged
                    speedTextSize: UILayout.speedTextSizeEnlarged
                    speedBaselineOffset: UILayout.speedBaselineOffsetEnlarged
                    innerRadius: UILayout.speedViewInnerRadiusEnlarged
                    speedUnitsSize: UILayout.speedUnitsSizeEnlarged
                    speedUnitBaselineOffset: UILayout.speedTextUnitMarginEnlarged
                    speedIconsOffset: UILayout.speedIconsCenterOffsetEnlarged
                    speedInfoTextsOffset: UILayout.speedInfoTextsOffsetEnlarged
                    speedInfoTextsSize: UILayout.speedInfoTextsSizeEnlarged
                    speedInfoUnitsOffset: UILayout.speedInfoUnitsOffsetEnlarged
                    assistPowerIconOffset: UILayout.assistPowerIconOffsetEnlarged
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
                    anchors.top: parent.top
                    anchors.left: undefined
                    anchors.bottom: undefined
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
        height: 350
        width: root.width
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
        StatsPage {}
        MainPage {
            id: mainPage
            naviGuideArrowSource: naviPage.naviGuideArrowSource
            naviGuideDistance: naviPage.naviGuideDistance
            naviGuideAddress: naviPage.naviGuideAddress
        }
        NaviPage {
            id: naviPage;
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
        onDemoReset: drawer.close()
    }

    // Virtual keyboard
    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: root.height
        width: root.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: root.height - inputPanel.height
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
