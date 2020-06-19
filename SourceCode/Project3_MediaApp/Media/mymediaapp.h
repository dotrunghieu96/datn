#ifndef MYMEDIAAPP_H
#define MYMEDIAAPP_H

#include <QObject>
#include <QDir>
#include <QFile>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QStandardPaths>

#include "mediadirmodel.h"
#include "playlistmodel.h"
#include "mymediaplayer.h"

#include <taglib/tag.h>
#include <taglib/fileref.h>
#include <taglib/id3v2tag.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v2frame.h>
#include <taglib/id3v2header.h>
#include <taglib/attachedpictureframe.h>

#define CONFIG_FILE_NAME "myMediaInfo.json"

using namespace TagLib;

class MyMediaApp : public QObject
{
    Q_OBJECT

public:
    explicit MyMediaApp(QObject *parent = nullptr);

    MediaDirModel *mediaDirModel() const;
    PlaylistModel *allMedias() const;
    MyMediaPlayer *controller() const;

public slots:
    void saveDirectoriesAndReload();
    void resetMediaDirList();

private:
    void scanMedias();
    void readDirectoriesInfoFromFile();
    void writeDirectoriesInfoToFile();
    void addToPlaylist(const QList<QUrl> &urls);
    QString getAlbumArt(QUrl url);

private:
    PlaylistModel *m_allMedias = nullptr;

    //the directories model to interact with on gui
    MediaDirModel *m_mediaDirModel = nullptr;

    //the actual directories list
    QList<MediaDir> *m_actualDir = nullptr;

    MyMediaPlayer *m_controller = nullptr;


};

#endif // MYMEDIAAPP_H
