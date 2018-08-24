/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the E-Bike demo project.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include <QSocketNotifier>
#include <signal.h>
#include <sys/socket.h>
#include <unistd.h>
#include "unixsignalhandler.h"

int UnixSignalHandler::sigintFd[2] = {0};
int UnixSignalHandler::sighupFd[2] = {0};
int UnixSignalHandler::sigtermFd[2] = {0};

UnixSignalHandler::UnixSignalHandler(QObject *parent)
    : QObject(parent)
{
    if (::socketpair(AF_UNIX, SOCK_STREAM, 0, sigintFd))
       qFatal("Couldn't create INT socketpair");

    if (::socketpair(AF_UNIX, SOCK_STREAM, 0, sighupFd))
       qFatal("Couldn't create HUP socketpair");

    if (::socketpair(AF_UNIX, SOCK_STREAM, 0, sigtermFd))
       qFatal("Couldn't create TERM socketpair");

    m_sigintNotifier = new QSocketNotifier(sigintFd[1], QSocketNotifier::Read, this);
    connect(m_sigintNotifier, &QSocketNotifier::activated,
            this, &UnixSignalHandler::handleSigInt);
    m_sighupNotifier = new QSocketNotifier(sighupFd[1], QSocketNotifier::Read, this);
    connect(m_sighupNotifier, &QSocketNotifier::activated,
            this, &UnixSignalHandler::handleSigHup);
    m_sigtermNotifier = new QSocketNotifier(sigtermFd[1], QSocketNotifier::Read, this);
    connect(m_sigtermNotifier, &QSocketNotifier::activated,
            this, &UnixSignalHandler::handleSigTerm);
}

int UnixSignalHandler::setupSignalHandlers()
{
    struct sigaction sig_int, sig_hup, sig_term;

    sig_int.sa_handler = UnixSignalHandler::sigIntHandler;
    sigemptyset(&sig_int.sa_mask);
    sig_int.sa_flags = 0;
    sig_int.sa_flags |= SA_RESTART;

    if (sigaction(SIGINT, &sig_int, 0))
       return 1;

    sig_hup.sa_handler = UnixSignalHandler::sigHupHandler;
    sigemptyset(&sig_hup.sa_mask);
    sig_hup.sa_flags = 0;
    sig_hup.sa_flags |= SA_RESTART;

    if (sigaction(SIGHUP, &sig_hup, 0))
       return 2;

    sig_term.sa_handler = UnixSignalHandler::sigTermHandler;
    sigemptyset(&sig_term.sa_mask);
    sig_term.sa_flags |= SA_RESTART;

    if (sigaction(SIGTERM, &sig_term, 0))
       return 3;

    return 0;
}

void UnixSignalHandler::sigIntHandler(int)
{
    char a = 1;
    ::write(sigintFd[0], &a, sizeof(a));
}

void UnixSignalHandler::sigHupHandler(int)
{
    char a = 1;
    ::write(sighupFd[0], &a, sizeof(a));
}

void UnixSignalHandler::sigTermHandler(int)
{
    char a = 1;
    ::write(sigtermFd[0], &a, sizeof(a));
}

void UnixSignalHandler::handleSigInt()
{
    m_sigintNotifier->setEnabled(false);
    char tmp;
    ::read(sigintFd[1], &tmp, sizeof(tmp));

    emit sigInt();

    m_sigintNotifier->setEnabled(true);
}

void UnixSignalHandler::handleSigHup()
{
    m_sighupNotifier->setEnabled(false);
    char tmp;
    ::read(sighupFd[1], &tmp, sizeof(tmp));

    emit sigHup();

    m_sighupNotifier->setEnabled(true);
}

void UnixSignalHandler::handleSigTerm()
{
    m_sigtermNotifier->setEnabled(false);
    char tmp;
    ::read(sigtermFd[1], &tmp, sizeof(tmp));

    emit sigTerm();

    m_sigtermNotifier->setEnabled(true);
}
