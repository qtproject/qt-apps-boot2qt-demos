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
#include "mockdataproviderpool.h"
#include "sensortagdataproviderpool.h"
#include "mockdataprovider.h"

MockDataProviderPool::MockDataProviderPool(QObject *parent)
    : DataProviderPool("Demo", parent)
    , m_cloudProvider(0)
{
}

void MockDataProviderPool::startScanning()
{
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

void MockDataProviderPool::finishScanning()
{
    if (m_dataProviders.length()) {
        // For mock data we have only one provider and
        // it servers as the provider to the cloud, too
        m_cloudProvider = m_dataProviders.at(0);
        emit providerForCloudChanged();
    }
    emit dataProvidersChanged();
    emit scanFinished();
}

SensorTagDataProvider *MockDataProviderPool::providerForCloud() const
{
    return m_cloudProvider;
}
