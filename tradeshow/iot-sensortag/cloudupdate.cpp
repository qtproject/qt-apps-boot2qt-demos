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
#include "cloudupdate.h"
#include "cloudservice.h"
#include "dataproviderpool.h"
#include "sensortagdataprovider.h"

#include "demodataproviderpool.h"

#include "was/storage_account.h"
#include "was/blob.h"

#define ROUNDING_DECIMALS           2
#define UPDATE_INTERVAL             1000

CloudUpdate::CloudUpdate(QObject *parent)
    : QObject(parent)
    , m_providerPool(0)
    , m_provider(0)
    , m_timerId(0)
    , m_updateInterval(UPDATE_INTERVAL)
{
}

void CloudUpdate::setDataProviderPool(DataProviderPool *provider)
{
    m_providerPool = provider;
    connect(m_providerPool, &DataProviderPool::providerForCloudChanged, this, [=]() {
         m_provider = m_providerPool->providerForCloud();
         if (!m_provider) {
             stop();
         }
    });
}

int CloudUpdate::updateInterval() const
{
    return m_updateInterval;
}

void CloudUpdate::setUpdateInterval(int interval)
{
    m_updateInterval = interval;
}

void CloudUpdate::restart()
{
    killTimer(m_timerId);
    m_timerId = startTimer(m_updateInterval);
}

void CloudUpdate::stop()
{
    killTimer(m_timerId);
}

void CloudUpdate::timerEvent(QTimerEvent *event)
{
    Q_UNUSED(event);

    if (!m_provider)
        return;

    writeToCloud();
}

void CloudUpdate::writeToCloud()
{
    if (!m_provider) {
        qWarning("CloudUpdate: sensor data provider not set. Data not updated");
        return;
    }

    // Define the connection-string with your values.
    QByteArray accStr = QByteArrayLiteral("DefaultEndpointsProtocol=https;AccountName=");
    accStr += AZURE_ACCOUNT_NAME;
    accStr += QByteArrayLiteral(";AccountKey=");
    accStr += AZURE_ACCOUNT_KEY;
#ifndef Q_OS_WIN
    const utility::string_t storage_connection_string(U(accStr.data()));
#else
    const utility::string_t storage_connection_string(reinterpret_cast<const wchar_t*>(QString(accStr).utf16()));
#endif
    azure::storage::cloud_blob_container container;

    try {
        azure::storage::cloud_storage_account storage_account = azure::storage::cloud_storage_account::parse(storage_connection_string);

       // Create the blob client.
       azure::storage::cloud_blob_client blob_client = storage_account.create_cloud_blob_client();

       // Retrieve a reference to a container.
      container = blob_client.get_container_reference(U(CLOUD_BLOB_NAME));

       // Create the container if it doesn't already exist.
       container.create_if_not_exists();
    }
    catch (const std::exception& e)
    {
       std::wcout << U("Error: ") << e.what() << std::endl;
    }

    // Retrieve reference to a blob
    azure::storage::cloud_block_blob blob = container.get_block_blob_reference(U(CLOUD_FILE_NAME));

    QString sensorData = buildString();
#ifndef Q_OS_WIN
    blob.upload_text(U(sensorData.toLocal8Bit().data()));
#else
    blob.upload_text(reinterpret_cast<const wchar_t*>(sensorData.utf16()));
#endif
}

QString CloudUpdate::buildString() const
{
    QString exportString;
    exportString += QString("Type:\n%1\n").arg(m_provider->sensorType());
    exportString += QString("Version:\n%1\n").arg(m_provider->versionString());
    exportString += QString("Humid:\n%1\n").arg(m_provider->getRelativeHumidity(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("Temp(Ambient):\n%1\n").arg(m_provider->getInfraredAmbientTemperature(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("Temp(Object):\n%1\n").arg(m_provider->getInfraredObjectTemperature(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("Light:\n%1\n").arg(m_provider->getLightIntensityLux(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("Temp(Baro):\n%1\n").arg(m_provider->getBarometerCelsiusTemperature(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("hPa:\n%1\n").arg(m_provider->getBarometer_hPa(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("gyroX:\n%1\n").arg(m_provider->getGyroscopeX_degPerSec(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("gyroY:\n%1\n").arg(m_provider->getGyroscopeY_degPerSec(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("gyroZ:\n%1\n").arg(m_provider->getGyroscopeZ_degPerSec(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("AccX:\n%1\n").arg(m_provider->getAccelometer_xAxis(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("AccY:\n%1\n").arg(m_provider->getAccelometer_yAxis(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("AccZ:\n%1\n").arg(m_provider->getAccelometer_zAxis(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("MagnX:\n%1\n").arg(m_provider->getMagnetometerMicroT_xAxis(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("MagnY:\n%1\n").arg(m_provider->getMagnetometerMicroT_yAxis(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("MagnZ:\n%1\n").arg(m_provider->getMagnetometerMicroT_zAxis(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("RotX:\n%1\n").arg(m_provider->getRotationX(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("RotY:\n%1\n").arg(m_provider->getRotationY(), 0, 'f', ROUNDING_DECIMALS);
    exportString += QString("RotZ:\n%1").arg(m_provider->getRotationZ(), 0, 'f', ROUNDING_DECIMALS);
    return exportString;
}
