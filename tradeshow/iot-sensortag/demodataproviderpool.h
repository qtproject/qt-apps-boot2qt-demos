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
#ifndef DEMODATAPROVIDERPOOL_H
#define DEMODATAPROVIDERPOOL_H

#include "sensortagdataproviderpool.h"

class CloudUpdate;

class DemoDataProviderPool : public SensorTagDataProviderPool
{
    Q_OBJECT
public:
    explicit DemoDataProviderPool(QObject *parent = 0);

    void startScanning() override;

    SensorTagDataProvider* providerForCloud() const override;

    void setMockDataMode(bool mode);

protected:
    void finishScanning() override;

private:
    bool m_mockData;
    SensorTagDataProvider* m_cloudProvider;
    bool m_initialized;
};

// Internal class to provide sensor data for cloud update from demo setup
class DemoCloudProvider : public SensorTagDataProvider
{
    Q_OBJECT
public:
    explicit DemoCloudProvider(QObject *parent);

    void setDataProviders(const QList<SensorTagDataProvider*>& dataProviders);

    QString sensorType() const override;
    QString versionString() const override;

    double getRelativeHumidity() const override;
    double getInfraredAmbientTemperature() const override;
    double getInfraredObjectTemperature() const override;
    double getLightIntensityLux() const override;
    double getBarometerCelsiusTemperature() const override;
    double getBarometerTemperatureAverage() const override;
    double getBarometer_hPa() const override;
    float getGyroscopeX_degPerSec() const override;
    float getGyroscopeY_degPerSec() const override;
    float getGyroscopeZ_degPerSec() const override;
    float getAccelometer_xAxis() const override;
    float getAccelometer_yAxis() const override;
    float getAccelometer_zAxis() const override;
    float getMagnetometerMicroT_xAxis() const override;
    float getMagnetometerMicroT_yAxis() const override;
    float getMagnetometerMicroT_zAxis() const override;
    float getRotationX() const override;
    float getRotationY() const override;
    float getRotationZ() const override;
    float getAltitude() const override;

    QList<SensorTagDataProvider*> m_dataProviders;
};

#endif // DEMODATAPROVIDERPOOL_H
