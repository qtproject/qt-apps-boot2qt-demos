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
#ifndef QQUICKFREENECTSTATE_H
#define QQUICKFREENECTSTATE_H

#include "qquickfreenectbackend.h"

#include <QObject>
#include <QVector3D>

class QQuickFreenectState : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVector3D accelVector READ accelVector NOTIFY accelVectorChanged)
    Q_PROPERTY(double motorTilt READ motorTilt WRITE setMotorTilt NOTIFY motorTiltChanged)
    Q_PROPERTY(qreal minMotorTilt READ minMotorTilt CONSTANT)
    Q_PROPERTY(qreal maxMotorTilt READ maxMotorTilt CONSTANT)
    Q_PROPERTY(QString errorString READ errorString NOTIFY errorStringChanged)

public:
    QQuickFreenectState()
        : m_backend(QQuickFreenectBackend::instance()) {
        connect(m_backend.get(), SIGNAL(accelVectorValue(const QVector3D&)), SLOT(updateAccelVector(const QVector3D&)));
        connect(m_backend.get(), SIGNAL(errorStringValue(const QString&)), SLOT(updateErrorString(const QString&)));
    }

    QVector3D accelVector() const { return m_accelVector; }

    void setMotorTilt(double motorTilt) {
        QQuickFreenectBackend::instance()->requestTiltDegrees(motorTilt);
        m_motorTilt = motorTilt;
        emit motorTiltChanged();
    }
    bool motorTilt() const { return m_motorTilt; }
    QString errorString() const { return m_errorString; }
    qreal minMotorTilt() const { return -30; }
    qreal maxMotorTilt() const { return 30; }

signals:
    void accelVectorChanged();
    void motorTiltChanged();
    void errorStringChanged();

private slots:
    void updateAccelVector(const QVector3D &accelVector) {
        m_accelVector = accelVector;
        emit accelVectorChanged();
    }
    void updateErrorString(const QString &errorString) {
        m_errorString = errorString;
        emit errorStringChanged();
    }

private:
    std::shared_ptr<QQuickFreenectBackend> m_backend;
    QVector3D m_accelVector{0, 1, 0};
    double m_motorTilt;
    QString m_errorString;
};

#endif
