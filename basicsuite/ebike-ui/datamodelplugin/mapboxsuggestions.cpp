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

#include <QTimer>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QUrl>
#include <QUrlQuery>
#include <QJsonDocument>
#include <QJsonParseError>
#include <QJsonObject>

#include "mapboxsuggestions.h"
#include "mapbox.h"
#include "suggestionsmodel.h"

MapBoxSuggestions::MapBoxSuggestions(MapBox *mapbox, QObject *parent)
    : QObject(parent)
    , m_mapbox(mapbox)
    , m_timer(new QTimer(this))
    , m_suggestions(new SuggestionsModel(this))
{
    // Setup timer to request 500ms after user stops typing
    m_timer->setSingleShot(true);
    m_timer->setInterval(500);

    // Connect timer signal
    connect(m_timer, &QTimer::timeout, this, &MapBoxSuggestions::loadSuggestions);
}

void MapBoxSuggestions::stopSuggest()
{
    m_timer->stop();
}

void MapBoxSuggestions::setSearch(const QString &search)
{
    if (m_search == search)
        return;

    m_search = search;
    m_timer->start();
    emit searchChanged(m_search);
}

void MapBoxSuggestions::loadSuggestions()
{
    QNetworkReply *reply = m_mapbox->getGeocoding(m_search, m_center);
    connect(reply, &QNetworkReply::finished, this, &MapBoxSuggestions::handleReply);
    m_requests.append(reply);
    emit loadingChanged();
}

void MapBoxSuggestions::handleReply()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll(), &error);
    if (error.error == QJsonParseError::NoError) {
        QJsonObject obj = doc.object();
        m_suggestions->setSuggestions(obj.value("features").toArray());
        emit suggestionsChanged();
    }

    m_requests.removeOne(reply);
    emit loadingChanged();
    reply->deleteLater();
}

void MapBoxSuggestions::setCenter(const QGeoCoordinate &center)
{
    if (m_center != center) {
        m_center = center;
        emit centerChanged();
    }
}
