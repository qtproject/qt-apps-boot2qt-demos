/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://www.qt.io
**
** This file is part of Qt Enterprise Embedded.
**
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://www.qt.io
**
****************************************************************************/
#ifndef ENGINE_H
#define ENGINE_H

#include <QObject>
#include <QSize>
#include <QString>
#include <QUrl>

/*!
    A simplified version of the one used by b2qt-launcher
*/
class DummyEngine : public QObject
{
    Q_OBJECT

public:
    explicit DummyEngine(QObject *parent = 0);

    Q_INVOKABLE QUrl fromUserInput(const QString &userInput) { return QUrl::fromUserInput(userInput); }
    Q_INVOKABLE int smallFontSize() const { return qMax<int>(m_dpcm * 0.4, 10); }
    Q_INVOKABLE int fontSize() const { return qMax<int>(m_dpcm * 0.6, 14); }
    Q_INVOKABLE int titleFontSize() const { return qMax<int>(m_dpcm * 0.9, 20); }
    Q_INVOKABLE int centimeter(int val = 1) const { return (m_dpcm * val); }
    Q_INVOKABLE int mm(int val) const { return (int)(m_dpcm * val * 0.1); }
    Q_INVOKABLE int screenWidth() const { return m_screenWidth; }
    Q_INVOKABLE int screenHeight() const { return m_screenHeight; }

private:
    QSize m_screenSize;
    qreal m_dpcm;
    int m_screenWidth, m_screenHeight;
};

#endif // ENGINE_H
