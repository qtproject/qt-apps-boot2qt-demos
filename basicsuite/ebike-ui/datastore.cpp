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

#include <QJsonArray>
#include <QMetaObject>
#include <QMetaMethod>

#include "socketclient.h"
#include "datastore.h"
#include "tripdatamodel.h"

// Speed conversions from m/s to km/h and mph
static const double msToKmh = 3.6;
static const double msToMph = 2.2369418519393043;
// Distance conversions to and from m to km and mi
static const double mToKm = 0.001;
static const double mToMi = 0.000621371;
static const double kmToM = 1000.0;
static const double miToM = 1609.344;
static const double mToYd = 1760.0 / 1609.344;

DataStore::DataStore(QObject *parent)
    : QObject(parent)
    , m_client(new SocketClient(this))
    , m_unit(Mph)
    , m_trips(new TripDataModel(this, this))
{
    connect(m_client, &SocketClient::connected, this, &DataStore::requestStatus);
    connect(m_client, &SocketClient::newMessage, this, &DataStore::parseMessage);
}

void DataStore::connectToServer(const QString &servername)
{
    m_client->connectToServer(servername);
}

void DataStore::getTrips()
{
    m_client->sendToServer(QJsonObject{{"method", "gettrips"}});
}

void DataStore::endTrip()
{
    m_client->sendToServer(QJsonObject{{"method", "endtrip"}});
}

void DataStore::toggleMode()
{
    setMode(mode() == Cruise ? Sport : Cruise);
}

void DataStore::resetDemo()
{
    m_client->sendToServer(QJsonObject{{"method", "reset"}});
}

double DataStore::speed() const
{
    return convertSpeed(m_properties.value("speed").toDouble());
}

double DataStore::topSpeed() const
{
    return convertSpeed(m_properties.value("topspeed").toDouble());
}

double DataStore::averageSpeed() const
{
    return convertSpeed(m_current.value("distance").toDouble() / m_current.value("duration").toDouble());
}

double DataStore::odometer() const
{
    return convertDistance(m_properties.value("odometer").toDouble());
}

double DataStore::trip() const
{
    return convertDistance(m_current.value("distance").toDouble());
}

double DataStore::calories() const
{
    return m_current.value("calories").toDouble();
}

double DataStore::assistDistance() const
{
    return convertDistance(m_properties.value("assistdistance").toDouble());
}

double DataStore::assistPower() const
{
    return m_properties.value("assistpower").toDouble();
}

double DataStore::batteryLevel() const
{
    return m_properties.value("batterylevel").toDouble();
}

bool DataStore::lights() const
{
    return m_properties.value("lights").toBool();
}

DataStore::Mode DataStore::mode() const
{
    return static_cast<Mode>(m_properties.value("mode").toInt());
}

DataStore::Unit DataStore::unit() const
{
    return m_unit;
}

int DataStore::arrow() const
{
    return m_properties.value("arrow").toInt();
}

double DataStore::legDistance() const
{
    return m_properties.value("legdistance").toDouble();
}

double DataStore::tripRemaining() const
{
    return m_properties.value("tripremaining").toDouble();
}

QString DataStore::smallUnit() const
{
    return m_unit == Kmh ? "m" : "yd";
}

void DataStore::setLights(bool lights)
{
    if (m_properties.value("lights").toBool() == lights)
        return;

    m_properties.insert("lights", lights);
    m_client->sendToServer(QJsonObject{{"method", "set"}, {"key", "lights"}, {"value", lights}});
    emit lightsChanged();
}

void DataStore::setMode(Mode mode)
{
    if (DataStore::mode() == mode)
        return;

    m_properties.insert("mode", mode);
    m_client->sendToServer(QJsonObject{{"method", "set"}, {"key", "mode"}, {"value", static_cast<int>(mode)}});
    emit modeChanged();
}

void DataStore::setUnit(DataStore::Unit unit)
{
    if (m_unit == unit)
        return;

    m_unit = unit;
    emit unitChanged();
    // Also emit all the other signals that are affected by mode change
    emit speedChanged();
    emit averagespeedChanged();
    emit odometerChanged();
    emit tripChanged();
    emit assistdistanceChanged();
    emit smallUnitChanged(smallUnit());
}

double DataStore::convertSpeed(double speed) const
{
    return speed * (m_unit == Kmh ? msToKmh : msToMph);
}

double DataStore::convertDistance(double distance) const
{
    return distance * (m_unit == Kmh ? mToKm : mToMi);
}

double DataStore::convertSmallDistance(double distance) const
{
    return distance * (m_unit == Kmh ? 1.0 : mToYd);
}

QString DataStore::getSmallUnit() const
{
    return m_unit == Kmh ? "m" : "yd";
}

QJsonObject DataStore::splitDistance(double distance, bool round) const
{
    if (m_unit == Kmh) {
        if (distance >= kmToM)
            return QJsonObject{{"value", distance * mToKm}, {"unit", "km"}, {"decimal", true}};
        else {
            if (round)
                distance = qRound(distance / 10) * 10;
            return QJsonObject{{"value", distance}, {"unit", "m"}, {"decimal", false}};
        }
    } else {
        if (distance >= miToM)
            return QJsonObject{{"value", distance * mToMi}, {"unit", "mi."}, {"decimal", true}};
        else {
            distance *= mToYd;
            if (round)
                distance = qRound(distance / 10) * 10;
            return QJsonObject{{"value", distance}, {"unit", "yd"}, {"decimal", false}};
        }
    }
}

QJsonObject DataStore::splitDuration(double duration) const
{
    if (duration >= 60.0)
        return QJsonObject{{"value", duration / 60.0}, {"unit", "min"}};
    else
        return QJsonObject{{"value", duration}, {"unit", "s"}};
}

void DataStore::requestStatus()
{
    m_client->sendToServer(QJsonObject{{"method", "getall"}});
}

void DataStore::emitByName(const QString &valuename)
{
    // Use QMetaObject information to find a proper signal
    const QMetaObject *meta = metaObject();

    // Find the notifier signal
    QString signalName = QString("%1Changed()").arg(valuename);
    int methodIndex = meta->indexOfSignal(signalName.toLatin1().constData());
    meta->method(methodIndex).invoke(this, Qt::AutoConnection);
}

void DataStore::parseMessage(const QJsonObject &message)
{
    QString method = message.value("method").toString();

    // If we are updating just one, simply insert new value and emit
    if (method == "updateone") {
        QString key = message.value("key").toString();
        m_properties.insert(key, message.value("value"));
        emitByName(key);
    // If we are updating many, then iterate over the list and update each value
    } else if (method == "updatemany") {
        foreach (const QJsonValue &value, message.value("values").toArray()) {
            QJsonObject obj = value.toObject();
            QString key = obj.value("key").toString();
            m_properties.insert(key, obj.value("value"));
            emitByName(key);
        }
    } else if (method == "trips") {
        m_trips->setTrips(message.value("trips").toArray());
    } else if (method == "trip") {
        m_trips->addTrip(message.value("trip").toObject());
    } else if (method == "currenttrip") {
        m_current = message.value("currenttrip").toObject();
        m_trips->setCurrentTrip(m_current);
        emit currentTripChanged();
    } else if (method == "reset") {
        emit demoReset();
    }
}
