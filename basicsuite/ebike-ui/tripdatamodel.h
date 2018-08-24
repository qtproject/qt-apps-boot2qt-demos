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

#ifndef TRIPDATAMODEL_H
#define TRIPDATAMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class DataStore;

class TripDataModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(bool refreshing READ refreshing NOTIFY refreshingChanged)
    Q_PROPERTY(bool saving READ saving NOTIFY savingChanged)

public:
    explicit TripDataModel(DataStore *datastore, QObject *parent = nullptr);
    enum TripDataRoles {
        DurationRole = Qt::UserRole + 1,
        DistanceRole,
        CaloriesRole,
        MaxspeedRole,
        AvgspeedRole,
        AscentRole,
        StartTimeRole
    };

public:
    virtual int rowCount(const QModelIndex &parent) const;
    virtual QVariant data(const QModelIndex &index, int role) const;
    virtual QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE const QJsonObject get(int index) const;

    void setTrips(const QJsonArray &trips);
    void addTrip(const QJsonObject &trip);

    bool refreshing() const { return m_refreshing; }
    bool saving() const { return m_saving; }

signals:
    void refreshed();
    void refreshingChanged(bool refreshing);
    void savingChanged(bool saving);
    void tripDataSaved(int index);

public slots:
    void refresh();
    void endTrip();
    void setCurrentTrip(const QJsonObject &current);

private:
    DataStore *m_datastore;
    QJsonArray m_trips;
    QJsonObject m_current;
    bool m_refreshing;
    bool m_saving;
};

#endif // TRIPDATAMODEL_H
