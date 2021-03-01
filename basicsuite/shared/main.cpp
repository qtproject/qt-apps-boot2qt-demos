/****************************************************************************
**
** Copyright (C) 2018 The Qt Company Ltd.
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
#include <QtCore/QDebug>
#ifdef QT_WIDGETS_LIB
#include <QApplication>
#elif QT_GUI_LIB
#include <QGuiApplication>
#endif
#include <QtGui/QFont>
#include <QtGui/QFontDatabase>
#include <QtGui/QScreen>
#include <QtGui/QPalette>

#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlComponent>
#include <QSettings>
#include <QQuickStyle>
#include <QIcon>
#include <QDir>
#include <QQuickWindow>

#if defined(USE_QTWEBENGINE)
#include <qtwebengineglobal.h>
#endif

#include "engine.h"

static bool checkGlAvailability()
{
    QQuickWindow window;
    return ((window.sceneGraphBackend() != "software") &&
            (window.sceneGraphBackend() != "softwarecontext"));
}

int main(int argc, char **argv)
{
#if defined(USE_QTWEBENGINE)
    // This is currently needed by all QtWebEngine applications using the HW accelerated QQuickWebView.
    // It enables sharing the QOpenGLContext of all QQuickWindows of the application.
    // We have to do so until we expose public API for it in Qt or choose to enable it by default.
    QtWebEngine::initialize();
#endif

    QString appPath = QString::fromLocal8Bit(argv[0]);
    QByteArray appDir = appPath.left(appPath.lastIndexOf(QDir::separator())).toLocal8Bit();
    QByteArray appName = appPath.split(QDir::separator().toLatin1()).last().toLocal8Bit();

    // VKB is active also for desktop
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

#if QT_CONFIG(cross_compile)
    qputenv("QT_QUICK_CONTROLS_CONF", "/data/user/qt/" + appName + "/qtquickcontrols2.conf");
#endif

    if (appName.contains("qtquickcontrols2")) {
        QIcon::setThemeName("gallery");
        QIcon::setThemeSearchPaths(QStringList() << appDir + "/icons");
    }

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

#ifdef QT_WIDGETS_LIB
    QApplication app(argc, argv);
#elif QT_GUI_LIB
    QGuiApplication app(argc, argv);
#endif

    bool fontsAsResource = false;
    QStringList fonts;
    QDir fontsResource(QStringLiteral(":/fonts"));
    if (fontsResource.exists()) {
        fontsAsResource = true;
        fonts = fontsResource.entryList();
    } else {
        QDir fontsDirectory(QCoreApplication::applicationDirPath() + QStringLiteral("/fonts"));
        fonts = fontsDirectory.entryList();
    }

    if (fonts.isEmpty())
        qWarning() << "No fonts provided, using system default!";

    QString path = fontsAsResource ? QStringLiteral(":/fonts/") : QCoreApplication::applicationDirPath() + QStringLiteral("/fonts/");
    for (int i = 0; i < fonts.size(); ++i)
        QFontDatabase::addApplicationFont(path + fonts.at(i));

    // Material style can be set only for devices supporting OpenGL
    QSettings styleSettings;
    QString style = styleSettings.value("style").toString();
    if (checkGlAvailability()) {
        if (style.isEmpty() || style == "Default")
            styleSettings.setValue("style", "Material");
    } else {
        qWarning() << "No OpenGL available, skipping Material style";
    }
    QQuickStyle::setStyle(styleSettings.value("style").toString());

    DummyEngine engine;

    QQmlApplicationEngine applicationengine;

#if !QT_CONFIG(cross_compile)
    applicationengine.addImportPath(QCoreApplication::applicationDirPath() + "/qmlplugins");
#else
    applicationengine.addImportPath("/data/user/qt/qmlplugins");
#endif

    QString appFont("TitilliumWeb");
    applicationengine.rootContext()->setContextProperty("engine", &engine);
    applicationengine.rootContext()->setContextProperty("appFont", appFont);
    applicationengine.rootContext()->setContextProperty("availableStyles", QQuickStyle::availableStyles());

    QSettings demoSettings("Boot2Qt-demos", "demoSettings");

    applicationengine.rootContext()->setContextProperty("_backgroundColor", demoSettings.value("backgroundColor", "#09102b"));
    applicationengine.rootContext()->setContextProperty("_primaryGreen", demoSettings.value("primaryGreen", "#41cd52"));
    applicationengine.rootContext()->setContextProperty("_mediumGreen", demoSettings.value("mediumGreen", "#21be2b"));
    applicationengine.rootContext()->setContextProperty("_darkGreen", demoSettings.value("darkGreen", "#17a81a"));
    applicationengine.rootContext()->setContextProperty("_primaryGrey", demoSettings.value("primaryGrey", "#9d9faa"));
    applicationengine.rootContext()->setContextProperty("_secondaryGrey", demoSettings.value("secondaryGrey", "#3a4055"));

    applicationengine.load(QUrl::fromLocalFile(QCoreApplication::applicationDirPath() + "/SharedMain.qml"));

    app.exec();
}
