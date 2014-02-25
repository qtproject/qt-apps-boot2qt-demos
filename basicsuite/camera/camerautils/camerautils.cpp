/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
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
#include "camerautils.h"

#include <QCamera>
#include <QCameraImageCapture>
#include <QCameraImageProcessing>
#include <QCameraExposure>
#include <QCameraFocus>
#include <QMediaRecorder>

static QList<CameraSettingsValue*> g_commonResolutions;
static QList<CameraSettingsValue*> g_commonVideoResolutions;
static QList<CameraSettingsValue*> g_whiteBalanceModes;
static QList<CameraSettingsValue*> g_sceneModes;
static QList<CameraSettingsValue*> g_flashModes;
static QList<CameraSettingsValue*> g_focusModes;

QDebug operator<<(QDebug dbg, const CameraSettingsValue &r) {
    dbg.nospace() << "CameraSettingsValue(" << r.name() << ", " << r.value() << ')';
    return dbg.space();
}

CameraUtils::CameraUtils(QObject *parent)
    : QObject(parent)
    , m_camera(0)
{
    if (g_commonResolutions.isEmpty()) {
        g_commonResolutions << new CameraSettingsValue(QStringLiteral("QVGA"), QSize(320, 240))
                            << new CameraSettingsValue(QStringLiteral("0.3M"), QSize(640, 480))
                            << new CameraSettingsValue(QStringLiteral("0.8M"), QSize(1024, 768))
                            << new CameraSettingsValue(QStringLiteral("1.2M"), QSize(1280, 960))
                            << new CameraSettingsValue(QStringLiteral("2M"), QSize(1600, 1200))
                            << new CameraSettingsValue(QStringLiteral("5M"), QSize(2560, 1920))
                            << new CameraSettingsValue(QStringLiteral("8M"), QSize(3264, 2448));

        g_commonVideoResolutions << new CameraSettingsValue(QStringLiteral("1080p (16:9)"), QSize(1920, 1080))
                                 << new CameraSettingsValue(QStringLiteral("1080p (16:9)"), QSize(1920, 1088))
                                 << new CameraSettingsValue(QStringLiteral("1080p (4:3)"), QSize(1440, 1080))
                                 << new CameraSettingsValue(QStringLiteral("1080p (4:3)"), QSize(1440, 1088))
                                 << new CameraSettingsValue(QStringLiteral("720p (16:9)"), QSize(1280, 720))
                                 << new CameraSettingsValue(QStringLiteral("720p (4:3)"), QSize(960, 720))
                                 << new CameraSettingsValue(QStringLiteral("480p (16:9)"), QSize(720, 480))
                                 << new CameraSettingsValue(QStringLiteral("480p (4:3)"), QSize(640, 480))
                                 << new CameraSettingsValue(QStringLiteral("QVGA"), QSize(320, 240));

        g_whiteBalanceModes << new CameraSettingsValue(QStringLiteral("Auto"), QCameraImageProcessing::WhiteBalanceAuto)
                            << new CameraSettingsValue(QStringLiteral("Manual"), QCameraImageProcessing::WhiteBalanceManual)
                            << new CameraSettingsValue(QStringLiteral("Sunlight"), QCameraImageProcessing::WhiteBalanceSunlight)
                            << new CameraSettingsValue(QStringLiteral("Cloudy"), QCameraImageProcessing::WhiteBalanceCloudy)
                            << new CameraSettingsValue(QStringLiteral("Shade"), QCameraImageProcessing::WhiteBalanceShade)
                            << new CameraSettingsValue(QStringLiteral("Tungsten"), QCameraImageProcessing::WhiteBalanceTungsten)
                            << new CameraSettingsValue(QStringLiteral("Fluorescent"), QCameraImageProcessing::WhiteBalanceFluorescent)
                            << new CameraSettingsValue(QStringLiteral("Flash"), QCameraImageProcessing::WhiteBalanceFlash)
                            << new CameraSettingsValue(QStringLiteral("Sunset"), QCameraImageProcessing::WhiteBalanceSunset);

        g_sceneModes << new CameraSettingsValue(QStringLiteral("Auto"), QCameraExposure::ExposureAuto)
                     << new CameraSettingsValue(QStringLiteral("Manual"), QCameraExposure::ExposureManual)
                     << new CameraSettingsValue(QStringLiteral("Portrait"), QCameraExposure::ExposurePortrait)
                     << new CameraSettingsValue(QStringLiteral("Night"), QCameraExposure::ExposureNight)
                     << new CameraSettingsValue(QStringLiteral("Backlight"), QCameraExposure::ExposureBacklight)
                     << new CameraSettingsValue(QStringLiteral("Spotlight"), QCameraExposure::ExposureSpotlight)
                     << new CameraSettingsValue(QStringLiteral("Sports"), QCameraExposure::ExposureSports)
                     << new CameraSettingsValue(QStringLiteral("Snow"), QCameraExposure::ExposureSnow)
                     << new CameraSettingsValue(QStringLiteral("Beach"), QCameraExposure::ExposureBeach)
                     << new CameraSettingsValue(QStringLiteral("Large Aperture"), QCameraExposure::ExposureLargeAperture)
                     << new CameraSettingsValue(QStringLiteral("Small Aperture"), QCameraExposure::ExposureSmallAperture);

        g_flashModes << new CameraSettingsValue(QStringLiteral("Auto"), QCameraExposure::FlashAuto)
                     << new CameraSettingsValue(QStringLiteral("Off"), QCameraExposure::FlashOff)
                     << new CameraSettingsValue(QStringLiteral("On"), QCameraExposure::FlashOn)
                     << new CameraSettingsValue(QStringLiteral("Red-Eye"), QCameraExposure::FlashRedEyeReduction)
                     << new CameraSettingsValue(QStringLiteral("Torch"), QCameraExposure::FlashVideoLight);

        g_focusModes << new CameraSettingsValue(QStringLiteral("Auto"), QCameraFocus::AutoFocus)
                     << new CameraSettingsValue(QStringLiteral("Continuous"), QCameraFocus::ContinuousFocus)
                     << new CameraSettingsValue(QStringLiteral("Hyperfocal"), QCameraFocus::HyperfocalFocus)
                     << new CameraSettingsValue(QStringLiteral("Infinity"), QCameraFocus::InfinityFocus)
                     << new CameraSettingsValue(QStringLiteral("Macro"), QCameraFocus::MacroFocus)
                     << new CameraSettingsValue(QStringLiteral("Off"), QCameraFocus::ManualFocus);
    }

}

