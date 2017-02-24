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
#ifndef SENSORTAGDATAPROVIDER_H
#define SENSORTAGDATAPROVIDER_H
#include <QObject>
#include <QString>
#include <QColor>
#include <QQmlEngine>

class SensorTagDataProvider : public QObject
{
    Q_OBJECT
    Q_ENUMS(TagType)
    Q_ENUMS(ProviderState)
    Q_PROPERTY(ProviderState state READ state NOTIFY stateChanged)
    Q_PROPERTY(QString name MEMBER m_name CONSTANT)
    Q_PROPERTY(QString providerId MEMBER m_id CONSTANT)
    Q_PROPERTY(QString relativeHumidityString READ getRelativeHumidityString NOTIFY relativeHumidityChanged)
    Q_PROPERTY(double relativeHumidity READ getRelativeHumidity NOTIFY relativeHumidityChanged)
    Q_PROPERTY(double infraredAmbientTemperature READ getInfraredAmbientTemperature NOTIFY infraredAmbientTemperatureChanged)
    Q_PROPERTY(double infraredObjectTemperature READ getInfraredObjectTemperature NOTIFY infraredObjectTemperatureChanged)
    Q_PROPERTY(QString lightIntensityLuxString READ getLightIntensityLuxString NOTIFY lightIntensityChanged)
    Q_PROPERTY(double lightIntensityLux READ getLightIntensityLux NOTIFY lightIntensityChanged)
    Q_PROPERTY(double barometerCelsiusTemperature READ getBarometerCelsiusTemperature NOTIFY barometerCelsiusTemperatureChanged)
    Q_PROPERTY(QString barometerCelsiusTemperatureString READ getBarometerCelsiusTemperatureString NOTIFY barometerCelsiusTemperatureChanged)
    Q_PROPERTY(QString barometer_hPaString READ getBarometer_hPaString NOTIFY barometer_hPaChanged)
    Q_PROPERTY(double barometerTemperatureAverage READ getBarometerTemperatureAverage NOTIFY barometerCelsiusTemperatureAverageChanged)
    Q_PROPERTY(double barometerHPa READ getBarometer_hPa NOTIFY barometer_hPaChanged)
    Q_PROPERTY(float gyroscopeX_degPerSec READ getGyroscopeX_degPerSec NOTIFY gyroscopeDegPerSecChanged)
    Q_PROPERTY(float gyroscopeY_degPerSec READ getGyroscopeY_degPerSec NOTIFY gyroscopeDegPerSecChanged)
    Q_PROPERTY(float gyroscopeZ_degPerSec READ getGyroscopeZ_degPerSec NOTIFY gyroscopeDegPerSecChanged)
    Q_PROPERTY(float accelometer_xAxis READ getAccelometer_xAxis NOTIFY accelometerChanged)
    Q_PROPERTY(float accelometer_yAxis READ getAccelometer_yAxis NOTIFY accelometerChanged)
    Q_PROPERTY(float accelometer_zAxis READ getAccelometer_zAxis NOTIFY accelometerChanged)
    Q_PROPERTY(float magnetometerMicroT_xAxis READ getMagnetometerMicroT_xAxis NOTIFY magnetometerMicroTChanged)
    Q_PROPERTY(float magnetometerMicroT_yAxis READ getMagnetometerMicroT_yAxis NOTIFY magnetometerMicroTChanged)
    Q_PROPERTY(float magnetometerMicroT_zAxis READ getMagnetometerMicroT_zAxis NOTIFY magnetometerMicroTChanged)
    Q_PROPERTY(float rotationX READ getRotationX NOTIFY rotationXChanged)
    Q_PROPERTY(float rotationY READ getRotationY NOTIFY rotationYChanged)
    Q_PROPERTY(float rotationZ READ getRotationZ NOTIFY rotationZChanged)
    Q_PROPERTY(int rotationUpdateInterval READ getRotationUpdateInterval NOTIFY rotationUpdateIntervalChanged)
    Q_PROPERTY(float altitude READ getAltitude NOTIFY altitudeChanged)

public:
    enum TagType { AmbientTemperature = 1 << 0,
                   ObjectTemperature = 1 << 1,
                   Humidity = 1 << 2,
                   AirPressure = 1 << 3,
                   Light = 1 << 4,
                   Magnetometer = 1 << 5,
                   Rotation = 1 << 6,
                   Accelometer = 1 << 7,
                   Altitude = 1 << 8
                 };
    static const int tagTypeCount = 9;
    enum ProviderState {NotFound = 0, Disconnected, Scanning, Connected, Error};

