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

#include "datastore.h"
#include "tripdatamodel.h"

#include <QDebug>

TripDataModel::TripDataModel(DataStore *datastore, QObject *parent)
    : QAbstractListModel(parent)
    , m_datastore(datastore)
    , m_refreshing(false)
    , m_saving(false)
{
}

int TripDataModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_trips.count() + 1; // +1 for current trip
}

QVariant TripDataModel::data(const QModelIndex &index, int role) const
{
    QJsonObject obj = get(index.row());
    if (role == DurationRole)
        return obj.value("duration").toDouble(); // Seconds
    else if (role == DistanceRole)
        return m_datastore->convertDistance(obj.value("distance").toDouble());
    else if (role == CaloriesRole)
        return obj.value("calories").toDouble();
    else if (role == MaxspeedRole)
        return m_datastore->convertSpeed(obj.value("maxspeed").toDouble());
    else if (role == AvgspeedRole)
        return m_datastore->convertSpeed(obj.value("distance").toDouble() / obj.value("duration").toDouble());
    else if (role == AscentRole)
        return obj.value("ascent").toDouble();
    else if (role == StartTimeRole)
        return obj.value("starttime").toDouble();

    return QVariant();
}

QHash<int, QByteArray> TripDataModel::roleNames() const
{
    QHash<int, QByteArray> roles = QAbstractListModel::roleNames();
    roles[DurationRole] = "duration";
    roles[DistanceRole] = "distance";
    roles[CaloriesRole] = "calories";
    roles[MaxspeedRole] = "maxspeed";
    roles[AvgspeedRole] = "avgspeed";
    roles[AscentRole] = "ascent";
    roles[StartTimeRole] = "starttime";

    return roles;
}

void TripDataModel::setTrips(const QJsonArray &trips)
{
    beginResetModel();
    m_trips = trips;
    endResetModel();
    m_refreshing = false;
    emit refreshingChanged(m_refreshing);
    emit refreshed();
}

void TripDataModel::addTrip(const QJsonObject &trip)
{
    // Always append at the beginning of the list, easy to calculate
    int newRow = 0;
    beginInsertRows(QModelIndex(), newRow, newRow);
    m_trips.append(trip);
    endInsertRows();
    emit tripDataSaved(newRow);
}

const QJsonObject TripDataModel::get(int index) const
{
    return index == 0 ? m_current : m_trips.at(m_trips.count() - index).toObject();
}

void TripDataModel::refresh()
{
    m_refreshing = true;
    emit refreshingChanged(m_refreshing);
    m_datastore->getTrips();
}

void TripDataModel::endTrip()
{
    m_saving = true;
    emit savingChanged(m_saving);
    m_datastore->endTrip();
}

void TripDataModel::setCurrentTrip(const QJsonObject &current)
{
    m_current = current;
    QModelIndex currentIndex = index(0);
    emit dataChanged(currentIndex, currentIndex);
}
