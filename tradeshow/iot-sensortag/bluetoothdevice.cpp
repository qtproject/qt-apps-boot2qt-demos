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
#include "bluetoothdevice.h"
#include "characteristicinfo.h"

#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>
#include <QLowEnergyService>
#include <QLoggingCategory>
#include <QList>
#include <QTimer>
#include <QDebug>
#include <QtMath>
#include <QDateTime>

Q_DECLARE_LOGGING_CATEGORY(boot2QtDemos)

#define START_MEASUREMENT_STR                    "01"   /* 01 start, 00 stop */
#define DISABLE_NOTIF_STR                        "0000" /* 0100 enable, 0000 disable */
#define ENABLE_NOTIF_STR                         "0100" /* 0100 enable, 0000 disable */
#define SLOW_TIMER_TIMEOUT_STR                   "64"   /* 100 -> 1000ms */
#define MEDIUM_TIMER_TIMEOUT_STR                 "32"   /* 50 -> 500ms */
#define RAPID_TIMER_TIMEOUT_STR                  "0A"   /* 10 -> 100ms */
#define MOVEMENT_ENABLE_SENSORS_BITMASK_VALUE    "7F02" /* see below */
//Enable motion axis: 0b0000_0010_0111_1111 = 0x7F 0x02  (all sensors, 8G, no wake on motion)
//bits of first byte:
//MPU9250_GYROSCOPE      = 0b0000_0111 all 3 xyz axes, 1 bit per axis
//MPU9250_ACCELEROMETER  = 0b0011_1000 all 3 xyz axes, 1 bit per axis
//MPU9250_MAGNETOMETER   = 0b0100_0000 all 3 xyz axes with one bit
//MPU9250_WAKEONMOTION   = 0b1000_0000 enables wake on motion
//bits of second byte (only 2 bits used) Accelerometer range in G
//MPU9250_ACCELEROMETER_RANGE_0       =0b0000_0000    =  2 G
//MPU9250_ACCELEROMETER_RANGE_1       =0b0000_0001    =  4 G
//MPU9250_ACCELEROMETER_RANGE_2       =0b0000_0010    =  8 G (default)
//MPU9250_ACCELEROMETER_RANGE_3       =0b0000_0011    = 16 G

// These modifiers come from the Texas Intruments SensorTag Bluetooth LE API specification
#define GYROSCOPE_API_READING_MULTIPLIER      (500.0 / 65536.0)
#define ACCELOMETER_API_READING_MULTIPLIER    (8.0 / 32.768)
#define HUMIDITY_API_READING_MULTIPLIER       (100.0 / 65536.0)
#define IR_TEMPERATURE_API_READING_DIVIDER    128.0
#define BAROMETER_API_READING_DIVIDER         100

typedef struct {
    qint16 gyrox;
    qint16 gyroy;
    qint16 gyroz;
    qint16 accelx;
    qint16 accely;
    qint16 accelz;
    qint16 magnetomx;
    qint16 magnetomy;
    qint16 magnetomz;
} movement_data_t;

BluetoothDevice::BluetoothDevice()
    : discoveryAgent(0)
    , controller(0)
    , irTemperatureService(0)
    , baroService(0)
    , humidityService(0)
    , lightService(0)
    , motionService(0)
    , m_deviceState(DeviceState::Disconnected)
    , randomAddress(false)
{
    lastMilliseconds = QDateTime::currentMSecsSinceEpoch();
    statusUpdated("Device created");
}

BluetoothDevice::BluetoothDevice(const QBluetoothDeviceInfo &d)
    : BluetoothDevice()
{
    m_deviceInfo = d;
}

BluetoothDevice::~BluetoothDevice()
{
    delete discoveryAgent;
    delete controller;
    qDeleteAll(m_services);
    qDeleteAll(m_characteristics);
    m_services.clear();
    m_characteristics.clear();
}
QString BluetoothDevice::getAddress() const
{
#if defined(Q_OS_DARWIN)
    // On Apple platforms we do not have addresses,
    // only unique UUIDs generated by Core Bluetooth.
    return m_deviceInfo.deviceUuid().toString();
#else
    return m_deviceInfo.address().toString();
#endif
}

