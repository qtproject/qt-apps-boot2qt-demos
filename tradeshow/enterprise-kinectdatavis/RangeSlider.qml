/****************************************************************************
**
** Copyright (C) 2015 Digia Plc and/or its subsidiary(-ies).
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
import QtQuick 2.1

Item {
    id: main
    property real minimumValue: 1
    property real maximumValue: 2048
    property real valueSpacing: 50
    property real lowValue: minimumValue
    property real highValue: maximumValue

    implicitHeight: 50
    Component {
        id: handleComponent
        Image {
            property alias touchPoint: lowTouchPoint
            anchors.fill: parent
            source: "handle.png"
            MultiPointTouchArea {
                id: lowTouchArea
                anchors.fill: parent
                touchPoints: [
                    TouchPoint {
                        id: lowTouchPoint
                        property real draggedX: pressed ? sceneX - _startSceneX : 0
                        property real baseX: pressed ? _startBaseX : _handleItem.x
                        property real _startSceneX
                        property real _startBaseX

                        onSceneXChanged: updateHandlesPosFromDrag()
                        onPressedChanged: {
                            _startBaseX = _handleItem.x
                            _startSceneX = lowTouchArea.mapToItem(null, x).x
                        }
                    }
                ]
            }
        }
    }
    Rectangle {
        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
        height: 10
        gradient: Gradient {
            GradientStop { position: 0.0; color: "lightgrey" }
            GradientStop { position: 1.0; color: "grey" }
        }
        radius: 4
    }
    Rectangle {
        anchors { verticalCenter: parent.verticalCenter; left: lowHandle.horizontalCenter; right: highHandle.horizontalCenter }
        height: 20
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#006CD9" }
            GradientStop { position: 1.0; color: "#00407F" }
        }
    }
    Loader {
        id: lowHandle
        property var touchPoint: item.touchPoint

        anchors { top: parent.top; bottom: parent.bottom }
        width: height
        sourceComponent: handleComponent

        property bool _hInvertComponent: false
        property Item _handleItem: this

        onXChanged: if (!_programmaticalChange) lowValue = _convert(lowHandle.x, _minimumLowPos, _maximumLowPos, minimumValue, maximumValue - valueSpacing)
    }
    Loader {
        id: highHandle
        property var touchPoint: item.touchPoint

        anchors { top: parent.top; bottom: parent.bottom }
        width: height
        sourceComponent: handleComponent

        property bool _hInvertComponent: true
        property Item _handleItem: this

        onXChanged: if (!_programmaticalChange) highValue = _convert(highHandle.x, _minimumHighPos, _maximumHighPos, minimumValue + valueSpacing, maximumValue)
    }

    property bool _programmaticalChange: false
    property real _minimumLowPos: -lowHandle.width / 2
    property real _maximumHighPos: main.width - highHandle.width / 2
    property real _maximumLowPos: _maximumHighPos - lowHandle.width
    property real _minimumHighPos: _minimumLowPos + lowHandle.width
    on_MaximumLowPosChanged: updateHandlesPosFromLimits()
    on_MaximumHighPosChanged: updateHandlesPosFromLimits()

    function _convert(src, srcMin, srcMax, dstMin, dstMax) {
        return (src - srcMin) / (srcMax - srcMin) * (dstMax - dstMin) + dstMin
    }
    function updateHandlesPosFromDrag() {
        var lowX, highX;
        if (lowHandle.touchPoint.baseX + lowHandle.touchPoint.draggedX > highHandle.touchPoint.baseX + highHandle.touchPoint.draggedX - lowHandle.width) {
            var overdrag = lowHandle.touchPoint.baseX + lowHandle.touchPoint.draggedX - (highHandle.touchPoint.baseX + highHandle.touchPoint.draggedX - lowHandle.width)
            // Not perfect when only one touch point is pressed, but works well enough.
            var handleOverdragAdj = overdrag / 2
            lowX = lowHandle.touchPoint.baseX  + lowHandle.touchPoint.draggedX - handleOverdragAdj
            highX = highHandle.touchPoint.baseX + highHandle.touchPoint.draggedX + handleOverdragAdj
        } else {
            lowX = lowHandle.touchPoint.baseX + lowHandle.touchPoint.draggedX
            highX = highHandle.touchPoint.baseX + highHandle.touchPoint.draggedX
        }
        if (lowX < _minimumLowPos)
            lowX = _minimumLowPos
        if (highX < lowX + lowHandle.width)
            highX = lowX + lowHandle.width
        if (highX > _maximumHighPos)
            highX = _maximumHighPos
        if (lowX > highX - lowHandle.width)
            lowX = highX - lowHandle.width
        lowHandle.x = lowX
        highHandle.x = highX
    }
    function updateHandlesPosFromLimits() {
        _programmaticalChange = true
        lowHandle.x = _convert(lowValue, minimumValue, maximumValue - valueSpacing, _minimumLowPos, _maximumLowPos)
        highHandle.x = _convert(highValue - valueSpacing, minimumValue, maximumValue - valueSpacing, _minimumHighPos, _maximumHighPos)
        _programmaticalChange = false
    }
}
