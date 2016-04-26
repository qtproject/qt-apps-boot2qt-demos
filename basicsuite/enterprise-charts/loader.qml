/******************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
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

import QtQuick 2.0

Item {
    id: container
    width: 600
    height: 400
    Component.onCompleted: {
    var co = Qt.createComponent("main.qml")
    if (co.status == Component.Ready) {
            var o = co.createObject(container)
        } else {
            console.log(co.errorString())
            console.log("QtCharts 2.0 not available")
            console.log("Please use correct QML_IMPORT_PATH export")
         }
    }
}
