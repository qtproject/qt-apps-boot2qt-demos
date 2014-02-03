/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://qt.digia.com/
**
** This file is part of the examples of the Qt Enterprise Embedded.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
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
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
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
#ifndef CAMERAUTILS_H
#define CAMERAUTILS_H

#include <QObject>
#include <QVariant>

class QCamera;

class CameraSettingsValue : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged)

public:
    CameraSettingsValue(const QString &n, const QVariant &v)
        : QObject()
        , m_name(n)
        , m_value(v)
    { }

    QString name() const { return m_name; }
    void setName(const QString &n) { m_name = n; emit nameChanged(); }

    QVariant value() const { return m_value; }
    void setValue(const QVariant &v) { m_value = v; emit valueChanged(); }

Q_SIGNALS:
    void nameChanged();
    void valueChanged();

private:
    QString m_name;
    QVariant m_value;
};

QDebug operator<<(QDebug, const CameraSettingsValue &);

class CameraUtils : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> supportedCaptureResolutions READ supportedCaptureResolutions NOTIFY supportedCaptureResolutionsChanged)
    Q_PROPERTY(QList<QObject*> supportedWhiteBalanceModes READ supportedWhiteBalanceModes NOTIFY supportedWhiteBalanceModesChanged)
    Q_PROPERTY(QList<QObject*> supportedSceneModes READ supportedSceneModes NOTIFY supportedSceneModesChanged)
    Q_PROPERTY(QList<QObject*> supportedFlashModes READ supportedFlashModes NOTIFY supportedFlashModesChanged)
    Q_PROPERTY(QList<QObject*> supportedFocusModes READ supportedFocusModes NOTIFY supportedFocusModesChanged)
    Q_PROPERTY(QList<QObject*> supportedVideoResolutions READ supportedVideoResolutions NOTIFY supportedVideoResolutionsChanged)
public:
    explicit CameraUtils(QObject *parent = 0);
    ~CameraUtils();

    Q_INVOKABLE void init();
    Q_INVOKABLE void setCamera(QObject *cam);

    QList<QObject*> supportedCaptureResolutions() const { return m_supportedResolutions; }
    QList<QObject*> supportedVideoResolutions() const { return m_supportedVideoResolutions; }
    QList<QObject*> supportedWhiteBalanceModes() const { return m_supportedWhiteBalanceModes; }
    QList<QObject*> supportedSceneModes() const { return m_supportedSceneModes; }
    QList<QObject*> supportedFlashModes() const { return m_supportedFlashModes; }
    QList<QObject*> supportedFocusModes() const { return m_supportedFocusModes; }

Q_SIGNALS:
    void supportedCaptureResolutionsChanged();
    void supportedWhiteBalanceModesChanged();
    void supportedSceneModesChanged();
    void supportedFlashModesChanged();
    void supportedFocusModesChanged();
    void supportedVideoResolutionsChanged();

    void done();

private Q_SLOTS:
    void onCameraStatusChanged();
    void onError();

private:
    QCamera *m_camera;

    QList<QObject*> m_supportedResolutions;
    QList<QObject*> m_supportedVideoResolutions;
    QList<QObject*> m_supportedWhiteBalanceModes;
    QList<QObject*> m_supportedSceneModes;
    QList<QObject*> m_supportedFlashModes;
    QList<QObject*> m_supportedFocusModes;
};

#endif // CAMERAUTILS_H
