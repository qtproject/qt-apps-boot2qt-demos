/****************************************************************************
**
** Copyright (C) 2018 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
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

#include "qminimalhttpserver.h"

QMinimalHttpServer::QMinimalHttpServer(QObject *parent)
    : QObject(parent)
{
    connect(&tcpServer, &QTcpServer::newConnection, this, &QMinimalHttpServer::onNewTcpConnection);
}

QMinimalHttpServer::~QMinimalHttpServer()
{
}

void QMinimalHttpServer::addFile(QString filename, QByteArray &data, QString mimetype)
{
    filename = filename.toUpper(); // ensure case insensitivity
    if (!filename.startsWith("/"))
        filename = QStringLiteral("/") + filename;

    httpFiles[filename] = data;
    if (mimetype == "") {
        QMimeDatabase db;
        QList<QMimeType> types = db.mimeTypesForFileName(filename);
        if (types.size() > 0)
            mimetype = types[0].name();
    }
    httpFileMimeTypes[filename] = mimetype;
}

void QMinimalHttpServer::onNewTcpConnection()
{
    for (QTcpSocket* socket = tcpServer.nextPendingConnection(); socket; socket = tcpServer.nextPendingConnection()) {
        #ifdef QT_DEBUG
            qDebug() << "QMinimalHttpServer::connected " << socket->peerAddress().toString() << ":" << socket->peerPort();
        #endif

        connect(socket, &QTcpSocket::readyRead, [this, socket](){
            this->onTcpDataReceived(socket);
        });
        connect(socket, &QTcpSocket::disconnected, [this, socket](){
            #ifdef QT_DEBUG
                qDebug() << "QMinimalHttpServer::disconnected " << socket->peerAddress().toString() << ":" << socket->peerPort();
            #endif
            //emit this->disconnected(socket);
        });
    }
}

void QMinimalHttpServer::onTcpDataReceived(QTcpSocket *socket)
{
    QByteArray data = socket->readAll();
    #ifdef QT_DEBUG
        qDebug() << "QMinimalHttpServer::onTcpDataReceived " << data;
    #endif
    this->processTcpData(data, socket);
}

void QMinimalHttpServer::processTcpData(const QByteArray &data, QTcpSocket *socket)
{
    QStringList lines = QString::fromUtf8(data).split("\r\n");
    QStringList request = lines[0].split(" ", QString::SkipEmptyParts);
    QString responseHead = QStringLiteral("HTTP/1.1 200 OK\r\n");
    QByteArray responseBody;
    int status = 200;

    QString filename = request[1].toUpper();
    if (!filename.startsWith("/"))
        filename = QStringLiteral("/") + filename;
    filename = filename.replace("%20", " ");

    if (request[0].toUpper() == "GET") {
        if (httpFiles.contains(filename)) {
            responseBody = httpFiles[filename];
            responseHead += QStringLiteral("content-type: ") + httpFileMimeTypes[filename] + "\r\n";
        } else if (this->processHttpGetRequest(filename, responseHead, responseBody)) {
            // in this case, everything must be done inside processGetRequest
        } else {
            responseHead = "HTTP/1.0 404 Not Found\r\n";
            status = 404;
        }

    } else if (request[0].toUpper() == "POST") {

        // find and validate "Content-Length:" header
        int contentLength = -1;
        int i = 0;
        for (; i < lines.size(); i++) {
            if (lines[i].startsWith("Content-Length:", Qt::CaseInsensitive))
                contentLength = lines[i].mid(15).trimmed().toInt();
            if (lines[i].trimmed()=="")
                break;
        }
        if (contentLength < 0) {
            responseHead = "HTTP/1.0 411 Length Required\r\n";
            status = 411;
        } else if (contentLength > maxPostRequestContentLength) {
            responseHead = "HTTP/1.0 413 Payload Too Large\r\n";
            status = 413;
        }

        // get the requests body
        int postBodyOffset = -1;
        for (int i = 0; postBodyOffset < 0 && i < data.size()-4; i++)
            if (data[i] == '\r' && data[i+1] == '\n' && data[i+2] == '\r' && data[i+3] == '\n')
                postBodyOffset = i+4;
        QByteArray postBody;
        if (0 <= postBodyOffset && postBodyOffset < data.size())
            postBody = data.mid(postBodyOffset);

        // multi-part message, wait for more packets
        while (status == 200 && postBody.size() < contentLength) {
            if (socket->waitForReadyRead(2000)) {
                QByteArray moreData = socket->readAll();
                #ifdef QT_DEBUG
                    qDebug() << "QMinimalHttpServer::processTcpData MORE DATA:" << moreData;
                #endif
                postBody.append(moreData);
            } else {
                responseHead = "HTTP/1.0 408 Request Timeout\r\n";
                status = 408;
            }
        }

        // call the handler
        if (status == 200)
            status = this->processHttpPostRequest(filename, postBody, responseHead, responseBody);

    } else if (request[0].toUpper() == "SUBSCRIBE") {
        this->processHttpSubscribeRequest(filename, lines, responseHead, responseBody);
    } else if (request[0].toUpper() == "UNSUBSCRIBE") {
        this->processHttpUnsubscribeRequest(filename, lines, responseHead, responseBody);
    }


    responseHead += QStringLiteral(
        "content-length: ") + QString::number(responseBody.size()) + "\r\n"
        "last-modified: Tue, 23 Jan 2018 15:54:00 GMT\r\n"
        "date: " + DateRfc7231() + "\r\n"
        "connection: close\r\n";

    #ifdef QT_DEBUG
        qDebug() << "QMinimalHttpServer::processTcpData" << responseHead << responseBody;
    #endif

    socket->write((responseHead+"\r\n").toUtf8());
    socket->write(responseBody);
}

/***************************************************************************\
 * Overrides of this method may add headers and set the responseBody.      *
 * returning true means that the request has successfully been processed   *
 * returning false means that the (overridden) method could not deliver    *
 * a response, so then a 404 will be sent.                                 *
\***************************************************************************/
bool QMinimalHttpServer::processHttpGetRequest(QString urlUpper, QString &responseHead, QByteArray &responseBody)
{
    Q_UNUSED(urlUpper);
    Q_UNUSED(responseHead);
    Q_UNUSED(responseBody);
    return false;
}

