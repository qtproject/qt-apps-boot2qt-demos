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

#include "mqttdataprovider.h"

#include <QUrl>
#include <QLoggingCategory>
#include <QTimer>

#define MAJOR_VERSION_NUMBER 1
#define MINOR_VERSION_NUMBER 0

Q_DECLARE_LOGGING_CATEGORY(boot2QtDemos)

MqttDataProvider::MqttDataProvider(QString id, QMqttClient *client, QObject *parent)
    : SensorTagDataProvider(id, parent)
    , m_client(client)
    , m_subscription(nullptr)
{
    intervalRotation = 200;

    m_pollTimer = new QTimer(this);
    m_pollTimer->setInterval(intervalRotation);
    m_pollTimer->setSingleShot(false);
    connect(m_pollTimer, &QTimer::timeout, this, &MqttDataProvider::dataTimeout);
}

bool MqttDataProvider::startDataFetching()
{
    const QString subName = QString::fromLocal8Bit("sensors/%1/#").arg(m_id);

    m_subscription = m_client->subscribe(subName);
    connect(m_subscription, &QMqttSubscription::messageReceived,
            this, &MqttDataProvider::messageReceived);
    return true;
}

void MqttDataProvider::endDataFetching()
{
    if (m_subscription) {
        disconnect(m_subscription, &QMqttSubscription::messageReceived,
                   this, &MqttDataProvider::messageReceived);
        m_subscription->unsubscribe();
        m_subscription = nullptr;
    }
}

QString MqttDataProvider::sensorType() const
{
    return QString("mqtt data");
}

QString MqttDataProvider::versionString() const
{
    return QString::number(MAJOR_VERSION_NUMBER) + "." + QString::number(MINOR_VERSION_NUMBER);
}

void MqttDataProvider::reset()
{
}

void MqttDataProvider::messageReceived(const QMqttMessage &msg)
{
    parseMessage(msg.payload(), msg.topic());
    if (!m_pollTimer->isActive())
        m_pollTimer->start();
}

void MqttDataProvider::parseMessage(const QString &content, const QString &topic)
{
    const QString msgType = topic.split(QLatin1Char('/')).last();
    if (msgType == QStringLiteral("type")) {
        qDebug() << "Type: " << content;
    } else if (msgType == QStringLiteral("version")) {
        qDebug() << "Version: " << content;
    } else if (msgType == QStringLiteral("humid")) {
        bool ok;
        const double v = content.toDouble(&ok);
        if (ok)
            humidity = v;
    } else if (msgType == QStringLiteral("light")) {
        bool ok;
        const double v = content.toDouble(&ok);
        if (ok)
            lightIntensityLux = v;
    } else if (msgType == QStringLiteral("temperature")) {
        //ambient_object
        QString streamContent = content;
        QTextStream stream(&streamContent);
        double ambient, object;
        char c;
        stream >> ambient >> c >> object;

        irAmbientTemperature = ambient;
        irObjectTemperature = object;
    } else if (msgType == QStringLiteral("barometer")) {
        QString streamContent = content;
        QTextStream stream(&streamContent);
        double v1, v2;
        char c;
        stream >> v1 >> c >> v2;
        barometerCelsiusTemperature = v1;
        barometerHPa = v2;
    } else if (msgType == QStringLiteral("gyro")) {
        QString streamContent = content;
        QTextStream stream(&streamContent);
        double v1, v2, v3;
        char c;
        stream >> v1 >> c >> v2 >> c >> v3;
        gyroscopeX_degPerSec = v1;
        gyroscopeY_degPerSec = v2;
        gyroscopeZ_degPerSec = v3;
    } else if (msgType == QStringLiteral("accel")) {
        QString streamContent = content;
        QTextStream stream(&streamContent);
        double v1, v2, v3;
        char c;
        stream >> v1 >> c >> v2 >> c >> v3;
        accelometerX = v1;
        accelometerY = v2;
        accelometerZ = v3;
    } else if (msgType == QStringLiteral("magnet")) {
        QString streamContent = content;
        QTextStream stream(&streamContent);
        double v1, v2, v3;
        char c;
        stream >> v1 >> c >> v2 >> c >> v3;
        magnetometerMicroT_xAxis = v1;
        magnetometerMicroT_yAxis = v2;
        magnetometerMicroT_zAxis = v3;
    } else if (msgType == QStringLiteral("rotation")) {
        QString streamContent = content;
        QTextStream stream(&streamContent);
        double v1, v2, v3;
        char c;
        stream >> v1 >> c >> v2 >> c >> v3;
        rotation_x = v1;
        rotation_y = v2;
        rotation_z = v3;
    } else if (msgType == QStringLiteral("altitude")) {
        QString streamContent = content;
        QTextStream stream(&streamContent);
        float alt;
        stream >> alt;
        altitude = alt;
    } else {
        qWarning() << "Unknown sensor data received:" << topic;
    }
}

void MqttDataProvider::dataTimeout()
{
    emit relativeHumidityChanged();
    emit lightIntensityChanged();
    emit infraredAmbientTemperatureChanged();
    emit infraredObjectTemperatureChanged();
    emit barometerCelsiusTemperatureChanged();
    emit barometer_hPaChanged();
    emit gyroscopeDegPerSecChanged();
    emit accelometerChanged();
    emit magnetometerMicroTChanged();
    emit rotationXChanged();
    emit rotationYChanged();
    emit rotationZChanged();
    emit altitudeChanged();
    emit rotationValuesChanged();
}
