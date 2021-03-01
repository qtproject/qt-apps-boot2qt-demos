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
#include <QNetworkAccessManager>
#include <QUrlQuery>

#include "mapbox.h"

#define MAPBOX_URL "https://api.mapbox.com/"
#define MAPBOX_TOKEN "pk.eyJ1IjoibWFwYm94NHF0IiwiYSI6ImNpd3J3eDE0eDEzdm8ydHM3YzhzajlrN2oifQ.keEkjqm79SiFDFjnesTcgQ"

MapBox::MapBox(QObject *parent)
    : QObject(parent)
    , m_nam(new QNetworkAccessManager(this))
{
}

const QUrl MapBox::createUrl(const QString &path, QUrlQuery params) const
{
    // Create URL and set path
    QUrl url(MAPBOX_URL);
    url.setPath(path, QUrl::TolerantMode);

    // Add access token to query params
    params.addQueryItem("access_token", MAPBOX_TOKEN);
    url.setQuery(params);

    return url;
}

QNetworkReply *MapBox::get(const QUrl &url) const
{
    return m_nam->get(QNetworkRequest(url));
}

QNetworkReply *MapBox::getGeocoding(const QString &query, const QGeoCoordinate &proximity)
{
    QUrlQuery params;
    params.addQueryItem("autocomplete", "true");
    params.addQueryItem("limit", "3");
    if (proximity.isValid())
        params.addQueryItem("proximity", QString("%1,%2").arg(proximity.longitude()).arg(proximity.latitude()));
    QUrl url = createUrl(QString("/geocoding/v5/mapbox.places/%1.json").arg(QString(QUrl::toPercentEncoding(query))), params);

    return get(url);
}

QNetworkReply *MapBox::getDirections(const QGeoCoordinate &source, const QGeoCoordinate &destination, const QString &type)
{
    QString where = QString("%1,%2;%3,%4").arg(source.longitude()).arg(source.latitude()).arg(destination.longitude()).arg(destination.latitude());
    QUrlQuery params;
    params.addQueryItem("steps", "true");
    params.addQueryItem("geometries", "geojson");
    QUrl url = createUrl(QString("/directions/v5/mapbox/%1/%2.json").arg(type).arg(QString(QUrl::toPercentEncoding(where))), params);

    return get(url);
}
