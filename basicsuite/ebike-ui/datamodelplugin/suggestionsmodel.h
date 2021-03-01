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

#ifndef SUGGESTIONSMODEL_H
#define SUGGESTIONSMODEL_H

#include <QAbstractListModel>
#include <QJsonArray>
#include <QJsonObject>

class SuggestionsModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(bool empty READ isEmpty RESET clear NOTIFY emptyChanged)

public:
    explicit SuggestionsModel(QObject *parent = nullptr);
    explicit SuggestionsModel(const QJsonArray &suggestions, QObject *parent = nullptr);
    enum SuggestionRoles {
        PlaceNameRole = Qt::UserRole + 1
    };

public:
    virtual QVariant headerData(int section, Qt::Orientation orientation, int role) const;
    virtual int rowCount(const QModelIndex &parent) const;
    virtual QVariant data(const QModelIndex &index, int role) const;
    virtual QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE const QJsonObject get(int index) const;
    bool isEmpty() const { return m_suggestions.size() == 0; }

    void setSuggestions(const QJsonArray &suggestions);
    Q_INVOKABLE void clear();

    Q_INVOKABLE void addToMostRecent(const QJsonObject &place);

private:
    void loadMostRecent();
    void saveMostRecent() const;

signals:
    void emptyChanged();

private:
    QJsonArray m_mostrecent;
    QJsonArray m_suggestions;
};

#endif // SUGGESTIONSMODEL_H
