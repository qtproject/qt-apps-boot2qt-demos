/****************************************************************************
**
** Copyright (C) 2013 Digia Plc
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
#ifndef ENGINE_H
#define ENGINE_H

#include <QObject>
#include <QSize>

class QQmlEngine;
class QQuickItem;
class FpsCounter;
class QQuickWindow;

/*!
    A simplified version of the one used by b2qt-launcher
*/
class DummyEngine : public QObject
{
    Q_OBJECT

public:
    explicit DummyEngine(QObject *parent = 0);

    Q_INVOKABLE int smallFontSize() const { return qMax<int>(m_dpcm * 0.4, 10); }
    Q_INVOKABLE int fontSize() const { return qMax<int>(m_dpcm * 0.6, 14); }
    Q_INVOKABLE int titleFontSize() const { return qMax<int>(m_dpcm * 0.9, 20); }
    Q_INVOKABLE int centimeter() const { return m_dpcm; }

private:
    QSize m_screenSize;
    qreal m_dpcm;
};

#endif // ENGINE_H
