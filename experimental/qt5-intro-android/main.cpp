#include <QtGui>
#include <QtQuick>

QtMessageHandler oldMessageHandler = 0;
void messageHandler(QtMsgType type, const QMessageLogContext &ctx, const QString &msg)
{
    if (type == QtCriticalMsg || type == QtFatalMsg)
        oldMessageHandler(type, ctx, msg);
}

int main(int argc, char **argv)
{
#if defined(QT_NO_DEBUG)
    oldMessageHandler = qInstallMessageHandler(messageHandler);
#endif

    QGuiApplication app(argc, argv);

    QString videoPath = QStandardPaths::writableLocation(QStandardPaths::MoviesLocation);
    if (!QFile::exists(videoPath + QLatin1String("/Qt5_Animation_small.mp4"))) {
        QDir().mkpath(videoPath);
        if (!QFile::copy(QLatin1String("assets:/video/Qt5_Animation_small.mp4"), videoPath + QLatin1String("/Qt5_Animation_small.mp4")))
            qWarning("main: Couldn't copy video.");
    }

    QQuickView view;
    view.engine()->rootContext()->setContextProperty("videoPath", QLatin1String("file://") + videoPath + QLatin1String("/Qt5_Animation_small.mp4"));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl("qrc:/main.qml"));
    view.show();

    return app.exec();
}
