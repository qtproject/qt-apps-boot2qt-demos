/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
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

#include "touchtracker.h"
#include "navigationhistoryproxymodel.h"
#include "appengine.h"

#include <QtQml/QQmlExtensionPlugin>

QT_BEGIN_NAMESPACE

static QObject *engine_factory(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    AppEngine *eng = new AppEngine();
    return eng;
}



class WebBrowser : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface/1.0")
public:
    virtual void registerTypes(const char *uri)
    {
        if (uri == QLatin1String("WebBrowser")) {
        qmlRegisterType<TouchTracker>(uri, 1, 0, "TouchTracker");
        qmlRegisterType<NavigationHistoryProxyModel>(uri, 1, 0, "SearchProxyModel");
        qmlRegisterSingletonType<AppEngine>(uri, 1, 0, "AppEngine", engine_factory);
        }
    }

    virtual void initializeEngine(QQmlEngine *engine, const char *uri)
    {
        Q_UNUSED(engine);
        Q_UNUSED(uri);
    }
};

QT_END_NAMESPACE

#include "plugin.moc"

