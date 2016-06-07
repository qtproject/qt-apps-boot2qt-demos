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
import QtQuick.VirtualKeyboard 2.0

TextBase {
    id: textField

    property alias color: textInput.color
    property alias text: textInput.text
    property alias textWidth: textInput.width
    property alias readOnly: textInput.readOnly
    property alias inputMethodHints: textInput.inputMethodHints
    property alias validator: textInput.validator
    property alias echoMode: textInput.echoMode
    property int passwordMaskDelay: 1000

    editor: textInput

    Flickable {
        id: flickable

        x: 12
        clip: true
        width: parent.width-24
        height: parent.height
        flickableDirection: Flickable.HorizontalFlick
        interactive: contentWidth - 4 > width

        contentWidth: textInput.width+2
        contentHeight: textInput.height
        TextInput {
            id: textInput

            EnterKeyAction.actionId: textField.enterKeyAction
            EnterKeyAction.label: textField.enterKeyText
            EnterKeyAction.enabled: textField.enterKeyEnabled

            y: 6
            focus: true
            color: "#2B2C2E"
            cursorVisible: activeFocus
            passwordCharacter: "\u2022"
            font.pixelSize: textField.fontPixelSize
            selectionColor: Qt.rgba(0.0, 0.0, 0.0, 0.15)
            selectedTextColor: color
            selectByMouse: true
            width: Math.max(flickable.width, implicitWidth)-2

            Binding {
                target: textInput
                property: "passwordMaskDelay"
                value: textField.passwordMaskDelay
                when: textInput.hasOwnProperty("passwordMaskDelay")
            }
        }
    }
}
