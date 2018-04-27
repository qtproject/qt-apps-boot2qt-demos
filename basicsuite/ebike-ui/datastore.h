/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the E-Bike demo project.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef DATASTORE_H
#define DATASTORE_H

#include <QObject>
#include <QJsonObject>

class SocketClient;
class TripDataModel;

class DataStore: public QObject
{
    Q_OBJECT

    // Different measured properties
    Q_PROPERTY(double speed READ speed NOTIFY speedChanged)
    Q_PROPERTY(double topspeed READ topSpeed NOTIFY topspeedChanged)
    Q_PROPERTY(double averagespeed READ averageSpeed NOTIFY currentTripChanged)
    Q_PROPERTY(double odometer READ odometer NOTIFY odometerChanged)
    Q_PROPERTY(double trip READ trip NOTIFY currentTripChanged)
    Q_PROPERTY(double calories READ calories NOTIFY currentTripChanged)
    Q_PROPERTY(double assistdistance READ assistDistance NOTIFY assistdistanceChanged)
    Q_PROPERTY(double assistpower READ assistPower NOTIFY assistpowerChanged)
    Q_PROPERTY(double batterylevel READ batteryLevel NOTIFY batterylevelChanged)

    // Toggles for lights and mode
    Q_PROPERTY(bool lights READ lights WRITE setLights NOTIFY lightsChanged)
    Q_PROPERTY(Mode mode READ mode WRITE setMode NOTIFY modeChanged)

    // Current units
    Q_PROPERTY(Unit unit READ unit WRITE setUnit NOTIFY unitChanged)
    Q_PROPERTY(QString smallUnit READ smallUnit NOTIFY smallUnitChanged)

    // Navigation
    Q_PROPERTY(int arrow READ arrow NOTIFY arrowChanged)
    Q_PROPERTY(double legdistance READ legDistance NOTIFY legdistanceChanged)
    Q_PROPERTY(double tripremaining READ tripRemaining NOTIFY tripremainingChanged)

public:
    explicit DataStore(QObject *parent = nullptr);

    enum Mode { Cruise, Sport };
    Q_ENUM(Mode)

    enum Unit { Kmh, Mph };
    Q_ENUM(Unit)

public:
    // Getters
    double speed() const;
    double topSpeed() const;
    double averageSpeed() const;
    double odometer() const;
    double trip() const;
    double calories() const;
    double assistDistance() const;
    double assistPower() const;
    double batteryLevel() const;
    bool lights() const;
    Mode mode() const;
    Unit unit() const;
    int arrow() const;
    double legDistance() const;
    double tripRemaining() const;
    QString smallUnit() const;

    // Setters
    void setLights(bool lights);
    void setMode(Mode mode);
    void setUnit(Unit unit);

    // Get trip data model
    TripDataModel *tripDataModel() const { return m_trips; }

    // Convert speed and distance to proper units
    Q_INVOKABLE double convertSpeed(double speed) const;
    Q_INVOKABLE double convertDistance(double distance) const;
    Q_INVOKABLE double convertSmallDistance(double distance) const;
    Q_INVOKABLE QString getSmallUnit() const;

    // Split and convert distance and duration to value and unit
    Q_INVOKABLE QJsonObject splitDistance(double distance, bool round=false) const;
    Q_INVOKABLE QJsonObject splitDuration(double duration) const;

private:
    void emitByName(const QString &valuename);

signals:
    void speedChanged();
    void topspeedChanged();
    void averagespeedChanged();
    void odometerChanged();
    void tripChanged();
    void caloriesChanged();
    void assistdistanceChanged();
    void assistpowerChanged();
    void batterylevelChanged();
    void lightsChanged();
    void modeChanged();
    void unitChanged();
    void arrowChanged();
    void legdistanceChanged();
    void tripremainingChanged();
    void currentTripChanged();
    void smallUnitChanged(QString smallUnit);
    void demoReset();

public slots:
    void connectToServer(const QString &servername);
    void getTrips();
    void endTrip();
    void toggleMode();
    void resetDemo();

private slots:
    void requestStatus();
    void parseMessage(const QJsonObject &message);

private:
    SocketClient *m_client;
    QJsonObject m_properties;
    QJsonObject m_current;
    Unit m_unit;
    TripDataModel *m_trips;
    int m_smallUnit;
};

#endif // DATASTORE_H
