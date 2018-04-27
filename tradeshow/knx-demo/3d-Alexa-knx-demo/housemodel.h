/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt 3D Studio Demos.
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

#ifndef HOUSEMODEL_H
#define HOUSEMODEL_H

#include <QAbstractListModel>
#include <QUrl>
#include <QRect>

class Room
{
public:
    Room(const QString &name, const QString &item,
         int temperature, double light, int x, int y)
    : m_name(name)
    , m_item(item)
    , m_temperature(temperature)
    , m_light(light)
    , m_xPos(x)
    , m_yPos(y) {}

    QString getName() const { return m_name; }
    QString getItem() const { return m_item; }
    int getTemperature() const { return m_temperature; }
    int getXPos() const { return m_xPos; }
    int getYPos() const { return m_yPos; }
    void setTemperature(int temperature) { m_temperature = temperature; }
    double getLight() const { return m_light; }
    void setLight(double light) { m_light = light; }
    void setXPos(int x) { m_xPos = x; }
    void setYPos(int y) { m_xPos = y; }

private:
    QString m_name;
    QString m_item;
    int m_temperature;
    double m_light;
    int m_xPos;
    int m_yPos;
};

class HouseModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum RoomRoles {
        NameRole = 0,
        ItemRole,
        TemperatureRole,
        LightRole,
        XPosRole,
        YPosRole
    };

    HouseModel(QObject *parent = 0);
    virtual QHash<int, QByteArray> roleNames() const;
    virtual int rowCount(const QModelIndex &parent = QModelIndex()) const;
    virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    virtual bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole);
    virtual bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex());
    void addRoom(const QString &name, const QString &item,
                 int temperature, double light, int xPos, int yPos);

private:
    void generateRooms();

    QList<Room> m_rooms;
};

#endif // HOUSEMODEL_H
