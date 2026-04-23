// Copyright (C) 2026 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.VirtualKeyboard
import QtWayland.Compositor
import QtWayland.Compositor.IviApplication
import QtVncServer

WaylandCompositor {
    WaylandOutput {
        sizeFollowsWindow: true
        window: Window {
            width: Screen.desktopAvailableWidth
            height: Screen.desktopAvailableHeight
            visible: true

            VncItem {
                id: vncItem
                anchors.fill: parent
                Rectangle {
                    id: sourceRect
                    anchors.fill: parent
                    color: "black"
                    Repeater {
                        model: shellSurfaces
                        ShellSurfaceItem {
                            shellSurface: modelData
                            onSurfaceDestroyed: shellSurfaces.remove(index)
                        }
                    }
                    InputPanel {
                        visible: active
                        y: active ? parent.height - height : parent.height
                        anchors.left: parent.left
                        anchors.right: parent.right
                    }
                }
            }
        }
    }

    TextInputManager {}
    QtTextInputMethodManager {}

    IviApplication {
        onIviSurfaceCreated: function(iviSurface) {
            iviSurface.sendConfigure(Qt.size(Screen.desktopAvailableWidth, Screen.desktopAvailableHeight))
            shellSurfaces.append({shellSurface: iviSurface});
        }
    }

    ListModel { id: shellSurfaces }
}
