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
#include <QNetworkReply>

#include "navigation.h"
#include "mapbox.h"

Navigation::Navigation(MapBox *mapbox, QObject *parent)
    : QObject(parent)
    , m_mapbox(mapbox)
    , m_position(QGeoCoordinate(36.131961, -115.153048), QDateTime::currentDateTime())
    , m_zoomlevel(18)
    , m_active(false)
    , m_routeDirection(0)
    , m_routePosition(m_position.coordinate())
{
    m_position.setAttribute(QGeoPositionInfo::Direction, 0);
}

void Navigation::setPosition(const QGeoPositionInfo &position)
{
    if (m_position != position) {
        m_position = position;
        emit positionChanged(m_position);
    }
}

void Navigation::setCoordinate(const QGeoCoordinate &coordinate)
{
    if (m_position.coordinate() != coordinate) {
        m_position.setCoordinate(coordinate);
        emit coordinateChanged(m_position.coordinate());
    }
}

void Navigation::setDirection(qreal direction)
{
    if (qFuzzyCompare(m_position.attribute(QGeoPositionInfo::Direction), direction))
        return;

    m_position.setAttribute(QGeoPositionInfo::Direction, direction);
    emit directionChanged(direction);
}

void Navigation::setZoomLevel(qreal zoomlevel)
{
    if (qFuzzyCompare(m_zoomlevel, zoomlevel))
        return;

    m_zoomlevel = zoomlevel;
    emit zoomLevelChanged(m_zoomlevel);
}

void Navigation::setActive(bool active)
{
    if (m_active == active)
        return;

    m_active = active;
    emit activeChanged(m_active);
}
