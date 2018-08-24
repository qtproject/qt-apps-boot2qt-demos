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

#include <QCoreApplication>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDir>
#include <cmath>

#include "mockdatasource.h"

static const char currentTripFilename[] = "currenttrip.bson";
static const char tripDataFilename[] = "tripdata.bson";
static const char statisticsFilename[] = "stats.bson";

MockDataSource::MockDataSource(QObject *parent)
    : AbstractDataSource(parent)
{
    connect(&m_updateTimer, &QTimer::timeout, this, &MockDataSource::generateData);

    QDir dir(QCoreApplication::applicationDirPath());

    // Load current status
    m_dataFile = dir.absoluteFilePath(statisticsFilename);
    QFile dataFile(m_dataFile);
    if (dataFile.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromBinaryData(dataFile.readAll());
        m_data = doc.object();
        m_lifetime = m_data.value("lifetime").toDouble();
    } else {
        // Set some default values in case data file did not exist
        m_data.insert("speed", 0.0);
        m_data.insert("topspeed", 0.0);
        m_data.insert("odometer", 0.0);
        m_data.insert("batterylevel", 100);
        m_lifetime = 0.0;
    }

    // Try to load current trip data as well as recorded trip(s)
    m_currentFile = dir.absoluteFilePath(currentTripFilename);
    m_current.load(m_currentFile);
    m_tripsFile = dir.absoluteFilePath(tripDataFilename);
    m_trips.load(m_tripsFile);

    m_updateTimer.start(100);
    m_elapsedTimer.start();

    // Generate the list of static trips to be shown on reset
    m_resettrips << TripData(2100, 6800, 225, 6.944, 3.2, 1515008400.0) // 3.1.2018 11:40
                 << TripData(2700, 10700, 300, 8.333, 2.5, 1515122400.0) // 4.1.2018 19:20
                 << TripData(3900, 13700, 370, 6.944, 5, 1515197100.0) // 5.1.2018 16:05
                 << TripData(1500, 3300, 150, 6.944, 4.7, 1515260100.0) // 6.1.2018 9:35
                 << TripData(4500, 15800, 450, 5.556, 3.2, 1515359700.0); // 7.1.2018 13:15
}

void MockDataSource::shutdown()
{
    m_current.save(m_currentFile);
    m_trips.save(m_tripsFile);
}

void MockDataSource::setSpeed(double speed)
{
    updateOne("speed", speed);
}

void MockDataSource::setTopSpeed(double topspeed)
{
    updateOne("topspeed", topspeed);
}

void MockDataSource::setAverageSpeed(double averagespeed)
{
    updateOne("averagespeed", averagespeed);
}

void MockDataSource::setLifetime(double lifetime)
{
    updateOne("lifetime", lifetime);
}

void MockDataSource::setOdometer(double odometer)
{
    updateOne("odometer", odometer);
}

void MockDataSource::setCalories(double calories)
{
    updateOne("calories", calories);
}

void MockDataSource::setBatteryLevel(int batterylevel)
{
    updateOne("batterylevel", batterylevel);
}

void MockDataSource::setAssistDistance(int assistdistance)
{
    updateOne("assistdistance", assistdistance);
}

void MockDataSource::setAssistPower(int assistpower)
{
    updateOne("assistpower", assistpower);
}

void MockDataSource::setCurrentTrip(const QJsonObject &current)
{
    emit dataUpdate(QJsonObject{{"method", "currenttrip"}, {"currenttrip", current}});
}

void MockDataSource::updateOne(const QString &key, const QJsonValue &value)
{
    m_data.insert(key, value);
    emit dataUpdate(QJsonObject{{"method", "updateone"}, {"key", key}, {"value", value}});
}

void MockDataSource::generateData()
{
    static int spd = 1;
    static int btr = 101;

    double x = static_cast<double>(spd) / 500;
    double speed = 4.5 * (1.5 + (0.75 * sin(2 * M_PI * x) + 0.5 * sin(6 * M_PI * x - M_PI_2))) - 1.5;
    double dist = speed / 10; // 10 times per second
    double elapsed = static_cast<double>(m_elapsedTimer.elapsed()) / 1000.0;

    setAssistPower(speed * 9.5);
    setSpeed(speed);
    if (speed > m_data.value("topspeed").toDouble())
        setTopSpeed(speed);
    setAverageSpeed(m_data.value("odometer").toDouble() / (m_lifetime + elapsed));
    setOdometer(m_data.value("odometer").toDouble() + dist);
    setLifetime(m_lifetime + elapsed);

    // Update trip data
    if (speed > m_current.maxSpeed())
        m_current.setMaxSpeed(speed);
    m_current.addDistance(dist);
    m_current.addDuration(0.1);
    m_current.addCalories(0.01);

    setCurrentTrip(m_current);

    if (spd % 50 == 0) {
        btr -= 1;
        setBatteryLevel(btr);
        setAssistDistance(500 * btr);
        if (btr == 0)
            btr = 100;
    }

    // Save the current trip and statistics files every 10 seconds
    if (spd % 100 == 0) {
        m_current.save(m_currentFile);
        QFile dataFile(m_dataFile);
        if (dataFile.open(QIODevice::WriteOnly)) {
            QJsonDocument doc(m_data);
            dataFile.write(doc.toBinaryData());
        }
    }

    spd++;
}

void MockDataSource::parseMessage(const QJsonObject &message)
{
    QString method = message.value("method").toString();

    if (method == "set") {
        m_data.insert(message.value("key").toString(), message.value("value"));
    } else if (method == "getall") {
        QJsonArray values;
        // Iterate over all data
        QJsonObject::ConstIterator it = m_data.constBegin();
        while (it != m_data.constEnd()) {
            values.append(QJsonObject{{"key", it.key()}, {"value", it.value()}});
            ++it;
        }

        emit dataUpdate(QJsonObject{{"method", "updatemany"}, {"values", values}});
        setCurrentTrip(m_current);
    } else if (method == "gettrips") {
        emit dataUpdate(QJsonObject{{"method", "trips"}, {"trips", m_trips.toJsonArray()}});
    } else if (method == "endtrip") {
        // Append current trip to list of trips and send to frontend
        m_trips.append(m_current);
        emit dataUpdate(QJsonObject{{"method", "trip"}, {"trip", m_current.toJsonObject()}});
         // Then clear it and its save file
        m_current.clear();
        m_current.setStartTime();
        QFile::remove(m_currentFile);
        // Send update of an empty trip to frontend
        setCurrentTrip(m_current);
        // Also save current trip list to file (in case of a crash)
        m_trips.save(m_tripsFile);
    } else if (method == "reset") {
        // Demo only method, to reset trip history
        m_trips = m_resettrips;
        emit dataUpdate(QJsonObject{{"method", "reset"}});
        emit dataUpdate(QJsonObject{{"method", "trips"}, {"trips", m_trips.toJsonArray()}});
    }
}
