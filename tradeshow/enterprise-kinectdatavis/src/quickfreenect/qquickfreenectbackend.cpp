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
#include "qquickfreenectbackend.h"

#include <QElapsedTimer>
#include <QVector3D>
#include "libfreenect.h"

static std::weak_ptr<QQuickFreenectBackend> s_instance;

std::shared_ptr<QQuickFreenectBackend> QQuickFreenectBackend::instance()
{
    std::shared_ptr<QQuickFreenectBackend> ret = s_instance.lock();
    if (!ret)
        s_instance = ret = std::shared_ptr<QQuickFreenectBackend>(new QQuickFreenectBackend);
    return ret;
}

QQuickFreenectBackend::QQuickFreenectBackend()
{
    start();
}

QQuickFreenectBackend::~QQuickFreenectBackend()
{
    m_exitRequested = true;
    wait();
    s_instance.reset();
}

uint8_t *QQuickFreenectBackend::pickVideoFrontBuffer()
{
    QMutexLocker lock(&m_mutex);
    if (m_gotVideoFrame) {
        std::swap(m_videoMid, m_videoFront);
        m_gotVideoFrame = false;
        return m_videoFront;
    }
    return 0;
}

void QQuickFreenectBackend::run()
{
    freenect_context *f_ctx;
    freenect_device *f_dev = 0;
    QVector3D accelVectorAccum;
    QVector3D emittedAccelVector;
    QElapsedTimer accelVectorTimer;

    accelVectorTimer.start();

    if (freenect_init(&f_ctx, NULL) < 0) {
        emit errorStringValue(QStringLiteral("Initialization of libfreenect failed, please restart."));
        qWarning("freenect_init() failed");
        return;
    }

#ifndef QT_NO_DEBUG
    freenect_set_log_level(f_ctx, FREENECT_LOG_DEBUG);
#endif
    freenect_select_subdevices(f_ctx, (freenect_device_flags)(FREENECT_DEVICE_MOTOR | FREENECT_DEVICE_CAMERA));

    int numDevices = freenect_num_devices(f_ctx);
    if (!numDevices) {
        emit errorStringValue(QStringLiteral("WARNING!\nNo Kinect detected, waiting for device..."));
        qWarning("WARNING: No Kinect detected, make sure that udev permissions are set properly. See <src/libfreenect/platform/linux/udev/README>.");
    }

    int status = 0;
    while (!m_exitRequested && status >= 0) {
        // Set up the device
        if (!f_dev) {
            if (!(numDevices = freenect_num_devices(f_ctx))) {
                timeval timeout{1, 0};
                status = freenect_process_events_timeout(f_ctx, &timeout);
                continue;
            }

            if (numDevices > 1)
                qWarning("WARNING: More than one Kinect detected, using the first available.");
            if (freenect_open_device(f_ctx, &f_dev, 0) < 0) {
                emit errorStringValue(QStringLiteral("ERROR!\nCould open device. Please restart."));
                freenect_shutdown(f_ctx);
                return;
            }

            freenect_set_user(f_dev, this);
            freenect_set_led(f_dev,LED_RED);
            freenect_set_depth_callback(f_dev, depth_cb);
            freenect_set_video_callback(f_dev, video_cb);
            // Success.
            emit errorStringValue(QString());
        }

        // Set up the depth stream
        if (m_currentDepthStreamEnabled != m_requestedDepthStreamEnabled) {
            if (m_requestedDepthStreamEnabled) {
                freenect_set_depth_mode(f_dev, freenect_find_depth_mode(FREENECT_RESOLUTION_MEDIUM, FREENECT_DEPTH_11BIT));
                m_depthBuffer = (uint16_t*)malloc(freenect_find_depth_mode(FREENECT_RESOLUTION_MEDIUM, FREENECT_DEPTH_11BIT).bytes);
                freenect_set_depth_buffer(f_dev, m_depthBuffer);
                freenect_start_depth(f_dev);
            } else {
                freenect_stop_depth(f_dev);
                free(m_depthBuffer);
            }
            m_currentDepthStreamEnabled = m_requestedDepthStreamEnabled;
        }

        // Set up the video stream
        if (m_currentVideoStream != m_requestedVideoStream) {
            freenect_stop_video(f_dev);
            // FIXME: Use YUV or BAYER instead.
            freenect_video_format videoFormat = m_requestedVideoStream == QQuickFreenectVideoOutput::VideoRGB ? FREENECT_VIDEO_RGB : FREENECT_VIDEO_IR_8BIT;
            free(m_videoBack);
            free(m_videoMid);
            free(m_videoFront);
            m_videoBack = (uint8_t*)malloc(freenect_find_video_mode(FREENECT_RESOLUTION_MEDIUM, videoFormat).bytes);
            m_videoMid = (uint8_t*)malloc(freenect_find_video_mode(FREENECT_RESOLUTION_MEDIUM, videoFormat).bytes);
            m_videoFront = (uint8_t*)malloc(freenect_find_video_mode(FREENECT_RESOLUTION_MEDIUM, videoFormat).bytes);
            freenect_set_video_mode(f_dev, freenect_find_video_mode(FREENECT_RESOLUTION_MEDIUM, videoFormat));
            freenect_set_video_buffer(f_dev, m_videoBack);
            freenect_start_video(f_dev);
            m_currentVideoStream = m_requestedVideoStream;
        }

        if (m_requestedTiltDegrees != m_currentTiltDegrees) {
            freenect_set_tilt_degs(f_dev, m_requestedTiltDegrees);
            m_currentTiltDegrees = m_requestedTiltDegrees;
        }

        double dx, dy, dz;
        freenect_update_tilt_state(f_dev);
        freenect_get_mks_accel(freenect_get_tilt_state(f_dev), &dx, &dy, &dz);
        // Weighted average of value updates over the last 100ms to flatten the noise.
        float newVecRatio = std::min(100, (int)accelVectorTimer.elapsed()) / 100.;
        accelVectorAccum = accelVectorAccum * (1. - newVecRatio) + QVector3D(dx, dy, dz) * newVecRatio;
        accelVectorTimer.restart();
        if (accelVectorAccum != emittedAccelVector) {
            emit accelVectorValue(accelVectorAccum);
            emittedAccelVector = accelVectorAccum;
        }

        // New accelerometer values seem to be available every ~5ms, make sure we come back to pick them.
        timeval timeout{0, 5000};
        status = freenect_process_events_timeout(f_ctx, &timeout);
    }

    if (status < 0) {
        emit errorStringValue(QStringLiteral("ERROR!\nCould not read from device."));
        freenect_shutdown(f_ctx);
        return;
    }

    if (f_dev) {
        freenect_stop_depth(f_dev);
        freenect_stop_video(f_dev);
        freenect_set_led(f_dev, LED_BLINK_GREEN);

        freenect_close_device(f_dev);
    }
    freenect_shutdown(f_ctx);
    free(m_videoBack);
    free(m_videoMid);
    free(m_videoFront);
    free(m_depthBuffer);
}

void QQuickFreenectBackend::depth_cb(freenect_device *dev, void *buffer, uint32_t timestamp)
{
    Q_UNUSED(buffer)
    Q_UNUSED(timestamp)
    QQuickFreenectBackend *that = static_cast<QQuickFreenectBackend *>(freenect_get_user(dev));
    ++that->m_depthFrameId;
    emit that->depthFrameReady();
}

void QQuickFreenectBackend::video_cb(freenect_device *dev, void *buffer, uint32_t timestamp)
{
    Q_UNUSED(buffer)
    Q_UNUSED(timestamp)
    QQuickFreenectBackend *that = static_cast<QQuickFreenectBackend *>(freenect_get_user(dev));
    {
        QMutexLocker lock(&that->m_mutex);
        Q_ASSERT(that->m_videoBack == buffer);
        freenect_set_video_buffer(dev, that->m_videoMid);
        std::swap(that->m_videoBack, that->m_videoMid);

        // Don't notify if a stream change was requested
        if (that->m_currentVideoStream == that->m_requestedVideoStream) {
            that->m_gotVideoFrame = true;
            emit that->videoFrameReady();
        }
    }
}
