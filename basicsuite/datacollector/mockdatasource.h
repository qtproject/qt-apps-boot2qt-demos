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

#ifndef MOCKDATASOURCE_H
#define MOCKDATASOURCE_H

#include <QObject>
#include <QTimer>
#include <QElapsedTimer>
#include "abstractdatasource.h"
#include "tripdata.h"

class MockDataSource: public AbstractDataSource
{
    Q_OBJECT

public:
    explicit MockDataSource(QObject *parent = nullptr);

public:
    void setSpeed(double speed);
    void setTopSpeed(double topSpeed);
    void setAverageSpeed(double averageSpeed);
    void setLifetime(double lifetime);
    void setOdometer(double odometer);
    void setTrip(double trip);
    void setCalories(double calories);
    void setBatteryLevel(int batteryLevel);
    void setAssistDistance(int assistdistance);
    void setAssistPower(int assistpower);
    void setCurrentTrip(const QJsonObject &current);

public slots:
    void parseMessage(const QJsonObject &message);
    void shutdown();

private:
    void updateOne(const QString &key, const QJsonValue &value);

private slots:
    void generateData();

private:
    QTimer m_updateTimer;
    QElapsedTimer m_elapsedTimer;
    double m_lifetime;

    QJsonObject m_data;
    QString m_dataFile;
    TripData m_current;
    Trips m_trips;
    Trips m_resettrips;
    QString m_currentFile;
    QString m_tripsFile;
};

#endif // MOCKDATASOURCE_H
