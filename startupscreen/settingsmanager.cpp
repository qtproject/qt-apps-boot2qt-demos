/****************************************************************************
**
** Copyright (C) 2020 The Qt Company Ltd.
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

#include "settingsmanager.h"

#include <QDebug>
#include <QDir>
#include <QFile>
#include <QTemporaryFile>
#include <QNetworkInterface>

#include <sys/reboot.h>
#include <unistd.h>

const QString QdbdFileName(QStringLiteral("/etc/default/qdbd"));
const char *ProtocolSetting("USB_ETHERNET_PROTOCOL=");

SettingsManager::SettingsManager(QObject *parent) : QObject(parent) {}

bool SettingsManager::hasQdb()
{
    return QFile::exists(QdbdFileName);
}

QString SettingsManager::usbMode()
{
    static bool initialized = false;
    if (!initialized) {
        QFile file(QdbdFileName);
        if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            QByteArray line;
            while (!(line = file.readLine()).isEmpty()) {
                if (line.startsWith(ProtocolSetting))
                    m_usbMode =
                            QString::fromLatin1(line.last(line.length() - strlen(ProtocolSetting)))
                                    .trimmed();
            }
        } else {
            qWarning() << "Failed to open file" << QdbdFileName;
        }
        initialized = true;
    }
    return m_usbMode;
}

void SettingsManager::setUsbMode(const QString &usbMode)
{
    QFile file(QdbdFileName);
    QTemporaryFile newFile(QdbdFileName);
    newFile.setAutoRemove(false);
    if (!newFile.open()) {
        qWarning() << "Failed to save qdbd settings:" << newFile.errorString();
        return;
    }

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream out(&newFile);
        QByteArray line;
        while (!(line = file.readLine()).isEmpty()) {
            if (line.startsWith(ProtocolSetting))
                out << ProtocolSetting << usbMode.toLatin1() << '\n';
            else
                out << line;
        }

        file.remove();
        if (!newFile.rename(QdbdFileName))
            qWarning() << "Failed to save qdbd settings:" << newFile.errorString();

    } else {
        qWarning() << "Failed to save qdbd settings:" << file.errorString();
    }
}

void SettingsManager::reboot()
{
    sync();
    ::reboot(RB_AUTOBOOT);
    qWarning("reboot failed");
}

QString SettingsManager::networks()
{
    QString networks;
    networks.reserve(100);

    const auto interfaceList = QNetworkInterface::allInterfaces();
    for (const auto &interface : interfaceList) {
        if (interface.name() == QLatin1String("lo"))
            continue;

        if (interface.flags().testFlag(QNetworkInterface::IsUp)) {
            for (QNetworkAddressEntry &entry : interface.addressEntries()) {
                if (entry.ip().protocol() == QAbstractSocket::IPv4Protocol) {
                    if (!networks.isEmpty())
                        networks += QLatin1String("\n");

                    networks += interface.name();
                    networks += QLatin1String(": ");
                    networks += entry.ip().toString();
                }
            }
        }
    }
    return networks;
}

QByteArray SettingsManager::guideText()
{
    QFile file(":/assets/b2qt-tutorial-deploying.html");
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return file.readAll();
    } else {
        return QByteArrayLiteral("Guide not found");
    }
}
