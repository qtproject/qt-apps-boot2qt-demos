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
#ifndef SHADERFILEREADER_H
#define SHADERFILEREADER_H

#include <QtCore/QObject>
#include <QtCore/QString>

class ShaderFileReader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString fragmentShaderFilename READ fragmentShaderFilename
               WRITE setFragmentShaderFilename NOTIFY fragmentShaderFilenameChanged)
    Q_PROPERTY(QString vertexShaderFilename READ vertexShaderFilename
               WRITE setVertexShaderFilename NOTIFY vertexShaderFilenameChanged)

    Q_PROPERTY(QString fragmentShader READ fragmentShader)
    Q_PROPERTY(QString vertexShader READ vertexShader)

public:
    ShaderFileReader(QObject* parent = 0);
    ~ShaderFileReader();

    void setFragmentShaderFilename(const QString &name);
    void setVertexShaderFilename(const QString &name);
    QString fragmentShaderFilename() const { return m_fragmentShaderFilename; }
    QString vertexShaderFilename() const { return m_vertexShaderFilename; }

    QString fragmentShader() const;
    QString vertexShader() const;

protected:
    QString readShaderFile(const QString &fileName) const;

Q_SIGNALS:
    void fragmentShaderFilenameChanged();
    void vertexShaderFilenameChanged();

private:
    QString m_fragmentShaderFilename;
    QString m_vertexShaderFilename;
};

Q_DECLARE_METATYPE(ShaderFileReader*)

#endif // SHADERFILEREADER_H
