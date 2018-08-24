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

#ifndef TRIPDATA_H
#define TRIPDATA_H

#include <QElapsedTimer>
#include <QJsonObject>
#include <QList>

class TripData
{
public:
    TripData();
    TripData(double duration, double distance, double calories,
             double maxspeed, double ascent, double starttime);
    TripData(const QJsonObject &data);

public:
    double duration() const { return m_duration; }
    double distance() const { return m_distance; }
    double calories() const { return m_calories; }
    double maxSpeed() const { return m_maxspeed; }
    double avgSpeed() const { return m_distance / m_duration; }
    double ascent() const { return m_ascent; }
    double startTime() const { return m_starttime; }

    void setDuration(double duration);
    void setDistance(double distance);
    void setCalories(double calories);
    void setMaxSpeed(double maxspeed);
    void setAscent(double ascent);
    void setStartTime(double starttime=0);
    void addDuration(double duration);
    void addDistance(double distance);
    void addCalories(double calories);
    void clear();

    // Load from file
    bool load(const QString &filename);

    // Save to file
    void save(const QString &filename) const;

    // Convert to Json Object
    operator QJsonObject() const;
    const QJsonObject toJsonObject(void) const;

    // Create from Json
    static TripData fromJsonObject(const QJsonObject &data);

    // Load from binary Json data
    static TripData fromFile(const QString &filename);

private:
    QElapsedTimer m_timer;
    double m_duration; // Seconds
    double m_distance; // Meters
    double m_calories; // calories, not kcal
    double m_maxspeed; // m/s
    double m_ascent; // meters
    double m_starttime; // Timestamp of the start of the trip
};

class Trips: public QList<TripData>
{
public:
    // Load from file
    bool load(const QString &filename);

    // Save to file
    void save(const QString &filename) const;

    // Convert to Json Array
    operator QJsonArray() const;
    const QJsonArray toJsonArray(void) const;

    // Load from binary Json data
    static Trips fromFile(const QString &filename);
};

#endif // TRIPDATA_H
