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
import QtQuick.Controls 2.3
import QtStudio3D 1.0

Item {
    id: home

    property real red: 0
    property real blue: 255
    property real green: 0
    property real light: 0

    property string currentTempAttribute: ""
    property string currentLightAttribute: ""

    Timer {
        id: goToHomeTimer
        interval: 30000
        running: false
        repeat: false

        onTriggered: presentation.goToSlide("Scene", "BackToInitialView")
    }

    Timer {
        id: showMenuTimer
        interval: 1000
        running: false
        repeat: false

        onTriggered: mainMenu.visible = true
    }

    signal studio3DPresentationReady()

    function getRoomName(index) {
        var name;
        if (index === 0)
            name = "BackToInitialView"
        else if (index === 1)
            name = "Livingroom"
        else if (index === 2)
            name = "Masterbedroom"
        else if (index === 3)
            name = "Bedroom"
        else if (index === 4)
            name = "Bathroom"
        return name
    }

    //
    // Qt 3D Studio presentation
    //
    Studio3D {
        anchors.fill: parent

        ViewerSettings {
            scaleMode: ViewerSettings.ScaleModeFill
        }

        Presentation {
            id: presentation
            source: "qrc:/uip/houseStudio.uip"

            SceneElement {
                id: scene
                elementPath: "Scene"
                onCurrentSlideNameChanged: {
                    var lightNum = 0
                    var startTimer = false;
                    if (currentSlideName === "Livingroom") {
                        currentTempAttribute = "Scene.3D.HeatAreas.Group_HeatAreas.HeatAreas_Heat_LivingRoom.HeatAreas_Heat_LivingRoom.Heat_LivingRoomSG"
                        currentLightAttribute = "Scene.3D.RoomLights.LivingroomLightMap.House"
                        livingRoomHeat.goToTime(2)
                        masterBedroomHeat.goToTime(0)
                        bedroomHeat.goToTime(0)
                        bathRoomHeat.goToTime(0)
                        entranceHeat.goToTime(0)
                        sliderToolbar.visible = true
                        lightNum = 1
                    } else if (currentSlideName === "Masterbedroom") {
                        currentTempAttribute = "Scene.3D.HeatAreas.Group_HeatAreas.HeatAreas_Heat_MasterBedroom.HeatAreas_Heat_MasterBedroom.Heat_MasterBedroomSG"
                        currentLightAttribute = "Scene.3D.RoomLights.MasterbedroomLightmap.House"
                        livingRoomHeat.goToTime(0)
                        masterBedroomHeat.goToTime(2)
                        bedroomHeat.goToTime(0)
                        bathRoomHeat.goToTime(0)
                        entranceHeat.goToTime(0)
                        sliderToolbar.visible = true
                        lightNum = 2
                    } else if (currentSlideName === "Bedroom") {
                        currentTempAttribute = "Scene.3D.HeatAreas.Group_HeatAreas.HeatAreas_Heat_BedRoom.HeatAreas_Heat_BedRoom.Heat_BedRoomSG"
                        currentLightAttribute = "Scene.3D.RoomLights.BedroomLightmap.House"
                        livingRoomHeat.goToTime(0)
                        masterBedroomHeat.goToTime(0)
                        bedroomHeat.goToTime(2)
                        bathRoomHeat.goToTime(0)
                        entranceHeat.goToTime(0)
                        sliderToolbar.visible = true
                        lightNum = 3
                    } else if (currentSlideName === "Bathroom") {
                        currentTempAttribute = "Scene.3D.HeatAreas.Group_HeatAreas.HeatAreas_Heat_BathRoom.HeatAreas_Heat_BathRoom.Heat_BathRoomSG"
                        currentLightAttribute = "Scene.3D.RoomLights.BathroomLightmap.House"
                        livingRoomHeat.goToTime(0)
                        masterBedroomHeat.goToTime(0)
                        bedroomHeat.goToTime(0)
                        bathRoomHeat.goToTime(2)
                        entranceHeat.goToTime(0)
                        sliderToolbar.visible = true
                        lightNum = 4
                    } else if (currentSlideName === "Entrance") {
                        currentTempAttribute = "Scene.3D.HeatAreas.Group_HeatAreas.HeatAreas_Heat_Entrance.Heat_Entrance_HeatAreas.Heat_EntranceSG"
                        currentLightAttribute = "Scene.3D.RoomLights.EntranceLightmap.House"
                        livingRoomHeat.goToTime(0)
                        masterBedroomHeat.goToTime(0)
                        bedroomHeat.goToTime(0)
                        bathRoomHeat.goToTime(0)
                        entranceHeat.goToTime(2)
                        sliderToolbar.visible = true
                    } else if (currentSlideName === "FloorPlan") {
                        livingRoomHeat.goToTime(0)
                        masterBedroomHeat.goToTime(0)
                        bedroomHeat.goToTime(0)
                        bathRoomHeat.goToTime(0)
                        entranceHeat.goToTime(0)
                        startTimer = true;
                        sliderToolbar.visible = false
                    } else {
                        sliderToolbar.visible = false
                    }

                    if (currentSlideName === "FloorPlan") {
                        if (previousSlideName === "InitialView")
                            mainMenu.visible = true
                        else
                            showMenuTimer.start()
                    } else {
                        if (showMenuTimer.running)
                            showMenuTimer.stop()
                        mainMenu.visible = false
                    }

                    if (startTimer)
                        goToHomeTimer.start()
                    else if (goToHomeTimer.running)
                        goToHomeTimer.stop()

                    presentation.setAttribute(currentTempAttribute, "diffuse.r", red)
                    presentation.setAttribute(currentTempAttribute, "diffuse.g", green)
                    presentation.setAttribute(currentTempAttribute, "diffuse.b", blue)
                    presentation.setAttribute(currentLightAttribute, "opacity", light)

                    if (knxBackend) {
                        lightControlLoader.item.lightNum = lightNum
                        lightControlLoader.item.updateLight(knxBackend.getLightState(lightNum))
                        tempSlider.setPositionByColor(knxBackend.getColor())
                        console.log("<<<<<<<<<<<<<<<<<<<1")
                    }
                }
            }

            SceneElement {
                id: livingRoomHeat
                elementPath: "Scene.3D.HeatAreas.Group_HeatAreas.HeatAreas_Heat_LivingRoom"
            }
            SceneElement {
                id: masterBedroomHeat
                elementPath: "Scene.3D.HeatAreas.Group_HeatAreas.HeatAreas_Heat_MasterBedroom"
            }
            SceneElement {
                id: bedroomHeat
                elementPath: "Scene.3D.HeatAreas.Group_HeatAreas.HeatAreas_Heat_BedRoom"
            }
            SceneElement {
                id: bathRoomHeat
                elementPath: "Scene.3D.HeatAreas.Group_HeatAreas.HeatAreas_Heat_BathRoom"
            }
            SceneElement {
                id: entranceHeat
                elementPath: "Scene.3D.HeatAreas.Group_HeatAreas.HeatAreas_Heat_Entrance"
            }
        }

        // Once https://bugreports.qt.io/browse/QT3DS-414 is solved uncomment the following lines.
//        onPresentationReady: {
//            if (presentationReady)
//                home.studio3DPresentationReady()
//        }

    }

    Connections {
        target: knxBackend
        onRoomChanged: presentation.goToSlide("Scene", getRoomName(roomId))
        onBoardUpdate: {
            console.log("signal onBoardUpdate lightNum: " + lightNum)
            if (lightNum > 0
                    && lightNum < 5
                    && lightControlLoader.item.lightNum == lightNum
                    && knxBackend.getLightState(lightNum) != lightControlLoader.item.checked) {
                var oldValue = houseModel.data(houseModel.index(lightNum - 1, 0), 3)
                houseModel.setData(houseModel.index(lightNum - 1, 0), !oldValue, 3)
                lightControlLoader.item.value = houseModel.data(houseModel.index(lightNum - 1, 0), 3)
                lightControlLoader.item.updateLight(knxBackend.getLightState(lightNum))
                console.log("lightControlLoader: " + lightControlLoader.item.value)
            }
        }
        onColorLedChange: {
            var sliderColor = Qt.rgba(tempSlider.redColor, tempSlider.greenColor, tempSlider.blueColor, 1)
            if (!Qt.colorEqual(sliderColor, color))
                tempSlider.setPositionByColor(color)
        }
//        knxBoard.changeColorLeftLed(color)
//        onRockerChange:  {
//            logo.rotation = (position - 1000) * 360 / 1000;
//        }
    }

    MouseArea {
        id: mouseArea
        property bool disableMouseEvents: false
        anchors.fill: parent
        onClicked: {
            if (!disableMouseEvents) {
                if (scene.currentSlideName === "BackToInitialView") {
                    presentation.goToSlide("Scene", "InitialView")
                    disableMouse(2200)
                } else if (scene.currentSlideName === "FloorPlan") {
                    presentation.goToSlide("Scene", "BackToInitialView")
                    disableMouse(2100)
                } else if (scene.currentSlideName !== "InitialView") {
                    presentation.goToSlide("Scene", "FloorPlan")
                    disableMouse(1000)
                }
            }
        }

        function disableMouse(animationDuration) {
            disableMouseEvents = true
            mouseTimer.interval = animationDuration
            mouseTimer.start()
        }

        Timer {
            id: mouseTimer
            interval: 1000
            running: false
            repeat: false

            onTriggered: mouseArea.disableMouseEvents = false
        }
    }

    //
    // Room label items
    //
    MainMenu {
        id: mainMenu

        property int currentIndex: -1

        visible: false
        anchors.fill: parent

        onCurrentMenuItemChanged: {
            presentation.goToSlide("Scene", currentItem)

            // Store temperature and light to model before changing the slider value
            if (currentIndex != -1) {
                houseModel.setData(houseModel.index(currentIndex, 0), tempSlider.currentValue, 2)
                houseModel.setData(houseModel.index(currentIndex, 0), lightControlLoader.item.currentValue, 3)
            }
            currentIndex = index
            var temp = houseModel.data(houseModel.index(index, 0), 2)
            tempSlider.value = (temp - 15) / 15
            lightControlLoader.item.value = houseModel.data(houseModel.index(index, 0), 3)
        }
    }

    //
    // Toolbar for Sliders
    //
    Item {
        id: sliderToolbar
        anchors.bottom: parent.bottom
        height: tempSlider.height
        anchors.horizontalCenter: parent.horizontalCenter
        width: lightControlLoader.width + sizesMap.controlMargin + tempSlider.width

        visible: false

        Loader {
            id: lightControlLoader
            source: knxBackend ? "LightSwitch.qml" : "LightSlider.qml"
            asynchronous: true
            anchors.bottom: parent.bottom
            anchors.bottomMargin: sizesMap.controlMargin
            anchors.left: parent.left
            width: knxBackend ? (sizesMap.controlHeight * 2) : (mainMenu.width / 3)
        }

        Connections {
            target: lightControlLoader.item
            onLightValueChanged: {
                var newLightValue = lightControlLoader.item.lightValue * 100
                home.light = newLightValue
                presentation.setAttribute(currentLightAttribute, "opacity", newLightValue)

            }
        }

        TempSlider {
            id: tempSlider
            anchors.bottom: parent.bottom
            anchors.bottomMargin: sizesMap.controlMargin
            anchors.right: parent.right
            width: mainMenu.width / 3

            onRedColorChanged: {
                home.red = redColor
                presentation.setAttribute(currentTempAttribute, "diffuse.r", redColor)
            }
            onBlueColorChanged: {
                home.blue = blueColor
                presentation.setAttribute(currentTempAttribute, "diffuse.b", blueColor)
            }

            onGreenColorChanged: {
                home.green = greenColor
                presentation.setAttribute(currentTempAttribute, "diffuse.g", greenColor)
            }

            onEconomyChanged: {
                if (knxBackend) {
                    // Toggle red light based on temperature changes
                    // The initial state of red lights on the board needs to be based on the default temperatures
                    var lightNum = 0
                     if (scene.currentSlideName === "Livingroom")
                         lightNum = 9
                     else if (scene.currentSlideName === "Masterbedroom")
                         lightNum = 10
                     else if (scene.currentSlideName === "Bedroom")
                         lightNum = 11
                     else if (scene.currentSlideName === "Bathroom")
                         lightNum = 12
                     //knxBackend.toggleLight(lightNum)
                }
            }
        }
    }
}
