/******************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Enterprise Embedded.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
******************************************************************************/
import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4

RowLayout {
    id: root
    property alias iconSource: icon.source
    property alias titleText: title.text
    property alias smallText: additionalText.text

    Layout.bottomMargin: engine.mm(6)
    spacing: 0

    Image {
        id: icon
        Layout.preferredWidth: mainLayout.width * .05
        Layout.preferredHeight: width * sourceSize.width/sourceSize.height
        source: ""
        fillMode: Image.PreserveAspectFit
        anchors.bottom: parent.bottom
    }

    Label {
        id: title
        text: "Display"
        font.pixelSize: engine.titleFontSize() *.8
        anchors.bottom: parent.bottom
        Layout.leftMargin: mainLayout.defaultMargin * .5
        Layout.preferredWidth: mainLayout.width * .5
    }

    Label {
        id: additionalText
        text: ""
        font.pixelSize: engine.smallFontSize()
        anchors.bottom: parent.bottom
        Layout.fillWidth: true
        elide: Label.ElideRight
    }
}
