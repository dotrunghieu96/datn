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

#include "mediaplaybackinfo.h"
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

    MediaPlaybackInfo *mediaPlaybackInfo() const;
    PlaylistModel *allAudios() const;
    VideoPlaylistModel *allVideos() const;
    MyAudioPlayer *audioPlayer() const;

public slots:
    void updateLastAudio(int index);
    void writePlaybackInfoToFile();

private:
    void scanMedias();
    void readMediaPlaybackInfoFromFile();
    void addToAudioPlaylist(const QList<QUrl> &urls);
    void addToVideoPlaylist(const QList<QUrl> &urls);
    QString getAlbumArt(QUrl url);

private:
    PlaylistModel *m_allAudios = nullptr;
    VideoPlaylistModel *m_allVideos = nullptr;
    //Info of last playback
    MediaPlaybackInfo *m_mediaPlaybackInfo = nullptr;
    MyAudioPlayer *m_audioPlayer = nullptr;
};

#endif // MYMEDIAAPP_H
