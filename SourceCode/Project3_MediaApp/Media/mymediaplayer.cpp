#include "mymediaplayer.h"

MyMediaPlayer::MyMediaPlayer(QObject *parent) : QObject(parent)
{
    m_player = new QMediaPlayer();
    m_playlist = new QMediaPlaylist();
    m_player->setPlaylist(m_playlist);

    QObject::connect(m_player, &QMediaPlayer::positionChanged,
                     this, &MyMediaPlayer::setPosition);

    QObject::connect(m_player, &QMediaPlayer::durationChanged,
                     this, &MyMediaPlayer::setDuration);

    QObject::connect(m_player, &QMediaPlayer::currentMediaChanged,
                     this, &MyMediaPlayer::mediaChangedHandler);

    m_isShuffle = false;
    m_playbackMode = SEQUENCE;
}

void MyMediaPlayer::switchPlaybackMode()
{
    switch (m_playbackMode) {
    case SEQUENCE:
        m_player->playlist()->setPlaybackMode(QMediaPlaylist::Loop);
        setPlaybackMode(REPEAT_ALL);
        break;
    case REPEAT_ALL:
        m_player->playlist()->setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
        setPlaybackMode(REPEAT_ONE);
        break;
    case REPEAT_ONE:
        m_player->playlist()->setPlaybackMode(QMediaPlaylist::Sequential);
        setPlaybackMode(SEQUENCE);
        break;
    }
}

void MyMediaPlayer::setMedia(const int &index)
{
    if (m_playlist->mediaCount() > 0)
    {
        m_player->stop();
        if (m_playbackMode == REPEAT_ONE) {
            m_player->playlist()->setPlaybackMode(QMediaPlaylist::Loop);
            setPlaybackMode(REPEAT_ALL);
        }
        m_player->playlist()->setCurrentIndex(index);
        m_player->play();
        setDuration(m_player->duration());
        setPosition(m_player->position());
        setIsPlaying(m_player->state() == QMediaPlayer::PlayingState);
    }
}

void MyMediaPlayer::togglePlay()
{
    switch (m_player->state()) {
    case QMediaPlayer::PausedState:
    case QMediaPlayer::StoppedState:
        m_player->play();
        setIsPlaying(m_player->state() == QMediaPlayer::PlayingState);
        break;
    case QMediaPlayer::PlayingState:
        m_player->pause();
        setIsPlaying(m_player->state() == QMediaPlayer::PlayingState);
        break;
    }
}

void MyMediaPlayer::next()
{
    if (m_playlist->mediaCount() > 0)
    {
        m_player->stop();
        if (m_playbackMode == REPEAT_ONE) {
            m_player->playlist()->setPlaybackMode(QMediaPlaylist::Loop);
            setPlaybackMode(REPEAT_ALL);
        }
        if (m_player->playlist()->currentIndex() == m_player->playlist()->mediaCount() - 1)
        {
            m_player->playlist()->setCurrentIndex(0);
        }
        else
        {
            m_player->playlist()->next();
        }
        m_player->play();
        setIsPlaying(m_player->state() == QMediaPlayer::PlayingState);
    }
}

void MyMediaPlayer::previous()
{
    if (m_playlist->mediaCount() > 0)
    {
        m_player->stop();
        if (m_playbackMode == REPEAT_ONE) {
            m_player->playlist()->setPlaybackMode(QMediaPlaylist::Loop);
            setPlaybackMode(REPEAT_ALL);
        }
        if (m_player->playlist()->currentIndex() == 0)
        {
            m_player->playlist()->setCurrentIndex(m_player->playlist()->mediaCount() - 1);
        }
        else
        {
            m_player->playlist()->previous();
        }
        m_player->play();
        setIsPlaying(m_player->state() == QMediaPlayer::PlayingState);
    }
}

void MyMediaPlayer::setPlaybackMode(const PlaybackMode &playbackMode)
{
    if (m_playbackMode != playbackMode)
    {
        m_playbackMode = playbackMode;
        emit playbackModeChanged(m_playbackMode);
    }
}