QString BluetoothDevice::getName() const
{
    return m_deviceInfo.name();
}

QVariant BluetoothDevice::getServices()
{
    return QVariant::fromValue(m_services);
}

QVariant BluetoothDevice::getCharacteristics()
{
    return QVariant::fromValue(m_characteristics);
}

void BluetoothDevice::scanServices()
{
    qDeleteAll(m_characteristics);
    m_characteristics.clear();
    emit characteristicsUpdated();
    qDeleteAll(m_services);
    m_services.clear();
    emit servicesUpdated();

    statusUpdated("(Connecting to device...)");

    if (controller && m_previousAddress != getAddress()) {
        controller->disconnectFromDevice();
        delete controller;
        controller = 0;
    }

    if (!controller) {
        // Connecting signals and slots for connecting to LE services.
        controller = new QLowEnergyController(m_deviceInfo);
        connect(controller, SIGNAL(connected()),
                this, SLOT(deviceConnected()));
        connect(controller, SIGNAL(error(QLowEnergyController::Error)),
                this, SLOT(errorReceived(QLowEnergyController::Error)));
        connect(controller, SIGNAL(disconnected()),
                this, SLOT(deviceDisconnected()));
        connect(controller, SIGNAL(serviceDiscovered(QBluetoothUuid)),
                this, SLOT(addLowEnergyService(QBluetoothUuid)));
        connect(controller, SIGNAL(discoveryFinished()),
                this, SLOT(serviceScanDone()));
    }

    if (randomAddress)
        controller->setRemoteAddressType(QLowEnergyController::RandomAddress);
    else
        controller->setRemoteAddressType(QLowEnergyController::PublicAddress);
    controller->connectToDevice();
}

void BluetoothDevice::addLowEnergyService(const QBluetoothUuid &serviceUuid)
{
    QLowEnergyService *service = controller->createServiceObject(serviceUuid);
    if (!service) {
        qWarning() << "Cannot create service for uuid";
        return;
    }
    ServiceInfo *serv = new ServiceInfo(service);
    m_services.append(serv);

    emit servicesUpdated();
}

