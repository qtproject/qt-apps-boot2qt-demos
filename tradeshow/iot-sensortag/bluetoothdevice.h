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
#ifndef BLUETOOTHDEVICE_H
#define BLUETOOTHDEVICE_H

#include "serviceinfo.h"

#include <QBluetoothDeviceDiscoveryAgent>
#include <QLowEnergyController>
#include <QObject>
#include <QVariant>
#include <QList>
#include <QTimer>
#include <QElapsedTimer>

class MotionSensorData
{
public:
    double gyroScope_x;
    double gyroScope_y;
    double gyroScope_z;
    double accelometer_x;
    double accelometer_y;
    double accelometer_z;
    double magnetometer_x;
    double magnetometer_y;
    double magnetometer_z;
    quint64 msSincePreviousData;
    MotionSensorData() {
        gyroScope_x = 0;
        gyroScope_y = 0;
        gyroScope_z = 0;
        accelometer_x = 0;
        accelometer_y = 0;
        accelometer_z = 0;
        magnetometer_x = 0;
        magnetometer_y = 0;
        magnetometer_z = 0;
        msSincePreviousData = 0;
    }
};

typedef enum CharacteristicType {
    temperatureCharacteristic = 0,
    humidityCharacteristic,
    barometerCharacteristic,
    motionCharacteristic,
    lightCharacteristic
} CharacteristicType;

class SensorTagDataProvider;

class BluetoothDevice: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString deviceName READ getName CONSTANT)
    Q_PROPERTY(QString deviceAddress READ getAddress CONSTANT)
    Q_PROPERTY(DeviceState state READ state NOTIFY stateChanged)

    Q_PROPERTY(QVariant servicesList READ getServices NOTIFY servicesUpdated)
    Q_PROPERTY(QVariant characteristicList READ getCharacteristics NOTIFY characteristicsUpdated)
    Q_PROPERTY(bool useRandomAddress MEMBER randomAddress NOTIFY randomAddressChanged)

public:
    enum DeviceState {Disconnected = 0, Scanning, Connected, Error};
    Q_ENUM(DeviceState)

    BluetoothDevice();
    BluetoothDevice(const QBluetoothDeviceInfo &d);
    ~BluetoothDevice();

    QString getAddress() const;
    QString getName() const;

    QVariant getServices();
    QVariant getCharacteristics();
    DeviceState state() const;

signals:
    void servicesUpdated();
    void characteristicsUpdated();
    void updateChanged();
    void stateChanged();
    void randomAddressChanged();
    void temperatureChanged(double ambientTemperature, double objectTemperature);
    void barometerChanged(double temperature, double barometer);
    void humidityChanged(double humidity);
    void lightIntensityChanged(double intensity);
    void motionChanged(MotionSensorData& data);
    void statusUpdated(QString statusMsg);

public slots:
    void scanServices();
    void connectToService(const QString &uuid);
    void disconnectFromDevice();
    void temperatureDetailsDiscovered(QLowEnergyService::ServiceState newstate);
    void barometerDetailsDiscovered(QLowEnergyService::ServiceState newstate);
    void humidityDetailsDiscovered(QLowEnergyService::ServiceState newstate);
    void lightIntensityDetailsDiscovered(QLowEnergyService::ServiceState newstate);
    void motionDetailsDiscovered(QLowEnergyService::ServiceState newstate);

private slots:
    // QLowEnergyController realted
    void addLowEnergyService(const QBluetoothUuid &uuid);
    void deviceConnected();
    void errorReceived(QLowEnergyController::Error);
    void serviceScanDone();
    void deviceDisconnected();

    // QLowEnergyService related
    void serviceDetailsDiscovered(QLowEnergyService::ServiceState newState);

    void characteristicsRead(const QLowEnergyCharacteristic &info,
                             const QByteArray &value);

private:
    void setState(DeviceState state);

private:
    void irTemperatureReceived(const QByteArray &value);
    void barometerReceived(const QByteArray &value);
    void humidityReceived(const QByteArray &value);
    void lightIntensityReceived(const QByteArray &value);
    void motionReceived(const QByteArray &value);
    double convertIrTemperatureAPIReadingToCelsius(quint16 rawReading);

    QBluetoothDeviceDiscoveryAgent *discoveryAgent;
    QList<QObject*> m_services;
    QList<QObject*> m_characteristics;
    QString m_previousAddress;
    QLowEnergyController *controller;
    QLowEnergyService* irTemperatureService;
    QLowEnergyService* baroService;
    QLowEnergyService* humidityService;
    QLowEnergyService* lightService;
    QLowEnergyService* motionService;
    DeviceState m_deviceState;
    bool m_temperatureMeasurementStarted;
    bool m_barometerMeasurementStarted;
    bool m_humidityMeasurementStarted;
    bool m_lightIntensityMeasurementStarted;
    bool m_motionMeasurementStarted;
    bool randomAddress;
    QElapsedTimer attitudeChangeInterval;
    quint64 lastMilliseconds;

    QBluetoothDeviceInfo m_deviceInfo;

    SensorTagDataProvider *m_dataProvider;
};

#endif // BLUETOOTHBLUETOOTHDEVICE_H