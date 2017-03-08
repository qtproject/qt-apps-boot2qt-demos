/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of Qt for Device Creation.
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
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQmlContext>
#include <QCommandLineParser>
#include <QFontDatabase>
#include <QScreen>

#if defined(RUNS_AS_HOST)
#include "bluetoothdataprovider.h"
#include "sensortagdataprovider.h"
#include "sensortagdataproviderpool.h"
#include "demodataproviderpool.h"
#endif
#include "clouddataprovider.h"
#include "clouddataproviderpool.h"
#include "mockdataprovider.h"
#include "mockdataproviderpool.h"
#ifdef AZURE_UPLOAD
#include "cloudupdate.h"
#endif
#include "seriesstorage.h"

Q_DECLARE_LOGGING_CATEGORY(boot2QtDemos)
Q_LOGGING_CATEGORY(boot2QtDemos, "boot2qt.demos.iot")

int main(int argc, char *argv[])
{
    // QtChars mandate using QApplication as it uses the graphics view fw
    QApplication app(argc, argv);

    QFontDatabase::addApplicationFont(QString::fromLatin1(":/resources/base/fonts/titilliumweb/TitilliumWeb-Regular.ttf"));
    app.setFont(QFont("Titillium Web", 13));

    DataProviderPool *dataProviderPool = 0;
    SeriesStorage seriesStorage;

    QCommandLineParser parser;
    parser.addOptions({{"source", "Sensor data source", "cloud | sensor | mock"}, {"fullscreen", "Fullscreen mode", "true | false"}});
    parser.addHelpOption();
    parser.process(app);

    QString sensorSource = parser.value("source");

    if (sensorSource.isEmpty())
        sensorSource = qgetenv("QT_IOT_DEMO_DATA_SOURCE");

    if (sensorSource.isEmpty())
        // There is no wastorage package available for WinRT
#ifdef Q_OS_WINRT
        sensorSource = "mock";
#else
        sensorSource = "cloud";
#endif

    if (sensorSource == QString("cloud").toLower()) {
        qCDebug(boot2QtDemos) << "Running in cloud mode";
        dataProviderPool = new CloudDataProviderPool;
    }
#if defined(RUNS_AS_HOST)
    else if (sensorSource == QString("sensor").toLower()) {
        qCDebug(boot2QtDemos) << "Running in sensor mode";
        dataProviderPool = new DemoDataProviderPool;
        // List of devices used in Embedded World
        static_cast<SensorTagDataProviderPool*>(dataProviderPool)->setMacFilterList(QStringList() <<
                                                                                    "24:71:89:BF:3B:82" <<
                                                                                    "24:71:89:BC:44:82");
    }
#endif
    else if (sensorSource == QString("mock").toLower()){
        qCDebug(boot2QtDemos) << "Running in mock data mode";
        dataProviderPool = new MockDataProviderPool;
    }
    else {
        qCDebug(boot2QtDemos) << "Unknown mode: " << sensorSource;
        return 1;
    }

    seriesStorage.setDataProviderPool(dataProviderPool);

    qmlRegisterType<SensorTagDataProvider>("SensorTag.DataProvider", 1, 0, "SensorTagData");
    qmlRegisterType<SensorTagDataProvider>("SensorTag.DataProvider", 1, 0, "ProviderState");
    qmlRegisterType<DataProviderPool>("SensorTag.DataProvider", 1, 0, "DataProviderPool");
    qmlRegisterType<SeriesStorage>("SensorTag.SeriesStorage", 1, 0, "SeriesStorage");

#if defined(RUNS_AS_HOST) && defined(AZURE_UPLOAD)
    CloudUpdate update;
    if (sensorSource == "sensor" || sensorSource == "mock") {
        update.setDataProviderPool(dataProviderPool);
        update.restart();
    }
#endif

#ifdef DEPLOY_TO_FS
    QString namingScheme = QStringLiteral("file://") + qApp->applicationDirPath();
    qCDebug(boot2QtDemos) << "Loading resources from the directory" << namingScheme;
#else
    QString namingScheme = QStringLiteral("qrc://");
    qCDebug(boot2QtDemos) << "Loading resources from a resource file";
#endif

    QString mainFile;
    QUrl styleFile;
    QString uiVariant;
    bool fullScreen;
    int appWidth = 0;
    int appHeight = 0;

    QScreen* scr = qApp->screens().at(0);

    QByteArray sf = qgetenv("QT_SCREEN_SCALE_FACTORS");
    qCDebug(boot2QtDemos) << "screen dimensions" << scr->geometry().size();
    qCDebug(boot2QtDemos) << "Scale factor:" << sf.data();

    QString addressString;
    for (auto address : QNetworkInterface::allAddresses()) {
        if (address.protocol() == QAbstractSocket::IPv4Protocol && address != QHostAddress(QHostAddress::LocalHost)
                && !address.toString().startsWith(QLatin1String("169"))) {
            addressString.append(address.toString());
            addressString.append(QLatin1Char('/'));
        }
    }
#if defined(UI_SMALL)
        mainFile = namingScheme + QStringLiteral("/resources/small/MainSmall.qml");
        styleFile = namingScheme + QStringLiteral("/resources/small/StyleSmall.qml");

        uiVariant = "small";
        fullScreen = true;
        appWidth = 1920;
        appHeight = 1080;
        qCDebug(boot2QtDemos) << "Using SMALL UI variant";
#elif defined(UI_MEDIUM)
        mainFile =QStringLiteral("qrc:/resources/medium/MainMedium.qml");
        styleFile = QUrl("qrc:/resources/medium/StyleMedium.qml");
        uiVariant = "medium";
        fullScreen = true;
        appWidth = 1920;
        appHeight = 1080;
        qCDebug(boot2QtDemos) << "Using MEDIUM UI variant";
#elif defined(UI_LARGE)
        mainFile = QStringLiteral("qrc:/resources/large/MainLarge.qml");
        styleFile = QUrl("qrc:/resources/large/StyleLarge.qml");
        uiVariant = "large";
        fullScreen = true;
        appWidth = 3840;
        appHeight = 2160;
        qCDebug(boot2QtDemos) << "Using LARGE UI variant";
#else
#error "Unknown UI form factor set in the project file"
#endif

    qmlRegisterSingletonType(styleFile, "Style", 1,0, "Style");

    if (qEnvironmentVariableIsSet("QT_IOS_DEMO_NO_FULLSCREEN")) {
        qCDebug(boot2QtDemos) << "Application forced not to obey fullscreen setting";
        fullScreen = false;
    }

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("pathPrefix", namingScheme + +"/resources/" + uiVariant + "/images/");
#ifdef DEPLOY_TO_FS
    engine.load(QUrl::fromLocalFile(qApp->applicationDirPath() + QStringLiteral("/resources/base/main.qml")));
#else
    engine.load(QUrl(QStringLiteral("qrc:///resources/base/main.qml")));
#endif

    QQuickWindow *item = qobject_cast<QQuickWindow *>(engine.rootObjects()[0]);
    if (item) {
        item->setWidth(appWidth);
        item->setHeight(appHeight);

        if (fullScreen)
            item->showFullScreen();

        item->setProperty("dataProviderPool", QVariant::fromValue(dataProviderPool));
        item->setProperty("contentFile", mainFile);
        item->setProperty("seriesStorage", QVariant::fromValue(&seriesStorage));
        item->setProperty("addresses", addressString);
    }
    int returnValue = app.exec();
    dataProviderPool->stopScanning();
    return returnValue;
}