void BluetoothDevice::serviceScanDone()
{
    statusUpdated("(Service scan done!)");
    // force UI in case we didn't find anything
    if (m_services.isEmpty())
        emit servicesUpdated();
    else {
        qCDebug(boot2QtDemos) << "ServiceScan done.";
        if (!irTemperatureService)
        {
            QBluetoothUuid uuid;
            for (int i = 0; i < controller->services().count(); i++) {
                QBluetoothUuid id = controller->services().at(i);
                if (id.toString().contains("f000aa00-0451-4000-b000-000000000000")) {
                    uuid = id;
                    break;
                }
            }

            irTemperatureService = controller->createServiceObject(uuid);
            connect(irTemperatureService, &QLowEnergyService::stateChanged, this, &BluetoothDevice::temperatureDetailsDiscovered);
            connect(irTemperatureService, &QLowEnergyService::characteristicChanged, this, &BluetoothDevice::characteristicsRead);
            irTemperatureService->discoverDetails();
        }
        if (!baroService)
        {
            QBluetoothUuid uuid;
            for (int i = 0; i < controller->services().count(); i++) {
                QBluetoothUuid id = controller->services().at(i);
                if (id.toString().contains("f000aa40-0451-4000-b000-000000000000")) {
                    uuid = id;
                    break;
                }
            }

            baroService = controller->createServiceObject(uuid);
            connect(baroService, &QLowEnergyService::stateChanged, this, &BluetoothDevice::barometerDetailsDiscovered);
            connect(baroService, &QLowEnergyService::characteristicChanged, this, &BluetoothDevice::characteristicsRead);
            baroService->discoverDetails();
        }
        if (!humidityService)
        {
            QBluetoothUuid uuid;
            for (int i = 0; i < controller->services().count(); i++) {
                QBluetoothUuid id = controller->services().at(i);
                if (id.toString().contains("f000aa20-0451-4000-b000-000000000000")) {
                    uuid = id;
                    break;
                }

            }

            humidityService = controller->createServiceObject(uuid);
            connect(humidityService, &QLowEnergyService::stateChanged, this, &BluetoothDevice::humidityDetailsDiscovered);
            connect(humidityService, &QLowEnergyService::characteristicChanged, this, &BluetoothDevice::characteristicsRead);
            humidityService->discoverDetails();
        }

        if (!lightService)
        {
            QBluetoothUuid uuid;
            for (int i = 0; i < controller->services().count(); i++) {
                QBluetoothUuid id = controller->services().at(i);
                if (id.toString().contains("f000aa70-0451-4000-b000-000000000000")) {
                    uuid = id;
                    break;
                }

            }

            lightService = controller->createServiceObject(uuid);
            connect(lightService, &QLowEnergyService::stateChanged, this, &BluetoothDevice::lightIntensityDetailsDiscovered);
            connect(lightService, &QLowEnergyService::characteristicChanged, this, &BluetoothDevice::characteristicsRead);
            lightService->discoverDetails();
        }
        if (!motionService)
        {
            QBluetoothUuid uuid;
            for (int i = 0; i < controller->services().count(); i++) {
                QBluetoothUuid id = controller->services().at(i);
                if (id.toString().contains("f000aa80-0451-4000-b000-000000000000")) {
                    uuid = id;
                    break;
                }
            }
            motionService = controller->createServiceObject(uuid);
            connect(motionService, &QLowEnergyService::stateChanged, this, &BluetoothDevice::motionDetailsDiscovered);
            connect(motionService, &QLowEnergyService::characteristicChanged, this, &BluetoothDevice::characteristicsRead);
            motionService->discoverDetails();
        }
        attitudeChangeInterval.restart();
    }
}

void BluetoothDevice::temperatureDetailsDiscovered(QLowEnergyService::ServiceState newstate)
{
    if (newstate == QLowEnergyService::ServiceDiscovered) {
        connect(irTemperatureService, &QLowEnergyService::characteristicWritten, [=]() {
            qCDebug(boot2QtDemos) << "Wrote Characteristic - temperature";
        });

        connect(irTemperatureService, static_cast<void(QLowEnergyService::*)(QLowEnergyService::ServiceError)>(&QLowEnergyService::error),
            [=](QLowEnergyService::ServiceError newError) {
            qCDebug(boot2QtDemos) << "error while writing - temperature:" << newError;
        });

        for (int i = 0; i < irTemperatureService->characteristics().count(); i++ ) {
            QLowEnergyCharacteristic characteristic = irTemperatureService->characteristics().at(i);
            QBluetoothUuid id = characteristic.uuid();

            if (id.toString().contains("f000aa01-0451-4000-b000-000000000000")) {
                //RN
                irTemperatureService->writeDescriptor(characteristic.descriptors().at(0), QByteArray::fromHex(ENABLE_NOTIF_STR));
            }
            if (id.toString().contains("f000aa02-0451-4000-b000-000000000000")) {
                //RW
                irTemperatureService->writeCharacteristic(characteristic, QByteArray::fromHex(START_MEASUREMENT_STR), QLowEnergyService::WriteWithResponse); // Start
            }
            if (id.toString().contains("f000aa03-0451-4000-b000-000000000000")) {
                //RW
                irTemperatureService->writeCharacteristic(characteristic, QByteArray::fromHex(SLOW_TIMER_TIMEOUT_STR), QLowEnergyService::WriteWithResponse); // Period 1 second
            }
        }
        m_temperatureMeasurementStarted = true;
    }
}

