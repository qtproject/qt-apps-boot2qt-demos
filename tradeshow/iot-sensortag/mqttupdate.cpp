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

#include "mqttupdate.h"
#include "cloudservice.h"
#include "dataproviderpool.h"
#include "sensortagdataprovider.h"
#include "demodataproviderpool.h"
#include "mqttdataproviderpool.h"

#include <QtCore/QUuid>
#include <QtMqtt/QtMqtt>
#include <QSysInfo>

#define ROUNDING_DECIMALS           2
#define UPDATE_INTERVAL             100

Q_DECLARE_LOGGING_CATEGORY(boot2QtDemos)

MqttUpdate::MqttUpdate(QObject *parent)
    : QObject(parent)
    , m_providerPool(0)
#ifdef MQTT_TIMER_BASED_PUBLISH
    , m_timerId(0)
#endif
    , m_handler(nullptr)
    , m_updateInterval(UPDATE_INTERVAL)
{
}

void MqttUpdate::setDataProviderPool(DataProviderPool *provider)
{
    m_providerPool = provider;
    connect(m_providerPool, &DataProviderPool::currentProviderChanged, this, [=]() {
        if (m_handler)
            m_handler->deleteLater();

        SensorTagDataProvider *provider = m_providerPool->currentProvider();
        if (!provider)
            return;

        QString hostname = QSysInfo::machineHostName();
        if (hostname == QLatin1String("localhost")) {
            hostname = QUuid::createUuid().toString();
            qCDebug(boot2QtDemos) << "localhost not unique. New ID:" << hostname;
        }

        m_handler = new MqttEventHandler(hostname + QLatin1String(" - ") + provider->id());
        m_handler->m_providerPool = m_providerPool;

        connect(provider, &SensorTagDataProvider::gyroscopeDegPerSecChanged, m_handler, &MqttEventHandler::uploadGyro);
        connect(provider, &SensorTagDataProvider::accelometerChanged, m_handler, &MqttEventHandler::uploadAccelerometer);
        connect(provider, &SensorTagDataProvider::rotationXChanged, m_handler, &MqttEventHandler::uploadRotation);
        connect(provider, &SensorTagDataProvider::infraredAmbientTemperatureChanged, m_handler, &MqttEventHandler::uploadTemperature);
        connect(provider, &SensorTagDataProvider::magnetometerMicroTChanged, m_handler, &MqttEventHandler::uploadMagnetometer);
        connect(provider, &SensorTagDataProvider::relativeHumidityChanged, m_handler, &MqttEventHandler::uploadHumidity);
        connect(provider, &SensorTagDataProvider::lightIntensityChanged, m_handler, &MqttEventHandler::uploadLight);
        connect(provider, &SensorTagDataProvider::barometer_hPaChanged, m_handler, &MqttEventHandler::uploadBarometer);
        connect(provider, &SensorTagDataProvider::altitudeChanged, m_handler, &MqttEventHandler::uploadAltitude);
    });
}

int MqttUpdate::updateInterval() const
{
    return m_updateInterval;
}

void MqttUpdate::setUpdateInterval(int interval)
{
    m_updateInterval = interval;
}

void MqttUpdate::restart()
{
#ifdef MQTT_TIMER_BASED_PUBLISH
    killTimer(m_timerId);
    m_timerId = startTimer(m_updateInterval);
#endif
}

void MqttUpdate::stop()
{
#ifdef MQTT_TIMER_BASED_PUBLISH
    killTimer(m_timerId);
#endif
}

#ifndef MQTT_TIMER_BASED_PUBLISH

inline bool ensureConnected(QMqttClient *client)
{
    if (client->state() == QMqttClient::Connected)
        return true;

    if (client->state() == QMqttClient::Disconnected) {
        qCDebug(boot2QtDemos) << "Disconnected, need to reconnect";
        client->connectToHost();
    }

    return false; // Connecting, nothing to do
}

void MqttEventHandler::uploadGyro()
{
    if (!ensureConnected(m_client))
        return;
    SensorTagDataProvider *provider = m_providerPool->currentProvider();

    if (provider) {
        const QString gyro = QString("%1_%2_%3").arg(provider->getGyroscopeX_degPerSec(), 0, 'f', ROUNDING_DECIMALS)
                .arg(provider->getGyroscopeY_degPerSec(), 0, 'f', ROUNDING_DECIMALS)
                .arg(provider->getGyroscopeZ_degPerSec(), 0, 'f', ROUNDING_DECIMALS);
        m_client->publish(m_topicPrefix + QLatin1String("gyro"), gyro.toLocal8Bit());
    }
}

void MqttEventHandler::uploadTemperature()
{
    if (!ensureConnected(m_client))
        return;

    SensorTagDataProvider *provider = m_providerPool->currentProvider();

    if (provider) {
        const QString temperature = QString("%1_%2").arg(provider->getInfraredAmbientTemperature(), 0, 'f', ROUNDING_DECIMALS)
                .arg(provider->getInfraredObjectTemperature(), 0, 'f', ROUNDING_DECIMALS);
        m_client->publish(m_topicPrefix + QLatin1String("temperature"), temperature.toLocal8Bit());
    }
}

