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

#include <QtTest>

#include "appparser.h"

class tst_AppParser : public QObject {
    Q_OBJECT

private Q_SLOTS:
    void testValidVersion1_data();
    void testValidVersion1();

    void testInvalid_data();
    void testInvalid();

    void testFileOpen();
};


void tst_AppParser::testValidVersion1_data()
{
    QTest::addColumn<QByteArray>("input");
    QTest::addColumn<QString>("icon");
    QTest::addColumn<QString>("name");
    QTest::addColumn<QString>("exec");
    QTest::addColumn<QString>("path");

    QTest::addRow("clock")
        << QByteArray("{\"Type\":\"Application\", \"Version\":1, \"Icon\":\"icon\", \"Name\":\"Clocks\",\"Exec\":\"clocks\"}")
        << QStringLiteral("icon") << QStringLiteral("Clocks") << QStringLiteral("clocks") << QString();
    QTest::addRow("path")
        << QByteArray("{\"Type\":\"Application\", \"Version\":1, \"Icon\":\"icon\", \"Name\":\"Clocks\",\"Exec\":\"clocks\",\"Path\":\"P\"}")
        << QStringLiteral("icon") << QStringLiteral("Clocks") << QStringLiteral("clocks") << QStringLiteral("P");
}

void tst_AppParser::testValidVersion1()
{
    QFETCH(QByteArray, input);
    QFETCH(QString, icon);
    QFETCH(QString, name);
    QFETCH(QString, exec);
    QFETCH(QString, path);

    bool ok = false;
    auto entry = AppParser::parseData(input, QStringLiteral("dummy"), &ok);
    QVERIFY(ok);
}

void tst_AppParser::testInvalid_data()
{
    QTest::addColumn<QByteArray>("input");
    QTest::addRow("no json") << QByteArray("12345");
    QTest::addRow("array") << QByteArray("[]");
    QTest::addRow("no content") << QByteArray("{}");
    QTest::addRow("empty") << QByteArray("");
}

void tst_AppParser::testInvalid()
{
    QFETCH(QByteArray, input);

    bool ok = true;
    AppParser::parseData(input, QStringLiteral("dummy"), &ok);
    QVERIFY(!ok);
}

void tst_AppParser::testFileOpen()
{
    bool ok = true;

    AppParser::parseFile(":/can_not_exist_here.json", &ok);
    QVERIFY(!ok);

    ok = false;
    auto entry = AppParser::parseFile(":/app.json", &ok);
    QVERIFY(ok);
    QCOMPARE(entry.iconName, QStringLiteral("qrc:/images/Icon_Clocks.png"));
    QCOMPARE(entry.appName, QStringLiteral("Clocks"));
    QCOMPARE(entry.executableName, QStringLiteral("clocks"));
    QCOMPARE(entry.executablePath, QStringLiteral("./"));

    // Look at extensions
    QVERIFY(entry.extensions["X-Fullscreen"].canConvert(QMetaType::Bool));
    QCOMPARE(entry.extensions["X-Fullscreen"].toBool(), true);
    QVERIFY(entry.extensions["X-Priority"].canConvert(QMetaType::Double));
    QCOMPARE(entry.extensions["X-Priority"].toInt(), 100);
    QVERIFY(entry.extensions["X-Screen"].canConvert(QMetaType::QString));
    QCOMPARE(entry.extensions["X-Screen"].toString(), QStringLiteral("left"));
}

QTEST_MAIN(tst_AppParser)
#include "tst_appparser.moc"
