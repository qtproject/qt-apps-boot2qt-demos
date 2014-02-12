/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://qt.digia.com
**
** This file is part of Qt Enterprise Embedded.
**
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://qt.digia.com
**
****************************************************************************/
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
}
