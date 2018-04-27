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

#include "housemodel.h"

HouseModel::HouseModel(QObject *parent) : QAbstractListModel(parent)
{
    generateRooms();
}

QHash<int, QByteArray> HouseModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[ItemRole] = "item";
    roles[TemperatureRole] = "temperature";
    roles[LightRole] = "light";
    roles[XPosRole] = "xPos";
    roles[YPosRole] = "yPos";

    return roles;
}

QVariant HouseModel::data(const QModelIndex &index, int role) const
{
    if (role == NameRole)
        return m_rooms.at(index.row()).getName();
    else if (role == ItemRole)
        return m_rooms.at(index.row()).getItem();
    else if (role == TemperatureRole)
        return m_rooms.at(index.row()).getTemperature();
    else if (role == LightRole)
        return m_rooms.at(index.row()).getLight();
    else if (role == XPosRole)
        return m_rooms.at(index.row()).getXPos();
    else if (role == YPosRole)
        return m_rooms.at(index.row()).getYPos();
    else return QVariant();
}

bool HouseModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid()) {
        if (role == TemperatureRole) {
            m_rooms[index.row()].setTemperature(value.toInt());
            emit dataChanged(index, index);
            return true;
        } else if (role == LightRole) {
            m_rooms[index.row()].setLight(value.toDouble());
            emit dataChanged(index, index);
            return true;
        }
    }
    return false;
}

int HouseModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_rooms.length();
}

bool HouseModel::removeRows(int row, int count, const QModelIndex &parent)
{
    Q_UNUSED(row)
    Q_UNUSED(count)
    Q_UNUSED(parent)
    beginResetModel();
    m_rooms.clear();
    endResetModel();

    return true;
}

void HouseModel::addRoom(const QString &name, const QString &item,
             int temperature, double light, int xPos, int yPos)
{
    int row = m_rooms.size();
    beginInsertRows(QModelIndex(), row, row);
    m_rooms.insert(row, Room(name, item, temperature, light, xPos, yPos));
    endInsertRows();
}

void HouseModel::generateRooms()
{
    removeRows(0, m_rooms.length());
    // Position of labels is defined from the center point of window
    addRoom(QStringLiteral("Living Room"), QStringLiteral("Livingroom"), 21, 0.8, 120, 200);
    addRoom(QStringLiteral("Master Bedroom"), QStringLiteral("Masterbedroom"), 18, 0.8, -380, -290);
    addRoom(QStringLiteral("Bedroom"), QStringLiteral("Bedroom"), 15, 0.0, -405, 170);
    addRoom(QStringLiteral("Bath Room"), QStringLiteral("Bathroom"), 30, 1.0, -20, -320);
#if !defined(KNX_BACKEND)
    addRoom(QStringLiteral("Entrance"), QStringLiteral("Entrance"), 20, 0.6, -450, -70);
#endif
}

