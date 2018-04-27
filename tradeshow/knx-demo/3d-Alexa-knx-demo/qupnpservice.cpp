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

#include "qupnpservice.h"
#include "qupnprootdevice.h"

QUPnPService::QUPnPService(QObject *parent, QString identifier)
    : QObject(parent)
{
    this->identifier = identifier;
}

QUPnPService::~QUPnPService()
{
}

QString QUPnPService::upnpServiceListEntry()
{
    return QStringLiteral(
    "<service>"
      "<serviceType>urn:schemas-upnp-org:service:") + identifier + ":1</serviceType>"
      //"<serviceId>urn:upnp-org:serviceId:" + identifier + ":1</serviceId>"
      "<serviceId>" + identifier + "</serviceId>"
      "<SCPDURL>/" + identifier + "/scpd.xml</SCPDURL>"
      "<controlURL>/" + identifier + "/Control</controlURL>"
      "<eventSubURL>/" + identifier + "/Events</eventSubURL>"
    "</service>";
}

int QUPnPService::executeRemoteProcedureCall(QString actionName, QMap<QString, QString> &actionParams, QString &responseHead, QByteArray &responseBody)
{
    Q_UNUSED(actionName);
    Q_UNUSED(actionParams);
    Q_UNUSED(responseHead);
    Q_UNUSED(responseBody);
    responseHead = "HTTP/1.0 404 Not Found\r\n";
    return 404;
}

int QUPnPService::processHttpSubscribeRequest(QStringList &lines, QString &responseHead, QByteArray &responseBody)
{
    Q_UNUSED(responseBody);
    #ifdef QT_DEBUG
        qDebug() << "QUPnPService::processHttpSubscribeRequest";
    #endif

    QUPnPServiceSubscription subscription;
    QString timeout = "0";
    for (int i = 1; i < lines.size(); i++) {
        if (lines.at(i).startsWith("CALLBACK:", Qt::CaseInsensitive)) {
            QString url = lines.at(i).mid(9).trimmed();
            if (url.startsWith("<") && url.endsWith(">"))
                url = url.mid(1, url.size()-2);
            subscription.url = QUrl(url);
        } else if (lines.at(i).startsWith("TIMEOUT:", Qt::CaseInsensitive)) {
            timeout = lines.at(i).mid(8).trimmed();
        } else if (lines.at(i).startsWith("SID:", Qt::CaseInsensitive)) {
            // renewing a subscription
            subscription.uuid = lines.at(i).mid(4).trimmed();
        }
    }

    if (timeout.startsWith("SECOND-", Qt::CaseInsensitive))
        timeout = timeout.mid(7).trimmed();
    bool ok = false;
    int iTimeout = timeout.toInt(&ok);
    subscription.timeoutTime = QDateTime::currentDateTime().addSecs(iTimeout);

    if (!ok || !subscription.url.isValid()) {
        responseHead = "HTTP/1.0 400 Bad Request\r\n";
        return 400;
    }

    // no SID header => new subscription => new SID
    if (subscription.uuid == "") {
        subscription.uuid = QUuid::createUuid().toString();
        subscription.uuid = QStringLiteral("uuid:") + subscription.uuid.mid(1, subscription.uuid.size()-2);

        subscriptions[subscription.uuid] = subscription;

        // delay the notification so that the "HTTP/1.1 200 OK" message comes first
        QString uuid = subscription.uuid;
        QTimer::singleShot(50, [uuid, this](){
            if (subscriptions.contains(uuid))
                onNewSubscriber(subscriptions[uuid]);
        });

    } else {
        // only update the timeout. seq and url must stay the same, uuid would stay the same anyways
        if (subscriptions.contains(subscription.uuid)) {
            responseHead = "HTTP/1.0 412 Precondition Failed\r\n";
            return 412;
        }
        subscriptions[subscription.uuid].timeoutTime = subscription.timeoutTime;
    }

    responseHead = responseHead
        + "SERVER: " + QSysInfo::productType() + "/" + QSysInfo::productVersion() + " UPnP/1.0 " + rootdevice->product + "/" + rootdevice->version + "\r\n"
        + "SID: " + subscription.uuid + "\r\n"
        + "TIMEOUT: Second-" + QString::number(iTimeout) + "\r\n";

    return 200;
}

