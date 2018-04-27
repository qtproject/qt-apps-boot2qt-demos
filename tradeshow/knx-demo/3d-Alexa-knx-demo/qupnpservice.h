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

#ifndef QUPNPSERVICE_H
#define QUPNPSERVICE_H

#include <QObject>
#include <QTcpSocket>
#include <QtXml/QtXml>


class QUPnPServiceSubscription
{
    friend class QUPnPService;
    QString uuid;
    QUrl url;
    QDateTime timeoutTime;
    quint32 sequenceNumber = 0;
};
class QUPnPRootDevice;

class QUPnPService : public QObject
{
    Q_OBJECT
    friend class QUPnPRootDevice;
    friend class QVirtualBelkinWeMo;

protected:
    QUPnPRootDevice *rootdevice;
    QString identifier;
    QMap<QString, QUPnPServiceSubscription> subscriptions;
    virtual QString upnpServiceListEntry();
    virtual QString getScpd() = 0;
    virtual int executeRemoteProcedureCall(QString actionName, QMap<QString, QString> &actionParams, QString &responseHead, QByteArray &responseBody);
    virtual int processHttpSubscribeRequest(QStringList &requestLines, QString &responseHead, QByteArray &responseBody);
    virtual int processHttpUnsubscribeRequest(QStringList &requestLines, QString &responseHead, QByteArray &responseBody);
    void notifyPropertyChanged(const QString &propertyName, const QString &propertyValue);
    bool notifySubscriber(QUPnPServiceSubscription &subscription, const QString &propertyName, const QString &propertyValue);
    virtual void onNewSubscriber(QUPnPServiceSubscription &subscription) = 0;

public:
    explicit QUPnPService(QObject *parent = nullptr, QString identifier=QString());
    virtual ~QUPnPService();
    Q_DISABLE_COPY(QUPnPService)
};


class QUPnPBooleanService : public QUPnPService
{
    Q_OBJECT

protected:
    bool state = false;
    virtual bool doSetState(bool state);
    QString getScpd() override;
    int executeRemoteProcedureCall(QString actionName, QMap<QString, QString> &actionParams, QString &responseHead, QByteArray &responseBody) override;
    void onNewSubscriber(QUPnPServiceSubscription &subscription) override;

public:
    explicit QUPnPBooleanService(QObject *parent = nullptr, QString identifier=QString());
    virtual void setState(bool state);
    virtual bool getState();

signals:
    void stateChanged(bool newState);
    void stateChangeFailed();
};


class QUPnPBooleanServiceProxy : public QUPnPBooleanService
{
    Q_OBJECT

protected:
    QUPnPBooleanService *m_target;

public:
    explicit QUPnPBooleanServiceProxy(QObject *parent, QUPnPBooleanService *target, QString identifier=QString());
    void setState(bool state) override;
    bool getState() override;
};

#endif // QUPNPSERVICE_H
