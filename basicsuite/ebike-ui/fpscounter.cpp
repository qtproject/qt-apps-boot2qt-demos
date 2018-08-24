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

#include <QQuickWindow>

#include "fpscounter.h"

FpsCounter::FpsCounter(QObject *parent)
    : QObject(parent)
    , m_frameCounter(0)
    , m_fps(0.0)
    , m_visible(false)
{
}

void FpsCounter::setVisible(bool visible)
{
    if (m_visible == visible)
        return;

    m_visible = visible;
    emit visibleChanged(m_visible);
}

void FpsCounter::setWindow(QQuickWindow *window)
{
    connect(window, &QQuickWindow::frameSwapped, this, &FpsCounter::frameUpdated);
    startTimer(1000);
    m_timer.start();
}

void FpsCounter::timerEvent(QTimerEvent *)
{
    // Calculate new FPS
    qreal newfps = qRound(m_frameCounter * 1000.0 / m_timer.elapsed());
    m_frameCounter = 0;
    m_timer.start();

    // If there is no change, do nothing
    if (qFuzzyCompare(m_fps, newfps))
        return;

    // Otherwise emit new fps
    m_fps = newfps;
    emit fpsChanged(m_fps);
}