int QUPnPService::processHttpUnsubscribeRequest(QStringList &lines, QString &responseHead, QByteArray &responseBody)
{
    Q_UNUSED(responseBody);
    #ifdef QT_DEBUG
        qDebug() << "QUPnPService::processHttpUnsubscribeRequest";
    #endif

    // find SID: header
    QString SubscriptionUuid;
    for (int i = 1; i < lines.size(); i++)
        if (lines.at(i).startsWith("SID:", Qt::CaseInsensitive))
            SubscriptionUuid = lines.at(i).mid(4).trimmed();
    if (SubscriptionUuid == "" || !subscriptions.contains(SubscriptionUuid)) {
        responseHead = "HTTP/1.0 412 Precondition Failed\r\n";
        return 412;
    }

    subscriptions.remove(SubscriptionUuid);
    return 200;
}

bool QUPnPService::notifySubscriber(QUPnPServiceSubscription &subscription, const QString &propertyName, const QString &propertyValue)
{
    QByteArray notificationBody = (QStringLiteral(
        "<e:propertyset xmlns:e=\"urn:schemas-upnp-org:event-1-0\">"
          "<e:property>"
            "<") + propertyName + ">" + propertyValue + "</" + propertyName + ">"
          "</e:property>"
        "</e:propertyset>").toUtf8();

    QString notification = QStringLiteral(
        "NOTIFY ") + subscription.url.path() + " HTTP/1.1\r\n"
        "HOST: " + subscription.url.host();
        if (subscription.url.port() > 0)
            notification += QStringLiteral(":") + QString::number(subscription.url.port());
        notification += "\r\n"
        "CONTENT-TYPE: text/xml; charset=utf-8\r\n"
        "NT: upnp:event\r\n"
        "NTS: upnp:propchange\r\n"
        "CONTENT-LENGTH: " + QString::number(notificationBody.size()) + "\r\n"
        "SID: " + subscription.uuid + "\r\n"
        "SEQ: " + QString::number(subscription.sequenceNumber) + "\r\n"
        "CONNECTION: close\r\n"
        "\r\n";

    if (subscription.sequenceNumber >= UINT_MAX)
        subscription.sequenceNumber = 1; // not 0!
    else
        subscription.sequenceNumber++;

    QByteArray message = notification.toUtf8();
    message.append(notificationBody);
    #ifdef QT_DEBUG
        qDebug() << "QUPnPService::notifySubscriber: " << message;
    #endif

    QTcpSocket notificationSocket;
    notificationSocket.connectToHost(subscription.url.host(), subscription.url.port(80));
    if (!notificationSocket.waitForConnected(10000)) {
        qDebug() << "QUPnPService::notifySubscriber: ERROR could not connect to host";
        return false;
    }

    notificationSocket.write(message);
    notificationSocket.waitForReadyRead(30000); // See UPnP specification, chapter 4.2.1
    #ifdef QT_DEBUG
        qDebug() << "QUPnPService::notifySubscriber RESPONSE: " << message;
    #endif
    return true;
}

void QUPnPService::notifyPropertyChanged(const QString &propertyName, const QString &propertyValue)
{
    #ifdef QT_DEBUG
        qDebug() << "QUPnPService::notifyPropertyChanged";
    #endif
    QDateTime now = QDateTime::currentDateTime();
    QList<QString> expiredSubscriptions;

    for (QString subscriptionKey : subscriptions.keys()) {
        QUPnPServiceSubscription &subscription = subscriptions[subscriptionKey];
        bool mustRemove = true;
        if (now <= subscription.timeoutTime)
            mustRemove = !notifySubscriber(subscription, propertyName, propertyValue);
        if (mustRemove)
            expiredSubscriptions.push_back(subscriptionKey);
    }

    for (QString expiredKey : expiredSubscriptions)
        subscriptions.remove(expiredKey);
}



