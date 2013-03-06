import QtQuick 2.0
import Qt.labs.presentation 1.0

Slide {
    id: slide

    title: "Qt WebKit - WebView"

    Loader {
        id: webkitLoader

        anchors.fill: parent

        source: "WebKitSlideContent.qml"
    }

    centeredText: webkitLoader.status == Loader.Error ? "Qt WebKit not installed or otherwise failed to load" : ""
}