void BluetoothDevice::barometerDetailsDiscovered(QLowEnergyService::ServiceState newstate) {
    if (newstate == QLowEnergyService::ServiceDiscovered) {
        connect(baroService, &QLowEnergyService::characteristicWritten, [=]() {
            qCDebug(boot2QtDemos) << "Wrote Characteristic - barometer";
        });

        connect(baroService, static_cast<void(QLowEnergyService::*)(QLowEnergyService::ServiceError)>(&QLowEnergyService::error),
            [=](QLowEnergyService::ServiceError newError) {
            qCDebug(boot2QtDemos) << "error while writing - barometer:" << newError;
        });

        for (int i = 0; i < baroService->characteristics().count(); i++ ) {
          QLowEnergyCharacteristic characteristic = baroService->characteristics().at(i);
          QBluetoothUuid id = characteristic.uuid();
          qCDebug(boot2QtDemos)<<"characteristic:"<<id.toString();

          if (id.toString().contains("f000aa41-0451-4000-b000-000000000000")) {
              baroService->writeDescriptor(characteristic.descriptors().at(0), QByteArray::fromHex(ENABLE_NOTIF_STR));
          }
          if (id.toString().contains("f000aa42-0451-4000-b000-000000000000")) {
              baroService->writeCharacteristic(characteristic, QByteArray::fromHex(START_MEASUREMENT_STR), QLowEnergyService::WriteWithResponse); // Start
          }
          if (id.toString().contains("f000aa44-0451-4000-b000-000000000000")) {
              baroService->writeCharacteristic(characteristic, QByteArray::fromHex(MEDIUM_TIMER_TIMEOUT_STR), QLowEnergyService::WriteWithResponse); // Period 1 second
          }
        }
        m_barometerMeasurementStarted = true;
    }
}

void BluetoothDevice::humidityDetailsDiscovered(QLowEnergyService::ServiceState newstate)
{
    if (newstate == QLowEnergyService::ServiceDiscovered) {
        connect(humidityService, &QLowEnergyService::characteristicWritten, [=]() {
            qCDebug(boot2QtDemos) << "Wrote Characteristic - humidity";
        });

        connect(humidityService, static_cast<void(QLowEnergyService::*)(QLowEnergyService::ServiceError)>(&QLowEnergyService::error),
            [=](QLowEnergyService::ServiceError newError) {
            qCDebug(boot2QtDemos) << "error while writing - humidity:" << newError;
        });

        for (int i = 0; i < humidityService->characteristics().count(); i++ ) {
          QLowEnergyCharacteristic characteristic = humidityService->characteristics().at(i);
          QBluetoothUuid id = characteristic.uuid();
          qCDebug(boot2QtDemos)<<"characteristic:"<<id.toString();

          if (id.toString().contains("f000aa21-0451-4000-b000-000000000000")) {
              humidityService->writeDescriptor(characteristic.descriptors().at(0), QByteArray::fromHex(ENABLE_NOTIF_STR));
          }
          if (id.toString().contains("f000aa22-0451-4000-b000-000000000000")) {
              humidityService->writeCharacteristic(characteristic, QByteArray::fromHex(START_MEASUREMENT_STR), QLowEnergyService::WriteWithResponse); // Start
          }
          if (id.toString().contains("f000aa23-0451-4000-b000-000000000000")) {
              humidityService->writeCharacteristic(characteristic, QByteArray::fromHex(SLOW_TIMER_TIMEOUT_STR), QLowEnergyService::WriteWithResponse); // Period 1 second
          }
        }
        m_humidityMeasurementStarted = true;
    }
}

