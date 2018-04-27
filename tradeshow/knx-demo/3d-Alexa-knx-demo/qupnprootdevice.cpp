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

#include "qupnprootdevice.h"
#include <QCryptographicHash>
#include <QNetworkDatagram>

// 239.255.255.250:1900 is the IANA reserved UPnP multicast address.
const QHostAddress QUPnPRootDevice::multicastAddress("239.255.255.250");
const quint16 QUPnPRootDevice::multicastPort = 1900;

QList<QUPnPRootDevice*> QUPnPRootDevice::allUPnPRootDevices;

QUPnPRootDevice::QUPnPRootDevice(QObject *parent, const QString &name, const QString &searchTarget)
    : QMinimalHttpServer(parent)
{
    allUPnPRootDevices.push_back(this);

    static bool didRandomize = false;
    if (!didRandomize)
        qsrand(QTime::currentTime().msec());
    didRandomize = true;

    foreach (const QHostAddress &address, QNetworkInterface::allAddresses())
        if (address.protocol() == QAbstractSocket::IPv4Protocol
        &&  address != QHostAddress(QHostAddress::LocalHost))
             this->localIpAddress = address.toString();

    this->searchTarget = searchTarget;
    this->product = name;
    this->uuid = createUuid(name);
    connect(&udpSocket, &QUdpSocket::readyRead, this, &QUPnPRootDevice::onUdpDataReceived);
}

QUPnPRootDevice::~QUPnPRootDevice()
{
    stopListening();
    allUPnPRootDevices.removeAll(this);
}

void QUPnPRootDevice::stopAllUPnPRootDevices()
{
    #ifdef QT_DEBUG
        qDebug() << "QUPnPRootDevice::stopAllUPnPRootDevices";
    #endif
    for (QUPnPRootDevice* dev : allUPnPRootDevices)
        dev->stopListening();
}

QString QUPnPRootDevice::getUPnPxml()
{
    /*
        <deviceType>urn:schemas-upnp-org:device:DimmableLight:1</deviceType>
        <modelDescription>UPnP-to-KNX Bridge</modelDescription>
        <modelName>UPnP-to-KNX Bridge</modelName>
        <modelNumber>0.1</modelNumber>
        <modelURL>https://qt.io</modelURL>
        <serialNumber>0.1</serialNumber>
        <presentationURL/>
    */

    QString upnp_xml = QStringLiteral(
        "<?xml version=\"1.0\"?>"
        "<root xmlns=\"urn:schemas-upnp-org:device-1-0\">"
          "<specVersion>"
            "<major>1</major>"
            "<minor>0</minor>"
          "</specVersion>"
          "<device>"
            "<deviceType>upnp:rootdevice</deviceType>"
            "<friendlyName>") + this->product + "</friendlyName>"
            "<manufacturer>" + this->manufacturer + "</manufacturer>"
            "<manufacturerURL>" + this->manufacturerURL + "</manufacturerURL>"
            "<modelName>" + this->product + "</modelName>"
            "<modelNumber>0.1</modelNumber>"
            "<UDN>uuid:" + this->uuid + "</UDN>";

    // icons
    if (icons.size() > 0) {
        upnp_xml += "<iconList>";
        for (QString iconKey : icons.keys()) {
            QImage icon = icons[iconKey];
            upnp_xml += QStringLiteral(
            "<icon>") +
              "<mimetype>" + httpFileMimeTypes[iconKey] + "</mimetype>"
              "<width>" + QString::number(icon.width()) + "</width>"
              "<height>" + QString::number(icon.height()) + "</height>"
              "<depth>" + QString::number(icon.depth()) + "</depth>"
              "<url>" + iconKey + "</url>"
            "</icon>";
        }
        upnp_xml += "</iconList>";
    }

    // services
    if (services.size() > 0) {
        upnp_xml += "<serviceList>";
        for (auto service : services)
            upnp_xml += service->upnpServiceListEntry();
        upnp_xml += "</serviceList>";
    }

    upnp_xml +=
          "</device>"
        "</root>";

    return upnp_xml;
}

