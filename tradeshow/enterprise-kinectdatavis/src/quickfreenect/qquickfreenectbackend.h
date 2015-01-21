/****************************************************************************
**
** Copyright (C) 2015 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://www.qt.io
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
#ifndef QQUICKFREENECTBACKEND_H
#define QQUICKFREENECTBACKEND_H

#include "qquickfreenectvideooutput.h"

#include <QMutex>
#include <QSize>
#include <QThread>
#include <memory>

class QVector3D;
struct _freenect_context;
typedef struct _freenect_context freenect_context;
struct _freenect_device;
typedef struct _freenect_device freenect_device;

class QQuickFreenectBackend : public QThread {
    Q_OBJECT
public:
    static std::shared_ptr<QQuickFreenectBackend> instance();
    ~QQuickFreenectBackend();

    void requestTiltDegrees(double degrees) { m_requestedTiltDegrees = degrees; }
    void requestDepthStreamEnabled() { m_requestedDepthStreamEnabled = true; }
    void requestVideoStreamType(QQuickFreenectVideoOutput::StreamType type) { m_requestedVideoStream = type; }
    unsigned depthFrameId() const { return m_depthFrameId; }
    QQuickFreenectVideoOutput::StreamType requestedVideoStreamType() const { return m_requestedVideoStream; }

    QSize depthBufferSize() const { return {640, 480}; }
    uint16_t *depthBuffer() { return m_depthBuffer; }
    QQuickFreenectVideoOutput::StreamType videoFrontBufferStreamType() const { return m_currentVideoStream; }
    uint8_t *pickVideoFrontBuffer();

    void run() override;

signals:
    void videoFrameReady();
    void depthFrameReady();
    void accelVectorValue(const QVector3D&);
    void errorStringValue(const QString&);

private:
    QQuickFreenectBackend();
    static void depth_cb(freenect_device *dev, void *buffer, uint32_t timestamp);
    static void video_cb(freenect_device *dev, void *buffer, uint32_t timestamp);

    uint8_t *m_videoBack = 0;
    uint8_t *m_videoMid = 0;
    uint8_t *m_videoFront = 0;
    uint16_t *m_depthBuffer = 0;
    double m_requestedTiltDegrees = 0;
    double m_currentTiltDegrees = 0;
    bool m_requestedDepthStreamEnabled = false;
    bool m_currentDepthStreamEnabled = false;
    QQuickFreenectVideoOutput::StreamType m_requestedVideoStream = QQuickFreenectVideoOutput::VideoOff;
    QQuickFreenectVideoOutput::StreamType m_currentVideoStream = QQuickFreenectVideoOutput::VideoOff;
    bool m_gotVideoFrame = false;
    bool m_exitRequested = false;
    unsigned m_depthFrameId = 0;
    QMutex m_mutex;
};

#endif
