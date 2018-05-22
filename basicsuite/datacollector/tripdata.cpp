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

#include <QJsonDocument>
#include <QJsonArray>
#include <QFile>
#include <QDateTime>

#include "tripdata.h"

TripData::TripData()
    : m_duration(0.0)
    , m_distance(0.0)
    , m_calories(0.0)
    , m_maxspeed(0.0)
    , m_ascent(0.0)
    , m_starttime(static_cast<double>(QDateTime::currentMSecsSinceEpoch()) / 1000.0)
{
}

TripData::TripData(double duration, double distance, double calories,
                   double maxspeed, double ascent, double starttime)
    : m_duration(duration)
    , m_distance(distance)
    , m_calories(calories)
    , m_maxspeed(maxspeed)
    , m_ascent(ascent)
    , m_starttime(starttime)
{
}

TripData::TripData(const QJsonObject &data)
    : m_duration(data.value("duration").toDouble())
    , m_distance(data.value("distance").toDouble())
    , m_calories(data.value("calories").toDouble())
    , m_maxspeed(data.value("maxspeed").toDouble())
    , m_ascent(data.value("ascent").toDouble())
    , m_starttime(data.value("starttime").toDouble())
{
}

bool TripData::load(const QString &filename)
{
    QFile jsonfile(filename);
    if (jsonfile.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromBinaryData(jsonfile.readAll());
        QJsonObject data = doc.object();

        m_duration = data.value("duration").toDouble();
        m_distance = data.value("distance").toDouble();
        m_calories = data.value("calories").toDouble();
        m_maxspeed = data.value("maxspeed").toDouble();
        m_ascent = data.value("ascent").toDouble();
        m_starttime = data.value("starttime").toDouble();

        return true;
    }
    return false;
}

void TripData::save(const QString &filename) const
{
    QFile jsonfile(filename);
    if (jsonfile.open(QIODevice::WriteOnly)) {
        QJsonDocument doc(toJsonObject());
        jsonfile.write(doc.toBinaryData());
    }
}

void TripData::setDuration(double duration)
{
    if (qFuzzyCompare(m_duration, duration))
        return;

    m_duration = duration;
}

void TripData::setDistance(double distance)
{
    if (qFuzzyCompare(m_distance, distance))
        return;

    m_distance = distance;
}

void TripData::setCalories(double calories)
{
    if (qFuzzyCompare(m_calories, calories))
        return;

    m_calories = calories;
}

void TripData::setMaxSpeed(double maxspeed)
{
    if (qFuzzyCompare(m_maxspeed, maxspeed))
        return;

    m_maxspeed = maxspeed;
}

void TripData::setAscent(double ascent)
{
    if (qFuzzyCompare(m_ascent, ascent))
        return;

    m_ascent = ascent;
}

void TripData::setStartTime(double starttime)
{
    // Special value means reset to current timestamp
    if (starttime == 0.0)
        starttime = static_cast<double>(QDateTime::currentMSecsSinceEpoch()) / 1000.0;

    if (qFuzzyCompare(m_starttime, starttime))
        return;

    m_starttime = starttime;
}

void TripData::addDuration(double duration)
{
    m_duration += duration;
}

void TripData::addDistance(double distance)
{
    m_distance += distance;
}

void TripData::addCalories(double calories)
{
    m_calories += calories;
}

void TripData::clear()
{
    m_duration = 0.0;
    m_distance = 0.0;
    m_calories = 0.0;
    m_maxspeed = 0.0;
    m_ascent = 0.0;
    m_starttime = 0.0;
}

TripData::operator QJsonObject() const
{
    return toJsonObject();
}

const QJsonObject TripData::toJsonObject(void) const
{
    QJsonObject data;

    data.insert("duration", m_duration);
    data.insert("distance", m_distance);
    data.insert("calories", m_calories);
    data.insert("maxspeed", m_maxspeed);
    data.insert("avgspeed", m_distance / m_duration);
    data.insert("ascent", m_ascent);
    data.insert("starttime", m_starttime);

    return data;
}

TripData TripData::fromJsonObject(const QJsonObject &data)
{
    return TripData(data);
}

TripData TripData::fromFile(const QString &filename)
{
    TripData trip;
    trip.load(filename);
    return trip;
}

bool Trips::load(const QString &filename)
{
    QFile jsonfile(filename);
    if (jsonfile.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromBinaryData(jsonfile.readAll());
        clear();
        foreach (const QJsonValue &trip, doc.array())
            append(trip.toObject());
        return true;
    }
    return false;
}

void Trips::save(const QString &filename) const
{
    QFile jsonfile(filename);
    if (jsonfile.open(QIODevice::WriteOnly)) {
        QJsonDocument doc(*this);
        jsonfile.write(doc.toBinaryData());
    }
}

Trips::operator QJsonArray() const
{
    return toJsonArray();
}

const QJsonArray Trips::toJsonArray() const
{
    QJsonArray array;
    foreach (const TripData &data, *this)
        array.append(data.toJsonObject());

    return array;
}

Trips Trips::fromFile(const QString &filename)
{
    Trips trips;
    trips.load(filename);
    return trips;
}
