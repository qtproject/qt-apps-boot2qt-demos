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
    property vector3d accel
    property real roll: Math.atan(-accel.x / accel.y)
    property real pitch: Math.atan(accel.z / accel.y)

    property real squareSize: Math.min(width, height)
    Item {
        clip: true
        width: squareSize
        height: squareSize
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Item {
            id: rollDisplay
            anchors.fill: parent

            rotation: main.roll * (180/Math.PI)

            Item {
                id: pitchDisplay
                width: parent.width
                height: parent.height

                property real sensorDegToHeightRatio: 1/50 * height
                property real heightFor90Degrees: 90 * sensorDegToHeightRatio
                y: main.pitch * (180/Math.PI) * sensorDegToHeightRatio

                Rectangle {
                    id: sky
                    y: -height
                    width: parent.width
                    height: pitchDisplay.heightFor90Degrees + parent.height / 2
                    color: '#66B2FF'
                }
                Rectangle {
                    id: ground
                    y: parent.height
                    width: parent.width
                    height: pitchDisplay.heightFor90Degrees + parent.height / 2
                    color: '#664000'
                }
                Canvas {
                    anchors.fill: parent

                    function drawGraduation(ctx, lineHalfWidth, centerX, y) {
                        ctx.beginPath()
                        ctx.moveTo(centerX - lineHalfWidth, y)
                        ctx.lineTo(centerX + lineHalfWidth, y)
                        ctx.stroke();
                    }
                    onPaint: {
                        var ctx = getContext('2d')
                        var centerX = width / 2
                        var centerY = height / 2

                        ctx.fillStyle = sky.color
                        var grd = ctx.createLinearGradient(0, 0, 0, centerY);
                        grd.addColorStop(0, sky.color);
                        grd.addColorStop(1, Qt.darker(sky.color, 1.5));
                        ctx.fillStyle = grd;
                        ctx.fillRect(0, 0, width, centerY)
                        ctx.fillStyle = ground.color
                        var grd = ctx.createLinearGradient(0, centerY, 0, height);
                        grd.addColorStop(0, Qt.lighter(ground.color, 1.5));
                        grd.addColorStop(1, ground.color);
                        ctx.fillStyle = grd;
                        ctx.fillRect(0, centerY, width, height)

                        // Horizon line
                        ctx.strokeStyle = 'white'
                        ctx.lineWidth = 4
                        ctx.moveTo(0, centerY)
                        ctx.lineTo(width, centerY)
                        ctx.stroke();

                        // Graduation
                        var lineHalfWidth = width / 16
                        var shortLineHalfWidth = width / 32
                        ctx.lineWidth = 2
                        drawGraduation(ctx, lineHalfWidth, centerX, centerY - 5 * pitchDisplay.sensorDegToHeightRatio)
                        drawGraduation(ctx, lineHalfWidth*1.5, centerX, centerY - 10 * pitchDisplay.sensorDegToHeightRatio)
                        drawGraduation(ctx, lineHalfWidth, centerX, centerY + 5 * pitchDisplay.sensorDegToHeightRatio)
                        drawGraduation(ctx, lineHalfWidth*1.5, centerX, centerY + 10 * pitchDisplay.sensorDegToHeightRatio)
                        ctx.lineWidth = 1
                        drawGraduation(ctx, shortLineHalfWidth, centerX, centerY - 2.5 * pitchDisplay.sensorDegToHeightRatio)
                        drawGraduation(ctx, shortLineHalfWidth, centerX, centerY - 7.5 * pitchDisplay.sensorDegToHeightRatio)
                        drawGraduation(ctx, shortLineHalfWidth, centerX, centerY + 2.5 * pitchDisplay.sensorDegToHeightRatio)
                        drawGraduation(ctx, shortLineHalfWidth, centerX, centerY + 7.5 * pitchDisplay.sensorDegToHeightRatio)
                    }
                }
            }
            Canvas {
                id: rollFrame
                property real holeRadius: width * 0.8 / 2
                anchors.fill: parent
                function drawLineToRadian(ctx, centerX, centerY, radian, radius) {
                    ctx.beginPath()
                    ctx.moveTo(centerX, centerY)
                    var x = radius * Math.cos(radian) + centerX
                    var y = -radius * Math.sin(radian) + centerY
                    ctx.lineTo(x, y)
                    ctx.stroke();
                }
                onPaint: {
                    var ctx = getContext('2d')
                    ctx.save()
                    var grd = ctx.createLinearGradient(0, 0, width, height);
                    grd.addColorStop(0, '#404040');
                    grd.addColorStop(1, '#202020');
                    ctx.fillStyle = grd;
                    ctx.fillRect(0, 0, width, height)

                    ctx.strokeStyle = 'white'
                    ctx.lineWidth = 4
                    ctx.moveTo(0, height / 2)
                    ctx.lineTo(width, height / 2)
                    ctx.stroke();

                    var centerX = width / 2
                    var centerY = height / 2
                    var longRadius = width / 2
                    var mediumRadius = width * 0.95 / 2
                    var shortRadius = width * 0.9 / 2
                    ctx.strokeStyle = 'white'
                    ctx.lineWidth = 4
                    drawLineToRadian(ctx, centerX, centerY, Math.PI*0/6, longRadius)
                    drawLineToRadian(ctx, centerX, centerY, Math.PI*1/6, mediumRadius)
                    drawLineToRadian(ctx, centerX, centerY, Math.PI*2/6, mediumRadius)
                    drawLineToRadian(ctx, centerX, centerY, Math.PI*3/6, longRadius)
                    drawLineToRadian(ctx, centerX, centerY, Math.PI*4/6, mediumRadius)
                    drawLineToRadian(ctx, centerX, centerY, Math.PI*5/6, mediumRadius)
                    drawLineToRadian(ctx, centerX, centerY, Math.PI*6/6, longRadius)
                    ctx.lineWidth = 1
                    drawLineToRadian(ctx, centerX, centerY, Math.PI*7/18, shortRadius)
                    drawLineToRadian(ctx, centerX, centerY, Math.PI*8/18, shortRadius)
                    drawLineToRadian(ctx, centerX, centerY, Math.PI*10/18, shortRadius)
                    drawLineToRadian(ctx, centerX, centerY, Math.PI*11/18, shortRadius)

                    // Punch a hole for the pitch display
                    ctx.lineWidth = 4
                    var grd = ctx.createLinearGradient(0, 0, width, height);
                    grd.addColorStop(0, '#474747');
                    grd.addColorStop(1, '#272727');
                    ctx.strokeStyle = grd;
                    ctx.fillStyle = 'transparent'
                    ctx.globalCompositeOperation = 'copy'
                    ctx.beginPath()
                    ctx.arc(width / 2, height / 2, holeRadius, 0, 2*Math.PI)
                    ctx.closePath()
                    ctx.fill();
                    ctx.stroke();

                    // Stroke the hole again, but only for the shadow this time.
                    // Keep only pixels within the transparent hole.
                    ctx.globalCompositeOperation = 'destination-over'
                    ctx.shadowBlur = 3;
                    ctx.shadowColor = "#ff000000";
                    ctx.shadowOffsetX = ctx.shadowOffsetY = ctx.lineWidth / 2
                    ctx.stroke();
                    ctx.restore()
                }
            }
        }
        Canvas {
            id: frame
            anchors.fill: parent
            onPaint: {
                var ctx = getContext('2d')
                var centerX = width / 2
                var centerY = height / 2
                var holeHalfWidth = width / 2
                ctx.save()
                ctx.fillStyle = '#101010'
                ctx.fillRect(x, y, width, height)

                // Punch a hole to see layers under.
                ctx.strokeStyle = '#272727'
                ctx.fillStyle = 'transparent'
                ctx.globalCompositeOperation = 'copy'
                ctx.beginPath();
                ctx.arc(centerX, centerY, holeHalfWidth, 0, 2*Math.PI);
                ctx.fill();
                ctx.stroke();
                ctx.globalCompositeOperation = 'source-over'

                // Shadow for the cross and arrow
                ctx.shadowBlur = 3;
                ctx.shadowColor = "#70000000";
                ctx.shadowOffsetX = ctx.shadowOffsetY = 3

                // The center cross
                var crossHalfWidth = width / 4
                ctx.strokeStyle = 'yellow'
                ctx.lineCap="round";
                ctx.beginPath();
                ctx.lineWidth = 3
                ctx.moveTo(centerX, centerY - crossHalfWidth)
                ctx.lineTo(centerX, centerY + crossHalfWidth)
                ctx.stroke();
                ctx.moveTo(centerX - crossHalfWidth, centerY)
                ctx.lineTo(centerX + crossHalfWidth, centerY)
                ctx.stroke();

                // The arrow the the roll scale
                var arrowHalfWidth = width / 64
                var arrowHeight = height / 16
                var arrowTop = centerY - rollFrame.holeRadius - arrowHeight / 3
                ctx.fillStyle = 'white'
                ctx.beginPath();
                ctx.moveTo(centerX, arrowTop);
                ctx.lineTo(centerX - arrowHalfWidth, arrowTop + arrowHeight);
                ctx.lineTo(centerX + arrowHalfWidth, arrowTop + arrowHeight);
                ctx.fill();
                ctx.restore()
            }
        }
    }
}
