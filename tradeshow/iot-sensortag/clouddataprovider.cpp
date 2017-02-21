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
#include "clouddataprovider.h"

#include <QUrl>
#include <QLoggingCategory>
#include <QTimer>

#define MAJOR_VERSION_NUMBER 1
#define MINOR_VERSION_NUMBER 1
#define CLOUD_DATA_POLL_INTERVAL_MS    1000 /* 1 second update interval */
#ifndef QT_NO_SSL
static QString dataFetchUrl = "https://ottoryynanenqt.blob.core.windows.net/btsensortagreadings/sensorTagReadings.txt";
#else
static QString dataFetchUrl = "http://ottoryynanenqt.blob.core.windows.net/btsensortagreadings/sensorTagReadings.txt";
#endif

Q_DECLARE_LOGGING_CATEGORY(boot2QtDemos)

CloudDataProvider::CloudDataProvider(QString id, QObject* parent)
    : SensorTagDataProvider(id, parent)
    , reply(Q_NULLPTR)
{
    intervalRotation = CLOUD_DATA_POLL_INTERVAL_MS;
    connect(&qnam, &QNetworkAccessManager::authenticationRequired,
            this, &CloudDataProvider::slotAuthenticationRequired);
#ifndef QT_NO_SSL
    connect(&qnam, &QNetworkAccessManager::sslErrors,
            this, &CloudDataProvider::sslErrors);
#endif
}

bool CloudDataProvider::startDataFetching()
{
    pollTimer = new QTimer(this);
    connect(pollTimer, SIGNAL(timeout()), this, SLOT(pollTimerExpired()));
    pollTimer->start(CLOUD_DATA_POLL_INTERVAL_MS);
    return true;
}

void CloudDataProvider::endDataFetching()
{
    httpRequestAborted = true;
    reply->abort();
}

void CloudDataProvider::parseReceivedText()
{
    QList<QByteArray> dataList = dataFetched.split('\n');
    if (dataList[2] != "Version:") {
        qWarning() << Q_FUNC_INFO << "Invalid file header:" << dataList[2];
        return;
    }

    QList<QByteArray> versionNumberList = dataList[3].split('.');
    const int dataMajorVersion = QString(versionNumberList[0]).toInt();
    const int dataMinorVersion = QString(versionNumberList[1]).toInt();
    if ((MAJOR_VERSION_NUMBER < dataMajorVersion) ||   // Major version not supported OR
        ((MAJOR_VERSION_NUMBER == dataMajorVersion) && // Major version OK but
         (MINOR_VERSION_NUMBER < dataMinorVersion))) { // Minor version not supported
        qWarning() << Q_FUNC_INFO << "Version" << dataList[3] << "not supported by version" << QString::number(MAJOR_VERSION_NUMBER)+"."+QString::number(MINOR_VERSION_NUMBER);
        return;
    }
    // Header OK, parse data.
    bool gyroscopeReadingGot = false;
    bool accelometerReadingGot = false;
    bool magnetometerReadingGot = false;
    bool rotationReadingsGot = false;
    for (int stringIndex = 4 ; stringIndex < (dataList.length()-1) ; stringIndex+=2) {
        const QString headerText(dataList[stringIndex]);
        const double doubleValue = QString(dataList[stringIndex+1]).toDouble();
        const float floatValue = QString(dataList[stringIndex+1]).toFloat();
        /* NOTE: We emit the signals even if value is unchanged.
         * Otherwise the scrolling graphs in UI will not scroll.
         */
        if ("Humid:" == headerText) {
            humidity = doubleValue;
            emit relativeHumidityChanged();
        } else if ("Temp(Ambient):" == headerText) {
            irAmbientTemperature = doubleValue;
            emit infraredAmbientTemperatureChanged();
        } else if ("Temp(Object):" == headerText) {
            irObjectTemperature = doubleValue;
            emit infraredObjectTemperatureChanged();
        } else if ("Light:" == headerText) {
            lightIntensityLux = doubleValue;
            emit lightIntensityChanged();
        } else if ("Temp(Baro):" == headerText) {
            barometerCelsiusTemperature = doubleValue;
            emit barometerCelsiusTemperatureChanged();
        } else if ("hPa:" == headerText) {
            barometerHPa = doubleValue;
            emit barometer_hPaChanged();
        } else if ("gyroX:" == headerText) {
            gyroscopeReadingGot = true;
            gyroscopeX_degPerSec = floatValue;
        } else if ("gyroY:" == headerText) {
            gyroscopeReadingGot = true;
            gyroscopeY_degPerSec = floatValue;
        } else if ("gyroZ:" == headerText) {
            gyroscopeReadingGot = true;
            gyroscopeZ_degPerSec = floatValue;
        } else if ("AccX:" == headerText) {
            accelometerReadingGot = true;
            accelometerX = floatValue;
        } else if ("AccY:" == headerText) {
            accelometerReadingGot = true;
            accelometerY = floatValue;
        } else if ("AccZ:" == headerText) {
            accelometerReadingGot = true;
            accelometerZ = floatValue;
        } else if ("MagnX:" == headerText) {
            magnetometerReadingGot = true;
            magnetometerMicroT_xAxis = floatValue;
        } else if ("MagnY:" == headerText) {
            magnetometerReadingGot = true;
            magnetometerMicroT_yAxis = floatValue;
        } else if ("MagnZ:" == headerText) {
            magnetometerReadingGot = true;
            magnetometerMicroT_zAxis = floatValue;
        } else if ("RotX:" == headerText) {
            rotation_x = floatValue;
            rotationReadingsGot = true;
            emit rotationXChanged();
        } else if ("RotY:" == headerText) {
            rotation_y = floatValue;
            rotationReadingsGot = true;
            emit rotationYChanged();
        } else if ("RotZ:" == headerText) {
            rotation_z = floatValue;
            rotationReadingsGot = true;
            emit rotationZChanged();
        } else {
            qCDebug(boot2QtDemos) << "Unsupported Header:" << headerText;
        }
    }
    if (gyroscopeReadingGot)
        emit gyroscopeDegPerSecChanged();
    if (accelometerReadingGot)
        emit accelometerChanged();
    if (magnetometerReadingGot)
        emit magnetometerMicroTChanged();
    if (rotationReadingsGot)
        emit rotationValuesChanged();
}

