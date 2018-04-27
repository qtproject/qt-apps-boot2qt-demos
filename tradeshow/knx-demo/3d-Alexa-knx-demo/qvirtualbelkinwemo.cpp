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

// Parts of this work are derived from makermusings fauxmo, see
//   http://www.makermusings.com/2015/07/18/virtual-wemo-code-for-amazon-echo/
//   https://github.com/makermusings/fauxmo
//   commit 54e00be77552fba7b177866f55cf89d017c57dc6
// provided under the terms of

/****************************************************************************
The MIT License (MIT)

Copyright (c) 2015

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
****************************************************************************/

#include "qvirtualbelkinwemo.h"
#include "qupnpservice.h"


QVirtualBelkinWeMo::QVirtualBelkinWeMo(QObject *parent, const QString &name)
    : QUPnPRootDevice(parent, name, QStringLiteral("urn:Belkin:device:**"))
{
    this->service = new QVirtualBelkinWeMoService(this);
    this->addService(this->service);

}

QString QVirtualBelkinWeMo::getUPnPxml()
{
    QString upnp_xml = QStringLiteral(
        "<?xml version=\"1.0\"?>"
        "<root>"
          "<device>"
            "<deviceType>urn:Belkin:device:")+ deviceType +":1</deviceType>"
            "<friendlyName>" + this->product + "</friendlyName>"
            "<manufacturer>Belkin International Inc.</manufacturer>"
            "<modelName>Emulated Socket</modelName>"
            "<modelNumber>3.1415</modelNumber>"
            "<UDN>uuid:Socket-1_0-" + this->uuid + "</UDN>";

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

QUPnPService *QVirtualBelkinWeMo::getService(const QString &urlUpper)
{
    Q_UNUSED(urlUpper);
    return service;
}

QVirtualBelkinWeMoService::QVirtualBelkinWeMoService(QObject *parent)
    : QUPnPBooleanService(parent, "SwitchPower")
{

}

QString QVirtualBelkinWeMoService::upnpServiceListEntry()
{
    return QStringLiteral(
    "<service>"
      "<serviceType>urn:schemas-upnp-org:service:SwitchPower:1</serviceType>"
      "<serviceId>") + identifier + "</serviceId>"
      "<SCPDURL>/" + identifier + "/scpd.xml</SCPDURL>"
      "<controlURL>/upnp/control</controlURL>"
    "</service>";
}

QString QVirtualBelkinWeMoService::getScpd()
{
    return QStringLiteral(
        "<scpd xmlns=\"urn:schemas-upnp-org:service-1-0\">"
          "<specVersion>"
            "<major>1</major>"
            "<minor>0</minor>"
          "</specVersion>"

          "<actionList>"
            "<action>"
              "<name>SetBinaryState</name>"
              "<argumentList>"
                "<argument>"
                  "<name>BinaryState</name>"
                  "<relatedStateVariable>state</relatedStateVariable>"
                  "<direction>in</direction>"
                "</argument>"
              "</argumentList>"
            "</action>"

            "<action>"
              "<name>GetBinaryState</name>"
              "<argumentList>"
                "<argument>"
                  "<name>BinaryState</name>"
                  "<relatedStateVariable>state</relatedStateVariable>"
                  "<direction>out</direction>"
                "</argument>"
              "</argumentList>"
            "</action>"
          "</actionList>"

          "<serviceStateTable>"
            "<stateVariable sendEvents=\"no\">"
              "<name>state</name>"
              "<dataType>boolean</dataType>"
              "<defaultValue>") + (getState()?"1":"0") + "</defaultValue>"
            "</stateVariable>"
          "</serviceStateTable>"
        "</scpd>";
}

int QVirtualBelkinWeMoService::executeRemoteProcedureCall(QString actionName, QMap<QString, QString> &actionParams, QString &responseHead, QByteArray &responseBody)
{
    #ifdef QT_DEBUG
        qDebug() << "QVirtualBelkinWeMoService::executeRemoteProcedureCall " << actionName << actionParams;
    #endif

    if (actionName.toUpper() == "SETBINARYSTATE") {
        bool ok = false;
        int newStateValue = actionParams["BinaryState"].toInt(&ok);
        if (newStateValue < 0 || 1 < newStateValue || !ok) {
            responseHead = "HTTP/1.0 400 Bad Request\r\n";
            return 400;
        }

        this->setState(newStateValue == 1);
    } else if (actionName.toUpper() != "GETBINARYSTATE") {
        responseHead = "HTTP/1.0 400 Bad Request\r\n";
        return 400;
    }

    responseHead = QStringLiteral(
        "HTTP/1.0 200 OK\r\n"
        "CONTENT-TYPE: text/xml; charset=\"utf-8\"\r\n");
    responseBody = (QStringLiteral(
        "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\""
        " s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
        "<s:Body>"
            "<u:") + actionName + "Response xmlns:u=\"urn:schemas-upnp-org:service:" + identifier +":1\">"
              "<BinaryState>" + (getState() ? "1" : "0") + "</BinaryState>"
            "</u:" + actionName + "Response>"
        "</s:Body>"
        "</s:Envelope>").toUtf8();
    return 200;
}
