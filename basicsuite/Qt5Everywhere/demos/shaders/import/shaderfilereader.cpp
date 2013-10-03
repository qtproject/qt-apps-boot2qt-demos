#include "shaderfilereader.h"
#include <QtCore/QFile>
#include <QtCore/QTextStream>

ShaderFileReader::ShaderFileReader(QObject* parent)
    : QObject(parent)
{
    if (qEnvironmentVariableIsEmpty("QT_SHADER_PATH"))
        setenv("QT_SHADER_PATH", "/data/user/qt/Qt5Everywhere/demos/shaders/",1);
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

