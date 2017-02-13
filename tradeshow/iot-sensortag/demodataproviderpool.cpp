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
#include "demodataproviderpool.h"
#include "mockdataprovider.h"

DemoCloudProvider::DemoCloudProvider(QObject *parent)
    : SensorTagDataProvider(parent)
{
}

void DemoCloudProvider::setDataProviders(const QList<SensorTagDataProvider *> &dataProviders)
{
    m_dataProviders = dataProviders;
}

QString DemoCloudProvider::sensorType() const
{
    if (m_dataProviders.length())
        return m_dataProviders.at(0)->sensorType();
    else
        return QString();
}

QString DemoCloudProvider::versionString() const
{
    if (m_dataProviders.length())
        return m_dataProviders.at(0)->versionString();
    else
        return QString();
}

double DemoCloudProvider::getRelativeHumidity()
{
   foreach (SensorTagDataProvider *p, m_dataProviders) {
       if (p->tagType() & SensorTagDataProvider::Humidity)
           return p->getRelativeHumidity();
   }
   return 0;
}

double DemoCloudProvider::getInfraredAmbientTemperature()
{
    m_dataProviders.first();
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::AmbientTemperature)
            return p->getInfraredAmbientTemperature();
    }
    return 0;
}

double DemoCloudProvider::getInfraredObjectTemperature()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::ObjectTemperature)
            return p->getInfraredObjectTemperature();
    }
    return 0;
}

double DemoCloudProvider::getLightIntensityLux()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::Light)
            return p->getLightIntensityLux();
    }
    return 0;
}

double DemoCloudProvider::getBarometerCelsiusTemperature()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::AirPressure)
            return p->getBarometerCelsiusTemperature();
    }
    return 0;
}

double DemoCloudProvider::getBarometerTemperatureAverage()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::AirPressure)
            return p->getBarometerTemperatureAverage();
    }
    return 0;
}

double DemoCloudProvider::getBarometer_hPa()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::AirPressure)
            return p->getBarometer_hPa();
    }
    return 0;
}

float DemoCloudProvider::getGyroscopeX_degPerSec()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::Magnetometer)
            return p->getGyroscopeX_degPerSec();
    }
    return 0;
}

float DemoCloudProvider::getGyroscopeY_degPerSec()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::Magnetometer)
            return p->getGyroscopeY_degPerSec();
    }
    return 0;
}

float DemoCloudProvider::getGyroscopeZ_degPerSec()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::Magnetometer)
            return p->getGyroscopeZ_degPerSec();
    }
    return 0;
}

float DemoCloudProvider::getAccelometer_xAxis()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::Accelometer)
            return p->getAccelometer_xAxis();
    }
    return 0;
}

float DemoCloudProvider::getAccelometer_yAxis()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::Accelometer)
            return p->getAccelometer_yAxis();
    }
    return 0;
}

float DemoCloudProvider::getAccelometer_zAxis()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::Accelometer)
            return p->getAccelometer_zAxis();
    }
    return 0;
}

float DemoCloudProvider::getMagnetometerMicroT_xAxis()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::Magnetometer)
            return p->getMagnetometerMicroT_xAxis();
    }
    return 0;
}

float DemoCloudProvider::getMagnetometerMicroT_yAxis()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::Magnetometer)
            return p->getMagnetometerMicroT_yAxis();
    }
    return 0;
}

float DemoCloudProvider::getMagnetometerMicroT_zAxis()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::Magnetometer)
            return p->getMagnetometerMicroT_zAxis();
    }
    return 0;
}

float DemoCloudProvider::getRotationX()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::Rotation)
            return p->getRotationX();
    }
    return 0;
}

float DemoCloudProvider::getRotationY()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::Rotation)
            return p->getRotationY();
    }
    return 0;
}

float DemoCloudProvider::getRotationZ()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::Rotation)
            return p->getRotationZ();
    }
    return 0;
}

float DemoCloudProvider::getAltitude()
{
    foreach (SensorTagDataProvider *p, m_dataProviders) {
        if (p->tagType() & SensorTagDataProvider::Altitude)
            return p->getAltitude();
    }
    return 0;
}


DemoDataProviderPool::DemoDataProviderPool(QObject *parent)
    : SensorTagDataProviderPool("Demo", parent)
    , m_mockData(false)
    , m_cloudProvider(0)
{
}

void DemoDataProviderPool::startScanning()
{
    qDeleteAll(m_dataProviders);
    m_dataProviders.clear();

    if (m_mockData) {
        MockDataProvider* p = new MockDataProvider("MOCK_PROVIDER_1", this);
        p->setTagType(SensorTagDataProvider::ObjectTemperature | SensorTagDataProvider::AmbientTemperature | SensorTagDataProvider::Rotation);
        m_dataProviders.push_back(p);
        p = new MockDataProvider("MOCK_PROVIDER_2", this);
        p->setTagType(SensorTagDataProvider::Humidity | SensorTagDataProvider::Light | SensorTagDataProvider::Accelometer);
        m_dataProviders.push_back(p);
        p = new MockDataProvider("MOCK_PROVIDER_3", this);
        p->setTagType(SensorTagDataProvider::Magnetometer | SensorTagDataProvider::AirPressure);
        m_dataProviders.push_back(p);
        for (int i=0; i < m_dataProviders.length(); i++) {
            m_dataProviders.at(i)->startDataFetching();
            emit providerConnected(p->id());
        }
        // Stop scanning as we already have a provider
        scanFinished();
    }
    else {
        SensorTagDataProviderPool::startScanning();
    }
}

void DemoDataProviderPool::finishScanning()
{
    if (m_dataProviders.length() && m_mockData) {
        // For mock data we have only one provider and
        // it servers as the provider to the cloud, too
        m_cloudProvider = m_dataProviders.at(0);
        emit providerForCloudChanged();
    } else {
        // Fake that we have set of sensors with different capabilities
        // by removing some of the sensor data types from each sensor tag
        foreach (SensorTagDataProvider *p, m_dataProviders) {
            if (p->id() == QStringLiteral("A0:E6:F8:B6:5B:86")) {
                p->setTagType(SensorTagDataProvider::ObjectTemperature |
                              SensorTagDataProvider::Light |
                              SensorTagDataProvider::Magnetometer |
                              SensorTagDataProvider::Accelometer);
            }
            else if (p->id() == QStringLiteral("A0:E6:F8:B6:44:01")) {
                p->setTagType(SensorTagDataProvider::AmbientTemperature |
                              SensorTagDataProvider::Altitude |
                              SensorTagDataProvider::Humidity |
                              SensorTagDataProvider::Rotation |
                              SensorTagDataProvider::AirPressure);
            }
        }
        m_cloudProvider = new DemoCloudProvider(this);
        static_cast<DemoCloudProvider*>(m_cloudProvider)->setDataProviders(m_dataProviders);
    }
}

void DemoDataProviderPool::setMockDataMode(bool mode)
{
    m_mockData = mode;
}

SensorTagDataProvider *DemoDataProviderPool::providerForCloud() const
{
    return m_cloudProvider;
}

