/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of Qt for Device Creation.
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
import QtQuick 2.0

Rectangle {
    id: root
    color: _backgroundColor
    property color lineColor: "black"
    property real spacing: 10
    property real sliderHeight: height * 0.4
    property bool isMouseAbove: mouseAboveMonitor.containsMouse

    property ListModel model: ListModel { }

    MouseArea {
        id: mouseAboveMonitor
        anchors.fill: parent
        hoverEnabled: true;
    }

    Component {
        id: editDelegate

        Rectangle {
            id: delegate
            width: parent.width
            height: root.sliderHeight
            color: "transparent"

            Text {
                id: text
                text: name
                color: "white"
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    leftMargin: itemMargin
                    left: parent.left
                }
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: defaultFontSize
                font.capitalization: Font.Capitalize
                font.family: appFont
                width: root.width * 0.2
                fontSizeMode: Text.Fit
            }

            PlayerSlider {
                anchors {
                    verticalCenter: text.verticalCenter
                    verticalCenterOffset: 3
                    left: text.right
                    leftMargin: itemMargin
                    right: parent.right
                    rightMargin: itemMargin
                }
                value: model.value
                onValueChanged: view.model.setProperty(index, "value", value)
            }
        }
    }

    ListView {
        id: view
        anchors.fill: parent
        anchors.margins: 8
        model: root.model
        delegate: editDelegate
        interactive: false
    }
}
