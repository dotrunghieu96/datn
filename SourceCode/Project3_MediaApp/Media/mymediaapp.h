#ifndef MYMEDIAAPP_H
#define MYMEDIAAPP_H

#include <QObject>
#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QStandardPaths>

#include "mediadirmodel.h"
#include "playlistmodel.h"
#include "videoplaylistmodel.h"
#include "myaudioplayer.h"

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
    PlaylistModel *allAudios() const;
    VideoPlaylistModel *allVideos() const;
    MyAudioPlayer *audioPlayer() const;

public slots:
    void saveDirectoriesAndReload();
    void resetMediaDirList();

private:
    void scanMedias();
    void readDirectoriesInfoFromFile();
    void writeDirectoriesInfoToFile();
    void addToAudioPlaylist(const QList<QUrl> &urls);
    void addToVideoPlaylist(const QList<QUrl> &urls);
    QString getAlbumArt(QUrl url);

private:
    PlaylistModel *m_allAudios = nullptr;

    VideoPlaylistModel *m_allVideos = nullptr;

    //the directories model to interact with on gui
    MediaDirModel *m_mediaDirModel = nullptr;

    //the actual directories list
    QList<MediaDir> *m_actualDir = nullptr;

    MyAudioPlayer *m_audioPlayer = nullptr;


};

#endif // MYMEDIAAPP_H