QUPnPService *QUPnPRootDevice::getService(const QString &urlUpper)
{
    QString serviceKey;
    if (urlUpper.startsWith("/") && urlUpper.endsWith("/CONTROL"))
        serviceKey = urlUpper.mid(1, urlUpper.size() - 9);
    else if (urlUpper.startsWith("/") && urlUpper.endsWith("/EVENTS"))
        serviceKey = urlUpper.mid(1, urlUpper.size() - 8);
    else if (urlUpper.startsWith("/") && urlUpper.endsWith("/SCPD.XML"))
        serviceKey = urlUpper.mid(1, urlUpper.size() - 10);

    if (serviceKey != "" && services.contains(serviceKey))
        return services[serviceKey];
    return nullptr;
}

void QUPnPRootDevice::onUdpDataReceived()
{
    QHostAddress senderAddress;
    quint16 senderPort;
    while (udpSocket.hasPendingDatagrams()) {
        //udpSocket.readDatagram(datagram.data(), datagram.size(), &senderAddress, &senderPort);
        QNetworkDatagram datagram = udpSocket.receiveDatagram(int(udpSocket.pendingDatagramSize()));
        senderAddress = datagram.senderAddress();
        senderPort = datagram.senderPort();
#ifdef QT_DEBUG
            QString sdatagram = QString::fromUtf8(datagram.data());
            if (!sdatagram.contains("ST: urn:dial-multiscreen-org:")
            &&  !sdatagram.contains("ST:urn:schemas-upnp-org:device:InternetGatewayDevice:")
            &&  !sdatagram.contains("ST: urn:schemas-upnp-org:device:InternetGatewayDevice:")
            &&  !sdatagram.contains("ST:urn:schemas-upnp-org:device:MediaRenderer:")
            &&  !sdatagram.contains("ST:urn:schemas-upnp-org:device:MediaServer:")
            &&  !sdatagram.contains("NOTIFY * HTTP/")
            //&&  !sdatagram.contains("")
            ) {
                qDebug() << "QUPnPRootDevice::onUdpDataReceived " << sdatagram;
                qDebug() << "QUPnPRootDevice::onUdpDataReceived ip and port:" << senderAddress << senderPort;
            }
        #endif
        processUdpData(QString::fromUtf8(datagram.data()), senderAddress, senderPort);
    }
}

void QUPnPRootDevice::processUdpData(const QString &data, QHostAddress senderAddress, quint16 senderPort)
{
    if (!data.startsWith("M-SEARCH")
    ||  !data.contains("MAN: \"ssdp:discover\"", Qt::CaseInsensitive)
    ||  (  !data.contains("ST: ssdp:all", Qt::CaseInsensitive)
        && !data.contains("ST: upnp:rootdevice", Qt::CaseInsensitive)
        && !data.contains(QStringLiteral("ST: ") + this->searchTarget, Qt::CaseInsensitive)))
        return;

    // SSDP Requests should not be answered immediately, because the sender of the
    // request might get many results and might run on weak hardware.
    int responseDelay = 1000; // milliseconds
    QStringList lines = data.split("\r\n");
    for (QString line : lines) {
        if (line.startsWith("MX:", Qt::CaseInsensitive))
            responseDelay = 1000 * line.mid(3).trimmed().toInt();
    }
    if (responseDelay > 0)
        responseDelay = qrand() % responseDelay;

    QTimer::singleShot(responseDelay, [this, senderAddress, senderPort](){
        QString message = QStringLiteral(
            "HTTP/1.1 200 OK\r\n"
            "LOCATION: http://") + localIpAddress + ":" + QString::number(tcpServer.serverPort()) + "/upnp.xml\r\n"
            "EXT:\r\n"
            "USN: uuid:" + this->uuid + "::" + this->searchTarget + "\r\n"
            "SERVER: " + QSysInfo::productType() + "/" + QSysInfo::productVersion() + " UPnP/1.0 " + product + "/" + version + "\r\n"
            "CACHE-CONTROL: max-age=86400\r\n"
            "ST: " + this->searchTarget + "\r\n"
            "DATE: " + DateRfc7231() + "\r\n"
            "CONTENT-LENGTH: 0\r\n"
            "\r\n";

        QUdpSocket responseSocket;
        #ifdef QT_DEBUG
            qDebug() << "QUPnPRootDevice::processUdpData senderIp:" << senderAddress << message;
        #endif
        responseSocket.writeDatagram(message.toUtf8(), senderAddress, senderPort);
    });
}

