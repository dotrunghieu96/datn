#include "myaudioplayer.h"

MyAudioPlayer::MyAudioPlayer(QObject *parent) : QObject(parent)
{
    m_player = new QMediaPlayer();
    m_playlist = new QMediaPlaylist();
    m_player->setPlaylist(m_playlist);

    QObject::connect(m_player, &QMediaPlayer::positionChanged,
                     this, &MyAudioPlayer::setPosition);

    QObject::connect(m_player, &QMediaPlayer::durationChanged,
                     this, &MyAudioPlayer::setDuration);

    QObject::connect(m_player, &QMediaPlayer::currentMediaChanged,
                     this, &MyAudioPlayer::mediaChangedHandler);

    m_playbackMode = SEQUENCE;
}

void MyAudioPlayer::switchPlaybackMode()
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

void MyAudioPlayer::setMedia(const int &index)
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
        m_nowPlayingIndex = index;
    }
}

void MyAudioPlayer::togglePlay()
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

void MyAudioPlayer::next()
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

void MyAudioPlayer::previous()
{
    if (m_playlist->mediaCount() > 0)
    {
        m_player->stop();
        if (m_playbackMode == REPEAT_ONE) {
            m_player->playlist()->setPlaybackMode(QMediaPlaylist::Loop);
            setPlaybackMode(REPEAT_ALL);
        }
        if (m_player->position() <= 3000)
        {
            if (m_player->playlist()->currentIndex() == 0)
            {
                m_player->playlist()->setCurrentIndex(m_player->playlist()->mediaCount() - 1);
            }
            else
            {
                m_player->playlist()->previous();
            }
        }
        else
        {
            m_player->play();
        }
        m_player->play();
        setIsPlaying(m_player->state() == QMediaPlayer::PlayingState);
    }
}

void MyAudioPlayer::setPlaybackMode(const PlaybackMode &playbackMode)
{
    if (m_playbackMode != playbackMode)
    {
        m_playbackMode = playbackMode;
        emit playbackModeChanged(m_playbackMode);
    }
}

void MyAudioPlayer::loadPlaylist()
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

int MyAudioPlayer::playbackMode() const
{
    return QVariant(m_playbackMode).toInt();
}

void MyAudioPlayer::setIsPlaying(bool isPlaying)
{
    m_isPlaying = isPlaying;
    emit isPlayingChanged(m_isPlaying);
}

bool MyAudioPlayer::isPlaying() const
{
    return m_isPlaying;
}

int MyAudioPlayer::nowPlayingIndex() const
{
    return m_nowPlayingIndex;
}

bool MyAudioPlayer::mediaAvailable() const
{
    return m_mediaAvailable;
}

void MyAudioPlayer::setMediaAvailable(bool mediaAvailable)
{
    m_mediaAvailable = mediaAvailable;
    emit mediaAvailableChanged(m_mediaAvailable);
}

qint64 MyAudioPlayer::position() const
{
    return m_position;
}

QString MyAudioPlayer::getTimeString(qint64 miliseconds)
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

void MyAudioPlayer::mediaChangedHandler()
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

void MyAudioPlayer::setPosition(const qint64 &position)
{
    m_position = position;
    emit positionChanged(m_position);
}

void MyAudioPlayer::setPositionByPercent(const int &percent)
{
    m_player->setPosition(percent * m_player->duration() / 100);
}

void MyAudioPlayer::setDuration(const qint64 &duration)
{
    m_duration = duration;
    emit durationChanged(m_duration);
}

void MyAudioPlayer::setOriginalPlaylist(PlaylistModel *originalPlaylist)
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

void MyAudioPlayer::stopMedia()
{
    m_player->stop();
    setIsPlaying(m_player->state() == QMediaPlayer::PlayingState);
}

qint64 MyAudioPlayer::duration() const
{
    return m_duration;
}
