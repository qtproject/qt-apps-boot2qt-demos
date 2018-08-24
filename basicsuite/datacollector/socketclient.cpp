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

#include <QDataStream>
#include <QJsonDocument>
#include <QJsonObject>

#include "socketclient.h"

SocketClient::SocketClient(QLocalSocket *socket, QObject *parent)
    : QObject(parent)
    , m_socket(socket)
{
    // Connect socket signals
    connect(m_socket, &QLocalSocket::connected, this, &SocketClient::connected);
    connect(m_socket, &QLocalSocket::disconnected, this, &SocketClient::disconnected);
    connect(m_socket, &QLocalSocket::readyRead, this, &SocketClient::readyRead);
}

qint64 SocketClient::write(const QByteArray &data) {
    return m_socket->write(data);
}

void SocketClient::readyRead() {
    m_data += m_socket->readAll();

    bool messagefound = true;
    while (messagefound) {
        messagefound = false;
        // If we have at least some data
        if (m_data.size() >= 4) {
            // Extract message size
            qint32 messagesize;
            QDataStream stream(m_data.left(4));
            stream >> messagesize;

            // If we have enough data for at least one message
            if (m_data.size() >= messagesize) {
                // Extract actual message
                QByteArray message = m_data.mid(4, messagesize - 4);
                parseMessage(message);
                // Drop necessary amount of bytes
                m_data = m_data.mid(messagesize);
                messagefound = true; // Try to parse another message
            }
        }
    }
}

void SocketClient::parseMessage(const QByteArray &message) {
    // Parse message from raw format
    QJsonDocument doc = QJsonDocument::fromBinaryData(message);
    QJsonObject obj = doc.object();

    emit clientMessage(obj);
}
