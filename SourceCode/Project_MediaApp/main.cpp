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

    engine.rootContext()->setContextProperty("appCore", mediaApp);
    engine.rootContext()->setContextProperty("audioPlayer", mediaApp->audioPlayer());
    engine.rootContext()->setContextProperty("playlist", mediaApp->allAudios());
    engine.rootContext()->setContextProperty("videoPlaylist", mediaApp->allVideos());
    engine.rootContext()->setContextProperty("mediaPlaybackInfo", mediaApp->mediaPlaybackInfo());

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
