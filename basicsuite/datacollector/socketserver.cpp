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

#include <QLocalServer>
#include <QJsonDocument>
#include <QDataStream>

#include "socketserver.h"
#include "socketclient.h"

SocketServer::SocketServer(QObject *parent)
    : QObject(parent)
    , m_server(new QLocalServer(this))
{
    connect(m_server, &QLocalServer::newConnection, this, &SocketServer::processConnected);
    QLocalServer::removeServer("datasocket");
    m_server->listen("datasocket");
}

void SocketServer::processConnected(void) {
    while (m_server->hasPendingConnections()) {
        QLocalSocket* socket = m_server->nextPendingConnection();
        qDebug() << "Client connected" << socket;
        if (socket) {
            SocketClient *client = new SocketClient(socket, this);
            connect(client, &SocketClient::disconnected, this, &SocketServer::processDisconnected);
            connect(client, &SocketClient::clientMessage, this, &SocketServer::clientMessage);
            m_clients.append(client);
        }
    }
}

void SocketServer::processDisconnected(void) {
    SocketClient *client = qobject_cast<SocketClient*>(sender());
    qDebug() << "Client disconnected" << client->socket();
    m_clients.removeOne(client);
    client->deleteLater();
}

void SocketServer::sendToClients(const QByteArray &message) {
    // Prepend the message length
    QByteArray data;
    QDataStream stream(&data, QIODevice::WriteOnly);
    stream << static_cast<qint32>(message.size() + 4);
    data.append(message);

    foreach (SocketClient *client, m_clients) {
        client->write(data);
    }
}

/**
 * @brief sendToClients
 * @param message
 *
 * Converts a JSON object to its binary representation and sends it to all clients
 */
void SocketServer::sendToClients(const QJsonObject &message) {
    QJsonDocument doc(message);
    sendToClients(doc.toBinaryData());
}
