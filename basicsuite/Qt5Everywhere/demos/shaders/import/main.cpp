#include <QtQml/QQmlExtensionPlugin>
#include <QtQml/QtQml>
#include "shaderfilereader.h"

QT_BEGIN_NAMESPACE

class SensorExplorerDeclarativeModule : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface" FILE "plugin.json")
public:
    virtual void registerTypes(const char *uri)
    {
        Q_ASSERT(QLatin1String(uri) == QLatin1String("ShaderReader"));
        qmlRegisterType<ShaderFileReader>(uri, 1, 0, "ShaderFileReader");
    }
};

QT_END_NAMESPACE

#include "main.moc"

