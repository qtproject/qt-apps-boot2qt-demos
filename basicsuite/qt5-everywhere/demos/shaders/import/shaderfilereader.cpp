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
#include "shaderfilereader.h"
#include <QtCore/QFile>
#include <QtCore/QTextStream>
#include <QtCore/QDir>
#include <QtCore/QDebug>

ShaderFileReader::ShaderFileReader(QObject* parent)
    : QObject(parent)
{
    if (qEnvironmentVariableIsEmpty("QT_SHADER_PATH"))
        setenv("QT_SHADER_PATH", "/data/user/qt/qt5-everywhere/demos/shaders/",1);
    // check if directory contains shader files
    QByteArray shaderPath(qgetenv("QT_SHADER_PATH").append("shaders/"));
    QDir shaderDir(shaderPath);
    if (shaderDir.entryInfoList(QStringList() << "*.fsh").length() < 1)
        qWarning() << "ShaderFileReader: can not find shader files in " << shaderPath;
}

ShaderFileReader::~ShaderFileReader()
{
}

void ShaderFileReader::setFragmentShaderFilename(const QString &name)
{
    m_fragmentShaderFilename = name;
    Q_EMIT fragmentShaderFilenameChanged();
}

void ShaderFileReader::setVertexShaderFilename(const QString &name)
{
    m_vertexShaderFilename = name;
    Q_EMIT vertexShaderFilenameChanged();
}

QString ShaderFileReader::fragmentShader() const
{
    return readShaderFile(m_fragmentShaderFilename);
}

QString ShaderFileReader::vertexShader() const
{
    return readShaderFile(m_vertexShaderFilename);
}

QString ShaderFileReader::readShaderFile(const QString &fileName) const
{
    QString content;
    QString path = qgetenv("QT_SHADER_PATH");
    QFile file(path.append(fileName));
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream stream(&file);
        content = stream.readAll();
        file.close();
    }
    return content;
}

