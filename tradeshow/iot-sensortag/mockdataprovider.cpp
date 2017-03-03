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
#include "mockdataprovider.h"
#include <QtCore/QDateTime>

#define MOCK_DATA_SLOW_REFRESH_INTERVAL_MS   1000
#define MOCK_DATA_RAPID_REFRESH_INTERVAL_MS   200

MockDataProvider::MockDataProvider(QString id, QObject* parent)
    : SensorTagDataProvider(id, parent),
    xAxisG(-0.02f),
    yAxisG(0.0f),
    zAxisG(0.02f),
    luxIncrease(100),
    rotationDegPerSecXIncrease(5),
    rotationDegPerSecYIncrease(7),
    rotationDegPerSecZIncrease(-9),
    m_smaSamples(0)
{
    intervalRotation = MOCK_DATA_RAPID_REFRESH_INTERVAL_MS;
    humidity = 40;
    irAmbientTemperature = 25;
    irObjectTemperature = 25;
    barometerCelsiusTemperature = 25;
    barometerHPa = 1040;
    pressureAtZeroAltitude = 1040;
    accelometerX = 1;
    accelometerZ = 0;
    magnetometerMicroT_xAxis = 333;
    magnetometerMicroT_yAxis = 666;
    magnetometerMicroT_zAxis = 999;
}

bool MockDataProvider::startDataFetching()
{
    // Mock data is immediately available
    m_state = Connected;

    qsrand(QDateTime::currentMSecsSinceEpoch() / 1000);
    slowUpdateTimer = new QTimer(this);
    connect(slowUpdateTimer, SIGNAL(timeout()), this, SLOT(slowTimerExpired()));
    slowUpdateTimer->start(MOCK_DATA_SLOW_REFRESH_INTERVAL_MS);
    rapidUpdateTimer = new QTimer(this);
    connect(rapidUpdateTimer, SIGNAL(timeout()), this, SLOT(rapidTimerExpired()));
    rapidUpdateTimer->start(MOCK_DATA_RAPID_REFRESH_INTERVAL_MS);
    return true;
}

void MockDataProvider::endDataFetching()
{
    slowUpdateTimer->stop();
}

QString MockDataProvider::sensorType() const
{
    return QLatin1String("Mock data");
}

QString MockDataProvider::versionString() const
{
    return QLatin1String("1.1");
}

void MockDataProvider::slowTimerExpired()
{
    /* Emit the signals even if values are unchanged.
     * Otherwise the scrolling graphs in UI will not scroll. */

    // Humidity goes randomly up and down between 20% and 60%
    humidity += static_cast<double>((qrand() % 11)-5)/10;
    if (humidity > 60)
        humidity = 60;
    if (humidity < 20)
        humidity = 20;
    emit relativeHumidityChanged();

    // IR temperature goes randomly up OR down by half of a degree. So does barometer temperature.
    if (qrand() % 2)
        irAmbientTemperature -= 5;
    else
        irAmbientTemperature += 5;
    if (irAmbientTemperature > 38)
        irAmbientTemperature = 38;
    if (irAmbientTemperature < 10)
        irAmbientTemperature = 10;
    emit infraredAmbientTemperatureChanged();
    irObjectTemperature = irAmbientTemperature + 2;
    emit infraredObjectTemperatureChanged();
    if (qrand() % 2)
        barometerCelsiusTemperature -= 0.5;
    else
        barometerCelsiusTemperature += 0.5;
    if (barometerCelsiusTemperature > 38)
        barometerCelsiusTemperature = 38;
    if (barometerCelsiusTemperature < 15)
        barometerCelsiusTemperature = 15;
    emit barometerCelsiusTemperatureChanged();
    barometerTemperatureAverage = (barometerCelsiusTemperature + m_smaSamples * barometerTemperatureAverage)  / (m_smaSamples + 1);
    emit barometerCelsiusTemperatureAverageChanged();
    m_smaSamples++;
    // Use a limited number of samples. It will eventually give wrong avg values, but this is just a demo...
    if (m_smaSamples > 10000)
        m_smaSamples = 0;

    // Light intensity switches between bright and dark (~0 and ~400)
    lightIntensityLux += luxIncrease;
    if (lightIntensityLux <= 0)
        luxIncrease = 100;
    if (lightIntensityLux >= 400)
        luxIncrease = -100;
    emit lightIntensityChanged();

    // Air pressure goes between 1030 and 1050, in 0.05 steps
    if (qrand() % 2)
        barometerHPa -= 0.05;
    else
        barometerHPa += 0.05;
    if (barometerHPa > 1050)
        barometerHPa = 1050;
    if (barometerHPa < 1030)
        barometerHPa = 1030;
    emit barometer_hPaChanged();

    calculateZeroAltitude();
}

void MockDataProvider::rapidTimerExpired()
{
    //Rotate counter-clockwise around Z axis
    accelometerX += xAxisG;
    if (accelometerX < -1) {
        xAxisG = xAxisG * -1;
        accelometerX = -1;
    } else if (accelometerX > 1) {
        xAxisG = xAxisG * -1;
        accelometerX = 1;
    }
    accelometerZ += zAxisG;
    if (accelometerZ < -1) {
        zAxisG = zAxisG * -1;
        accelometerZ = -1;
    } else if (accelometerZ > 1) {
        zAxisG = zAxisG * -1;
        accelometerZ = 1;
    }
    emit accelometerChanged();
    magnetometerMicroT_xAxis += 100;
    magnetometerMicroT_yAxis += 100;
    magnetometerMicroT_zAxis += 100;
    if (magnetometerMicroT_xAxis > 1500)
        magnetometerMicroT_xAxis -= 3000;
    if (magnetometerMicroT_yAxis > 1500)
        magnetometerMicroT_yAxis -= 3000;
    if (magnetometerMicroT_zAxis > 1500)
        magnetometerMicroT_zAxis -= 3000;
    emit magnetometerMicroTChanged();

    rotation_x += 1;
    if (rotation_x > 360)
        rotation_x -= 360;
    rotation_y += 4;
    if (rotation_y > 360)
        rotation_y -= 360;
    rotation_z += 9;
    if (rotation_z > 360)
        rotation_z -= 360;
    emit rotationXChanged();
    emit rotationYChanged();
    emit rotationZChanged();
    // Signal that all values have changed, for easier
    // value change handling in clients
    emit rotationValuesChanged();

    gyroscopeX_degPerSec += rotationDegPerSecXIncrease;
    if ((gyroscopeX_degPerSec > 240) ||
        (gyroscopeX_degPerSec < -240))
        rotationDegPerSecXIncrease *= -1;
    gyroscopeY_degPerSec += rotationDegPerSecYIncrease;
    if ((gyroscopeY_degPerSec > 240) ||
        (gyroscopeY_degPerSec < -240))
        rotationDegPerSecYIncrease *= -1;
    gyroscopeZ_degPerSec += rotationDegPerSecZIncrease;
    if ((gyroscopeZ_degPerSec > 240) ||
        (gyroscopeZ_degPerSec < -240))
        rotationDegPerSecZIncrease *= -1;
    emit gyroscopeDegPerSecChanged();
}

void MockDataProvider::startServiceScan()
{

}

void MockDataProvider::reset()
{
    rotation_x = 0;
    rotation_y = 0;
    rotation_z = 0;
    emit rotationXChanged();
    emit rotationYChanged();
    emit rotationZChanged();

    pressureAtZeroAltitude = 1040;
}
