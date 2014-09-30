/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://www.qt.io
**
** This file is part of the Qt Enterprise Charts Add-on.
**
** $QT_BEGIN_LICENSE$
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://www.qt.io
** $QT_END_LICENSE$
**
****************************************************************************/

//![1]
import QtQuick 2.0
//![1]

Rectangle {
    width: 600
    height: 400
    property int viewNumber: 1

    Loader {
        id: loader
        anchors.fill: parent
        source: "View" + viewNumber + ".qml";
    }

    Rectangle {
        id: infoText
        anchors.centerIn: parent
        width: parent.width
        height: 40
        color: "black"
        Text {
            color: "white"
            anchors.centerIn: parent
            text: "Use left and right arrow keys or tap on the screen to navigate between chart types"
        }

        Behavior on opacity {
            NumberAnimation { duration: 400 }
        }
    }

    MouseArea {
        focus: true
        anchors.fill: parent
        onClicked: {
            if (infoText.opacity > 0) {
                infoText.opacity = 0.0;
            } else {
                nextView();
            }
        }
        Keys.onPressed: {
            if (infoText.opacity > 0) {
                infoText.opacity = 0.0;
            } else {
                if (event.key == Qt.Key_Left) {
                    previousView();
                } else {
                    // tapping on the screen advances to the next view
                    nextView();
                }
            }
        }
    }

    function nextView() {
        var i = viewNumber + 1;
        if (i > 15)
            viewNumber = 1;
        else
            viewNumber = i;
    }

    function previousView() {
        var i = viewNumber - 1;
        if (i <= 0)
            viewNumber = 15;
        else
            viewNumber = i;
    }
}
