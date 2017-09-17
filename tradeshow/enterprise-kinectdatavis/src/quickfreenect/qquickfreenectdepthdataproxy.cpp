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
#include "qquickfreenectdepthdataproxy.h"

#include "libfreenect.h"

QQuickFreenectDepthDataProxy::QQuickFreenectDepthDataProxy()
    : m_backend(QQuickFreenectBackend::instance())
{
    connect(m_backend.get(), SIGNAL(depthFrameReady()), SLOT(updateData()));
    connect(this, SIGNAL(highClipChanged()), SLOT(updateData()));

    m_dataArray = new QtDataVisualization::QSurfaceDataArray;
    m_dataArray->reserve(height);
    for (int y = 0; y < height; ++y)
        m_dataArray->append(new QtDataVisualization::QSurfaceDataRow(width));
    resetArray(m_dataArray);
    m_backend->requestDepthStreamEnabled();
}

void QQuickFreenectDepthDataProxy::updateData()
{
    unsigned frameId = m_backend->depthFrameId();
    if (m_lastUpdateFrameId == frameId)
        return;

    uint16_t *buffer = m_backend->depthBuffer();
    QSize bufferSize = m_backend->depthBufferSize();
    int widthRatio = bufferSize.width() / width;
    int heightRatio = bufferSize.height() / height;
    for (int y = 0; y < height; ++y) {
        auto proxyRow = (*m_dataArray)[y];
        for (int x = 0; x < width; ++x) {
            uint16_t data = buffer[(height - 1 - y)*widthRatio * bufferSize.width() + x*heightRatio];
            data = std::min(m_highClip, data != FREENECT_DEPTH_RAW_NO_VALUE ? FREENECT_DEPTH_RAW_MAX_VALUE - data : 0);
            (*proxyRow)[x].setPosition(QVector3D(x, data, y));
        }
    }
    resetArray(m_dataArray);
    m_lastUpdateFrameId = frameId;
}