void MyMediaPlayer::loadPlaylist()
{
    m_playlist->clear();
    if (m_originalPlaylist != nullptr && m_playlist != nullptr)
    {
        if (m_originalPlaylist->rowCount() == 0)
        {
            Song dummy("No media founds", "", "", "");
            m_originalPlaylist->addSong(dummy);
        }
        else
        {
            for (int i = 0; i < m_originalPlaylist->rowCount(); i++)
            {
                m_playlist->addMedia(QUrl::fromUserInput(m_originalPlaylist->data(m_originalPlaylist->index(i),
                                                                                  PlaylistModel::SourceRole).toString()));
            }
        }
        setMediaAvailable(m_playlist->mediaCount() > 0);
    }
    else
    {
        setMediaAvailable(false);
    }
}

int MyMediaPlayer::playbackMode() const
{
    return QVariant(m_playbackMode).toInt();
}

bool MyMediaPlayer::isShuffle() const
{
    return m_isShuffle;
}

void MyMediaPlayer::setIsPlaying(bool isPlaying)
{
    m_isPlaying = isPlaying;
    emit isPlayingChanged(m_isPlaying);
}

bool MyMediaPlayer::isPlaying() const
{
    return m_isPlaying;
}

int MyMediaPlayer::nowPlayingIndex() const
{
    return m_nowPlayingIndex;
}

bool MyMediaPlayer::mediaAvailable() const
{
    return m_mediaAvailable;
}

void MyMediaPlayer::setMediaAvailable(bool mediaAvailable)
{
    m_mediaAvailable = mediaAvailable;
    emit mediaAvailableChanged(m_mediaAvailable);
}

qint64 MyMediaPlayer::position() const
{
    return m_position;
}

QString MyMediaPlayer::getTimeString(qint64 miliseconds)
{
    QString timeString = "00:00";
    miliseconds = miliseconds/1000;
    QTime currentTime((miliseconds / 3600) % 60, (miliseconds / 60) % 60,
                      miliseconds % 60, (miliseconds * 1000) % 1000);
    QString format = "mm:ss";
    if (miliseconds > 3600)
        format = "hh::mm:ss";
    timeString = currentTime.toString(format);
    return timeString;
}

void MyMediaPlayer::mediaChangedHandler()
{
    bool triggerAnimationDirection = true;
    if (m_playlist->mediaCount() > 0)
    {
        if ((m_playlist->currentIndex() - m_nowPlayingIndex == 1)
                || ((m_playlist->currentIndex() == 0)
                    && (m_nowPlayingIndex == m_playlist->mediaCount() - 1)))
        {
            triggerAnimationDirection = true;
        }
        else if ((m_playlist->currentIndex() - m_nowPlayingIndex == -1)
                 || ((m_playlist->currentIndex() == m_playlist->mediaCount() - 1)
                     && (m_nowPlayingIndex == 0)))
        {
            triggerAnimationDirection = false;
        }
        else {
            //do nothing
        }
        m_nowPlayingIndex = m_playlist->currentIndex();
        emit triggerAnimation(triggerAnimationDirection);
    }
    else
    {
        m_nowPlayingIndex = -1;
    }
    setIsPlaying(m_player->state() == QMediaPlayer::PlayingState);
    emit nowPlayingIndexChanged(m_nowPlayingIndex);
}

void MyMediaPlayer::setPosition(const qint64 &position)
{
    m_position = position;
    emit positionChanged(m_position);
}

void MyMediaPlayer::setPositionByPercent(const int &percent)
{
    m_player->setPosition(percent * m_player->duration() / 100);
}

void MyMediaPlayer::setDuration(const qint64 &duration)
{
    m_duration = duration;
    emit durationChanged(m_duration);
}

void MyMediaPlayer::toggleShuffle()
{
    //TO-DO: a solution for shuffle
    if (m_isShuffle == false) {
        m_isShuffle = true;
    }
    else
    {
        m_isShuffle = false;
    }
    emit shuffleChanged(m_isShuffle);
}

void MyMediaPlayer::setOriginalPlaylist(PlaylistModel *originalPlaylist)
{
    if (m_originalPlaylist != originalPlaylist)
    {
        m_originalPlaylist = originalPlaylist;
    }

    loadPlaylist();

    if (m_playlist->mediaCount() > 0)
    {
        m_player->playlist()->setCurrentIndex(0);
    }
}

void MyMediaPlayer::stopMedia()
{
    m_player->stop();
}

qint64 MyMediaPlayer::duration() const
{
    return m_duration;
}
