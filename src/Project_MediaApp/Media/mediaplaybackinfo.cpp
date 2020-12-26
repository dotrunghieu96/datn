#include "mediaplaybackinfo.h"

MediaPlaybackInfo::MediaPlaybackInfo(
        QString lastVideoSource,
        quint8 lastVideoPosition,
        QString lastAudioSource,
        QString secLastVideoSource)
{
    m_lastVideoSource = lastVideoSource;
    m_lastVideoPosition = lastVideoPosition;
    m_lastAudioSource = lastAudioSource;
    m_secLastVideoSource = secLastVideoSource;

    if (m_lastVideoSource != "")
    {
        QFileInfo videoFileInfo(m_lastVideoSource);
        m_lastVideoName = videoFileInfo.baseName();

        videoFileInfo.setFile(m_secLastVideoSource);
        m_secLastVideoName = videoFileInfo.baseName();
    }
    else
    {
        m_lastVideoName = "No recently played";
    }
}

QString MediaPlaybackInfo::lastVideoSource() const
{
    return m_lastVideoSource;
}

quint64 MediaPlaybackInfo::lastVideoPosition() const
{
    return m_lastVideoPosition;
}

QString MediaPlaybackInfo::lastAudioSource() const
{
    return m_lastAudioSource;
}

void MediaPlaybackInfo::setLastVideoPosition(const quint8 &position)
{
    m_lastVideoPosition = position;
}

void MediaPlaybackInfo::updateLastVideo(const QString &videoSource)
{
    if (videoSource != m_lastVideoSource)
    {
        QFileInfo videoFileInfo(m_lastVideoSource);
        m_secLastVideoName = videoFileInfo.baseName();
        m_secLastVideoSource = m_lastVideoSource;

        videoFileInfo.setFile(videoSource);
        m_lastVideoName = videoFileInfo.baseName();
        m_lastVideoSource = videoSource;

        emit lastVideoNameChanged(m_lastVideoName);
        emit secLastVideoNameChanged(m_secLastVideoName);
    }
}

void MediaPlaybackInfo::setLastAudio(const QString &audioSource)
{
    m_lastAudioSource = audioSource;
}

void MediaPlaybackInfo::setLastVideoSource(const QString &lastVideoSource)
{
    m_lastVideoSource = lastVideoSource;
}

QString MediaPlaybackInfo::secLastVideoName() const
{
    return m_secLastVideoName;
}

QString MediaPlaybackInfo::lastVideoName() const
{
    return m_lastVideoName;
}

QString MediaPlaybackInfo::secLastVideoSource() const
{
    return m_secLastVideoSource;
}

void MediaPlaybackInfo::setSecLastVideoSource(const QString &secLastVideoSource)
{
    m_secLastVideoSource = secLastVideoSource;
}
