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

#include "appparser.h"
#include "applog.h"

#include <QtCore/QFile>
#include <QtCore/QJsonDocument>
#include <QtCore/QJsonObject>

Q_LOGGING_CATEGORY(apps, "launcher.apps")


static QString doReadString(const QJsonValue& value, bool *ok)
{
    if (value.type() != QJsonValue::String) {
        *ok = false;
        return QString();
    }
    return value.toString();
}

static int doReadInt(const QJsonValue& value, bool *ok)
{
    if (value.type() != QJsonValue::Double) {
        *ok = false;
        return 0;
    }
    return value.toInt();
}

static QString readString(const QJsonObject& object, const QString& key, bool *ok)
{
    return doReadString(object.value(key), ok);
}

static QString readStringOptional(const QJsonObject& object, const QString& key, bool *ok)
{
    auto item = object.value(key);
    if (item.type() == QJsonValue::Undefined)
        return QString();
    return doReadString(item, ok);
}

static int readInt(const QJsonObject& object, const QString& key, bool *ok)
{
    return doReadInt(object.value(key), ok);
}

AppEntry AppParser::parseData(const QByteArray& content, const QString& fileName, bool *ok)
{
    *ok = true;
    QJsonParseError error;

    QJsonDocument doc = QJsonDocument::fromJson(content, &error);
    if (error.error != QJsonParseError::NoError) {
        qCWarning(apps) << "Failed to parse json: " << error.errorString();
        *ok = false;
        return AppEntry::empty();
    }

    if (!doc.isObject()) {
        qCWarning(apps) << "Parsed document is not an object";
        *ok = false;
        return AppEntry::empty();
    }

    auto root = doc.object();

    QString type = readString(root, QStringLiteral("Type"), ok);
    if (type != QStringLiteral("Application")) {
        qCWarning(apps) << "Unknown type" << type;
        *ok = false;
    }

    int version = readInt(root, QStringLiteral("Version"), ok);
    if (version != 1) {
        qCWarning(apps) << "Version number should be 1... Consider to fix that" << version;
    }

    QString iconName = readString(root, QStringLiteral("Icon"), ok);
    QString appName = readString(root, QStringLiteral("Name"), ok);
    QString executableName = readString(root, QStringLiteral("Exec"), ok);
    QString executablePath = readStringOptional(root, QStringLiteral("Path"), ok);
    if (!*ok)
        return AppEntry::empty();

    return AppEntry{iconName, appName, executableName, executablePath, fileName};
}

AppEntry AppParser::parseFile(const QString& fileName, bool *ok)
{
    qCDebug(apps) << "Trying to parse" << fileName;

    QFile file(fileName);
    if (!file.open(QFile::ReadOnly)) {
        qCWarning(apps) << "Failed to open" << fileName;
        *ok = false;
        return AppEntry::empty();
    }

    auto entry = parseData(file.readAll(), fileName, ok);
    file.close();
    if (!*ok) {
        qCWarning(apps) << "Failed to parse" << fileName;
        return AppEntry::empty();
    }
    return entry;
}
