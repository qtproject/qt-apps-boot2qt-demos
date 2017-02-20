/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
#ifndef SERIESSTORAGE_H
#define SERIESSTORAGE_H

#include "dataproviderpool.h"

#include <QObject>
#include <QtCharts/QtCharts>

QT_CHARTS_USE_NAMESPACE

class SeriesStorage : public QObject
{
    Q_OBJECT
public:
    explicit SeriesStorage(QObject *parent = nullptr);

    void setDataProviderPool(DataProviderPool *pool);
    Q_INVOKABLE void setTemperatureSeries(QAbstractSeries *series);
    Q_INVOKABLE void setGyroSeries(QAbstractSeries *xSeries, QAbstractSeries *ySeries,
                       QAbstractSeries *zSeries);
    Q_INVOKABLE void setMagnetoMeterSeries(QAbstractSeries *xSeries, QAbstractSeries *ySeries,
                       QAbstractSeries *zSeries);
signals:

public slots:
    void dataProviderPoolChanged();

    void changeRotationSeries();
    void changeMagnetoSeries();
    void changeTemperatureSeries();

private:
    DataProviderPool *m_providerPool;
    SensorTagDataProvider *m_temperatureProvider{0};
    SensorTagDataProvider *m_gyroProvider{0};
    SensorTagDataProvider *m_magnetoProvider{0};
    QSplineSeries *m_gyroX{0};
    QSplineSeries *m_gyroY{0};
    QSplineSeries *m_gyroZ{0};
    QLineSeries *m_magnetoX{0};
    QLineSeries *m_magnetoY{0};
    QLineSeries *m_magnetoZ{0};
    QLineSeries *m_temperature{0};
    QList<QPointF> m_gyroListX;
    QList<QPointF> m_gyroListY;
    QList<QPointF> m_gyroListZ;
    QList<QPointF> m_magnetoListX;
    QList<QPointF> m_magnetoListY;
    QList<QPointF> m_magnetoListZ;
    QList<QPointF> m_temperatureList;

};

#endif // SERIESSTORAGE_H
