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

#ifndef NAVIGATION_H
#define NAVIGATION_H

#include <QObject>
#include <QGeoPositionInfo>
#include <QJsonObject>
#include <QJSValue>
#include <QTimer>

#include <QDebug>

class MapBox;

class Navigation : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QGeoPositionInfo position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(QGeoCoordinate coordinate READ coordinate WRITE setCoordinate NOTIFY coordinateChanged)
    Q_PROPERTY(qreal direction READ direction WRITE setDirection NOTIFY directionChanged)
    Q_PROPERTY(qreal zoomlevel READ zoomLevel WRITE setZoomLevel NOTIFY zoomLevelChanged)
    Q_PROPERTY(bool active READ active WRITE setActive NOTIFY activeChanged)
    Q_PROPERTY(qreal routeDirection READ routeDirection NOTIFY routeDirectionChanged)
    Q_PROPERTY(QGeoCoordinate routePosition READ routePosition NOTIFY routePositionChanged)

public:
    explicit Navigation(MapBox *mapbox, QObject *parent = nullptr);

public:
    // Getters
    const QGeoPositionInfo &position() const { return m_position; }
    QGeoCoordinate coordinate() const { return m_position.coordinate(); }
    qreal direction() const { return m_position.attribute(QGeoPositionInfo::Direction); }
    qreal zoomLevel() const { return m_zoomlevel; }
    bool active() const { return m_active; }

    qreal routeDirection() const { return m_routeDirection; }
    QGeoCoordinate routePosition() const { return m_routePosition; }

    // Setters
    void setPosition(const QGeoPositionInfo &position);
    void setCoordinate(const QGeoCoordinate &coordinate);
    void setDirection(qreal direction);
    void setZoomLevel(qreal zoomlevel);
    void setActive(bool active);

signals:
    void positionChanged(QGeoPositionInfo position);
    void coordinateChanged(QGeoCoordinate coordinate);
    void directionChanged(qreal direction);
    void zoomLevelChanged(qreal zoomlevel);
    void activeChanged(bool active);

    void routeDirectionChanged(qreal routeDirection);
    void routePositionChanged(QGeoCoordinate routePosition);

private:
    MapBox *m_mapbox;
    QGeoPositionInfo m_position;
    qreal m_zoomlevel;
    bool m_active;

    qreal m_routeDirection;
    QGeoCoordinate m_routePosition;
};

#endif // NAVIGATION_H
