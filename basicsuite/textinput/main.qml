/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://qt.digia.com/
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

import QtQuick 2.0
import QtQuick.Enterprise.VirtualKeyboard 1.0

Flickable {
    id: flickable

    property real scrollMarginVertical: 20

    anchors.fill: parent
    contentWidth: content.width
    contentHeight: content.height
    interactive: contentHeight > height
    flickableDirection: Flickable.VerticalFlick
    children: ScrollBar {}

    MouseArea  {
        id: content

        width: flickable.width
        height: textEditors.height + 24

        onClicked: focus = true

        Column {
            id: textEditors
            spacing: 15
            x: 12; y: 12
            width: parent.width - 26

            Text {
                color: "#EEEEEE"
                text: "Tap fields to enter text"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 22
            }
            TextField {
                width: parent.width
                previewText: "One line field"
                enterKeyAction: EnterKeyAction.Next
                onEnterKeyClicked: passwordField.focus = true
            }
            TextField {
                id: passwordField

                width: parent.width
                echoMode: TextInput.Password
                previewText: "Password field"
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhPreferLowercase | Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                enterKeyAction: EnterKeyAction.Next
                onEnterKeyClicked: upperCaseField.focus = true
            }
            TextField {
                id: upperCaseField

                width: parent.width
                previewText: "Upper case field"
                inputMethodHints: Qt.ImhUppercaseOnly
                enterKeyAction: EnterKeyAction.Next
                onEnterKeyClicked: lowerCaseField.focus = true
            }
            TextField {
                id: lowerCaseField

                width: parent.width
                previewText: "Lower case field"
                inputMethodHints: Qt.ImhLowercaseOnly
                enterKeyAction: EnterKeyAction.Next
                onEnterKeyClicked: phoneNumberField.focus = true
            }
            TextField {
                id: phoneNumberField

                validator: RegExpValidator { regExp: /^[0-9\+\-\#\*\ ]{6,}$/ }
                width: parent.width
                previewText: "Phone number field"
                inputMethodHints: Qt.ImhDialableCharactersOnly
                enterKeyAction: EnterKeyAction.Next
                onEnterKeyClicked: formattedNumberField.focus = true
            }
            TextField {
                id: formattedNumberField

                width: parent.width
                previewText: "Formatted number field"
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                enterKeyAction: EnterKeyAction.Next
                onEnterKeyClicked: digitsField.focus = true
            }
            TextField {
                id: digitsField

                width: parent.width
                previewText: "Digits only field"
                inputMethodHints: Qt.ImhDigitsOnly
                enterKeyAction: EnterKeyAction.Next
                onEnterKeyClicked: textArea.focus = true
            }
            TextArea {
                id: textArea

                width: parent.width
                previewText: "Multiple lines field"
                height: Math.max(206, implicitHeight)
            }
        }
    }
}
