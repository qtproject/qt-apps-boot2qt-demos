/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the QtBrowser project.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPLv2 included in the
** packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/gpl-2.0.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file. Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "appengine.h"
#include "navigationhistoryproxymodel.h"
#include "touchtracker.h"

#if defined(DESKTOP_BUILD)
#include "touchmockingapplication.h"
#endif

#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickView>
#include <QtWebEngine/qtwebengineglobal.h>

static QObject *engine_factory(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    AppEngine *eng = new AppEngine();
    return eng;
}

int main(int argc, char **argv)
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    //do not use any plugins installed on the device
    qputenv("QML2_IMPORT_PATH", QByteArray());

    // We use touch mocking on desktop and apply all the mobile switches.
    QByteArrayList args = QByteArrayList()
            << QByteArrayLiteral("--enable-embedded-switches")
            << QByteArrayLiteral("--log-level=0");
    const int count = args.size() + argc;
    QVector<char*> qargv(count);

    qargv[0] = argv[0];
    for (int i = 0; i < args.size(); ++i)
        qargv[i + 1] = args[i].data();
    for (int i = args.size() + 1; i < count; ++i)
        qargv[i] = argv[i - args.size()];

    int qAppArgCount = qargv.size();

#if defined(DESKTOP_BUILD)
    TouchMockingApplication app(qAppArgCount, qargv.data());
#else
    QGuiApplication app(qAppArgCount, qargv.data());
#endif

    qmlRegisterType<NavigationHistoryProxyModel>("WebBrowser", 1, 0, "SearchProxyModel");
    qmlRegisterType<TouchTracker>("WebBrowser", 1, 0, "TouchTracker");
    qmlRegisterSingletonType<AppEngine>("WebBrowser", 1, 0, "AppEngine", engine_factory);

    QtWebEngine::initialize();

    app.setOrganizationName("The Qt Company");
    app.setOrganizationDomain("qt.io");
    app.setApplicationName("qtwebbrowser");

    QQuickView view;
    view.setTitle("Yet Another Browser");
    view.setFlags(Qt::Window | Qt::WindowTitleHint);
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setColor(Qt::black);
    view.setSource(QUrl("qrc:///qml/Main.qml"));

    QObject::connect(view.engine(), SIGNAL(quit()), &app, SLOT(quit()));

#if defined(DESKTOP_BUILD)
    view.show();
    if (view.size().isEmpty())
        view.setGeometry(0, 0, 800, 600);
#else
    view.showFullScreen();
#endif

    app.exec();
}