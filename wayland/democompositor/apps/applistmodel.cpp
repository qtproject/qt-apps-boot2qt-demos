/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of Qt for Device Creation.
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

#include "applistmodel.h"
#include "appparser.h"
#include "applog.h"

static QHash<int, QByteArray> modelRoles()
{
    QHash<int, QByteArray> roles;
    roles[AppListModel::App] = "appEntry";
    roles[AppListModel::IconName] = "iconName";
    roles[AppListModel::ApplicationName] = "applicationName";
    roles[AppListModel::ExeuctableName] = "executableName";
    roles[AppListModel::ExecutablePath] = "executablePath";
    roles[AppListModel::SourceFileName] = "sourceFileName";
    return roles;
}

QHash<int, QByteArray> AppListModel::m_roles = modelRoles();

AppListModel::~AppListModel()
{
    qDeleteAll(m_rows);
}

int AppListModel::rowCount(const QModelIndex& index) const
{
    if (index.isValid())
        return 0;
    return m_rows.count();
}

QVariant AppListModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.parent().isValid())
        return QVariant();

    auto entry = m_rows[index.row()];

    switch (role) {
    case App:
        return QVariant::fromValue(*entry);
    case IconName:
        return entry->iconName;
    case ApplicationName:
        return entry->appName;
    case ExeuctableName:
        return entry->executableName;
    case ExecutablePath:
        return entry->executablePath;
    case SourceFileName:
        return entry->sourceFileName;
    default:
        qCWarning(apps) << "Unhandled role" << role;
        return QVariant();
    }
}

QHash<int, QByteArray> AppListModel::roleNames() const
{
    return m_roles;
}

void AppListModel::addFile(const QString& fileName)
{
    beginResetModel();
    doAddFile(fileName);
    endResetModel();
}

void AppListModel::doAddFile(const QString& fileName)
{
    bool ok;
    auto newEntry = AppParser::parseFile(fileName, &ok);
    if (!ok)
        return;

    for (int i = 0; i < m_rows.count(); ++i) {
        auto oldEntry = m_rows[i];
        if (oldEntry->sourceFileName == fileName) {
            m_rows[i] = new AppEntry(newEntry);
            delete oldEntry;
            return;
        }
    }

    m_rows.push_back(new AppEntry(newEntry));
}
