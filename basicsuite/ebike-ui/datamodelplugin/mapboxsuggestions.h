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

#ifndef MAPBOXSUGGESTIONS_H
#define MAPBOXSUGGESTIONS_H

#include <QObject>
#include <QGeoCoordinate>

class MapBox;
class QNetworkReply;
class QTimer;
class SuggestionsModel;

class MapBoxSuggestions : public QObject
{
    Q_OBJECT
    Q_PROPERTY(SuggestionsModel suggestions READ suggestions NOTIFY suggestionsChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)
    Q_PROPERTY(QGeoCoordinate center READ center WRITE setCenter NOTIFY centerChanged)
    Q_PROPERTY(QString search READ search WRITE setSearch NOTIFY searchChanged)

public:
    explicit MapBoxSuggestions(MapBox *mapbox, QObject *parent = nullptr);

public:
    SuggestionsModel *suggestions() const { return m_suggestions; }
    bool loading() const { return m_requests.size() > 0; }
    const QGeoCoordinate center() { return m_center; }
    void setCenter(const QGeoCoordinate &center);
    const QString search() const { return m_search; }
    void setSearch(const QString &search);

signals:
    void suggestionsChanged();
    void loadingChanged();
    void centerChanged();
    void searchChanged(QString search);

public slots:
    void stopSuggest();

private slots:
    void loadSuggestions();
    void handleReply();

private:
    MapBox *m_mapbox;
    QTimer *m_timer;
    QList<QNetworkReply *> m_requests;
    SuggestionsModel *m_suggestions;
    QGeoCoordinate m_center;
    QString m_search;
};

#endif // MAPBOXSUGGESTIONS_H
