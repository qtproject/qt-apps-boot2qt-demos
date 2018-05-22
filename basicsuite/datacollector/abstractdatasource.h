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

#ifndef ABSTRACTDATASOURCE_H
#define ABSTRACTDATASOURCE_H

#include <QObject>
#include <QJsonObject>

class AbstractDataSource : public QObject
{
    Q_OBJECT

public:
    explicit AbstractDataSource(QObject *parent = nullptr);
    virtual ~AbstractDataSource() {}

public:
    virtual void setSpeed(double speed)=0;
    virtual void setTopSpeed(double topSpeed)=0;
    virtual void setAverageSpeed(double averageSpeed)=0;
    virtual void setLifetime(double lifetime)=0;
    virtual void setOdometer(double odometer)=0;
    virtual void setCalories(double calories)=0;
    virtual void setBatteryLevel(int batteryLevel)=0;
    virtual void setAssistDistance(int assistdistance)=0;
    virtual void setAssistPower(int assistpower)=0;
    virtual void setCurrentTrip(const QJsonObject &current)=0;

signals:
    void dataUpdate(const QJsonObject &update);

public slots:
    virtual void parseMessage(const QJsonObject &message)=0;
    virtual void shutdown()=0;
};

#endif // ABSTRACTDATASOURCE_H
