/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://qt.digia.com
**
** This file is part of Qt Enterprise Embedded.
**
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://qt.digia.com
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

#if (QT_VERSION < QT_VERSION_CHECK(5, 3, 0))
#include <QtQuick/QQuickItem>
#endif
#include <QtQuick/QQuickView>

#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlComponent>

#include "engine.h"


int main(int argc, char **argv)
{
    //qputenv("QT_IM_MODULE", QByteArray("qtvkb"));

    QApplication app(argc, argv);
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

    QQuickView view;
#if (QT_VERSION < QT_VERSION_CHECK(5, 3, 0))
    // Ensure the width and height are valid because of QTBUG-36938.
    QObject::connect(&view, SIGNAL(widthChanged(int)), view.contentItem(), SLOT(setWidth(int)));
    QObject::connect(&view, SIGNAL(heightChanged(int)), view.contentItem(), SLOT(setHeight(int)));
#endif

    DummyEngine engine;
    view.rootContext()->setContextProperty("engine", &engine);
    view.setColor(Qt::black);
    view.setResizeMode(QQuickView::SizeRootObjectToView);

    QSize screenSize = QGuiApplication::primaryScreen()->size();
    QString mainFile = screenSize.width() < screenSize.height()
        ? QStringLiteral("/main_landscape.qml")
        : QStringLiteral("/SharedMain.qml");

    view.setSource(QUrl::fromLocalFile(path + mainFile));
    view.show();

    app.exec();
}
