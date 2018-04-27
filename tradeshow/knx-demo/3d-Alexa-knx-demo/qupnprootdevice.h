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

#ifndef QUPNPROOTDEVICE_H
#define QUPNPROOTDEVICE_H

#include <QObject>
#include <QUdpSocket>
#include <QHostAddress>
#include <QNetworkInterface>
#include <QTimer>
#include <QUuid>
#include <QFileInfo>
#include <QImage>
#include <QtXml/QtXml>

#include "qminimalhttpserver.h"
#include "qupnpservice.h"

class QUPnPRootDevice : public QMinimalHttpServer
{
    Q_OBJECT
    friend class QUPnPService;
    friend class MainWindow;

private:
    static QList<QUPnPRootDevice*> allUPnPRootDevices;

protected:
    QString manufacturer = "The Qt Company GmbH";
    QString manufacturerURL = "https://qt.io";
    QString product = "Qt UPnP-to-KNX Bridge";
    QString version = "0.1";
    QString uuid = "";
    QString searchTarget = "upnp:rootdevice";
    QMap<QString, QImage> icons;
    QMap<QString, QUPnPService*> services;

    QString localIpAddress = "";
    QUdpSocket udpSocket;
    virtual QString getUPnPxml();
    virtual QUPnPService *getService(const QString &urlUpper);
    void onUdpDataReceived();
    virtual void processUdpData(const QString &data, QHostAddress senderAddress, quint16 senderPort);
    bool processHttpGetRequest(QString urlUpper, QString &responseHead, QByteArray &responseBody) override;
    int processHttpPostRequest(QString urlUpper, QByteArray &postBody, QString &responseHead, QByteArray &responseBody) override;
    int processHttpSubscribeRequest(QString urlUpper, QStringList &requestLines, QString &responseHead, QByteArray &responseBody) override;
    int processHttpUnsubscribeRequest(QString urlUpper, QStringList &requestLines, QString &responseHead, QByteArray &responseBody) override;

    static const QHostAddress multicastAddress;
    static const quint16 multicastPort;
    static QString createUuid(const QString &base = QString());

public:
    explicit QUPnPRootDevice(QObject *parent, const QString &searchTarget, const QString &name = "upnp:rootdevice");
    ~QUPnPRootDevice();

    void startListening(quint16 port = 0);
    void stopListening();
    void addIcon(const QString &filename);
    void addService(QUPnPService* service);
    static void stopAllUPnPRootDevices();

signals:

};

#endif // QUPNPROOTDEVICE_H