    explicit SensorTagDataProvider(QObject *parent = 0);
    SensorTagDataProvider(QString id, QObject *parent = 0);

    virtual bool startDataFetching() {return false;}
    virtual void endDataFetching() {}
    QString getRelativeHumidityString() const;
    virtual double getRelativeHumidity() const;
    virtual double getInfraredAmbientTemperature() const;
    virtual double getInfraredObjectTemperature() const;
    QString getLightIntensityLuxString() const;
    virtual double getLightIntensityLux() const;
    virtual double getBarometerCelsiusTemperature() const;
    QString getBarometerCelsiusTemperatureString() const;
    virtual double getBarometerTemperatureAverage() const;
    QString getBarometer_hPaString() const;
    virtual double getBarometer_hPa() const;
    virtual float getGyroscopeX_degPerSec() const;
    virtual float getGyroscopeY_degPerSec() const;
    virtual float getGyroscopeZ_degPerSec() const;
    virtual float getAccelometer_xAxis() const;
    virtual float getAccelometer_yAxis() const;
    virtual float getAccelometer_zAxis() const;
    virtual float getMagnetometerMicroT_xAxis() const;
    virtual float getMagnetometerMicroT_yAxis() const;
    virtual float getMagnetometerMicroT_zAxis() const;
    virtual float getRotationX() const;
    virtual float getRotationY() const;
    virtual float getRotationZ() const;
    int getRotationUpdateInterval() const;
    virtual float getAltitude() const;

    Q_INVOKABLE virtual int tagType() const;
    void setTagType(int tagType);
    virtual QString id() const;
    ProviderState state() const;
    void setState(ProviderState state);

    virtual QString providerName() const { return m_name;}
    virtual QString sensorType() const { return QString();}
    virtual QString versionString() const{ return QString();}

public slots:
    void recalibrate();

signals:
    void stateChanged();
    void relativeHumidityChanged();
    void infraredAmbientTemperatureChanged();
    void infraredObjectTemperatureChanged();
    void lightIntensityChanged();
    void barometerCelsiusTemperatureChanged();
    void barometerCelsiusTemperatureAverageChanged();
    void barometer_hPaChanged();
    void gyroscopeDegPerSecChanged();
    void accelometerChanged();
    void magnetometerMicroTChanged();
    void rotationXChanged();
    void rotationYChanged();
    void rotationZChanged();
    void rotationValuesChanged();
    void rotationUpdateIntervalChanged();
    void altitudeChanged();

protected:
    virtual void reset();
    virtual void calculateZeroAltitude();

    double humidity;
    double irAmbientTemperature;
    double irObjectTemperature;
    double lightIntensityLux;
    double barometerCelsiusTemperature;
    double barometerTemperatureAverage;
    double barometerHPa;
    //double temperatureAverage;
    float gyroscopeX_degPerSec;
    float gyroscopeY_degPerSec;
    float gyroscopeZ_degPerSec;
    float accelometerX;
    float accelometerY;
    float accelometerZ;
    float magnetometerMicroT_xAxis;
    float magnetometerMicroT_yAxis;
    float magnetometerMicroT_zAxis;
    float rotation_x;
    float rotation_y;
    float rotation_z;
    int intervalRotation;
    float pressureAtZeroAltitude;
    float altitude;
    int m_tagType;
    QString m_id;
    QString m_name;
    ProviderState m_state;
};

Q_DECLARE_METATYPE(SensorTagDataProvider::TagType)
Q_DECLARE_METATYPE(SensorTagDataProvider::ProviderState)

#endif // SENSORTAGDATAPROVIDER_H
