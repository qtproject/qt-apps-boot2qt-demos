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
#include <QLoggingCategory>
#include "bluetoothapiconstants.h"

Q_DECLARE_LOGGING_CATEGORY(boot2QtDemos)

#define SAMPLE_COUNT_FOR_ZERO_ALTITUDE  10

BluetoothDataProvider::BluetoothDataProvider(QString id, QObject *parent)
    : SensorTagDataProvider(id, parent)
    , m_btDevice(Q_NULLPTR)
    , m_smaSamples(0)
    , m_zeroAltitudeSamples(0)
    , gyroscopeX_calibration(0)
    , gyroscopeY_calibration(0)
    , gyroscopeZ_calibration(0)
{
    m_state = NotFound;
    intervalRotation = SENSORTAG_RAPID_TIMER_TIMEOUT_MS;
}

BluetoothDataProvider::~BluetoothDataProvider()
{
    if (m_btDevice)
        delete m_btDevice;
}

bool BluetoothDataProvider::startDataFetching()
{
    qCDebug(boot2QtDemos) << Q_FUNC_INFO;
    if (m_btDevice) {
        connect(m_btDevice, &BluetoothDevice::statusUpdated, this, [=](const QString& statusMsg) {
            qCDebug(boot2QtDemos) << id() << "----------" << statusMsg;
        });
        connect(m_btDevice, &BluetoothDevice::stateChanged,
                this, &BluetoothDataProvider::updateState);
        connect(m_btDevice, &BluetoothDevice::temperatureChanged,
                this, &BluetoothDataProvider::temperatureReceived);
        connect(m_btDevice, &BluetoothDevice::barometerChanged,
                this, &BluetoothDataProvider::barometerReceived);
        connect(m_btDevice, &BluetoothDevice::humidityChanged,
                this, &BluetoothDataProvider::humidityReceived);
        connect(m_btDevice, &BluetoothDevice::lightIntensityChanged,
                this, &BluetoothDataProvider::lightIntensityReceived);
        connect(m_btDevice, &BluetoothDevice::motionChanged,
                this, &BluetoothDataProvider::motionReceived);
        startServiceScan();
    }
    return true;
}

void BluetoothDataProvider::endDataFetching()
{
}

void BluetoothDataProvider::startServiceScan()
{
    qCDebug(boot2QtDemos)<<Q_FUNC_INFO;
    if (m_btDevice) {
        setState(Scanning);
        m_btDevice->scanServices();
    }
}

void BluetoothDataProvider::temperatureReceived(double newAmbientTemperature, double newObjectTemperature)
{
    /* NOTE: We emit the signals even if value is unchanged.
     * Otherwise the scrolling graphs in UI will not scroll.
     */
    irAmbientTemperature = newAmbientTemperature;
    emit infraredAmbientTemperatureChanged();
    irObjectTemperature = newObjectTemperature;
    emit infraredObjectTemperatureChanged();
}

void BluetoothDataProvider::barometerReceived(double temperature, double barometer)
{
    /* NOTE: We emit the signals even if value is unchanged.
     * Otherwise the scrolling graphs in UI will not scroll.
     */
    barometerCelsiusTemperature = temperature;
    emit barometerCelsiusTemperatureChanged();
    barometerTemperatureAverage = (temperature + m_smaSamples * barometerTemperatureAverage)  / (m_smaSamples + 1);
    m_smaSamples++;
    emit barometerCelsiusTemperatureAverageChanged();
    // Use a limited number of samples. It will eventually give wrong avg values, but this is just a demo...
    if (m_smaSamples > 10000)
        m_smaSamples = 0;
    barometerHPa = barometer;
    emit barometer_hPaChanged();

    recalibrateZeroAltitude();

    calculateZeroAltitude();
}

void BluetoothDataProvider::humidityReceived(double humidity)
{
    /* NOTE: We emit the signals even if value is unchanged.
     * Otherwise the scrolling graphs in UI will not scroll.
     */
    this->humidity = humidity;
    emit relativeHumidityChanged();
}
void BluetoothDataProvider::lightIntensityReceived(double lightIntensity)
{
    /* NOTE: We emit the signals even if value is unchanged.
     * Otherwise the scrolling graphs in UI will not scroll.
     */
    lightIntensityLux = lightIntensity;
    emit lightIntensityChanged();
}