void CloudDataProvider::pollTimerExpired()
{
    if (!reply) {
        httpRequestAborted = false;
        dataFetched.clear();
        reply = qnam.get(QNetworkRequest(QUrl(dataFetchUrl)));
        connect(reply, &QNetworkReply::finished, this, &CloudDataProvider::httpFinished);
        connect(reply, &QIODevice::readyRead, this, &CloudDataProvider::httpReadyRead);
    } else {
        qWarning() << "Attempt to fetch before previous http request was completed.";
    }
}

void CloudDataProvider::httpFinished()
{
    if (httpRequestAborted) {
        qCDebug(boot2QtDemos) << "http request aborted.";
        return;
    }
    if (reply->error()) {
        qWarning() << "Failed to fetch data," << reply->errorString();
        return;
    }

    parseReceivedText();
    const QVariant redirectionTarget = reply->attribute(QNetworkRequest::RedirectionTargetAttribute);

    reply->deleteLater();
    reply = Q_NULLPTR;
}

void CloudDataProvider::httpReadyRead()
{
    // this slot gets called every time the QNetworkReply has new data.
    // We read all of its new data and write it into the file.
    // That way we use less RAM than when reading it at the finished()
    // signal of the QNetworkReply
    dataFetched += reply->readAll();
}

#ifndef QT_NO_SSL
void CloudDataProvider::sslErrors(QNetworkReply*, const QList<QSslError> &errors)
{
    QString errorString;
    for (const QSslError &error : errors) {
        if (!errorString.isEmpty())
            errorString += '\n';
        errorString += error.errorString();
    }

    qWarning() << "Ignoring SSL Error(s):" << errorString;
    reply->ignoreSslErrors();
}
#endif

void CloudDataProvider::slotAuthenticationRequired(QNetworkReply*, QAuthenticator *authenticator)
{
    Q_UNUSED(authenticator);
}

QString CloudDataProvider::sensorType() const
{
    return QString("cloud data");
}

QString CloudDataProvider::versionString() const
{
    return QString::number(MAJOR_VERSION_NUMBER)+"."+QString::number(MINOR_VERSION_NUMBER);
}
