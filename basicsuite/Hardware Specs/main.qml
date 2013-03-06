/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/
**
** This file is part of the QML Presentation System.
**
** $QT_BEGIN_LICENSE:LGPL$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation and
** appearing in the file LICENSE.LGPL included in the packaging of this
** file. Please review the following information to ensure the GNU Lesser
** General Public License version 2.1 requirements will be met:
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights. These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU General
** Public License version 3.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of this
** file. Please review the following information to ensure the GNU General
** Public License version 3.0 requirements will be met:
** http://www.gnu.org/copyleft/gpl.html.
**
** Other Usage
** Alternatively, this file may be used in accordance with the terms and
** conditions contained in a signed written agreement between you and Digia.
**
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/


import QtQuick 2.0

import Qt.labs.presentation 1.0

Presentation {
    width: 1280
    height: 720

    BackgroundSwirls {}

    textColor: "white"


    Slide {
        title: "Hardware Specs"
        content: [
            "Asus/Google Nexus 7 tablet",
            " System-on-Chip: Nvidia Tegra 3",
            " CPU: 1.3 GHz quad-core Cortex-A9 (T30L)",
            " GPU: 416 MHz 12-core Nvidia GeForce ULP",
	    " RAM: 1 GB DDR3L",
            "Texas Instruments BeagleBoard-xM",
	    " System-on-Chip: Texas Instruments OMAP3530",
            " CPU: 1 GHz ARM Cortex-A8 core (TI DM3730)",
            " GPU: Imagination Technologies PowerVR SGX 2D/3D",
	    " RAM: 512 MB LPDDR",
        ]
    }

}
