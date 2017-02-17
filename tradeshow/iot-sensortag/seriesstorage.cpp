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
#include "seriesstorage.h"

Q_DECLARE_METATYPE(QAbstractSeries *)
Q_DECLARE_METATYPE(QAbstractAxis *)

inline void updatePoints(QList<QPointF> &list, int newIndex, float newValue, int maxItems)
{
    list.append(QPointF(newIndex, newValue));
    if (list.size() > maxItems)
        list.removeFirst();
}

SeriesStorage::SeriesStorage(QObject *parent) : QObject(parent)
{
    for (int i = 0; i < 30; i++)
        m_temperatureList.append(QPointF(i, 30));
}

void SeriesStorage::setDataProviderPool(DataProviderPool *pool)
{
    m_providerPool = pool;
    if (!m_providerPool)
        return;
    connect(m_providerPool, &DataProviderPool::dataProvidersChanged, this, &SeriesStorage::dataProviderPoolChanged);
}

void SeriesStorage::setTemperatureSeries(QAbstractSeries *series)
{
    m_temperature = qobject_cast<QLineSeries *>(series);
}

void SeriesStorage::setGyroSeries(QAbstractSeries *xSeries, QAbstractSeries *ySeries, QAbstractSeries *zSeries)
{
    m_gyroX = qobject_cast<QSplineSeries *>(xSeries);
    m_gyroY = qobject_cast<QSplineSeries *>(ySeries);
    m_gyroZ = qobject_cast<QSplineSeries *>(zSeries);
}

void SeriesStorage::setMagnetoMeterSeries(QAbstractSeries *xSeries, QAbstractSeries *ySeries, QAbstractSeries *zSeries)
{
    m_magnetoX = qobject_cast<QLineSeries *>(xSeries);
    m_magnetoY = qobject_cast<QLineSeries *>(ySeries);
    m_magnetoZ = qobject_cast<QLineSeries *>(zSeries);
}

void SeriesStorage::dataProviderPoolChanged()
{
    m_gyroProvider = m_providerPool->getProvider(SensorTagDataProvider::Rotation);
    if (m_gyroProvider) {
        connect(m_gyroProvider, &SensorTagDataProvider::rotationValuesChanged, this, &SeriesStorage::changeRotationSeries);
    }

    m_magnetoProvider = m_providerPool->getProvider(SensorTagDataProvider::Magnetometer);
    if (m_magnetoProvider) {
        connect(m_magnetoProvider, &SensorTagDataProvider::magnetometerMicroTChanged, this, &SeriesStorage::changeMagnetoSeries);
    }

    m_temperatureProvider = m_providerPool->getProvider(SensorTagDataProvider::AmbientTemperature);
    if (m_temperatureProvider) {
        connect(m_temperatureProvider, &SensorTagDataProvider::infraredAmbientTemperatureChanged, this, &SeriesStorage::changeTemperatureSeries);
    }
}

void SeriesStorage::changeRotationSeries()
{
    if (!m_gyroX || !m_gyroY || !m_gyroZ)
        return;

    static int gyroSeriesIndex = 0;
    static const int maxGyroReadings = 24;
    static int axisMin = 0;
    static int axisMax = maxGyroReadings + 1;

    updatePoints(m_gyroListX, gyroSeriesIndex, m_gyroProvider->getRotationX(), maxGyroReadings);
    m_gyroX->replace(m_gyroListX);
    updatePoints(m_gyroListY, gyroSeriesIndex, m_gyroProvider->getRotationY(), maxGyroReadings);
    m_gyroY->replace(m_gyroListY);
    updatePoints(m_gyroListZ, gyroSeriesIndex, m_gyroProvider->getRotationZ(), maxGyroReadings);
    m_gyroZ->replace(m_gyroListZ);

    if (gyroSeriesIndex >= maxGyroReadings) {
        QAbstractAxis *axis = m_gyroX->attachedAxes().at(0);
        axisMin++;
        axisMax++;
        axis->setRange(axisMin, axisMax);
    }
    gyroSeriesIndex++;
}

void SeriesStorage::changeMagnetoSeries()
{
    if (!m_magnetoX || !m_magnetoY || !m_magnetoZ)
        return;

    static int magneticSeriesIndex = 0;
    static const int maxMagneticReadings = 24;
    static int axisMin = 0;
    static int axisMax = maxMagneticReadings;

    updatePoints(m_magnetoListX, magneticSeriesIndex, m_magnetoProvider->getMagnetometerMicroT_xAxis(), maxMagneticReadings);
    m_magnetoX->replace(m_magnetoListX);
    updatePoints(m_magnetoListY, magneticSeriesIndex, m_magnetoProvider->getMagnetometerMicroT_yAxis(), maxMagneticReadings);
    m_magnetoY->replace(m_magnetoListY);
    updatePoints(m_magnetoListZ, magneticSeriesIndex, m_magnetoProvider->getMagnetometerMicroT_zAxis(), maxMagneticReadings);
    m_magnetoZ->replace(m_magnetoListZ);

    if (magneticSeriesIndex >= maxMagneticReadings) {
        QAbstractAxis *axis = m_magnetoX->attachedAxes().at(0);
        axisMin++;
        axisMax++;
        axis->setRange(axisMin, axisMax);
    }
    magneticSeriesIndex++;
}

void SeriesStorage::changeTemperatureSeries()
{
    if (!m_temperature)
        return;

    static const int maxTemperatureReadings = 30;
    static int temperatureSeriesIndex = maxTemperatureReadings;
    static int axisMin = 0;
    static int axisMax = maxTemperatureReadings - 1;
    static const int defaultAvgValue = 25;

    m_temperatureList.removeLast();
    m_temperatureList.append(QPointF(temperatureSeriesIndex -1, m_temperatureProvider->getInfraredAmbientTemperature()));
    m_temperatureList.append(QPointF(temperatureSeriesIndex, defaultAvgValue));

    if (m_temperatureList.size() >= maxTemperatureReadings)
        m_temperatureList.removeFirst();

    if (temperatureSeriesIndex >= maxTemperatureReadings) {
        QAbstractAxis *axis = m_temperature->attachedAxes().at(0);
        axisMin++;
        axisMax++;
        axis->setRange(axisMin, axisMax);
    }
    m_temperature->replace(m_temperatureList);
    temperatureSeriesIndex++;
}