void BluetoothDevice::lightIntensityDetailsDiscovered(QLowEnergyService::ServiceState newstate)
{
    if (newstate == QLowEnergyService::ServiceDiscovered) {
        connect(lightService, &QLowEnergyService::characteristicWritten, [=]() {
            qCDebug(boot2QtDemos) << "Wrote Characteristic - light intensity";
        });

        connect(lightService, static_cast<void(QLowEnergyService::*)(QLowEnergyService::ServiceError)>(&QLowEnergyService::error),
            [=](QLowEnergyService::ServiceError newError) {
            qCDebug(boot2QtDemos) << "error while writing - light intensity:" << newError;
        });

        for (int i = 0; i < lightService->characteristics().count(); i++ ) {
          QLowEnergyCharacteristic characteristic = lightService->characteristics().at(i);
          QBluetoothUuid id = characteristic.uuid();
          qCDebug(boot2QtDemos)<<"characteristic:"<<id.toString();

          if (id.toString().contains("f000aa71-0451-4000-b000-000000000000")) {
              lightService->writeDescriptor(characteristic.descriptors().at(0), QByteArray::fromHex(ENABLE_NOTIF_STR));
          }
          if (id.toString().contains("f000aa72-0451-4000-b000-000000000000")) {
              lightService->writeCharacteristic(characteristic, QByteArray::fromHex(START_MEASUREMENT_STR), QLowEnergyService::WriteWithResponse); // Start
          }
          if (id.toString().contains("f000aa73-0451-4000-b000-000000000000")) {
              lightService->writeCharacteristic(characteristic, QByteArray::fromHex(MEDIUM_TIMER_TIMEOUT_STR), QLowEnergyService::WriteWithResponse); // Period 1 second
          }
        }
        m_lightIntensityMeasurementStarted = true;
    }
}

void BluetoothDevice::motionDetailsDiscovered(QLowEnergyService::ServiceState newstate)
{
    // reset the time once more before we start to receive measurements.
    lastMilliseconds = QDateTime::currentMSecsSinceEpoch();

    if (newstate == QLowEnergyService::ServiceDiscovered) {
        connect(motionService, &QLowEnergyService::characteristicWritten, [=]() {
            qCDebug(boot2QtDemos) << "Wrote Characteristic - gyro";
        });

        connect(motionService, static_cast<void(QLowEnergyService::*)(QLowEnergyService::ServiceError)>(&QLowEnergyService::error),
            [=](QLowEnergyService::ServiceError newError) {
            qCDebug(boot2QtDemos) << "error while writing - gyro:" << newError;
        });

        for (int i = 0; i < motionService->characteristics().count(); i++ ) {
          QLowEnergyCharacteristic characteristic = motionService->characteristics().at(i);
          QBluetoothUuid id = characteristic.uuid();
          qCDebug(boot2QtDemos)<<"characteristic:"<<id.toString();

          if (id.toString().contains("f000aa81-0451-4000-b000-000000000000")) {
              motionService->writeDescriptor(characteristic.descriptors().at(0), QByteArray::fromHex(ENABLE_NOTIF_STR));
          }
          if (id.toString().contains("f000aa82-0451-4000-b000-000000000000")) {
              motionService->writeCharacteristic(characteristic, QByteArray::fromHex(MOVEMENT_ENABLE_SENSORS_BITMASK_VALUE), QLowEnergyService::WriteWithResponse);
          }
          if (id.toString().contains("f000aa83-0451-4000-b000-000000000000")) {
              motionService->writeCharacteristic(characteristic, QByteArray::fromHex(RAPID_TIMER_TIMEOUT_STR), QLowEnergyService::WriteWithResponse);
          }
        }
        m_motionMeasurementStarted = true;
    }
}

void BluetoothDevice::characteristicsRead(const QLowEnergyCharacteristic &info, const QByteArray &value)
{
    switch (info.handle())
    {
    case 0x0021:
        irTemperatureReceived(value);
        break;
    case 0x0029:
        humidityReceived(value);
        break;
    case 0x0031:
        barometerReceived(value);
        break;
    case 0x0039:
        motionReceived(value);
        break;
    case 0x0041:
        lightIntensityReceived(value);
        break;
    default:
        qWarning() << "Invalid handle" << info.handle() << "in characteristicsRead!";
        break;
    }
}

