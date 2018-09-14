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

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import DataStore 1.0

import "./BikeStyle"

Item {
    property string selectedComponent: "battery"
    property string bikeImageSource: "images/bike-battery.png"
    property string componentName: "Battery"
    property string componentStatusImageSource: "images/ok.png"
    property color statusLineColor: selectedComponent === "rearwheel" ? Colors.bikeInfoLineWarning : Colors.bikeInfoLineOk
    property int statusLineLength: 280
    property string primaryDetails: "Health"
    property string primaryDetailsValue: "85%"
    property bool primaryDetailsOk: true
    property var activeComponent: batteryCircle
    property real circleRadius: Math.min(parent.height * 0.125, parent.width * 0.125)

    function updateComponent() {
        if (selectedComponent === "")
            bikeImageSource = "images/bike.png";
        else
            bikeImageSource = "images/bike-" + selectedComponent + ".png";

        if (selectedComponent === "battery") {
            componentName = "Battery";
            primaryDetails = "Health";
            primaryDetailsValue = "85%";
            primaryDetailsOk = true;
            statusLineLength = 280;
        } else if (selectedComponent === "brakes") {
            componentName = "Brakes";
            primaryDetails = "Health";
            primaryDetailsValue = "85%";
            primaryDetailsOk = true;
            statusLineLength = 448;
        } else if (selectedComponent === "chain") {
            componentName = "Chain";
            primaryDetails = "Health";
            primaryDetailsValue = "85%";
            primaryDetailsOk = true;
            statusLineLength = 0;
        } else if (selectedComponent === "gears") {
            componentName = "Gears";
            primaryDetails = "Health";
            primaryDetailsValue = "85%";
            primaryDetailsOk = true;
            statusLineLength = 245;
        } else if (selectedComponent === "light") {
            componentName = "Light";
            primaryDetails = "Health";
            primaryDetailsValue = "85%";
            primaryDetailsOk = true;
            statusLineLength = 300;
        } else if (selectedComponent === "frontwheel") {
            componentName = "Front wheel";
            primaryDetails = "Tire pressure";
            primaryDetailsValue = "6.8 bar / 100 psi";
            primaryDetailsOk = true;
            statusLineLength = 340;
        } else if (selectedComponent === "rearwheel") {
            componentName = "Rear wheel";
            primaryDetails = "Tire pressure";
            primaryDetailsValue = "4.0 bar / 58 psi";
            primaryDetailsOk = false;
            statusLineLength = 210;
        }
    }

    Text {
        id: bikeInfoText
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: stackLayout.height * 0.225
        width: parent.width
        text: qsTr("BIKE INFO")
        font {
            family: "Montserrat, Medium"
            weight: Font.Medium
            pixelSize: height * 0.375
        }
        color: Colors.tabTitleColor
        verticalAlignment: Text.AlignVCenter
    }

    ColumnSpacer {
        id: spacer
        anchors.top: bikeInfoText.bottom
        color: Colors.tabItemBorder
    }


    Image {
        id: bikeImage
        anchors {
            top: spacer.bottom
            right: parent.right
            bottom: parent.bottom
        }
        fillMode: Image.PreserveAspectFit
        source: bikeImageSource
    }

    Rectangle {
        id: brakesCircle
        width: circleRadius
        height: circleRadius
        radius: circleRadius * 2
        anchors {
            verticalCenter: bikeImage.top
            verticalCenterOffset: bikeImage.height * 0.2
            horizontalCenter: bikeImage.left
            horizontalCenterOffset: bikeImage.width * 0.63
        }

        color: "transparent"
        border.width: UILayout.bikeInfoLineWidth
        border.color: selectedComponent === "brakes" ? Colors.bikeInfoLineOk : Colors.bikeInfoDeselected

        MouseArea {
            anchors.fill: parent
            onClicked: {
                activeComponent = brakesCircle;
                selectedComponent = "brakes"
                updateComponent()
            }
        }
    }

    Rectangle {
        id: lightCircle
        width: circleRadius
        height: circleRadius
        radius: circleRadius * 2
        anchors {
            verticalCenter: bikeImage.top
            verticalCenterOffset: bikeImage.height * 0.325
            horizontalCenter: bikeImage.left
            horizontalCenterOffset: bikeImage.width * 0.65
        }

        color: "transparent"
        border.width: UILayout.bikeInfoLineWidth
        border.color: selectedComponent === "light" ? Colors.bikeInfoLineOk : Colors.bikeInfoDeselected

        MouseArea {
            anchors.fill: parent
            onClicked: {
                activeComponent = lightCircle;
                selectedComponent = "light"
                updateComponent()
            }
        }
    }

    Rectangle {
        id: batteryCircle
        width: circleRadius
        height: circleRadius
        radius: circleRadius * 2
        anchors {
            verticalCenter: bikeImage.top
            verticalCenterOffset: bikeImage.height * 0.475
            horizontalCenter: bikeImage.left
            horizontalCenterOffset: bikeImage.width * 0.525
        }

        color: "transparent"
        border.width: UILayout.bikeInfoLineWidth
        border.color: selectedComponent === "battery" ? Colors.bikeInfoLineOk : Colors.bikeInfoDeselected

        MouseArea {
            anchors.fill: parent
            onClicked: {
                activeComponent = batteryCircle;
                selectedComponent = "battery"
                updateComponent()
            }
        }
    }

    Rectangle {
        id: gearsCircle
        width: circleRadius
        height: circleRadius
        radius: circleRadius * 2
        anchors {
            verticalCenter: bikeImage.top
            verticalCenterOffset: bikeImage.height * 0.625
            horizontalCenter: bikeImage.left
            horizontalCenterOffset: bikeImage.width * 0.2725
        }

        color: "transparent"
        border.width: UILayout.bikeInfoLineWidth
        border.color: selectedComponent === "gears" ? Colors.bikeInfoLineOk : Colors.bikeInfoDeselected

        MouseArea {
            anchors.fill: parent
            onClicked: {
                activeComponent = gearsCircle;
                selectedComponent = "gears"
                updateComponent()
            }
        }
    }

    Rectangle {
        id: rearWheelCircle
        width: circleRadius
        height: circleRadius
        radius: circleRadius * 2
        anchors {
            verticalCenter: bikeImage.top
            verticalCenterOffset: bikeImage.height * 0.625
            horizontalCenter: bikeImage.left
            horizontalCenterOffset: bikeImage.width * 0.15
        }

        color: "transparent"
        border.width: UILayout.bikeInfoLineWidth
        border.color: selectedComponent === "rearwheel" ? Colors.bikeInfoLineWarning : Colors.bikeInfoDeselected

        MouseArea {
            anchors.fill: parent
            onClicked: {
                activeComponent = rearWheelCircle;
                selectedComponent = "rearwheel"
                updateComponent()
            }
        }

        Image {
            anchors.centerIn: parent
            height: circleRadius * 0.65
            width: height
            source: "images/warning.png"
        }
    }

    Rectangle {
        id: frontWheelCircle
        width: circleRadius
        height: circleRadius
        radius: circleRadius * 2
        anchors {
            verticalCenter: bikeImage.top
            verticalCenterOffset: bikeImage.height * 0.625
            horizontalCenter: bikeImage.left
            horizontalCenterOffset: bikeImage.width * 0.82
        }

        color: "transparent"
        border.width: UILayout.bikeInfoLineWidth
        border.color: selectedComponent === "frontwheel" ? Colors.bikeInfoLineOk : Colors.bikeInfoDeselected

        MouseArea {
            anchors.fill: parent
            onClicked: {
                activeComponent = frontWheelCircle;
                selectedComponent = "frontwheel"
                updateComponent()
            }
        }
    }

    Canvas {
        id: slantedLine
        anchors {
            left: statusLineHorizontal.right
            top: statusLineHorizontal.top
            right: activeComponent.horizontalCenter
            bottom: activeComponent.verticalCenter
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

            // Calculate line length and subtract circle radius
            var lineLength = Math.sqrt(slantedLine.width * slantedLine.width +
                                       slantedLine.height * slantedLine.height);
            lineLength -= UILayout.bikeInfoCircleRadius;

            // Calculate angle
            var angle = Math.atan2(slantedLine.height, slantedLine.width);

            // Calculate new endpoints
            var x = Math.cos(angle) * lineLength;
            var y = Math.sin(angle) * lineLength;

            ctx.lineCap = "round";
            ctx.strokeStyle = statusLineColor;
            ctx.lineWidth = UILayout.bikeInfoLineWidth;
            ctx.beginPath();
            ctx.moveTo(0, 1);
            ctx.lineTo(x, y);
            ctx.stroke();
        }
    }

    Image {
        id: componentStatusImage
        height: circleRadius * 0.9
        width: height
        anchors {
            verticalCenter: componentNameText.verticalCenter
            left: parent.left
        }
        source: componentStatusImageSource
        visible: selectedComponent != ""
    }

    Text {
        id: componentNameText
        anchors {
            top: spacer.bottom
            topMargin: parent.height * 0.0175
            left: componentStatusImage.right
            leftMargin: parent.width * 0.01
        }
        font {
            family: "Montserrat, Medium"
            weight: Font.Medium
            pixelSize: parent.height * 0.075
        }
        color: Colors.bikeInfoComponentHeader
        text: componentName
        visible: selectedComponent != ""
    }

    // The line goes here somehow
    Rectangle {
        id: statusLineHorizontal
        anchors {
            top: componentNameText.baseline
            topMargin: parent.height * 0.03
            left: parent.left
        }
        height: UILayout.bikeInfoLineWidth
        width: statusLineLength
        color: statusLineColor
        visible: selectedComponent != ""
    }

    Text {
        id: primaryDetailsText
        anchors {
            top: statusLineHorizontal.bottom
            topMargin: parent.height * 0.035
            left: parent.left
        }
        font {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: parent.height * 0.065
        }
        color: Colors.bikeInfoComponentText
        text: primaryDetails
        visible: selectedComponent != ""
    }

    Text {
        id: primaryDetailsValueText
        anchors {
            top: primaryDetailsText.bottom
            left: parent.left
        }
        font {
            family: "Montserrat, Medium"
            weight: Font.Medium
            pixelSize: parent.height * 0.065
        }
        color: primaryDetailsOk ? Colors.bikeInfoComponentOk : Colors.bikeInfoComponentWarning
        text: primaryDetailsValue
        visible: selectedComponent != ""
    }

    Text {
        id: lastMaintenanceText
        anchors {
            top: primaryDetailsValueText.bottom
            topMargin: parent.height * 0.03
            left: parent.left
        }
        font {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: parent.height * 0.065
        }
        color: Colors.bikeInfoComponentText
        text: qsTr("Last maintenance")
        visible: selectedComponent != ""
    }

    Text {
        id: lastMaintenanceValueText
        anchors {
            top: lastMaintenanceText.bottom
            left: parent.left
        }
        font {
            family: "Montserrat, Medium"
            weight: Font.Medium
            pixelSize: parent.height * 0.065
        }
        color: Colors.bikeInfoComponentOk
        text: "10/3/2017"
        visible: selectedComponent != ""
    }

    Text {
        id: nextMaintenanceText
        anchors {
            top: lastMaintenanceValueText.bottom
            topMargin: parent.height * 0.03
            left: parent.left
        }
        font {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: parent.height * 0.065
        }
        color: Colors.bikeInfoComponentText
        text: qsTr("Scheduled maintenance")
        visible: selectedComponent != ""
    }

    Text {
        id: nextMaintenanceValueText
        anchors {
            top: nextMaintenanceText.bottom
            left: parent.left
        }
        font {
            family: "Montserrat, Medium"
            weight: Font.Medium
            pixelSize: parent.height * 0.065
        }
        color: Colors.bikeInfoComponentOk
        text: "10/3/2018"
        visible: selectedComponent != ""
    }
}
