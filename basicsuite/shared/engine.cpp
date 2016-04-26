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
#include "engine.h"
#include <QGuiApplication>
#include <QScreen>

DummyEngine::DummyEngine(QObject *parent)
    : QObject(parent)
{
    QScreen *screen = QGuiApplication::primaryScreen();
    m_screenSize = screen->size();
    m_dpcm = screen->physicalDotsPerInchY() / 2.54f;

    // Make the buttons smaller for smaller screens to compensate for that
    // one typically holds it nearer to the eyes.
    float low = 5;
    float high = 20;
    float screenSizeCM = qMax<float>(qMin(m_screenSize.width(), m_screenSize.height()) / m_dpcm, low);
    m_dpcm *= (screenSizeCM - low) / (high - low) * 0.5 + 0.5;
    m_screenWidth = m_screenSize.width();
    m_screenHeight = m_screenSize.height();
}
