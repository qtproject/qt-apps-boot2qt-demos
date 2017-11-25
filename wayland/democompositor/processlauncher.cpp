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

#include "processlauncher.h"
#include "apps/appentry.h"

#include <QProcess>
#include <QTimer>

Q_LOGGING_CATEGORY(procs, "launcher.procs")

/*
 * Two AppState's are equal if they are managing the same
 * QProcess. It is assumed that no AppState survives beyond
 * the QProcess.
 */
bool operator==(const AppState& lhs, const AppState& rhs)
{
    return lhs.process == rhs.process;
}

WaylandProcessLauncher::WaylandProcessLauncher(QObject *parent)
    : QObject(parent)
{
}

WaylandProcessLauncher::~WaylandProcessLauncher()
{
    for (auto state : m_appStates) {
        state.process->disconnect(state.finishedConn);
        state.process->disconnect(state.errorOccurredConn);
        state.process->disconnect(state.startedConn);
        delete state.process;
    }
    m_appStates.clear();
}

QVariant WaylandProcessLauncher::appStateForPid(int pid) const
{
    for (auto state : m_appStates) {
        if (state.process->pid() == pid) {
            qCDebug(procs) << "Found state for" << pid << state.appEntry.executableName;
            return QVariant::fromValue(state);
        }
    }

    qCDebug(procs) << "Couldn't find entry for" << pid;
    return QVariant();
}

bool WaylandProcessLauncher::isRunning(const AppEntry& entry) const
{
    for (auto state : m_appStates) {
        if (state.appEntry.sourceFileName == entry.sourceFileName) {
            qCDebug(procs) << "AppEntry associated to a state" << entry.executableName;
            return true;
        }
    }

    qCDebug(procs) << "AppEntry not associated to a state " << entry.executableName;
    return false;
}

void WaylandProcessLauncher::kill(const AppEntry& entry)
{
    for (auto state : m_appStates) {
        if (state.appEntry.sourceFileName != entry.sourceFileName)
            continue;

        qCDebug(procs) << "Killing process " << state.process->pid() << " for " << entry.sourceFileName;
        state.process->kill();
    }
}

void WaylandProcessLauncher::stop(const AppEntry& entry, int ms)
{
    for (auto state : m_appStates) {
        if (state.appEntry.sourceFileName != entry.sourceFileName)
            continue;

        auto timer = new QTimer(state.process);
        connect(timer, &QTimer::timeout, [entry, state, timer] {
            qCDebug(procs) << "Sending SIGKILL " << state.process->pid() << " for " << entry.sourceFileName;
            timer->deleteLater();
            state.process->kill();
        });
        timer->start(ms);
        qCDebug(procs) << "Sending SIGTERM " << state.process->pid() << " for " << entry.sourceFileName;
        state.process->terminate();
    }
}

void WaylandProcessLauncher::launch(const AppEntry &entry)
{
    qCDebug(procs) << "Launching" << entry.executableName;

    QProcess *process = new QProcess(this);
    process->setProcessChannelMode(QProcess::ForwardedChannels);

    QMetaObject::Connection conn;
    AppState state{process, entry, conn, conn, conn};
    m_appStates.push_back(state);

    /* handle potential errors and life cycle */
    state.finishedConn = connect(process, static_cast<void(QProcess::*)(int, QProcess::ExitStatus)>(&QProcess::finished),
            [state, this](int exitCode, QProcess::ExitStatus status) {
                qCDebug(procs) << "AppEntry finished" << state.appEntry.executableName << exitCode << status;
                emit appFinished(state, exitCode, status);
                m_appStates.removeOne(state);
                state.process->deleteLater();
    });
    state.errorOccurredConn = connect(process, &QProcess::errorOccurred,
            [state, this](QProcess::ProcessError err) {
                qCDebug(procs) << "AppEntry error occurred" << state.appEntry.executableName << err;

                /* Maybe finished was already emitted. Let's not emit an error after that */
                if (!m_appStates.removeOne(state))
                    return;

                if (err == QProcess::FailedToStart || err == QProcess::UnknownError)
                    emit appNotStarted(state);
                state.process->deleteLater();
    });
    state.startedConn = connect(process, &QProcess::started,
            [state, this]() {
                qCDebug(procs) << "AppEntry started" << state.appEntry.executableName;
                emit appStarted(state);
    });

    if (!entry.executablePath.isNull()) {
        auto env = QProcessEnvironment::systemEnvironment();
        env.insert(QStringLiteral("PATH"), entry.executablePath);
        process->setProcessEnvironment(env);
    }

    QStringList arguments;
    arguments << "-platform" << "wayland";
    process->start(entry.executableName, arguments);
}
