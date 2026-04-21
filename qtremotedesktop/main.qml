// Copyright (C) 2026 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
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
                }
            }
        }
    }

    IviApplication {
        onIviSurfaceCreated: {
            iviSurface.sendConfigure(Qt.size(Screen.desktopAvailableWidth, Screen.desktopAvailableHeight))
            shellSurfaces.append({shellSurface: iviSurface});
        }
    }

    ListModel { id: shellSurfaces }
}