bool QUPnPRootDevice::processHttpGetRequest(QString urlUpper, QString &responseHead, QByteArray &responseBody)
{
    if (urlUpper == "/UPNP.XML")
    {
        responseBody = this->getUPnPxml().toUtf8();
        responseHead += "content-type: text/xml; charset=utf-8\r\n";
        return true;
    }
    else
    {
        QUPnPService *service = getService(urlUpper);
        if (service) {
            responseBody = service->getScpd().toUtf8();
            responseHead += QStringLiteral(
                "content-type: text/xml; charset=utf-8\r\n"
                "server: ") + QSysInfo::productType() + "/" + QSysInfo::productVersion() + " UPnP/1.0 " + product + "/" + version + "\r\n";
            return true;
        }
    }
    return QMinimalHttpServer::processHttpGetRequest(urlUpper, responseHead, responseBody);
}

int QUPnPRootDevice::processHttpPostRequest(QString urlUpper, QByteArray &postBody, QString &responseHead, QByteArray &responseBody)
{
    #ifdef QT_DEBUG
        qDebug() << "QUPnPRootDevice::processHttpPostRequest";
        qDebug() << postBody;
    #endif

    QUPnPService *service = getService(urlUpper);
    if (!service) {
        responseHead = "HTTP/1.0 404 Not Found\r\n";
        return 404;
    }

    QDomDocument doc;
    QString errorMsg; int errorLine; int errorColumn;
    if (!doc.setContent(postBody, true, &errorMsg, &errorLine, &errorColumn)) {
        #ifdef QT_DEBUG
            qDebug() << "doc.setContent failed (" << errorLine << ":" << errorColumn << ") " << errorMsg;
        #endif
        responseHead = "HTTP/1.0 400 Bad Request\r\n";
        return 400;
    }

    QDomElement envelope = doc.documentElement();
    QDomNodeList bodies = envelope.elementsByTagNameNS("http://schemas.xmlsoap.org/soap/envelope/", "Body");
    for (int bodyIdx = 0; bodyIdx < bodies.size(); bodyIdx++) {

        QString actionName;

        // iterate the RPC calls in the envelope
        QDomNodeList RPCs = bodies.at(bodyIdx).toElement().childNodes();
        for (int RPCIdx = 0; RPCIdx < RPCs.size(); RPCIdx++) {
            if (!RPCs.at(RPCIdx).isElement())
                continue;

            actionName = RPCs.at(RPCIdx).toElement().localName();

            // collect parameters
            QMap<QString, QString> actionParameters;
            QDomNodeList params = RPCs.at(RPCIdx).toElement().childNodes();
            for (int paramIdx = 0; paramIdx < params.size(); paramIdx++) {
                if (!params.at(paramIdx).isElement())
                    continue;

                QString paramName = params.at(paramIdx).toElement().localName();
                QString paramValue = "";
                // get paramValue
                QDomNodeList paramChildren = params.at(paramIdx).toElement().childNodes();
                for (int paramChildIdx = 0; paramChildIdx < paramChildren.size(); paramChildIdx++)
                    if (paramChildren.at(paramChildIdx).isText())
                        paramValue = paramChildren.at(paramChildIdx).toText().data();

                actionParameters[paramName] = paramValue;
            }

            // execute the RPC call
            return service->executeRemoteProcedureCall(actionName, actionParameters, responseHead, responseBody);

        }
    }

    return QMinimalHttpServer::processHttpPostRequest(urlUpper, postBody, responseHead, responseBody);
}

int QUPnPRootDevice::processHttpSubscribeRequest(QString urlUpper, QStringList &requestLines, QString &responseHead, QByteArray &responseBody)
{
    #ifdef QT_DEBUG
        qDebug() << "QUPnPRootDevice::processHttpSubscribeRequest";
    #endif

    QUPnPService *service = getService(urlUpper);
    if (!service) {
        responseHead = "HTTP/1.0 404 Not Found\r\n";
        return 404;
    }

    return service->processHttpSubscribeRequest(requestLines, responseHead, responseBody);
}

