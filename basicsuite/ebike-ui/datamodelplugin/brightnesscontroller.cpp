/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the E-Bike demo project.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include <QFile>

#include "brightnesscontroller.h"

static const char brightnessSource[] = "/sys/class/backlight/backlight/brightness";
static const int brightnessMax = 6;
static const int brightnessMin = 1;

BrightnessController::BrightnessController(QObject *parent)
    : QObject(parent)
    , m_automatic(false)
{
    QFile brightnessfile(brightnessSource);
    if (brightnessfile.exists() && brightnessfile.open(QIODevice::ReadOnly)) {
        char data[1];
        if (brightnessfile.read(data, 1)) {
            m_brightness = static_cast<int>(data[0] - '0');
        }
    } else {
        // By default set to half
        m_brightness = (brightnessMax + brightnessMin) / 2;
    }
}

void BrightnessController::setBrightness(int brightness)
{
    if (m_brightness == brightness)
        return;

    // Valid values are between 1-6
    if (brightness < brightnessMin || brightness > brightnessMax)
        return;

    QFile brightnessfile(brightnessSource);
    if (brightnessfile.exists() && brightnessfile.open(QIODevice::WriteOnly)) {
        char data[1] = {static_cast<char>('0' + brightness)};
        if (brightnessfile.write(data, 1) == 1) {
            m_brightness = brightness;
            emit brightnessChanged(m_brightness);
        }
    } else {
        // File does not exists, simulate changes
        m_brightness = brightness;
        emit brightnessChanged(m_brightness);
    }
}

void BrightnessController::setAutomatic(bool automatic)
{
    if (m_automatic == automatic)
        return;

    m_automatic = automatic;
    emit automaticChanged(m_automatic);
}
