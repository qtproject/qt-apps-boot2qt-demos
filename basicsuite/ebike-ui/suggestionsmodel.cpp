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
#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QJsonDocument>

#include "suggestionsmodel.h"

#define EBIKE_DEMO_MODE

static const char mostRecentFilename[] = "mostrecent.bson";

SuggestionsModel::SuggestionsModel(QObject *parent)
    : QAbstractListModel(parent)
{
    loadMostRecent();
}

SuggestionsModel::SuggestionsModel(const QJsonArray &suggestions, QObject *parent)
    : QAbstractListModel(parent)
    , m_suggestions(suggestions)
{
    loadMostRecent();
}

QVariant SuggestionsModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    // Only horizontal header
    if (orientation == Qt::Vertical)
        return QVariant();

    if (role == Qt::DisplayRole && section == 0)
        return tr("Place");

    return QAbstractListModel::headerData(section, orientation, role);
}

int SuggestionsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_suggestions.isEmpty() ? m_mostrecent.size() : m_suggestions.size();
}

QVariant SuggestionsModel::data(const QModelIndex &index, int role) const
{
    QJsonObject obj = get(index.row());
    if (role == Qt::DisplayRole) {
        return obj.value("place_name").toVariant();
    } else if (role == PlaceNameRole) {
        return obj.value("place_name").toVariant();
    }

    return QVariant();
}

QHash<int, QByteArray> SuggestionsModel::roleNames() const
{
    QHash<int, QByteArray> roles = QAbstractListModel::roleNames();
    roles[PlaceNameRole] = "placename";
    return roles;
}

const QJsonObject SuggestionsModel::get(int index) const
{
    return m_suggestions.isEmpty() ?
                m_mostrecent[index].toObject() :
                m_suggestions[index].toObject();
}

void SuggestionsModel::setSuggestions(const QJsonArray &suggestions)
{
    beginResetModel();
    m_suggestions = suggestions;
    endResetModel();
    emit emptyChanged();
}

void SuggestionsModel::clear()
{
    beginResetModel();
    m_suggestions = QJsonArray();
    endResetModel();
    emit emptyChanged();
}

void SuggestionsModel::addToMostRecent(const QJsonObject &place)
{
    Q_UNUSED(place)
    // For the demo, do not add new most recent places
#ifndef EBIKE_DEMO_MODE
    if (!m_mostrecent.contains(place))
        m_mostrecent.prepend(place);
    if (m_mostrecent.size() > 3)
        m_mostrecent.pop_back();
    saveMostRecent();
#endif
}

void SuggestionsModel::loadMostRecent()
{
    QDir dir(QCoreApplication::applicationDirPath());

    // Load most recent places
    QString mostRecentFilepath = dir.absoluteFilePath(mostRecentFilename);
    QFile mostRecentFile(mostRecentFilepath);
    if (mostRecentFile.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromBinaryData(mostRecentFile.readAll());
        m_mostrecent = doc.array();
    }
}

void SuggestionsModel::saveMostRecent() const
{
    QDir dir(QCoreApplication::applicationDirPath());

    // Load most recent places
    QString mostRecentFilepath = dir.absoluteFilePath(mostRecentFilename);
    QFile mostRecentFile(mostRecentFilepath);
    if (mostRecentFile.open(QIODevice::WriteOnly)) {
        QJsonDocument doc(m_mostrecent);
        mostRecentFile.write(doc.toBinaryData());
    }
}
