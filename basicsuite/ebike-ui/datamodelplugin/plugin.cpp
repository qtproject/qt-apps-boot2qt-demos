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

#include <QtQml/QQmlExtensionPlugin>
#include <QtQml/qqml.h>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>
#include <qdebug.h>

#include "datastore.h"
#include "tripdatamodel.h"
#include "navigation.h"
#include "mapbox.h"
#include "mapboxsuggestions.h"
#include "suggestionsmodel.h"
#include "brightnesscontroller.h"
#include "fpscounter.h"

class QExampleQmlPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:

        void registerTypes(const char *uri)
    {
        Q_UNUSED(uri);
        qmlRegisterType<DataStore>("DataStore", 1, 0, "DataStore");
    }

    void initializeEngine(QQmlEngine *engine, const char *uri)
    {
       Q_UNUSED(uri);

       // Setup data store for connection to backend server
       DataStore *datastore = new DataStore(engine);
       datastore->connectToServer("datasocket");

       // Setup mapbox and suggestions
       MapBox *mapbox = new MapBox(engine);
       MapBoxSuggestions *suggest = new MapBoxSuggestions(mapbox, engine);

       // Setup navigation container
       Navigation *navi = new Navigation(mapbox, engine);

       // Brightness controller
       BrightnessController *brightness = new BrightnessController(engine);

       // FPS counter
       FpsCounter *fps = new FpsCounter(engine);

       QQmlContext *context = engine->rootContext();
       context->setContextProperty("datastore", datastore);
       context->setContextProperty("tripdata", datastore->tripDataModel());
       context->setContextProperty("navigation", navi);
       context->setContextProperty("suggest", suggest);
       context->setContextProperty("suggestions", suggest->suggestions());
       context->setContextProperty("brightness", brightness);
       context->setContextProperty("fps", fps);
    }
};


#include "plugin.moc"
