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
#ifndef QQUICKFREENECTVIDEOOUTPUT_H
#define QQUICKFREENECTVIDEOOUTPUT_H

#include <QQuickItem>
#include <memory>

class QQuickFreenectBackend;

class QQuickFreenectVideoOutput : public QQuickItem {
    Q_OBJECT
    Q_PROPERTY(StreamType streamType READ streamType WRITE setStreamType NOTIFY streamTypeChanged)
    Q_PROPERTY(bool streaming READ isStreaming NOTIFY isStreamingChanged)
    Q_ENUMS(StreamType)

public:
    enum StreamType {
        VideoOff,
        VideoRGB,
        VideoIR
    };
    QQuickFreenectVideoOutput();

    StreamType streamType() const;
    void setStreamType(StreamType type);

    bool isStreaming() const { return m_isStreaming; }

    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *) override;

private slots:
    void onReceivedFrame();

signals:
    void streamTypeChanged();
    void isStreamingChanged();

private:
    std::shared_ptr<QQuickFreenectBackend> m_backend;
    bool m_isStreaming = false;
};

#endif
