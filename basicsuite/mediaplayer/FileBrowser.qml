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
import Qt.labs.folderlistmodel 2.0
import QtQuick.Controls 1.4
import QtDeviceUtilities.QtButtonImageProvider 1.0

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
            color: defaultBackground
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
                        font.family: appFont
                        color: view.currentIndex === index ? defaultGreen : "white"
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
                color: defaultBackground
                id: titleBar

                QtButton {
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
                    color: "white"
                    elide: Text.ElideLeft
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: backButton.height * .8
                    font.family: appFont
                }

                QtButton {
                    id: cancelButton
                    text: qsTr("Cancel")
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width * .05
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: fileBrowser.selectFile("")
                }

                Rectangle {
                    width: parent.width
                    anchors.bottom: parent.bottom
                    height: 2
                    color: defaultGrey
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
