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
#include "qquickfreenectvideooutput.h"

#include "qquickfreenectbackend.h"

#include <QQuickWindow>
#include <QSGSimpleTextureNode>
#include <memory>

class TextureOwningNode : public QSGSimpleTextureNode {
    std::unique_ptr<QSGTexture> m_texture;
public:
    TextureOwningNode() {
    }
    void setTexture(QSGTexture *texture) {
        QSGSimpleTextureNode::setTexture(texture);
        m_texture.reset(texture);
    }
};

QQuickFreenectVideoOutput::QQuickFreenectVideoOutput()
    : m_backend(QQuickFreenectBackend::instance())
{
    setFlag(ItemHasContents);
    connect(m_backend.get(), SIGNAL(videoFrameReady()), SLOT(onReceivedFrame()));
    m_backend->requestVideoStreamType(VideoRGB);
}

QQuickFreenectVideoOutput::StreamType QQuickFreenectVideoOutput::streamType() const
{
    return m_backend->requestedVideoStreamType();
}

void QQuickFreenectVideoOutput::setStreamType(StreamType type)
{
    m_backend->requestVideoStreamType(type);
    emit streamTypeChanged();
    m_isStreaming = false;
    emit isStreamingChanged();
}

QSGNode *QQuickFreenectVideoOutput::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *)
{
    StreamType bufferType = m_backend->videoFrontBufferStreamType();
    const QSize textureSize(640, bufferType == VideoRGB ? 480 : 488);
    auto textureNode = static_cast<TextureOwningNode *>(oldNode);
    if (!textureNode) {
        GLuint texId;
        glGenTextures(1, &texId);
        QSGTexture *texture = window()->createTextureFromId(texId, textureSize, QQuickWindow::TextureOwnsGLTexture);

        textureNode = new TextureOwningNode;
        textureNode->setTexture(texture);
    }

    qreal widthRatio = width() / textureSize.width();
    qreal heightRatio = height() / textureSize.height();
    QSizeF nodeSize = QSizeF(textureSize) * std::min(widthRatio, heightRatio);
    textureNode->setRect(QRectF(QPointF((width() - nodeSize.width()) / 2, (height() - nodeSize.height()) / 2), nodeSize));

    if (uint8_t *buffer = m_backend->pickVideoFrontBuffer()) {
        GLint bufferFormat = bufferType == VideoRGB ? GL_RGB : GL_LUMINANCE;
        glBindTexture(GL_TEXTURE_2D, textureNode->texture()->textureId());
        glTexImage2D(GL_TEXTURE_2D, 0, bufferFormat, textureSize.width(), textureSize.height(), 0, bufferFormat, GL_UNSIGNED_BYTE, buffer);
        textureNode->markDirty(QSGNode::DirtyMaterial);
    }

    return textureNode;
}

void QQuickFreenectVideoOutput::onReceivedFrame()
{
    m_isStreaming = true;
    emit isStreamingChanged();
    update();
}
