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
#include "bluetoothdataprovider.h"

#include <QLoggingCategory>

Q_DECLARE_LOGGING_CATEGORY(boot2QtDemos)

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

double DemoCloudProvider::getRelativeHumidity() const
{
   for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
       if (p->tagType() & SensorTagDataProvider::Humidity)
           return p->getRelativeHumidity();
   }
   return 0;
}

double DemoCloudProvider::getInfraredAmbientTemperature() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::AmbientTemperature)
            return p->getInfraredAmbientTemperature();
    }
    return 0;
}

double DemoCloudProvider::getInfraredObjectTemperature() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::ObjectTemperature)
            return p->getInfraredObjectTemperature();
    }
    return 0;
}

double DemoCloudProvider::getLightIntensityLux() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::Light)
            return p->getLightIntensityLux();
    }
    return 0;
}

double DemoCloudProvider::getBarometerCelsiusTemperature() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::AirPressure)
            return p->getBarometerCelsiusTemperature();
    }
    return 0;
}

double DemoCloudProvider::getBarometerTemperatureAverage() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::AirPressure)
            return p->getBarometerTemperatureAverage();
    }
    return 0;
}

double DemoCloudProvider::getBarometer_hPa() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::AirPressure)
            return p->getBarometer_hPa();
    }
    return 0;
}

float DemoCloudProvider::getGyroscopeX_degPerSec() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::Magnetometer)
            return p->getGyroscopeX_degPerSec();
    }
    return 0;
}

float DemoCloudProvider::getGyroscopeY_degPerSec() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::Magnetometer)
            return p->getGyroscopeY_degPerSec();
    }
    return 0;
}

float DemoCloudProvider::getGyroscopeZ_degPerSec() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::Magnetometer)
            return p->getGyroscopeZ_degPerSec();
    }
    return 0;
}

float DemoCloudProvider::getAccelometer_xAxis() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::Accelometer)
            return p->getAccelometer_xAxis();
    }
    return 0;
}

float DemoCloudProvider::getAccelometer_yAxis() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::Accelometer)
            return p->getAccelometer_yAxis();
    }
    return 0;
}

float DemoCloudProvider::getAccelometer_zAxis() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::Accelometer)
            return p->getAccelometer_zAxis();
    }
    return 0;
}

float DemoCloudProvider::getMagnetometerMicroT_xAxis() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::Magnetometer)
            return p->getMagnetometerMicroT_xAxis();
    }
    return 0;
}

float DemoCloudProvider::getMagnetometerMicroT_yAxis() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::Magnetometer)
            return p->getMagnetometerMicroT_yAxis();
    }
    return 0;
}

float DemoCloudProvider::getMagnetometerMicroT_zAxis() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::Magnetometer)
            return p->getMagnetometerMicroT_zAxis();
    }
    return 0;
}

float DemoCloudProvider::getRotationX() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::Rotation)
            return p->getRotationX();
    }
    return 0;
}

float DemoCloudProvider::getRotationY() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::Rotation)
            return p->getRotationY();
    }
    return 0;
}

float DemoCloudProvider::getRotationZ() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::Rotation)
            return p->getRotationZ();
    }
    return 0;
}

float DemoCloudProvider::getAltitude() const
{
    for (SensorTagDataProvider *p : qAsConst(m_dataProviders)) {
        if (p->tagType() & SensorTagDataProvider::Altitude)
            return p->getAltitude();
    }
    return 0;
}


DemoDataProviderPool::DemoDataProviderPool(QObject *parent)
    : SensorTagDataProviderPool("Demo", parent)
    , m_mockData(false)
    , m_cloudProvider(0)
    , m_initialized(false)
{
}

void DemoDataProviderPool::startScanning()
{
    if (m_mockData) {
        qDeleteAll(m_dataProviders);
        m_dataProviders.clear();

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
        finishScanning();
    }
    else {
        if (!m_initialized) {
            // Create a DataProvider objects early on for UI to be able to
            // show all data providers as available. The BT device information
            // will be added later on when the Bluetooth device has been found
            for (const QString& id : m_macFilters) {
                BluetoothDataProvider *p = new BluetoothDataProvider(id, this);
                m_dataProviders.push_back(p);
                // Set initial state to Scanning for UI to be
                // able to show "Connecting.." information
                p->setState(SensorTagDataProvider::Scanning);
                // Empty tag type, it will be set next
                p->setTagType(0);
            }
            // Fake that we have set of sensors with different capabilities
            // by assigning only some of the sensor data types to each sensor tag
            int i = 0;
            while (i < SensorTagDataProvider::tagTypeCount) {
                for (int p = 0; p < m_dataProviders.count() && i < SensorTagDataProvider::tagTypeCount; p++) {
                    SensorTagDataProvider *provider = m_dataProviders.at(p);
                    int tagType = provider->tagType() | (1 << i++);
                    provider->setTagType(tagType);
                    qCDebug(boot2QtDemos) << "Set tag type for provider" << provider->id() << "to" << QString::number(tagType, 2);
                }
            }
            emit dataProvidersChanged();
            m_initialized = true;
        }
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
        m_cloudProvider = new DemoCloudProvider(this);
        static_cast<DemoCloudProvider*>(m_cloudProvider)->setDataProviders(m_dataProviders);
        for (SensorTagDataProvider *p : m_dataProviders) {
            // If BluetoothDevice object is not attached, the device has not been found
            if (!static_cast<BluetoothDataProvider*>(p)->device())
                p->setState(SensorTagDataProvider::NotFound);
        }
    }
    emit dataProvidersChanged();
    emit scanFinished();
}

void DemoDataProviderPool::setMockDataMode(bool mode)
{
    m_mockData = mode;
}

SensorTagDataProvider *DemoDataProviderPool::providerForCloud() const
{
    return m_cloudProvider;
}
