/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Mobility Components.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://www.qt.io/licensing.  For further information
** use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.0
import Qt.labs.folderlistmodel 2.0
import QtQuick.Controls 1.4

Item {
    id: fileBrowser

    property string folder: "file:///data/videos"

    signal fileSelected(string file)

    function selectFile(file) {
        loader.sourceComponent = undefined
        fileBrowser.fileSelected("file://" + file)
    }

    Loader {
        id: loader
        anchors.fill: parent
    }

    function show() {
        loader.sourceComponent = fileBrowserComponent
    }

    Component {
        id: fileBrowserComponent

        Rectangle {
            id: root
            color: "white"
            property alias folder: folders.folder

            FolderListModel {
                id: folders
                folder: fileBrowser.folder
                nameFilters: [ "*.3g2", "*.3gp", "*.asf", "*.avi", "*.drc", "*.flv", "*.f4v", "*.f4p",
                    "*.f4a", "*.f4b", "*.gif", "*.gifv", "*.m4v", "*.mkv", "*.mng", "*.mov", "*.qt",
                    "*.mp4", "*.m4p", "*.m4v", "*.mpg", "*.mp2", "*.mpeg", "*.mpe", "*.mpv", "*.m2v",
                    "*.mxf", "*.nsv", "*.ogv", "*.ogg", "*.rm", "*.rmvb", "*.roq", "*.svi", "*.vob",
                    "*.webm", "*.wmv", "*.yuv", "*.aa", "*.aac", "*.aax", "*.act", "*.aiff", "*.amr",
                    "*.ape", "*.au", "*.awb", "*.dct", "*.dss", "*.flac", "*.gsm", "*.m4a", "*.m4b",
                    "*.m4p", "*.mp3", "*.mpc", "*.ogg", "*.oga", "*.vox", "*.wav", "*.wma"
                ]
            }

            Component {
                id: folderDelegate

                Item {
                    width: root.width / 5
                    height: width

                    Text {
                        id: nameText
                        anchors { top: parent.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
                        anchors.topMargin:  -parent.height * .2
                        anchors.leftMargin:  parent.width * .1
                        anchors.rightMargin: parent.width * .1
                        anchors.bottomMargin:  -parent.height * .1
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        text: fileName
                        font.pixelSize: parent.height * .1
                        color: view.currentIndex === index ? "#80c342" : "#46484a"
                        elide: Text.ElideRight
                    }

                    Item {
                        id: wrapper

                        function launch() {
                            if (folders.isFolder(index))
                                down(filePath);
                            else
                                fileBrowser.selectFile(filePath)
                        }

                        anchors.fill: parent
                        anchors.margins: parent.width * .1

                        Image {
                            anchors.top: parent.top
                            anchors.topMargin: -view.cellHeight * .2
                            anchors.right: parent.right
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            fillMode: Image.PreserveAspectFit

                            source:  folders.isFolder(index) ? "images/icon_folder.png" : "images/icon_video.png"
                        }

                        MouseArea {
                            id: mouseRegion
                            anchors.fill: parent
                            onClicked: { wrapper.launch() }
                        }
                    }
                }
            }

            GridView {
                id: view
                anchors.top: titleBar.bottom
                anchors.bottom: parent.bottom
                x: 0
                width: parent.width
                model: folders
                delegate: folderDelegate
                cellWidth: root.width / 5
                cellHeight: cellWidth
                focus: true

                Component.onCompleted: forceActiveFocus();

                Keys.onPressed: {
                    if (event.key === Qt.Key_Escape) {
                        fileBrowser.selectFile("")
                    } else if (event.key === Qt.Key_Return) {
                        if (folders.isFolder(view.currentIndex)) {


                            down(folders.get(view.currentIndex, "filePath"))
                        } else {
                            fileBrowser.selectFile(folders.get(view.currentIndex, "filePath"))
                        }

                    } else if (event.key === Qt.Key_Backspace) {
                        up()
                    }
                }
            }

            Rectangle {
                width: parent.width;
                height: 70
                color: "#f6f6f6"
                id: titleBar

                Button {
                    id: backButton
                    text: qsTr("Back")
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * .05
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: up()
                }

                Text {
                    anchors.left: backButton.right;
                    anchors.leftMargin: parent.width * .05
                    anchors.right: cancelButton.left
                    anchors.rightMargin: parent.width * .05
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    text: String(folders.folder).replace("file://", "")
                    color: "#46484a"
                    elide: Text.ElideLeft
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: backButton.height * .8
                }

                Button {
                    id: cancelButton
                    text: qsTr("Cancel")
                    checkable: true
                    checked: true
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width * .05
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: fileBrowser.selectFile("")
                }

                Rectangle {
                    width: parent.width
                    anchors.bottom: parent.bottom
                    height: 2
                    color: "#e4e4e4"
                }
            }

            function down(path) {
                if (folderChangeAnimation.running)
                    return;

                folderChangeAnimation.targetFolder = "file://" + path;
                folderChangeAnimation.direction = "down"
                folderChangeAnimation.restart()
            }

            function up() {
                var path = folders.parentFolder;

                if (path.toString() === "")
                    return;

                if (folderChangeAnimation.running)
                    return;

                folderChangeAnimation.targetFolder = path
                folderChangeAnimation.direction = "up"
                folderChangeAnimation.restart()
            }

            SequentialAnimation {
                id: folderChangeAnimation
                property string targetFolder: ""
                property string direction: "up"

                alwaysRunToEnd: true

                NumberAnimation {
                    target: view
                    property: "x"
                    from: 0
                    to: folderChangeAnimation.direction === "up" ? root.width : -root.width
                    duration: 250
                }

                ScriptAction {
                    script: root.folder = folderChangeAnimation.targetFolder
                }

                NumberAnimation {
                    target: view
                    property: "x"
                    from: folderChangeAnimation.direction === "up" ? -root.width : root.width
                    to: 0
                    duration: 250
                }
            }
        }
    }
}
