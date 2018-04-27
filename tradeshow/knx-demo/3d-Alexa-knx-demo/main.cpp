/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt 3D Studio Demos.
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

#include <QtGui/QGuiApplication>
#include <QtCore/QDir>
#include <QtCore/QVector>
#include <QtQuick/QQuickView>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>
#include <QtGui/QScreen>
#include <QtQml/QQmlPropertyMap>
#include "housemodel.h"
#if defined(KNX_BACKEND)
#include "qmlknxdemo.h"
#endif
#define  ALEXA_WEMO
#if defined(ALEXA_WEMO)
#include "qvirtualbelkinwemo.h"
#endif

// Uncomment for 1280x900 window
//#define FIXEDWINDOW

int applyFontRatio(const int value, const int ratioFont)
{
    return int(value * ratioFont);
}

int applyRatio(const int value, const int ratio)
{
    return qMax(2, int(value * ratio));
}

void setupWemoToKnx(QmlKnxDemo *m_knxBackend)
{
#if defined(ALEXA_WEMO)
    static quint16 nextPort = 52000;
    static QVector<QVirtualBelkinWeMo*> devices;
    static QObject parent;
    static QVirtualBelkinWeMo livingRoom(nullptr, "Livingroom");
    static QVirtualBelkinWeMo masterbedroom(nullptr, "Master bedroom");
    static QVirtualBelkinWeMo bedroom(nullptr, "Bedroom");
    static QVirtualBelkinWeMo bathroom(nullptr, "Bathroom");
    static QVirtualBelkinWeMo all(nullptr, "all");

    devices.push_back(&livingRoom);
    devices.push_back(&masterbedroom);
    devices.push_back(&bedroom);
    devices.push_back(&bathroom);
    devices.push_back(&all);

    livingRoom.startListening(nextPort++);
    masterbedroom.startListening(nextPort++);
    bedroom.startListening(nextPort++);
    bathroom.startListening(nextPort++);
    all.startListening(nextPort++);

    qDebug () << "11111 Connecting services!";
    for (int lightNum = 0; lightNum < devices.size(); ++lightNum) {
        if (lightNum == (devices.size()-1))
        {
            QObject::connect(dynamic_cast<QUPnPBooleanService*>(devices[lightNum]->getService("")), &QUPnPBooleanService::stateChanged, [m_knxBackend](bool state){
                for (int i = 1; i <= 4; ++i) {
                    if (m_knxBackend->getLightState(i) != state)
                        m_knxBackend->toggleLight(i);
                }
               m_knxBackend->changeRoom(0);
            });

            break;
        }
        QObject::connect(dynamic_cast<QUPnPBooleanService*>(devices[lightNum]->getService("")), &QUPnPBooleanService::stateChanged, [lightNum, m_knxBackend](bool state){
             if (m_knxBackend->getLightState(lightNum+1) != state)
                m_knxBackend->toggleLight(lightNum+1);
             m_knxBackend->changeRoom(lightNum+1);
            qDebug () << ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Switching light! "<< lightNum+1 <<"state "<< (state ? "true":"false") << " light_state:" << m_knxBackend->getLightState(lightNum+1);
        });
        QObject::connect(dynamic_cast<QUPnPBooleanService*>(devices[lightNum]->getService("")), &QUPnPBooleanService::stateChangeFailed, [lightNum](){
           qDebug () << ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Switching light FAILEDDD! "<< lightNum+1;
        });
    }

//    QUPnPRootDevice rootdev(nullptr, "Qt UPnP to KNX Bridge");
//    QUPnPBooleanService *service = new QUPnPBooleanServiceProxy(&rootdev, dynamic_cast<QUPnPBooleanService*>(devices[0]->getService("")), "SwitchPower");
//    rootdev.addService(service);
//    rootdev.startListening(nextPort++);
#else
    Q_UNUSED(m_knxBackend)
#endif
    return;
}


