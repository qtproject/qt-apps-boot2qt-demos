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
