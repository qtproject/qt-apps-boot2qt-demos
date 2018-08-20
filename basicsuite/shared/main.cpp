/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
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
// QtWidget (QApplication) dependecy is required by QtCharts demo,
// when QtWidget dependecy is not required use QGuiApplication from QtGui module
#include <QtWidgets/QApplication>
#include <QtGui/QFont>
#include <QtGui/QFontDatabase>
#include <QtGui/QScreen>
#include <QtGui/QPalette>
#include <QtCore/QRegExp>
#include <QtCore/QFile>

#include <QtQml/QQmlApplicationEngine>

#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlComponent>
#include <QSettings>
#include <QQuickStyle>
#include <QIcon>

#if defined(USE_QTWEBENGINE)
#include <qtwebengineglobal.h>
#endif

#include "engine.h"

int main(int argc, char **argv)
{
    //qputenv("QT_IM_MODULE", QByteArray("qtvkb"));
    qputenv("QT_QUICK_CONTROLS_CONF", "/data/user/qt/qtquickcontrols2/qtquickcontrols2.conf");
    QIcon::setThemeName("gallery");
    QIcon::setThemeSearchPaths(QStringList() << "/data/user/qt/qtquickcontrols2/icons");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

#if defined(USE_QTWEBENGINE)
    // This is currently needed by all QtWebEngine applications using the HW accelerated QQuickWebView.
    // It enables sharing the QOpenGLContext of all QQuickWindows of the application.
    // We have to do so until we expose public API for it in Qt or choose to enable it by default.
    QtWebEngine::initialize();
#endif

    QFontDatabase::addApplicationFont(":/fonts/TitilliumWeb-Regular.ttf");
    QFontDatabase::addApplicationFont(":/fonts/TitilliumWeb-SemiBold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/TitilliumWeb-Bold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/TitilliumWeb-Black.ttf");

    //For eBike demo
    QFontDatabase::addApplicationFont(":/fonts/ebike-fonts/Montserrat-Bold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/ebike-fonts/Montserrat-Light.ttf");
    QFontDatabase::addApplicationFont(":/fonts/ebike-fonts/Montserrat-Medium.ttf");
    QFontDatabase::addApplicationFont(":/fonts/ebike-fonts/Montserrat-Regular.ttf");
    QFontDatabase::addApplicationFont(":/fonts/ebike-fonts/Teko-Bold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/ebike-fonts/Teko-Light.ttf");
    QFontDatabase::addApplicationFont(":/fonts/ebike-fonts/Teko-Medium.ttf");
    QFontDatabase::addApplicationFont(":/fonts/ebike-fonts/Teko-Regular.ttf");
    QFontDatabase::addApplicationFont(":/fonts/ebike-fonts/fontawesome-webfont.ttf");

    QString path = app.applicationDirPath();

    QPalette pal;
    pal.setColor(QPalette::Text, Qt::black);
    pal.setColor(QPalette::WindowText, Qt::black);
    pal.setColor(QPalette::ButtonText, Qt::black);
    pal.setColor(QPalette::Base, Qt::white);
    QGuiApplication::setPalette(pal);

    QString target = qgetenv("B2QT_BASE") + "-" + qgetenv("B2QT_PLATFORM");
    QFile excludeFile(path + QStringLiteral("/exclude.txt"));
    if (excludeFile.open(QFile::ReadOnly)) {
        const QStringList excludeList = QString::fromUtf8(excludeFile.readAll()).split(QRegExp(":|\\s+"));
        if (excludeList.contains(target))
            qDebug("Warning: This example may not be fully functional on this platform");
        excludeFile.close();
    }

    QString fontName = QStringLiteral("/system/lib/fonts/DejaVuSans.ttf");
    if (QFile::exists(fontName)) {
        QFontDatabase::addApplicationFont(fontName);
        QFont font("DejaVu Sans");
        font.setPixelSize(12);
        QGuiApplication::setFont(font);
    } else {
        QFont font;
        font.setStyleHint(QFont::SansSerif);
        QGuiApplication::setFont(font);
    }

    QString videosPath = QStringLiteral("file://");
    QString defaultVideoUrl = QStringLiteral("file:///data/videos/Qt_video_720p.webm");
    videosPath.append("/data/videos");

    QSettings styleSettings;
    QString style = styleSettings.value("style").toString();
    if (style.isEmpty() || style == "Default")
        styleSettings.setValue("style", "Material");
    QQuickStyle::setStyle(styleSettings.value("style").toString());

    DummyEngine engine;

    QQmlApplicationEngine applicationengine;
    QString appFont("TitilliumWeb");
    applicationengine.rootContext()->setContextProperty("engine", &engine);
    applicationengine.rootContext()->setContextProperty("appFont", appFont);
    applicationengine.rootContext()->setContextProperty("availableStyles", QQuickStyle::availableStyles());

    applicationengine.rootContext()->setContextProperty("VideosLocation", videosPath);
    applicationengine.rootContext()->setContextProperty("DefaultVideoUrl", defaultVideoUrl);

    QSettings themeColorSettings("QtLauncher", "colorSettings");

    applicationengine.rootContext()->setContextProperty("_backgroundColor", themeColorSettings.value("backgroundColor", "#09102b"));
    applicationengine.rootContext()->setContextProperty("_primaryGreen", themeColorSettings.value("primaryGreen", "#41cd52"));
    applicationengine.rootContext()->setContextProperty("_mediumGreen", themeColorSettings.value("mediumGreen", "#21be2b"));
    applicationengine.rootContext()->setContextProperty("_darkGreen", themeColorSettings.value("darkGreen", "#17a81a"));
    applicationengine.rootContext()->setContextProperty("_primaryGrey", themeColorSettings.value("primaryGrey", "#9d9faa"));
    applicationengine.rootContext()->setContextProperty("_secondaryGrey", themeColorSettings.value("secondaryGrey", "#3a4055"));

    applicationengine.load(QUrl::fromLocalFile(path + "/SharedMain.qml"));

    app.exec();
}