int main(int argc, char *argv[])
{
////#if defined(Q_OS_MACOS)
//    QSurfaceFormat openGLFormat;
//    openGLFormat.setRenderableType(QSurfaceFormat::OpenGL);
//    openGLFormat.setProfile(QSurfaceFormat::CoreProfile);
//    openGLFormat.setMajorVersion(3);
//    openGLFormat.setMinorVersion(0);

//    //openGLFormat.setStencilBufferSize(8);
//    QSurfaceFormat::setDefaultFormat(openGLFormat);
////#endif

    QGuiApplication app(argc, argv);

    // Define size variants for scaling
    qreal refDpi = 96.;
    qreal refWidth = 1280.;
    qreal refHeight = 900.;
    QRect rect = QGuiApplication::primaryScreen()->geometry();
    qreal width = rect.width();
    qreal height = rect.height();
    qreal dpi = QGuiApplication::primaryScreen()->logicalDotsPerInch();
    qreal widthRatio = width / refWidth;
    qreal heightRatio = height / refHeight;
    qreal ratioFont = qMin(height * dpi / (refDpi * refHeight), width * dpi / (refDpi * refWidth));
    if (widthRatio < 1.)
        widthRatio = 1;
    if (heightRatio < 1.)
        heightRatio = 1;
    if (ratioFont < 1.)
        ratioFont = 1;

#ifdef FIXEDWINDOW
    width = refWidth;
    height = refHeight;
    widthRatio = 1;
    heightRatio = 1;
    ratioFont = 1;
#endif

    QQmlPropertyMap sizesMap;
    sizesMap.insert(QStringLiteral("screenHeight"), QVariant(height));
    sizesMap.insert(QStringLiteral("screenWidth"), QVariant(width));
    sizesMap.insert(QStringLiteral("fontSize"), QVariant(applyFontRatio(26, ratioFont)));
    sizesMap.insert(QStringLiteral("controlHeight"), QVariant(applyFontRatio(64, ratioFont)));
    sizesMap.insert(QStringLiteral("labelMouseMargin"), QVariant(applyRatio(20, widthRatio)));
    sizesMap.insert(QStringLiteral("controlMargin"), QVariant(applyRatio(20, widthRatio)));
    sizesMap.insert(QStringLiteral("controlBorderWidth"), QVariant(applyRatio(3, widthRatio)));
    sizesMap.insert(QStringLiteral("sliderMaxWidth"), QVariant(applyRatio(300, widthRatio)));

    QQuickView viewer;

    viewer.engine()->addImportPath(QStringLiteral(":/qml/imports"));

#ifndef Q_OS_ANDROID
    // Hack to get self build working.
    // Also needs the Qt3DStudio\bin directory in run environment path.
    viewer.engine()->addImportPath(QStringLiteral("C:/Qt/Tools/Qt3DStudio/qml"));
#endif

#if defined(KNX_BACKEND)
    qmlRegisterUncreatableType<QmlKnxDemo>("QmlKnxDemo", 1, 0, "QmlKnxDemo", "Not instantiated from QML");
    QmlKnxDemo *m_knxBackend = new QmlKnxDemo;
    viewer.engine()->rootContext()->setContextProperty(QStringLiteral("knxBackend"), m_knxBackend);
    setupWemoToKnx(m_knxBackend);
#else
    viewer.engine()->rootContext()->setContextProperty(QStringLiteral("knxBackend"), nullptr);
#endif

    HouseModel *m_houseModel = new HouseModel;
    viewer.engine()->rootContext()->setContextProperty(QStringLiteral("houseModel"), m_houseModel);

    viewer.engine()->rootContext()->setContextProperty(QStringLiteral("sizesMap"), &sizesMap);
    viewer.engine()->rootContext()->setContextProperty(QStringLiteral("heightRatio"), heightRatio);

    viewer.setSource(QUrl(QStringLiteral("qrc:/main.qml")));

    viewer.setTitle(QStringLiteral("Qt 3D Studio Home Automation Demo"));
    viewer.setResizeMode(QQuickView::SizeViewToRootObject);
#ifdef FIXEDWINDOW
    viewer.setMinimumSize(QSize(width, height));
    viewer.setMaximumSize(QSize(width, height));
    viewer.show();
#else
    viewer.showFullScreen();
#endif

    return app.exec();
}
