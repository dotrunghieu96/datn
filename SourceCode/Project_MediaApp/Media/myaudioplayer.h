#ifndef MYMEDIAPLAYER_H
#define MYMEDIAPLAYER_H

#include <QObject>
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QTime>
#include <QRandomGenerator>
#include "playlistmodel.h"


enum PlaybackMode {
    SEQUENCE = 1,
    REPEAT_ALL,
    REPEAT_ONE
};

class MyAudioPlayer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(qint64 position READ position NOTIFY positionChanged)
    Q_PROPERTY(bool mediaAvailable READ mediaAvailable NOTIFY mediaAvailableChanged)
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)
    Q_PROPERTY(int nowPlayingIndex READ nowPlayingIndex NOTIFY nowPlayingIndexChanged)
    Q_PROPERTY(int playbackMode READ playbackMode NOTIFY playbackModeChanged)

public:
    explicit MyAudioPlayer(QObject *parent = nullptr);
    void setOriginalPlaylist(PlaylistModel *originalPlaylist);
    void stopMedia();

    qint64 duration() const;
    qint64 position() const;
    bool mediaAvailable() const;
    bool isPlaying() const;
    int nowPlayingIndex() const;
    int playbackMode() const;

signals:
    void nowPlayingIndexChanged(int nowPlayingIndex);
    void playbackModeChanged(int currentMode);
    void durationChanged(qint64 duration);
    void positionChanged(qint64 position);
    void mediaAvailableChanged(bool mediaAvailable);
    void isPlayingChanged(bool isPlaying);
    void triggerAnimation(bool isIncreased);

public slots:
    void setMedia(const int &index);
    void setPositionByPercent(const int &percent);
    void switchPlaybackMode();
    void togglePlay();
    void next();
    void previous();
    QString getTimeString(qint64 miliseconds);

private slots:
    void mediaChangedHandler();

private:
    void setIsPlaying(bool isPlaying);
    void setMediaAvailable(bool mediaAvailable);
    void setPosition(const qint64 &position);
    void setDuration(const qint64 &duration);
    void setPlaybackMode(const PlaybackMode &playbackMode);
    void loadPlaylist();

    QMediaPlayer *m_player = nullptr;
    QMediaPlaylist *m_playlist = nullptr;
    PlaylistModel *m_originalPlaylist = nullptr;
    PlaybackMode m_playbackMode;
    qint64 m_duration;
    qint64 m_position;
    bool m_mediaAvailable;
    bool m_isPlaying;
    int m_nowPlayingIndex;
};

#endif // MYMEDIAPLAYER_H