QUPnPBooleanService::QUPnPBooleanService(QObject *parent, QString identifier)
    : QUPnPService(parent, identifier)
{
}

bool QUPnPBooleanService::doSetState(bool state)
{
//    if (state == this->state)
//        return false;
    this->state = state;
    return true;
}

void QUPnPBooleanService::setState(bool state)
{
    if (doSetState(state)) {
        notifyPropertyChanged("state", state?"1":"0");
        emit this->stateChanged(state);
    } else {
        emit this->stateChangeFailed();
    }
}

bool QUPnPBooleanService::getState()
{
    return state;
}

QString QUPnPBooleanService::getScpd()
{
    return QStringLiteral(
        "<scpd xmlns=\"urn:schemas-upnp-org:service-1-0\">"
          "<specVersion>"
            "<major>1</major>"
            "<minor>0</minor>"
          "</specVersion>"

          "<actionList>"
            "<action>"
              "<name>setState</name>"
              "<argumentList>"
                "<argument>"
                  "<name>newState</name>"
                  "<relatedStateVariable>state</relatedStateVariable>"
                  "<direction>in</direction>"
                "</argument>"
              "</argumentList>"
            "</action>"
          "</actionList>"

          "<serviceStateTable>"
            "<stateVariable sendEvents=\"yes\">"
              "<name>state</name>"
              "<dataType>boolean</dataType>"
              "<defaultValue>") + (getState()?"1":"0") + "</defaultValue>"
            "</stateVariable>"
          "</serviceStateTable>"
        "</scpd>";
}

int QUPnPBooleanService::executeRemoteProcedureCall(QString actionName, QMap<QString, QString> &actionParams, QString &responseHead, QByteArray &responseBody)
{
    #ifdef QT_DEBUG
        qDebug() << "QUPnPBooleanService::executeRemoteProcedureCall";
    #endif

    bool ok = false;
    int newStateValue = actionParams["newState"].toInt(&ok);
    if (actionName.toUpper() != "SETSTATE" || newStateValue < 0 || 1 < newStateValue || !ok) {
        responseHead = "HTTP/1.0 400 Bad Request\r\n";
        return 400;
    }

    this->setState(newStateValue == 1);
    responseHead = QStringLiteral(
        "HTTP/1.0 200 OK\r\n"
        "CONTENT-TYPE: text/xml; charset=\"utf-8\"\r\n");
    responseBody = (QStringLiteral(
        "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\""
        " s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
          "<s:Body>"
            "<u:") + actionName + "Response xmlns:u=\"urn:schemas-upnp-org:service:" + identifier +":1\">"
            "</u:" + actionName + "Response>"
          "</s:Body>"
        "</s:Envelope>").toUtf8();
    return 200;
}

void QUPnPBooleanService::onNewSubscriber(QUPnPServiceSubscription &subscription)
{
    this->notifySubscriber(subscription, "state", getState()?"1":"0");
}



QUPnPBooleanServiceProxy::QUPnPBooleanServiceProxy(QObject *parent, QUPnPBooleanService *target, QString identifier)
    : QUPnPBooleanService(parent, identifier)
    , m_target(target)
{
    if (target) {
        connect(target, &QUPnPBooleanService::stateChanged, [this](bool state){
            this->notifyPropertyChanged("state", state?"1":"0");
            emit stateChanged(state);
        });
        connect(target, &QUPnPBooleanService::stateChangeFailed, [this](){
            emit stateChangeFailed();
        });
    }
}

void QUPnPBooleanServiceProxy::setState(bool state)
{
    if (m_target)
        m_target->setState(state);
}

bool QUPnPBooleanServiceProxy::getState()
{
    if (!m_target)
        return false;
    return m_target->getState();
}
