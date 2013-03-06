import QtQuick 2.0

Column {
    id: root

    width: parent.width

    spacing: engine.smallFontSize()

    Title {
        text: "Boot2Qt vs Qt for Android"
    }

    ContentText {
        width: parent.width
        text: "<p>Qt for Android is a port of the Qt Framework to be used
               for application development on the Android platform. Its
               purpose is to enable development of applications that
               can run on Android devices. For developers writing applications
               for the Android ecosystem, Qt for Android is the right choice.

               <p>Boot2Qt tries to strip down the Android stack to the bare minimum,
               relying only on basic Linux features. The majority of the Android stack,
               such as <i>SurfaceFlinger</i> or <i>DalvikVM</i> is not running in
               Boot2Qt, resulting in faster startup times, lower memory consumption
               and overall better performance.
               "
    }

    Column {
        id: diagram
        spacing: 1
        width: parent.width * 0.8
        anchors.horizontalCenter: parent.horizontalCenter
        Box { text: "Application"; accentColor: "coral" }
        Box { text: "Qt for Android"; accentColor: Qt.rgba(0.64, 0.82, 0.15) }
        Row {
            width: parent.width
            height: b.height
            Box { id: b; width: parent.width / 2; text: "Qt Framework"; accentColor: Qt.rgba(0.64, 0.82, 0.15) }
            Box { width: parent.width / 2; text: "Android (Dalvik)"; accentColor: "steelblue" }
        }

        Box { text: "Android Baselayer"; accentColor: "steelblue" }
        Box { text: "Embedded Hardware"; accentColor: "steelblue"}
    }

}
