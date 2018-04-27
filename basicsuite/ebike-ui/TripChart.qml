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
import QtCharts 2.2
import DataStore 1.0

import "./BikeStyle"

ChartView {
    property var exampleTrips: [
        [[0, 0], [15, 250], [30, 0], [30, 0], [25, 450], [20, 400], [10, 200], [10, 200], [20, 350], [20, 300], [10, 200], [10, 100], [10, 100], [10, 175], [10, 150], [15, 200], [15, 250], [10, 200], [15, 250], [0, 0]],
        [[0, 0], [5, 100], [10, 200], [10, 200], [10, 150], [15, 250], [15, 275], [15, 200], [20, 350], [5, 50], [15, 200], [15, 250], [15, 225], [20, 300], [25, 425], [25, 400], [15, 200], [8, 125], [10, 175], [0, 0]],
        [[0, 0], [20, 375], [15, 250], [15, 300], [15, 275], [0, 0], [10, 200], [10, 100], [10, 100], [15, 250], [10, 200], [10, 100], [10, 100], [8, 100], [25, 50], [15, 200], [15, 250], [10, 200], [8, 100], [0, 0]],
        [[0, 0], [15, 300], [15, 200], [15, 250], [10, 450], [20, 375], [20, 350], [20, 250], [15, 200], [15, 225], [8, 150], [8, 100], [8, 125], [8, 100], [10, 150], [15, 200], [15, 250], [20, 300], [15, 250], [0, 0]]
    ]
    property bool animationRunning: false
    property int currentIndex
    property var tripDetails

    id: tripChart
    antialiasing: true
    backgroundColor: "transparent"
    backgroundRoundness: 0
    title: ""
    legend {
        markerShape: Legend.MarkerShapeCircle
        reverseMarkers: true
        labelColor: "#ffffff"
        font {
            family: "Montserrat, Regular"
            weight: Font.Normal
            pixelSize: UILayout.chartLegendTextSize
        }
    }

    margins {
        top: 0
        bottom: 0
        left: 0
        right: 0
    }

    // X-axis is a timestamp value
    DateTimeAxis {
        id: axisX
        format: Qt.locale("en_US").timeFormat(Locale.ShortFormat)
        tickCount: 3
        // No grid and no line
        gridVisible: false
        lineVisible: false
        titleVisible: false
        labelsColor: Colors.chartTimeLabel
        labelsFont {
            family: "Montserrat, Light"
            weight: Font.Light
            pixelSize: UILayout.chartTimeLabelSize
        }
    }

    ValueAxis {
        id: speedAxis
        min: 0
        max: 50
        gridLineColor: Colors.chartGridLine
        labelsColor: Colors.chartSpeed
        labelsFont {
            family: "Montserrat, Regular"
            weight: Font.Normal
            pixelSize: UILayout.chartSpeedLabelSize
        }
        titleVisible: false
        lineVisible: false
        labelFormat: "%.0f"
    }

    ValueAxis {
        id: assistAxis
        min: 0
        max: 500
        labelsColor: Colors.chartAssistpower
        labelsFont {
            family: "Montserrat, Regular"
            weight: Font.Normal
            pixelSize: UILayout.chartAssistpowerLabelSize
        }
        titleVisible: false
        lineVisible: false
        gridVisible: false
        labelFormat: "%.0f"
    }

    SplineSeries {
        id: assistSeries
        name: qsTr("Pedal assist (W)")

        axisX: axisX
        axisYRight: assistAxis
        pointsVisible: true
    }

    SplineSeries {
        id: speedSeries
        name: datastore.unit === DataStore.Kmh ? qsTr("Speed (km/h)") : qsTr("Speed (mph)")

        axisX: axisX
        axisY: speedAxis
        pointsVisible: true
    }

    function updateTripGraph() {
        if (currentIndex === 0 ) {
            // Clear all current values (resets the graph)
            speedSeries.removePoints(0, speedSeries.count);
            assistSeries.removePoints(0, assistSeries.count);
        } else if (currentIndex > 0) {
            // Clear all current values
            speedSeries.removePoints(0, speedSeries.count);
            assistSeries.removePoints(0, assistSeries.count);
            var seriesdata = exampleTrips[currentIndex % 4];

            var now = tripDetails.starttime * 1000;
            var duration = tripDetails.duration / seriesdata.length;

            axisX.min = new Date(now - 60000);
            for (var i = 0; i < seriesdata.length; i++) {
                speedSeries.append(now, seriesdata[i][0]);
                assistSeries.append(now, seriesdata[i][1]);
                now += duration * 1000;
            }
            now -= duration * 1000;
            axisX.max = new Date(now + 60000);
        }
    }

    onTripDetailsChanged: updateTripGraph()

    onCurrentIndexChanged: updateTripGraph()

    // Make sure we have a proper value here
    onAnimationRunningChanged: tripAnimationTimer.lastUpdate = new Date().getTime()

    Timer {
        id: tripAnimationTimer
        property real lastUpdate: new Date().getTime()
        property int currentIndex: 0
        property var values: [[0, 0],
            [10, 200],
            [15, 250],
            [15, 250],
            [8, 150],
            [5, 100],
            [20, 400],
            [20, 375],
            [15, 275],
            [15, 250],
            [25, 450],
            [15, 200],
            [15, 200],
            [10, 175],
            [10, 150],
            [5, 100],
            [8, 125],
            [10, 200],
            [15, 250],
            [0, 0]]

        // Animate only if visible on screen
        running: animationRunning && (swipeView.currentIndex === 0)
        repeat: true
        interval: 200
        onTriggered: {
            var now = new Date().getTime();
            // Load a few initial numbers if empty
            if (speedSeries.count === 0) {
                speedSeries.append(now, values[0][0]);
                assistSeries.append(now, values[0][1]);
                speedSeries.append(now + 5000, values[1][0]);
                assistSeries.append(now + 5000, values[1][1]);
                speedSeries.append(now + 10000, values[2][0]);
                assistSeries.append(now + 10000, values[2][1]);
                speedSeries.append(now + 15000, values[3][0]);
                assistSeries.append(now + 15000, values[3][1]);
                currentIndex = 4;
            }

            if (now - lastUpdate > 5000) {
                speedSeries.append(now + 15000, values[currentIndex][0]);
                assistSeries.append(now + 15000, values[currentIndex][1]);
                if (speedSeries.count > 17)
                    speedSeries.remove(0);
                if (assistSeries.count > 17)
                    assistSeries.remove(0);
                currentIndex += 1;
                if (currentIndex == 20)
                    currentIndex = 0;
                lastUpdate = now;
            }
            axisX.min = new Date(now - 50 * 1000);
            axisX.max = new Date(now);
        }
    }
}