void MqttEventHandler::uploadHumidity()
{
    if (!ensureConnected(m_client))
        return;

    SensorTagDataProvider *provider = m_providerPool->currentProvider();

    if (provider)
        m_client->publish(m_topicPrefix + QLatin1String("humid"),
                          QString("%1").arg(provider->getRelativeHumidity(), 0, 'f', ROUNDING_DECIMALS).toLocal8Bit());
}

void MqttEventHandler::uploadLight()
{
    if (!ensureConnected(m_client))
        return;

    SensorTagDataProvider *provider = m_providerPool->currentProvider();

    if (provider)
        m_client->publish(m_topicPrefix + QLatin1String("light"),
                          QString("%1").arg(provider->getLightIntensityLux(), 0, 'f', ROUNDING_DECIMALS).toLocal8Bit());
}

void MqttEventHandler::uploadAltitude()
{
    if (!ensureConnected(m_client))
        return;

    SensorTagDataProvider *provider = m_providerPool->currentProvider();

    if (provider)
        m_client->publish(m_topicPrefix + QLatin1String("altitude"),
                          QString("%1").arg(provider->getAltitude(), 0, 'f', ROUNDING_DECIMALS).toLocal8Bit());
}

void MqttEventHandler::uploadBarometer()
{
    if (!ensureConnected(m_client))
        return;

    SensorTagDataProvider *provider = m_providerPool->currentProvider();

    if (provider) {
        const QString baro = QString("%1_%2").arg(provider->getBarometerCelsiusTemperature(), 0, 'f', ROUNDING_DECIMALS)
                .arg(provider->getBarometer_hPa(), 0, 'f', ROUNDING_DECIMALS);
        m_client->publish(m_topicPrefix + QLatin1String("barometer"), baro.toLocal8Bit());
    }
}

void MqttEventHandler::uploadAccelerometer()
{
    if (!ensureConnected(m_client))
        return;

    SensorTagDataProvider *provider = m_providerPool->currentProvider();

    if (provider) {
        const QString accel = QString("%1_%2_%3").arg(provider->getAccelometer_xAxis(), 0, 'f', ROUNDING_DECIMALS)
                .arg(provider->getAccelometer_yAxis(), 0, 'f', ROUNDING_DECIMALS)
                .arg(provider->getAccelometer_zAxis(), 0, 'f', ROUNDING_DECIMALS);
        m_client->publish(m_topicPrefix + QLatin1String("accel"), accel.toLocal8Bit());
    }
}

void MqttEventHandler::uploadMagnetometer()
{
    if (!ensureConnected(m_client))
        return;

    SensorTagDataProvider *provider = m_providerPool->currentProvider();

    if (provider) {
        const QString magnet = QString("%1_%2_%3").arg(provider->getMagnetometerMicroT_xAxis(), 0, 'f', ROUNDING_DECIMALS)
                .arg(provider->getMagnetometerMicroT_yAxis(), 0, 'f', ROUNDING_DECIMALS)
                .arg(provider->getMagnetometerMicroT_zAxis(), 0, 'f', ROUNDING_DECIMALS);
        m_client->publish(m_topicPrefix + QLatin1String("magnet"), magnet.toLocal8Bit());
    }
}

void MqttEventHandler::uploadRotation()
{
    if (!ensureConnected(m_client))
        return;

    SensorTagDataProvider *provider = m_providerPool->currentProvider();

    if (provider) {
        const QString rotation = QString("%1_%2_%3").arg(provider->getRotationX(), 0, 'f', ROUNDING_DECIMALS)
                .arg(provider->getRotationY(), 0, 'f', ROUNDING_DECIMALS)
                .arg(provider->getRotationZ(), 0, 'f', ROUNDING_DECIMALS);
        m_client->publish(m_topicPrefix + QLatin1String("rotation"), rotation.toLocal8Bit());
    }
}

void MqttEventHandler::clientConnected()
{
    m_pingTimer.start();
}

void MqttEventHandler::sendAlive()
{
    m_client->publish(QLatin1String("sensors/active"), QString::fromLocal8Bit("%1>Online").arg(m_deviceName).toLocal8Bit(), 1);
}
#endif // !MQTT_TIMER_BASED_PUBLISH

#ifdef MQTT_TIMER_BASED_PUBLISH
void MqttUpdate::timerEvent(QTimerEvent *event)
{
    Q_UNUSED(event);

    if (!m_provider)
        return;

    writeToCloud();
}