float BluetoothDataProvider::countRotationDegrees(double degreesPerSecond, quint64 milliseconds)
{
    const quint32 mseconds = milliseconds;
    const float seconds = ((float)mseconds)/float(1000);
    return ((float)degreesPerSecond) * seconds;
}

void BluetoothDataProvider::motionReceived(MotionSensorData &data)
{
    /* NOTE: We emit the signals even if value is unchanged.
     * Otherwise the scrolling graphs in UI will not scroll.
     */
    latestData = data;
    gyroscopeX_degPerSec = data.gyroScope_x - gyroscopeX_calibration;
    gyroscopeY_degPerSec = data.gyroScope_y - gyroscopeY_calibration;
    gyroscopeZ_degPerSec = data.gyroScope_z - gyroscopeZ_calibration;
    emit gyroscopeDegPerSecChanged();

    rotation_x += countRotationDegrees(gyroscopeX_degPerSec, data.msSincePreviousData);
    rotation_y += countRotationDegrees(gyroscopeY_degPerSec, data.msSincePreviousData);
    rotation_z += countRotationDegrees(gyroscopeZ_degPerSec, data.msSincePreviousData);

    if (rotation_x > 360)
        rotation_x -= 360;
    else if (rotation_x < 0)
        rotation_x += 360;
    if (rotation_y > 360)
        rotation_y -= 360;
    else if (rotation_y < 0)
        rotation_y += 360;
    if (rotation_z > 360)
        rotation_z -= 360;
    else if (rotation_z < 0)
        rotation_z += 360;
    emit rotationXChanged();
    emit rotationYChanged();
    emit rotationZChanged();
    accelometerX = data.accelometer_x;
    accelometerY = data.accelometer_y;
    accelometerZ = data.accelometer_z;
    emit accelometerChanged();
    magnetometerMicroT_xAxis = data.magnetometer_x;
    magnetometerMicroT_yAxis = data.magnetometer_y;
    magnetometerMicroT_zAxis = data.magnetometer_z;
    emit magnetometerMicroTChanged();
    // Signal that all values have changed, for easier
    // value change handling in clients
    emit rotationValuesChanged();
}

QString BluetoothDataProvider::sensorType() const
{
    return QString("Bluetooth data");
}

QString BluetoothDataProvider::versionString() const
{
    return QString("1.1");
}

void BluetoothDataProvider::updateState()
{
    switch (m_btDevice->state()) {
    case BluetoothDevice::Disconnected:
        unbindDevice();
        break;
    case BluetoothDevice::Scanning:
        setState(Scanning);
        break;
    case BluetoothDevice::Connected:
        setState(Connected);
        break;
    case BluetoothDevice::Error:
        setState(Error);
        break;
    default:
        break;
    }
}

void BluetoothDataProvider::reset()
{
    qCDebug(boot2QtDemos) << "Reset bluetooth data provider";

    rotation_x = 0;
    rotation_y = 0;
    rotation_z = 0;
    gyroscopeX_calibration = latestData.gyroScope_x;
    gyroscopeY_calibration = latestData.gyroScope_y;
    gyroscopeZ_calibration = latestData.gyroScope_z;
    emit rotationXChanged();
    emit rotationYChanged();
    emit rotationZChanged();

    // Forces recalculation of zero altitude
    m_zeroAltitudeSamples = 0;
    pressureAtZeroAltitude = 0;
}

void BluetoothDataProvider::recalibrateZeroAltitude()
{
    if (m_zeroAltitudeSamples < SAMPLE_COUNT_FOR_ZERO_ALTITUDE) {
        pressureAtZeroAltitude = (barometerHPa
                                + m_zeroAltitudeSamples * pressureAtZeroAltitude)
                                / (m_zeroAltitudeSamples + 1);
        m_zeroAltitudeSamples++;
    }
}

void BluetoothDataProvider::bindToDevice(BluetoothDevice *device)
{
    if (m_btDevice)
        delete m_btDevice;
    m_btDevice = device;
}

void BluetoothDataProvider::unbindDevice()
{
    if (m_btDevice) {
        delete m_btDevice;
        m_btDevice = 0;
        setState(NotFound);
    }
}

BluetoothDevice *BluetoothDataProvider::device()
{
    return m_btDevice;
}
