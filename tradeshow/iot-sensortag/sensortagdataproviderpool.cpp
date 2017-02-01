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

#include "bluetoothdataprovider.h"
#include "sensortagdataproviderpool.h"

#include <QLoggingCategory>

Q_DECLARE_LOGGING_CATEGORY(boot2QtDemos)

SensorTagDataProviderPool::SensorTagDataProviderPool(QObject *parent)
    : SensorTagDataProviderPool("SensorTag", parent)
{

}

SensorTagDataProviderPool::SensorTagDataProviderPool(QString poolName, QObject* parent)
    : DataProviderPool(poolName, parent)
{
    m_discoveryAgent = new QBluetoothDeviceDiscoveryAgent();
    connect(m_discoveryAgent, SIGNAL(deviceDiscovered(const QBluetoothDeviceInfo&)),
            this, SLOT(btDeviceFound(const QBluetoothDeviceInfo&)));
    connect(m_discoveryAgent, SIGNAL(error(QBluetoothDeviceDiscoveryAgent::Error)),
            this, SLOT(deviceScanError(QBluetoothDeviceDiscoveryAgent::Error)));
    connect(m_discoveryAgent, SIGNAL(finished()), this, SLOT(deviceDiscoveryFinished()));
}

void SensorTagDataProviderPool::startScanning()
{
    qDeleteAll(m_dataProviders);
    m_dataProviders.clear();

    m_discoveryAgent->start();

    if (m_discoveryAgent->isActive()) {
        m_deviceScanState = true;
    }
}

void SensorTagDataProviderPool::setMacFilterList(const QStringList &addressList)
{
    m_macFilters = addressList;
}

QStringList SensorTagDataProviderPool::macFilters() const
{
    return m_macFilters;
}

void SensorTagDataProviderPool::setnameFilteList(const QStringList &nameList)
{
    m_nameFilters = nameList;
}

SensorTagDataProvider *SensorTagDataProviderPool::providerForCloud() const
{
    return m_providerForCloud;
}

// Currently, return simply the first provider found.
// It might be better to somehow collect the results from
// all providers and combine them
void SensorTagDataProviderPool::updateProviderForCloud()
{
    if (m_dataProviders.length())
        m_providerForCloud = m_dataProviders.at(0);
    else
        m_providerForCloud = 0;
    emit providerForCloudChanged();
}

void SensorTagDataProviderPool::deviceDiscoveryFinished()
{
    m_deviceScanState = false;
    emit scanFinished();
}

void SensorTagDataProviderPool::btDeviceFound(const QBluetoothDeviceInfo &info)
{
    qCDebug(boot2QtDemos) << "Found a Bluetooth device. Name:" << info.name() << ", addr:" << info.address().toString();

    if (info.coreConfigurations() & QBluetoothDeviceInfo::LowEnergyCoreConfiguration) {
        bool filtered = m_macFilters.length() || m_nameFilters.length();
        bool found = filtered ? false : true;

        if (m_macFilters.length() && m_macFilters.contains(info.address().toString()))
            found = true;
        else if (m_nameFilters.length() && m_nameFilters.contains(info.name()))
            found = true;

        if (found) {
            qCDebug(boot2QtDemos) << "   Adding to the available devices";
            BluetoothDataProvider* dataProvider = new BluetoothDataProvider(info.address().toString(), this);
            BluetoothDevice *d = new BluetoothDevice(info);
            dataProvider->bindToDevice(d);
            m_dataProviders.append(dataProvider);
            emit providerConnected(d->getAddress());
            emit dataProvidersChanged();
            updateProviderForCloud();
            connect(dataProvider, &SensorTagDataProvider::stateChanged, this, &SensorTagDataProviderPool::handleStateChange);
        }
    }
}

void SensorTagDataProviderPool::handleStateChange()
{
    SensorTagDataProvider *provider = static_cast<SensorTagDataProvider*>(sender());

    qCDebug(boot2QtDemos) << provider->state();

    switch (provider->state()) {
    case SensorTagDataProvider::Disconnected:
        updateProviderForCloud();
        emit providerDisconnected(provider->id());
        break;
    case SensorTagDataProvider::Connected:
        emit providerConnected(provider->id());
        break;
    case SensorTagDataProvider::Error:
        emit providerInError(provider->id());
        break;
    default:
        break;
    }
}

void SensorTagDataProviderPool::deviceScanError(QBluetoothDeviceDiscoveryAgent::Error error)
{
    if (error == QBluetoothDeviceDiscoveryAgent::PoweredOffError)
        qCDebug(boot2QtDemos) << "The Bluetooth adaptor is powered off, power it on before doing discovery.";
    else if (error == QBluetoothDeviceDiscoveryAgent::InputOutputError)
        qCDebug(boot2QtDemos) << "Writing or reading from the device resulted in an error.";
    else
        qCDebug(boot2QtDemos) << "An unknown error has occurred.";

    m_deviceScanState = false;
    emit scanFinished();
}