void BluetoothDevice::setState(BluetoothDevice::DeviceState state)
{
    if (m_deviceState != state) {
        m_deviceState = state;
        emit stateChanged();
    }
}

double BluetoothDevice::convertIrTemperatureAPIReadingToCelsius(quint16 rawReading)
{
    // Compute and filter final value according to TI Bluetooth LE API
    const float SCALE_LSB = 0.03125;
    int it = (int)((rawReading) >> 2);
    float t = (float)it;
    return t * SCALE_LSB;
}

void BluetoothDevice::irTemperatureReceived(const QByteArray &value)
{
    const unsigned int rawObjectTemperature = (((quint8)value.at(3)) << 8) + ((quint8)value.at(2));
    const double objectTemperature = convertIrTemperatureAPIReadingToCelsius(rawObjectTemperature);
    const unsigned int rawAmbientTemperature = (((quint8)value.at(1)) << 8) + ((quint8)value.at(0));
    const double ambientTemperature = convertIrTemperatureAPIReadingToCelsius(rawAmbientTemperature);
    emit temperatureChanged(ambientTemperature, objectTemperature);
}

void BluetoothDevice::barometerReceived(const QByteArray &value)
{
    //Merge bytes
    unsigned int temperature_raw;
    unsigned int barometer_raw;
    if (value.length() == 6) {
        temperature_raw = (((quint8)value.at(2)) << 16) + (((quint8)value.at(1)) << 8) + ((quint8)value.at(0));
        barometer_raw = (((quint8)value.at(5)) << 16) + (((quint8)value.at(4)) << 8) + ((quint8)value.at(3));
    } else {
        temperature_raw = (((quint8)value.at(1)) << 8) + ((quint8)value.at(0));
        barometer_raw = (((quint8)value.at(3)) << 8) + ((quint8)value.at(2));
    }

    double temperature = static_cast<double>(temperature_raw);
    temperature /= BAROMETER_API_READING_DIVIDER;

    double barometer = static_cast<double>(barometer_raw);
    barometer /= BAROMETER_API_READING_DIVIDER;
    emit barometerChanged(temperature, barometer);
}

void BluetoothDevice::humidityReceived(const QByteArray &value)
{
    //Merge bytes
    unsigned int humidity_raw = (((quint8)value.at(3)) << 8) + ((quint8)value.at(2));
    double humidity = static_cast<double>(humidity_raw);
    humidity = humidity * HUMIDITY_API_READING_MULTIPLIER;
    emit humidityChanged(humidity);
}

void BluetoothDevice::lightIntensityReceived(const QByteArray &value)
{
    //Merge bytes
    uint16_t lightIntensity_raw;
    lightIntensity_raw = (((quint8)value.at(1)) << 8) + ((quint8)value.at(0));
    uint16_t e, m;
    m = lightIntensity_raw & 0x0FFF;
    e = (lightIntensity_raw & 0xF000) >> 12;

    // Compute and final value according to TI Bluetooth LE API
    double lightIntensity = ((double)m) * (0.01 * (double)qPow(2.0,(qreal)e));
    emit lightIntensityChanged(lightIntensity);
}

void BluetoothDevice::motionReceived(const QByteArray &value)
{
    static MotionSensorData data;
    data.msSincePreviousData = lastMilliseconds;
    lastMilliseconds = QDateTime::currentMSecsSinceEpoch();
    data.msSincePreviousData = lastMilliseconds - data.msSincePreviousData;
    movement_data_t values;
    quint8* writePtr = (quint8*)(&values);

    for (int i = 0; i < 18; ++i) {
        *writePtr = (quint8)value.at(i);
        writePtr++;
    }

    // Data is in little endian. Fix here if needed.

    //Convert gyroscope and accelometer readings to proper units
    data.gyroScope_x = double(values.gyrox) * GYROSCOPE_API_READING_MULTIPLIER;
    data.gyroScope_y = double(values.gyroy) * GYROSCOPE_API_READING_MULTIPLIER;
    data.gyroScope_z = double(values.gyroz) * GYROSCOPE_API_READING_MULTIPLIER;
    // Accelometer at 8G
    data.accelometer_x = double(values.accelx) * ACCELOMETER_API_READING_MULTIPLIER;
    data.accelometer_y = double(values.accely) * ACCELOMETER_API_READING_MULTIPLIER;
    data.accelometer_z = double(values.accelz) * ACCELOMETER_API_READING_MULTIPLIER;
    data.magnetometer_x = double(values.magnetomx);
    data.magnetometer_y = double(values.magnetomy);
    data.magnetometer_z = double(values.magnetomz);
    emit motionChanged(data);
}