void MqttUpdate::writeToCloud()
{
    if (!m_provider) {
        qWarning("MqttUpdate: sensor data provider not set. Data not updated");
        return;
    }

    if (m_client->state() == QMqttClient::Disconnected) {
        qCDebug(boot2QtDemos) << "Disconnected, need to reconnect";
        m_client->connectToHost();
    }
    if (m_client->state() == QMqttClient::Connected) {
        static bool sendTypeVersion = true;
        if (sendTypeVersion) {
            m_client->publish(m_topicPrefix + QLatin1String("type"), m_provider->sensorType());
            m_client->publish(m_topicPrefix + QLatin1String("version"), m_provider->versionString());
            sendTypeVersion = false;
        }
        m_client->publish(m_topicPrefix + QLatin1String("humid"),
                          QString("%1").arg(m_provider->getRelativeHumidity(), 0, 'f', ROUNDING_DECIMALS));
        m_client->publish(m_topicPrefix + QLatin1String("light"),
                          QString("%1").arg(m_provider->getLightIntensityLux(), 0, 'f', ROUNDING_DECIMALS));

        const QString temperature = QString("%1_%2").arg(m_provider->getInfraredAmbientTemperature(), 0, 'f', ROUNDING_DECIMALS)
                .arg(m_provider->getInfraredObjectTemperature(), 0, 'f', ROUNDING_DECIMALS);
        m_client->publish(m_topicPrefix + QLatin1String("temperature"), temperature);

        const QString baro = QString("%1_%2").arg(m_provider->getBarometerCelsiusTemperature(), 0, 'f', ROUNDING_DECIMALS)
                .arg(m_provider->getBarometer_hPa(), 0, 'f', ROUNDING_DECIMALS);
        m_client->publish(m_topicPrefix + QLatin1String("barometer"), baro);

        const QString gyro = QString("%1_%2_%3").arg(m_provider->getGyroscopeX_degPerSec(), 0, 'f', ROUNDING_DECIMALS)
                .arg(m_provider->getGyroscopeY_degPerSec(), 0, 'f', ROUNDING_DECIMALS)
                .arg(m_provider->getGyroscopeZ_degPerSec(), 0, 'f', ROUNDING_DECIMALS);
        m_client->publish(m_topicPrefix + QLatin1String("gyro"), gyro);

        const QString accel = QString("%1_%2_%3").arg(m_provider->getAccelometer_xAxis(), 0, 'f', ROUNDING_DECIMALS)
                .arg(m_provider->getAccelometer_yAxis(), 0, 'f', ROUNDING_DECIMALS)
                .arg(m_provider->getAccelometer_zAxis(), 0, 'f', ROUNDING_DECIMALS);
        m_client->publish(m_topicPrefix + QLatin1String("accel"), accel);

        const QString magnet = QString("%1_%2_%3").arg(m_provider->getMagnetometerMicroT_xAxis(), 0, 'f', ROUNDING_DECIMALS)
                .arg(m_provider->getMagnetometerMicroT_yAxis(), 0, 'f', ROUNDING_DECIMALS)
                .arg(m_provider->getMagnetometerMicroT_zAxis(), 0, 'f', ROUNDING_DECIMALS);
        m_client->publish(m_topicPrefix + QLatin1String("magnet"), magnet);

        const QString rotation = QString("%1_%2_%3").arg(m_provider->getRotationX(), 0, 'f', ROUNDING_DECIMALS)
                .arg(m_provider->getRotationY(), 0, 'f', ROUNDING_DECIMALS)
                .arg(m_provider->getRotationZ(), 0, 'f', ROUNDING_DECIMALS);
        m_client->publish(m_topicPrefix + QLatin1String("rotation"), rotation);
    }
}
#endif //MQTT_TIMER_BASED_PUBLISH

MqttEventHandler::MqttEventHandler(const QString &name, QObject *parent)
    : QObject(parent)
{
    m_deviceName = name;
    m_topicPrefix = QString::fromLocal8Bit("sensors/%1/").arg(m_deviceName);

    m_pingTimer.setInterval(5000);
    m_pingTimer.setSingleShot(false);
    connect(&m_pingTimer, &QTimer::timeout, this, &MqttEventHandler::sendAlive);

    m_client = new QMqttClient;
    m_client->setHostname(MqttCredentials::getBroker());
    m_client->setPort(MqttCredentials::getPort());
    m_client->setUsername(MqttCredentials::getUsername());
    m_client->setPassword(MqttCredentials::getPassword());

    m_client->setWillMessage(QString::fromLocal8Bit("%1>Offline").arg(m_deviceName).toLocal8Bit());
    m_client->setWillQoS(1);
    m_client->setWillRetain(true);
    m_client->setWillTopic(QString::fromLocal8Bit("sensors/active"));
    connect(m_client, &QMqttClient::connected, this, &MqttEventHandler::clientConnected);
}

MqttEventHandler::~MqttEventHandler()
{
    m_client->publish(QLatin1String("sensors/active"),
                      QString::fromLocal8Bit("%1>Offline").arg(m_deviceName).toLocal8Bit(), 1);
}
