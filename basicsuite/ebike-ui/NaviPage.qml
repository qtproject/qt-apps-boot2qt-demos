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
import QtPositioning 5.3
import QtLocation 5.9
import QtQuick.VirtualKeyboard 2.1

import "./BikeStyle"

Page {
    id: mapContainer
    property var startCoordinate: QtPositioning.coordinate(36.131961, -115.153048)
    property var destinationCoordinate: QtPositioning.coordinate(90, 0)
    property var targetPlace
    property real totalDistance
    property real metersPerSecond // This is calculated at the start of a trip
    property real totalTravelTime: totalDistance / metersPerSecond
    property real naviGuideSegmentDistance: 0
    property string naviGuideArrowSource: "images/nav_nodir.png"
    property string naviGuideDistance
    property string naviGuideAddress: "-"
    property alias routeQuery: routeQuery
    property alias routeModel: routeModel
    property alias targetEdit: targetEdit
    property var routeSegmentList
    property var currentSegment
    property int routeSegment
    property int pathSegment

    function resetDemo() {
        // Clear/reset everything
        naviGuideArrowSource = "images/nav_nodir.png"
        naviGuideDistance = "-"
        naviGuideAddress = "-"
        navigation.active = false
        navigationArrowAnimation.stop()
        targetEdit.clear()

        map.focus = true
        routeQuery.clearWaypoints()
        routeModel.reset()
        navigationArrowItem.coordinate = navigation.coordinate
        destinationCoordinate = QtPositioning.coordinate(90, 0)
        map.center = navigation.coordinate
    }

    TextField {
        id: targetEdit
        width: UILayout.naviPageLocationWidth
        height: UILayout.naviPageLocationHeight
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: UILayout.naviPageLocationTopMargin
        }
        background: Rectangle {
            radius: UILayout.naviPageLocationRadius
            implicitWidth: UILayout.naviPageLocationWidth
            implicitHeight: UILayout.naviPageLocationHeight
            border.color: Colors.naviPageSuggestionBorder
            border.width: targetEdit.activeFocus ? 2 : 0
        }
        font {
            family: "Montserrat, Medium"
            weight: Font.Medium
            pixelSize: UILayout.naviPageSearchTextSize
        }
        cursorVisible: !navigation.active
        inputMethodHints: Qt.ImhNoPredictiveText // This should disable lookup on the device

        leftPadding: UILayout.naviPageLocationLeftPadding
        rightPadding: UILayout.naviPageSearchIconMargin + UILayout.naviPageSearchIconWidth
        placeholderText: qsTr("<i>Where do you want to go?</i>")
        z: 1
        autoScroll: false

        // Update search text whenever text is edited
        onTextEdited: suggest.search = text

        // If in navigation mode, disable editing
        readOnly: navigation.active

        Image {
            source: navigation.active ? "images/search_cancel.png" : "images/search.png"
            width: UILayout.naviPageSearchIconWidth
            height: UILayout.naviPageSearchIconHeight
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                rightMargin: UILayout.naviPageSearchIconMargin
            }
            visible: !suggest.loading

            MouseArea {
                anchors.fill: parent
                enabled: navigation.active
                onClicked: {
                    naviGuideArrowSource = "images/nav_nodir.png"
                    naviGuideDistance = "-"
                    naviGuideAddress = "-"
                    navigation.active = false
                    navigationArrowAnimation.stop()
                    targetEdit.clear()
                }
            }
        }

        // Show a busy indicator whenever suggestions are loading
        BusyIndicator {
            width: height
            anchors {
                top: targetEdit.top
                bottom: targetEdit.bottom
                right: targetEdit.right
                rightMargin: UILayout.naviPageSearchIconMargin
            }
            running: suggest.loading
        }

        Image {
            id: naviInputShadow
            source: "images/small_input_box_shadow.png"
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                horizontalCenterOffset: 1
                verticalCenterOffset: 1
            }
            visible: false
            z: -2
        }
    }

    ListView {
        id: targetList
        anchors {
            top: targetEdit.bottom;
            topMargin: UILayout.naviPageSuggestionsOffset
            horizontalCenter: targetEdit.horizontalCenter
        }
        width: UILayout.naviPageLocationWidth
        height: 3 * UILayout.naviPageSuggestionHeight
        model: suggestions
        visible: targetEdit.activeFocus && !navigation.active
        z: 1
        currentIndex: -1

        delegate: Component {
            Rectangle {
                width: parent.width
                height: UILayout.naviPageSuggestionHeight
                color: "white"
                border.color: Colors.naviPageSuggestionsDivider
                border.width: 1

                Text {
                    width: parent.width
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 10
                    elide: Text.ElideRight
                    text: placename
                    color: Colors.naviPageSuggestionText
                    font {
                        family: "Montserrat, Medium"
                        weight: Font.Medium
                        pixelSize: UILayout.naviPageSuggestionTextSize
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: targetList.currentIndex = index
                }
            }
        }

        onCurrentIndexChanged: {
            // Called when the currentIndex is reset, ignore that
            if (targetList.currentIndex == -1)
                return;

            // Get current place name
            targetPlace = model.get(targetList.currentIndex)
            suggestions.addToMostRecent(targetPlace)

            // Reset search
            targetList.currentIndex = -1
            // Update current text
            targetEdit.text = targetPlace.place_name
            // Clear the model and stop any search
            suggestions.clear()
            suggest.stopSuggest()

            targetEdit.cursorPosition = 0
            targetEdit.ensureVisible(1)
            navigation.active = true
            map.focus = true

            destinationCoordinate = QtPositioning.coordinate(targetPlace.center[1], targetPlace.center[0]);
            routeQuery.clearWaypoints()
            routeQuery.addWaypoint(map.center)
            routeQuery.addWaypoint(destinationCoordinate)
            routeQuery.travelModes = RouteQuery.BicycleTravel
            routeQuery.routeOptimizations = RouteQuery.ShortestRoute
            routeModel.update()
        }
    }

    // Zoom and location icons
    NaviButton {
        id: gpsCenter
        anchors {
            top: parent.top
            topMargin: UILayout.naviPageIconTopMargin
            right: parent.right
            rightMargin: UILayout.naviPageIconRightMargin
        }
        iconSource: "images/map_locate.png"
        onClicked: {
            navigationArrowItem.coordinate = navigation.coordinate
            map.center = navigation.coordinate
        }
    }

    NaviButton {
        id: zoomIn
        anchors {
            top: gpsCenter.bottom
            topMargin: UILayout.naviPageIconSpacing
            right: parent.right
            rightMargin: UILayout.naviPageIconRightMargin
        }
        iconSource: "images/map_zoomin.png"
        autoRepeat: true
        onClicked: navigation.zoomlevel += 0.1
    }

    NaviButton {
        id: zoomOut
        anchors {
            top: zoomIn.bottom
            topMargin: UILayout.naviPageIconSpacing
            right: parent.right
            rightMargin: UILayout.naviPageIconRightMargin
        }
        iconSource: "images/map_zoomout.png"
        autoRepeat: true
        onClicked: navigation.zoomlevel -= 0.1
    }

    NaviGuide {
        id: naviGuide
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: root.width * 0.015
            bottomMargin: anchors.rightMargin
        }
        arrowSource: naviGuideArrowSource
        distance: naviGuideDistance
        address: naviGuideAddress
        visible: navigation.active
    }

    NaviTripInfo {
        id: totalTripInfo
        z: 1
        visible: navigation.active
        anchors {
            bottom: parent.bottom
            bottomMargin: UILayout.naviPageTripBottomMargin
            horizontalCenter: parent.horizontalCenter
        }

        remainingDistance: totalDistance
        remainingTravelTime: totalTravelTime
    }

    RouteQuery {
        id: routeQuery
        numberAlternativeRoutes: 0
    }

    function updateNaviGuide(segment, nextsegment) {
        var maneuver = segment.maneuver;
        naviGuideSegmentDistance = maneuver.distanceToNextInstruction;
        navigationArrowAnimation.pathDistance = naviGuideSegmentDistance;
        naviGuideDistance = maneuver.distanceToNextInstruction;

        if (nextsegment) {
            var nextmaneuver = nextsegment.maneuver;
            naviGuideAddress = nextmaneuver.instructionText;
            switch (nextmaneuver.direction) {
                case RouteManeuver.NoDirection:
                    naviGuideArrowSource = "images/nav_nodir.png";
                    break;
                case RouteManeuver.DirectionForward:
                    naviGuideArrowSource = "images/nav_straight.png";
                    break;
                case RouteManeuver.DirectionBearRight:
                    naviGuideArrowSource = "images/nav_bear_r.png";
                    break;
                case RouteManeuver.DirectionLightRight:
                    naviGuideArrowSource = "images/nav_light_right.png";
                    break;
                case RouteManeuver.DirectionRight:
                    naviGuideArrowSource = "images/nav_right.png";
                    break;
                case RouteManeuver.DirectionHardRight:
                    naviGuideArrowSource = "images/nav_hard_r.png";
                    break;
                case RouteManeuver.DirectionUTurnRight:
                    naviGuideArrowSource = "images/nav_uturn_r.png";
                    break;
                case RouteManeuver.DirectionUTurnLeft:
                    naviGuideArrowSource = "images/nav_uturn_l.png";
                    break;
                case RouteManeuver.DirectionHardLeft:
                    naviGuideArrowSource = "images/nav_hard_l.png";
                    break;
                case RouteManeuver.DirectionLeft:
                    naviGuideArrowSource = "images/nav_left.png";
                    break;
                case RouteManeuver.DirectionLightLeft:
                    naviGuideArrowSource = "images/nav_light_left.png";
                    break;
                case RouteManeuver.DirectionBearLeft:
                    naviGuideArrowSource = "images/nav_bear_l.png";
                    break;
            }
        } else {
            naviGuideAddress = "-";
            naviGuideArrowSource = "images/nav_nodir.png";
        }
    }

    function setNextAnimation() {
        if (!navigation.active)
            return;
        var position = QtPositioning.coordinate(currentSegment.maneuver.position.longitude,
                                                currentSegment.maneuver.position.latitude);

        // Update the navigation instructions
        if (pathSegment === 0) {
            var nextSegment = routeSegmentList[routeSegment + 1];
            updateNaviGuide(currentSegment, nextSegment);
        }

        var startPos = navigationArrowItem.coordinate;
        var path = currentSegment.path;
        pathSegment += 1;
        if (pathSegment >= path.length) {
            routeSegment += 1;
            currentSegment = routeSegmentList[routeSegment];
            if (!currentSegment) {
                naviGuideArrowSource = "images/nav_nodir.png";
                navigation.active = false;
                targetEdit.clear();
                return;
            }
            pathSegment = 0;
            setNextAnimation();
            return;
        }
        var endPos = path[pathSegment];

        // Calculate new direction
        var oldDir = navigationArrowAnimation.rotationDirection;
        var newDir = startPos.azimuthTo(endPos);

        // Calculate the duration of the animation
        var diff = oldDir - newDir;
        if (Math.abs(diff) < 15)
            navigationArrowAnimation.rotationDuration = 0;
        else if (diff < -180)
            navigationArrowAnimation.rotationDuration = (diff + 360) * 5;
        else if (diff > 180)
            navigationArrowAnimation.rotationDuration = (360 - diff) * 5;
        else
            navigationArrowAnimation.rotationDuration = Math.abs(diff) * 5;

        // Set animation details
        var pathDistance = startPos.distanceTo(endPos);
        var nextDistance = navigationArrowAnimation.pathDistance - pathDistance;
        var nextRemainingDistance = navigationArrowAnimation.remainingDistance - pathDistance;
        navigationArrowAnimation.coordinateDuration = pathDistance * 40;
        navigationArrowAnimation.rotationDirection = startPos.azimuthTo(endPos);
        navigationArrowAnimation.pathDistance = nextDistance;
        navigationArrowAnimation.remainingDistance = nextRemainingDistance;
        navigationArrowAnimation.sourceCoordinate = startPos;
        navigationArrowAnimation.targetCoordinate = endPos;
        navigationArrowAnimation.start();
    }

    RouteModel {
        id: routeModel
        plugin: mapbox
        query: routeQuery
        onStatusChanged: {
            if (status === RouteModel.Ready) {
                switch (count) {
                case 0:
                    // technically not an error
                    console.log('mapping error', errorString)
                    break
                case 1:
                    break
                }
            } else if (status === RouteModel.Error) {
                console.log('mapping error', errorString)
            }
        }
        onRoutesChanged: {
            if (count === 0)
                return;
            var route = routeModel.get(0);

            totalDistance = route.distance;
            metersPerSecond = route.distance / route.travelTime;
            navigationArrowAnimation.remainingDistance = route.distance;

            routeManeuverModel.clear();
            currentSegment = route.segments[0];
            routeSegmentList = route.segments;

            routeSegment = 0;
            pathSegment = 0;
            setNextAnimation();
        }
    }

    // Model that is used to display individual instructions
    ListModel {
        id: routeManeuverModel
    }

    Map {
        id: map
        gesture.enabled: true
        anchors.fill: parent
        plugin: mapboxgl

        center: navigation.coordinate
        zoomLevel: navigation.zoomlevel
        bearing: navigation.direction

        onCenterChanged: {
            suggest.center = map.center
        }

        Behavior on bearing {
            RotationAnimation {
                duration: 250
                direction: RotationAnimation.Shortest
            }
        }

        Behavior on center {
            id: centerBehavior
            enabled: true
            CoordinateAnimation { duration: 1500 }
        }

        MapQuickItem {
            id: navigationArrowItem
            z: 3
            coordinate: navigation.routePosition
            anchorPoint.x: navigationArrowImage.width / 2
            anchorPoint.y: navigationArrowImage.height / 2
            sourceItem: Image {
                id: navigationArrowImage
                source: "images/map_location_arrow.png"
                width: 30
                height: 30
            }
        }

        MapQuickItem {
            id: navigationCircleItem
            z: 2
            coordinate: navigation.routePosition
            anchorPoint.x: navigationCircleImage.width / 2
            anchorPoint.y: navigationCircleImage.height / 2
            sourceItem: Image {
                id: navigationCircleImage
                source: "images/blue_circle_gps_area.png"
                width: 100
                height: 100
            }
        }

        MapQuickItem {
            id: destinationQuickItem
            z: 3
            coordinate: destinationCoordinate
            anchorPoint.x: destinationImage.width / 2
            anchorPoint.y: destinationImage.height - 10
            sourceItem: Image {
                id: destinationImage
                source: "images/map_destination.png"
                width: 40
                height: 40
            }
            visible: navigation.active
        }

        MapItemView {
            model: routeModel
            delegate: routeDelegate
        }

        Component {
            id: routeDelegate

            MapRoute {
                id: route
                route: routeData
                line.color: "#3698e8"
                line.width: 6
                smooth: true
                visible: index === 0 // Show only one route (numberAlternativeRoutes not respected yet)
            }
        }

        SequentialAnimation {
            id: navigationArrowAnimation
            property real rotationDuration: 0;
            property real rotationDirection: 0;
            property real coordinateDuration: 0;
            property real pathDistance: 0;
            property real remainingDistance: 0;
            property var sourceCoordinate: navigation.routePosition;
            property var targetCoordinate: startCoordinate;

            RotationAnimation {
                target: map
                property: "bearing"
                duration: navigationArrowAnimation.rotationDuration
                to: navigationArrowAnimation.rotationDirection
                direction: RotationAnimation.Shortest
            }

            ParallelAnimation {
                CoordinateAnimation {
                    target: map
                    property: "center"
                    duration: navigationArrowAnimation.coordinateDuration
                    to: navigationArrowAnimation.targetCoordinate
                }

                CoordinateAnimation {
                    target: navigationArrowItem
                    property: "coordinate"
                    duration: navigationArrowAnimation.coordinateDuration
                    to: navigationArrowAnimation.targetCoordinate
                }

                CoordinateAnimation {
                    target: navigationCircleItem
                    property: "coordinate"
                    duration: navigationArrowAnimation.coordinateDuration
                    to: navigationArrowAnimation.targetCoordinate
                }

                NumberAnimation {
                    target: mapContainer
                    property: "naviGuideDistance"
                    duration: navigationArrowAnimation.coordinateDuration
                    to: navigationArrowAnimation.pathDistance
                }

                NumberAnimation {
                    target: mapContainer
                    property: "totalDistance"
                    duration: navigationArrowAnimation.coordinateDuration
                    to: navigationArrowAnimation.remainingDistance
                }
            }

            onStopped: setNextAnimation()
        }

        MouseArea {
            // Whenever the user taps on the map, move focus to it
            anchors.fill: parent
            onClicked: map.focus = true
        }
    }

    Plugin {
        id: mapboxgl
        name: "mapboxgl"
        PluginParameter {
            name: "mapbox.access_token"
            value: "pk.eyJ1IjoibWFwYm94NHF0IiwiYSI6ImNpd3J3eDE0eDEzdm8ydHM3YzhzajlrN2oifQ.keEkjqm79SiFDFjnesTcgQ"
        }
        PluginParameter {
            name: "mapboxgl.mapping.additional_style_urls"
            value: "mapbox://styles/mapbox/outdoors-v11"
        }
    }
    Plugin {
        id: mapbox
        name: "mapbox"
        PluginParameter {
            name: "mapbox.access_token"
            value: "pk.eyJ1IjoibWFwYm94NHF0IiwiYSI6ImNpd3J3eDE0eDEzdm8ydHM3YzhzajlrN2oifQ.keEkjqm79SiFDFjnesTcgQ"
        }
    }

    states: [
        State {
            name: "";
            when: !navigation.active
            PropertyChanges {
                target: targetEdit
                width: UILayout.naviPageLocationWidth
                anchors.topMargin: UILayout.naviPageLocationTopMargin
                anchors.bottomMargin: 0
            }
            AnchorChanges {
                target: targetEdit
                anchors.top: parent.top
                anchors.bottom: undefined
            }
            PropertyChanges {
                target: naviInputShadow
                visible: false
            }
        },
        State {
            name: "NAVIGATING";
            when: navigation.active
            PropertyChanges {
                target: targetEdit
                width: UILayout.naviPageTripWidth
                anchors.topMargin: 0
                anchors.bottomMargin: UILayout.naviPageTripSearchMargin
            }
            AnchorChanges {
                target: targetEdit
                anchors.top: undefined
                anchors.bottom: totalTripInfo.top
            }
            PropertyChanges {
                target: naviInputShadow
                visible: true
            }
        }
    ]

    transitions: Transition {
        NumberAnimation {
            properties: "width"
            easing.type: Easing.InOutQuad
            duration: 250
        }
        AnchorAnimation {
            duration: 250
        }
    }
}