/***************************************************************************\
 * Overrides of this method may add headers and set the responseBody.      *
 * return value should be an HTTP status code corresponding to the         *
 * status that is set in the responseHead.                                 *
 * Since the method is only invoked if the status was 200 before,          *
 * returning 200 is valid in cases where responseHead is not changed       *
\***************************************************************************/
int QMinimalHttpServer::processHttpPostRequest(QString urlUpper, QByteArray &postBody, QString &responseHead, QByteArray &responseBody)
{
    Q_UNUSED(urlUpper);
    Q_UNUSED(postBody);
    Q_UNUSED(responseBody);
    responseHead = "HTTP/1.0 403 Forbidden\r\n";
    return 403;
}

int QMinimalHttpServer::processHttpSubscribeRequest(QString urlUpper, QStringList &requestLines, QString &responseHead, QByteArray &responseBody)
{
    Q_UNUSED(urlUpper);
    Q_UNUSED(requestLines);
    Q_UNUSED(responseBody);
    responseHead = "HTTP/1.0 404 Not Found\r\n";
    return 404;
}

int QMinimalHttpServer::processHttpUnsubscribeRequest(QString urlUpper, QStringList &requestLines, QString &responseHead, QByteArray &responseBody)
{
    Q_UNUSED(urlUpper);
    Q_UNUSED(requestLines);
    Q_UNUSED(responseBody);
    responseHead = "HTTP/1.0 404 Not Found\r\n";
    return 404;
}



void QMinimalHttpServer::startListening(quint16 port)
{
    if (isListening())
        return;
    tcpServer.listen(QHostAddress::Any, port);
}

void QMinimalHttpServer::stopListening()
{
    if (!isListening())
        return;
    tcpServer.close();
}

bool QMinimalHttpServer::isListening()
{
    return tcpServer.isListening();
}

QString QMinimalHttpServer::DateRfc7231(const QDateTime &date)
{
    static const QString daysEn[] = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};
    static const QString monthsEn[] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
    QString sDate = daysEn[ date.date().dayOfWeek() - 1 ]
                  + date.toString(", dd ")
                  + monthsEn[ date.date().month() - 1 ]
                  + date.toString(" yyyy HH:mm::ss")
                  + " GMT";
    return std::move(sDate);
}
QString QMinimalHttpServer::DateRfc7231()
{
    return std::move(DateRfc7231(QDateTime::currentDateTimeUtc()));
}
