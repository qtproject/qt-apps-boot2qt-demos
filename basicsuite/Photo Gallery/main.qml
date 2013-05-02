import QtQuick 2.0
import Qt.labs.folderlistmodel 1.0

Item {
    id: root

    width: 320
    height: 480

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    FolderListModel {
        id: imageList
        folder: "/data/images"
        nameFilters: ["*.png", "*.jpg"]

        showDirs: false
    }

    Text {
        id: noImages
        color: "white"
        visible: grid.count == 0
        text: "No images in " + imageList.folder
        anchors.centerIn: parent
    }

    GridView {
        id: grid

        anchors.fill: parent

        cellHeight: root.width / 3
        cellWidth: cellHeight

        model: imageList

//        NumberAnimation on contentY { from: 0; to: 2000; duration: 3000; loops: 1; easing.type: Easing.InOutCubic }

        delegate: Rectangle {

            id: box
            color: "white"
            width: grid.cellWidth
            height: grid.cellHeight
            scale: 0.97
            rotation: 2;
            antialiasing: true

            Rectangle {
                id: sepia
                color: "#b08050"
                width: image.width
                height: image.height
                anchors.centerIn: parent

                property real fakeOpacity: image.status == Image.Ready ? 1.5 : 0
                Behavior on fakeOpacity { NumberAnimation { duration: 1000 } }

                opacity: fakeOpacity
                visible: image.opacity <= 0.99;
                antialiasing: true
            }

            Image {
                id: image
                source: filePath
                width: grid.cellWidth * 0.9
                height: grid.cellHeight * 0.9
                anchors.centerIn: sepia
                asynchronous: true
                opacity: sepia.fakeOpacity - .5
                sourceSize.width: width;
                antialiasing: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.showBigImage(filePath, box.x - grid.contentX, box.y - grid.contentY, image);
                }
            }
        }
    }

    function showBigImage(filePath, itemX, itemY, image) {
        fakeBigImage.x = itemX;
        fakeBigImage.y = itemY;
        fakeBigImage.sourceSize = image.sourceSize;
        fakeBigImage.source = filePath;

        beginEnterLargeAnimation.running = true;
    }

    property int time: 500;
    property real xPos: width < height ? 0 : width / 2 - height / 2;
    property real yPos: width < height ? height / 2 - width / 2: 0;
    property real size: Math.min(width, height);

    states: [
        State { name: "grid" },
        State { name: "enter-large" },
        State { name: "large" },
        State { name: "exit-large" }
    ]

    SequentialAnimation {
        id: beginEnterLargeAnimation
        PropertyAction { target: mouseArea; property: "enabled"; value: "true" }
        PropertyAction { target: fakeBigImage; property: "rotation"; value: 2; }
        PropertyAction { target: fakeBigImage; property: "scale"; value: 0.97 * 0.9; }
        PropertyAction { target: fakeBigImage; property: "width"; value: grid.cellWidth; }
        PropertyAction { target: fakeBigImage; property: "height"; value: grid.cellHeight; }
        PropertyAction { target: fakeBigImage; property: "visible"; value: true; }

        ParallelAnimation {
            NumberAnimation { target: fakeBigImage; property: "rotation"; to: 0; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "scale"; to: 1; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "x"; to: root.xPos; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "y"; to: root.yPos; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "width"; to: root.size; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "height"; to: root.size; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: grid; property: "opacity"; to: 0; duration: root.time; easing.type: Easing.InOutCubic }
        }
        ScriptAction {
            script: {

                bigImage = realBigImageComponent.createObject(root);
                bigImage.source = fakeBigImage.source;
            }
        }
    }

    property Item bigImage;
    property real targetRotation: 0;
    property real targetWidth: 0
    property real targetHeight: 0
    property bool bigImageShowing: false;

    SequentialAnimation {
        id: finalizeEnterLargeAnimation
        ScriptAction { script: {
                fakeBigImage.anchors.centerIn = root;
            }
        }
        ParallelAnimation {
            NumberAnimation { target: bigImage; property: "opacity"; to: 1; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "rotation"; to: root.targetRotation; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: bigImage; property: "rotation"; to: root.targetRotation; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "width"; to: root.targetWidth; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "height"; to: root.targetHeight; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: bigImage; property: "width"; to: root.targetWidth; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: bigImage; property: "height"; to: root.targetHeight; duration: root.time; easing.type: Easing.InOutCubic }
        }
        PropertyAction { target: fakeBigImage; property: "visible"; value: false }
        PropertyAction { target: root; property: "bigImageShowing"; value: true }
    }

    SequentialAnimation {
        id: backToGridAnimation
        ParallelAnimation {
            NumberAnimation { target: bigImage; property: "opacity"; to: 0; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: grid; property: "opacity"; to: 1; duration: root.time; easing.type: Easing.InOutCubic }
        }
        PropertyAction { target: fakeBigImage; property: "source"; value: "" }
        PropertyAction { target: root; property: "bigImageShowing"; value: false }
        PropertyAction { target: mouseArea; property: "enabled"; value: false }
        ScriptAction { script: {
                bigImage.destroy();
                fakeBigImage.anchors.centerIn = undefined
            }
        }
    }

    Image {
        id: fakeBigImage
        width: grid.cellWidth
        height: grid.cellHeight
        visible: false
        antialiasing: true
    }

    Component {
        id: realBigImageComponent

        Image {
            id: realBigImage

            anchors.centerIn: parent;

            asynchronous: true;

            // Bound size to the current display size, to try to avoid any GL_MAX_TEXTURE_SIZE issues.
            sourceSize: Qt.size(Math.max(root.width, root.height), Math.max(root.width, root.height));

            opacity: 0
            onStatusChanged: {

                if (status != Image.Ready)
                    return;

                var imageIsLandscape = width > height;
                var screenIsLandscape = root.width > root.height;

                var targetScale;

                // Rotation needed...
                if (imageIsLandscape != screenIsLandscape && width != height) {
                    root.targetRotation = 90;
                    var aspect = width / height
                    var screenAspect = root.height / root.width

                    if (aspect > screenAspect) {
                        targetScale = root.height / width
                    } else {
                        targetScale = root.width / height;
                    }
                } else {
                    root.targetRotation = 0;
                    var aspect = height / width;
                    var screenAspect = root.height / root.width

                    if (aspect > screenAspect) {
                        targetScale = root.height / height
                    } else {
                        targetScale = root.width / width;
                    }
                }

                root.targetWidth = width * targetScale
                root.targetHeight = height * targetScale;

                width = root.size
                height = root.size;

                finalizeEnterLargeAnimation.running = true;
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: false

        onClicked: {
            if (root.bigImageShowing)
                backToGridAnimation.running = true;
        }
    }

}
