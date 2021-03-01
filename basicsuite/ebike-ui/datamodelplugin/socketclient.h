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

#ifndef SOCKETCLIENT_H
#define SOCKETCLIENT_H

#include <QObject>
#include <QLocalSocket>
#include <QTimer>
#include <QJsonObject>

/**
 * @brief The SocketClient class
 *
 * Socket container and message parser for client communications.
 */
class SocketClient : public QObject
{
    Q_OBJECT

public:
    explicit SocketClient(QObject *parent = nullptr);

public:
    QLocalSocket* socket(void) const { return m_socket; }
    qint64 write(const QByteArray &data);
    void sendToServer(const QByteArray &message);
    void sendToServer(const QJsonObject &message);

private:
    void parseMessage(const QByteArray &message);

signals:
    void connected();
    void disconnected();

    void newMessage(const QJsonObject &message);

public slots:
    void connectToServer(const QString &servername);

private slots:
    void reconnect();
    void readyRead();

private:
    QLocalSocket *m_socket;
    QString m_servername;
    QTimer m_connectionTimer;
    QByteArray m_data;
};

#endif // SOCKETCLIENT_H
