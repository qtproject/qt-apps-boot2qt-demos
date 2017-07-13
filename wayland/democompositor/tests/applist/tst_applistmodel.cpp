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

#include "applistmodel.h"
#include "appentry.h"

#include <QtCore/QVariant>

#include <QtTest>

class tst_AppListModel : public QObject {
    Q_OBJECT

private Q_SLOTS:
    void testNoDuplicates();
    void testRoles();
};

void tst_AppListModel::testNoDuplicates()
{
    AppListModel model;
    QCOMPARE(model.rowCount(QModelIndex()), 0);
    model.addFile(":/app1.json");
    QCOMPARE(model.rowCount(QModelIndex()), 1);
    model.addFile(":/app2.json");
    QCOMPARE(model.rowCount(QModelIndex()), 2);
    model.addFile(":/app1.json");
    QCOMPARE(model.rowCount(QModelIndex()), 2);
    model.addFile(":/app2.json");
}

void tst_AppListModel::testRoles()
{
    AppListModel model;
    model.addFile(":/app1.json");

    auto idx = model.index(1, 0);
    QVERIFY(!idx.isValid());
    idx = model.index(0, 0);
    QVERIFY(idx.isValid());

    /* Check we get a full AppEntry back */
    auto var = idx.data(AppListModel::App);
    QVERIFY(var.canConvert<AppEntry>());
    auto app = var.value<AppEntry>();
    QCOMPARE(app.sourceFileName, QStringLiteral(":/app1.json"));

    var = idx.data(AppListModel::IconName);
    QCOMPARE(var.toString(), QStringLiteral("qrc:/images/Icon_Clocks.png"));
    var = idx.data(AppListModel::ApplicationName);
    QCOMPARE(var.toString(), QStringLiteral("Clocks"));
    var = idx.data(AppListModel::ExeuctableName);
    QCOMPARE(var.toString(), QStringLiteral("clocks"));
    var = idx.data(AppListModel::ExecutablePath);
    QCOMPARE(var.toString(), QStringLiteral("./"));
    var = idx.data(AppListModel::SourceFileName);
    QCOMPARE(var.toString(), QStringLiteral(":/app1.json"));
}

QTEST_MAIN(tst_AppListModel)
#include "tst_applistmodel.moc"