void BluetoothDevice::connectToService(const QString &uuid)
{
    QLowEnergyService *service = 0;
    for (int i = 0; i < m_services.size(); i++) {
        ServiceInfo *serviceInfo = (ServiceInfo*)m_services.at(i);
        if (serviceInfo->getUuid() == uuid) {
            service = serviceInfo->service();
            break;
        }
    }

    if (!service)
        return;

    qDeleteAll(m_characteristics);
    m_characteristics.clear();
    emit characteristicsUpdated();

    if (service->state() == QLowEnergyService::DiscoveryRequired) {
        connect(service, SIGNAL(stateChanged(QLowEnergyService::ServiceState)),
                this, SLOT(serviceDetailsDiscovered(QLowEnergyService::ServiceState)));
        service->discoverDetails();
        statusUpdated("(Discovering details...)");
        return;
    }

    //discovery already done
    const QList<QLowEnergyCharacteristic> chars = service->characteristics();
    foreach (const QLowEnergyCharacteristic &ch, chars) {
        CharacteristicInfo *cInfo = new CharacteristicInfo(ch);
        m_characteristics.append(cInfo);
    }

    QTimer::singleShot(0, this, SIGNAL(characteristicsUpdated()));
}

void BluetoothDevice::deviceConnected()
{
    setState(DeviceState::Connected);
    statusUpdated("(Discovering services...)");
    controller->discoverServices();
}

void BluetoothDevice::errorReceived(QLowEnergyController::Error /*error*/)
{
    setState(DeviceState::Error);
    statusUpdated(QString("Error: %1)").arg(controller->errorString()));
}

void BluetoothDevice::disconnectFromDevice()
{
    // UI always expects disconnect() signal when calling this signal
    // TODO what is really needed is to extend state() to a multi value
    // and thus allowing UI to keep track of controller progress in addition to
    // device scan progress

    if (controller->state() != QLowEnergyController::UnconnectedState)
        controller->disconnectFromDevice();
    else
        deviceDisconnected();
}

void BluetoothDevice::deviceDisconnected()
{
    statusUpdated("Disconnect from device");
    setState(BluetoothDevice::Disconnected);
}

void BluetoothDevice::serviceDetailsDiscovered(QLowEnergyService::ServiceState newState)
{
    if (newState != QLowEnergyService::ServiceDiscovered) {
        // do not hang in "Scanning for characteristics" mode forever
        // in case the service discovery failed
        // We have to queue the signal up to give UI time to even enter
        // the above mode
        if (newState != QLowEnergyService::DiscoveringServices) {
            QMetaObject::invokeMethod(this, "characteristicsUpdated",
                                      Qt::QueuedConnection);
        }
        return;
    }

    QLowEnergyService *service = qobject_cast<QLowEnergyService *>(sender());
    if (!service)
        return;


    const QList<QLowEnergyCharacteristic> chars = service->characteristics();
    foreach (const QLowEnergyCharacteristic &ch, chars) {
        CharacteristicInfo *cInfo = new CharacteristicInfo(ch);
        m_characteristics.append(cInfo);
    }

    emit characteristicsUpdated();
}

BluetoothDevice::DeviceState BluetoothDevice::state() const
{
    return m_deviceState;
}