CameraUtils::~CameraUtils()
{
}

void CameraUtils::init()
{
    m_camera = new QCamera;
    connect(m_camera, SIGNAL(statusChanged(QCamera::Status)), this, SLOT(onCameraStatusChanged()));
    connect(m_camera, SIGNAL(error(QCamera::Error)), this, SLOT(onError()));
    m_camera->load();
}

void CameraUtils::setCamera(QObject *obj)
{
    QObject *mediaObject = qvariant_cast<QObject*>(obj->property("mediaObject"));
    if (!mediaObject)
        return;

    m_camera = qobject_cast<QCamera*>(mediaObject);
    if (!m_camera)
        return;

    if (m_camera->status() >= QCamera::LoadedStatus)
        onCameraStatusChanged();
    else
        connect(m_camera, SIGNAL(statusChanged(QCamera::Status)), this, SLOT(onCameraStatusChanged()));
}

void CameraUtils::onError()
{
    if (m_camera && m_camera->status() == QCamera::UnavailableStatus) {
        delete m_camera;
        m_camera = 0;

        emit done();
    }
}

void CameraUtils::onCameraStatusChanged()
{
    if (!m_camera || m_camera->status() < QCamera::LoadedStatus)
        return;

    disconnect(m_camera, SIGNAL(statusChanged(QCamera::Status)), this, SLOT(onCameraStatusChanged()));

    QCameraImageCapture *imageCapture = new QCameraImageCapture(m_camera);
    QCameraImageProcessing *imageProc = m_camera->imageProcessing();
    QCameraExposure *exposure = m_camera->exposure();
    QCameraFocus *focus = m_camera->focus();
    QMediaRecorder rec(m_camera);

    // Supported image resolutions
    QList<QSize> resolutions = imageCapture->supportedResolutions();
    for (int i = resolutions.size() - 1; i >= 0; --i) {
        QSize reso = resolutions.at(i);
        int mp = reso.width() * reso.height();
        CameraSettingsValue *r = new CameraSettingsValue(QString::number(mp / double(1000000), 'f', 1) + QLatin1String("M"), reso);
        m_supportedResolutions.append(r);
    }

    // Supported video resolutions
    QList<QSize> suppRes = rec.supportedResolutions();
    for (int i = 0; i < g_commonVideoResolutions.size(); ++i) {
        CameraSettingsValue *r = g_commonVideoResolutions.at(i);
        if (suppRes.contains(r->value().toSize()))
            m_supportedVideoResolutions.append(r);
    }


    // Supported white balance modes
    for (int i = 0; i < g_whiteBalanceModes.size(); ++i) {
        CameraSettingsValue *m = g_whiteBalanceModes.at(i);
        if (imageProc->isWhiteBalanceModeSupported(QCameraImageProcessing::WhiteBalanceMode(m->value().toInt())))
            m_supportedWhiteBalanceModes.append(m);
    }

    // Supported scene modes
    for (int i = 0; i < g_sceneModes.size(); ++i) {
        CameraSettingsValue *sm = g_sceneModes.at(i);
        if (exposure->isExposureModeSupported(QCameraExposure::ExposureMode(sm->value().toInt())))
            m_supportedSceneModes.append(sm);
    }

    // Supported flash modes
    for (int i = 0; i < g_flashModes.size(); ++i) {
        CameraSettingsValue *sm = g_flashModes.at(i);
        if (exposure->isFlashModeSupported(QCameraExposure::FlashModes(sm->value().toInt())))
            m_supportedFlashModes.append(sm);
    }

    // Supported focus modes
    for (int i = 0; i < g_focusModes.size(); ++i) {
        CameraSettingsValue *sm = g_focusModes.at(i);
        if (focus->isFocusModeSupported(QCameraFocus::FocusModes(sm->value().toInt())))
            m_supportedFocusModes.append(sm);
    }

    delete imageCapture;

    emit supportedCaptureResolutionsChanged();
    emit supportedVideoResolutionsChanged();
    emit supportedWhiteBalanceModesChanged();
    emit supportedSceneModesChanged();
    emit supportedFlashModesChanged();
}


