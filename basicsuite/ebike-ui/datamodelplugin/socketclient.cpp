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

#include "socketclient.h"

SocketClient::SocketClient(QObject *parent)
    : QObject(parent)
    , m_socket(new QLocalSocket(this))
{
    // Connect socket signals
    connect(m_socket, &QLocalSocket::connected, this, &SocketClient::connected);
    connect(m_socket, &QLocalSocket::disconnected, this, &SocketClient::disconnected);
    connect(m_socket, &QLocalSocket::readyRead, this, &SocketClient::readyRead);

    // Setup timer to try to reconnect after disconnect
    m_connectionTimer.setInterval(5000);
    connect(&m_connectionTimer, &QTimer::timeout, this, &SocketClient::reconnect);
    connect(m_socket, &QLocalSocket::connected, &m_connectionTimer, &QTimer::stop);
    connect(m_socket, &QLocalSocket::disconnected,
            &m_connectionTimer, static_cast<void (QTimer::*)()>(&QTimer::start));
    connect(m_socket,  static_cast<void(QLocalSocket::*)(QLocalSocket::LocalSocketError)>(&QLocalSocket::error),
            &m_connectionTimer, static_cast<void (QTimer::*)()>(&QTimer::start));
}

void SocketClient::connectToServer(const QString &servername)
{
    m_servername = servername;
    reconnect();
}

void SocketClient::reconnect()
{
    qDebug("Connecting to server...");
    m_socket->connectToServer(m_servername);
}

qint64 SocketClient::write(const QByteArray &data)
{
    return m_socket->write(data);
}

/**
 * @brief send a QByteArray to the server
 * @param message
 *
 * Adds the length of the message as a header and sends the message to the server.
 */
void SocketClient::sendToServer(const QByteArray &message)
{
    // Prepend the message length
    QByteArray data;
    QDataStream stream(&data, QIODevice::WriteOnly);
    stream << static_cast<qint32>(message.size() + 4);
    data.append(message);

    write(data);
}

/**
 * @brief send a Json object to the server
 * @param message
 *
 * Sends a QJsonObject object to the server, encoded in Qt's internal binary format.
 */
void SocketClient::sendToServer(const QJsonObject &message)
{
    QJsonDocument doc(message);
    sendToServer(doc.toBinaryData());
}

/**
 * @brief reads incoming data from the server
 *
 * Parses only message headers and body as QByteArray, but does not care about
 * the contents. All complete messages are processed at @see parseMessage.
 */
void SocketClient::readyRead()
{
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

/**
 * @brief parse the contents of a QByteArray
 * @param message
 *
 * Contents are parsed from QJsonDocument's binary data. This separation allows
 * the format to be changed later on, if need be.
 */
void SocketClient::parseMessage(const QByteArray &message)
{
    // Parse message from raw format
    QJsonDocument doc = QJsonDocument::fromBinaryData(message);
    emit newMessage(doc.object());
}