int QUPnPRootDevice::processHttpUnsubscribeRequest(QString urlUpper, QStringList &requestLines, QString &responseHead, QByteArray &responseBody)
{
    #ifdef QT_DEBUG
        qDebug() << "QUPnPRootDevice::processHttpUnsubscribeRequest";
    #endif

    QUPnPService *service = getService(urlUpper);
    if (!service) {
        responseHead = "HTTP/1.0 404 Not Found\r\n";
        return 404;
    }

    return service->processHttpUnsubscribeRequest(requestLines, responseHead, responseBody);
}

QString QUPnPRootDevice::createUuid(const QString &base)
{
    QString uuid;
    if (base == QString()) {
        uuid = QUuid::createUuid().toString(); // random uuid
        uuid = uuid.mid(1, uuid.length()-2); // remove leading { and trailing }
    } else {
        uuid = QString(QCryptographicHash::hash(base.toUtf8(),QCryptographicHash::Sha1).toHex());
    }

    return uuid;
}

void QUPnPRootDevice::startListening(quint16 port)
{
    if (isListening())
        return;

    QMinimalHttpServer::startListening(port);

    udpSocket.bind(QHostAddress::AnyIPv4, multicastPort, QUdpSocket::ReuseAddressHint);
    udpSocket.joinMulticastGroup(multicastAddress);

    // notify network via multicast
    QString message = QStringLiteral(
        "NOTIFY * HTTP/1.1\r\n"
        "HOST: ") + multicastAddress.toString() + ":" + QString::number(multicastPort) + "\r\n"
        "CACHE-CONTROL: max-age=86400\r\n"
        "LOCATION: http://" + localIpAddress + ":" + QString::number(tcpServer.serverPort()) + "/upnp.xml\r\n"
        "SERVER: " + QSysInfo::productType() + "/" + QSysInfo::productVersion() + " UPnP/1.0 " + product + "/" + version + "\r\n"
        "NTS: ssdp:alive\r\n"
        "NT: " + this->searchTarget + "\r\n"
        "USN: uuid:" + this->uuid + "::" + this->searchTarget + "\r\n"
        "\r\n";
    QUdpSocket aliveSocket;
    aliveSocket.setSocketOption(QAbstractSocket::MulticastTtlOption, 4);
    #ifdef QT_DEBUG
        qDebug() << "QUPnPRootDevice::startListening " << message;
    #endif
    aliveSocket.writeDatagram(message.toUtf8(), multicastAddress, multicastPort);
}

void QUPnPRootDevice::stopListening()
{
    if (!isListening())
        return;

    // notify network via multicast
    QString message = QStringLiteral(
        "NOTIFY * HTTP/1.1\r\n"
        "HOST: ") + multicastAddress.toString() + ":" + QString::number(multicastPort) + "\r\n"
        "NT: " + this->searchTarget + "\r\n"
        "NTS: ssdp:byebye\r\n"
        "USN: uuid:" + this->uuid + "::" + this->searchTarget + "\r\n"
        "SERVER: " + QSysInfo::productType() + "/" + QSysInfo::productVersion() + " UPnP/1.0 " + product + "/" + version + "\r\n"
        "DATE: " + DateRfc7231() + "\r\n"
        "CONTENT-LENGTH: 0\r\n"
        "\r\n";
    QUdpSocket byebyeSocket;
    byebyeSocket.setSocketOption(QAbstractSocket::MulticastTtlOption, 4);
    #ifdef QT_DEBUG
        qDebug() << "QUPnPRootDevice::stopListening " << message;
    #endif
    byebyeSocket.writeDatagram(message.toUtf8(), multicastAddress, multicastPort);

    udpSocket.leaveMulticastGroup(multicastAddress);
    udpSocket.close();
    QMinimalHttpServer::stopListening();
}

void QUPnPRootDevice::addIcon(const QString &filename)
{
    QFileInfo info(filename);
    QString nameonly = QString("/") + info.fileName().toUpper();

    QFile file(filename);
    file.open(QFile::ReadOnly);
    QByteArray data = file.readAll();
    file.close();
    this->addFile(nameonly, data);

    QImage img;
    img.load(filename);
    icons[nameonly] = img;

    if (isListening()) {
        stopListening();
        startListening();
    }
}

void QUPnPRootDevice::addService(QUPnPService *service)
{
    QString id = service->identifier.toUpper();
    if (this->services.contains(id))
        return;
    service->rootdevice = this;
    this->services[id] = service;

    if (isListening()) {
        stopListening();
        startListening();
    }
}
