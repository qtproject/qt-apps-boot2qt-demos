import QtQuick 2.0
import QtMultimedia 5.0

MouseArea {
    id: focusRoot

    signal searchAndLock

    onClicked: {
        camera.focus.focusPointMode = Camera.FocusPointCustom
        camera.focus.customFocusPoint = viewfinder.mapPointToSourceNormalized(Qt.point(mouse.x, mouse.y))
        focusRoot.searchAndLock()
    }

    Item {
        id: zones
        anchors.fill: parent

        property color focusAreaColor
        property real focusAreaScale: 1

        Repeater {
            model: camera.focus.focusZones

            Rectangle {
                border {
                    width: Math.round(2 * root.contentScale)
                    color: zones.focusAreaColor
                }
                radius: 8 * root.contentScale
                color: "transparent"
                scale: zones.focusAreaScale

                // Map from the relative, normalized frame coordinates
                property rect mappedRect: viewfinder.mapNormalizedRectToItem(area);

                Connections {
                    target: viewfinder
                    onContentRectChanged: {
                        mappedRect = viewfinder.mapNormalizedRectToItem(area);
                    }
                }

                x: mappedRect.x - (width - mappedRect.width) / 2
                y: mappedRect.y - (height - mappedRect.height) / 2
                width: Math.round(120 * root.contentScale)
                height: width

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -1.5
                    color: "transparent"
                    border.width: 1
                    border.color: "black"
                    radius: parent.radius + 2
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1 + parent.border.width / 2 + 0.5
                    color: "transparent"
                    border.width: 1
                    border.color: "black"
                    radius: parent.radius - 3
                }
            }
        }

        states: [
            State {
                name: "unlocked"; when: camera.lockStatus === Camera.Unlocked
                PropertyChanges { target: zones; opacity: 0; focusAreaColor: "red" }
            },
            State {
                name: "searching"; when: camera.lockStatus === Camera.Searching
                PropertyChanges { target: zones; opacity: 1; focusAreaColor: "white" }
            },
            State {
                name: "locked"; when: camera.lockStatus === Camera.Locked
                PropertyChanges { target: zones; opacity: 0; focusAreaColor: "green" }
            }
        ]

        transitions: [
            Transition {
                to: "searching"
                NumberAnimation { properties: "opacity"; duration: 60 }
                SequentialAnimation {
                    NumberAnimation {
                        target: zones; property: "focusAreaScale"; from: 1; to: 1.3; duration: 150
                    }
                    PauseAnimation { duration: 20 }
                    NumberAnimation {
                        target: zones; property: "focusAreaScale"; easing.period: 1; easing.amplitude: 1.4
                        easing.type: Easing.OutElastic; from: 1.3; to: 1
                        duration: 450
                    }
                }
            },
            Transition {
                from: "searching"
                SequentialAnimation {
                    PauseAnimation { duration: 1500 }
                    NumberAnimation { properties: "opacity"; duration: 60 }
                }
            }

        ]
    }

}
