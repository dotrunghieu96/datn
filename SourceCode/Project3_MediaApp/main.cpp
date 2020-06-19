#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "Media/mymediaapp.h"
#include <QDebug>
#include <QQmlContext>
#include <QFileSystemModel>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    MyMediaApp *mediaApp = new MyMediaApp();

    QQmlApplicationEngine engine;

    QFileSystemModel *fileSystemModel = new QFileSystemModel();
    fileSystemModel->setRootPath(QDir::homePath());
    fileSystemModel->setFilter(QDir::Dirs | QDir::NoDotAndDotDot);

    engine.rootContext()->setContextProperty("appCore", mediaApp);
    engine.rootContext()->setContextProperty("controller", mediaApp->controller());
    engine.rootContext()->setContextProperty("playlist", mediaApp->allMedias());
    engine.rootContext()->setContextProperty("directories", mediaApp->mediaDirModel());

    engine.rootContext()->setContextProperty("fileSystemModel", fileSystemModel);
    engine.rootContext()->setContextProperty("rootPathIndex", fileSystemModel->index(fileSystemModel->rootPath()));

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
