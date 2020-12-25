#include "video.h"

Video::Video(QString title, QString source, QString thumbnailSource)
{
    m_title = title;
    m_videoSrc = source;
    m_thumbnailSource = thumbnailSource;
}

QString Video::title() const
{
    return m_title;
}

QString Video::videoSrc() const
{
    return m_videoSrc;
}

QString Video::thumbnailSource() const
{
    return "qrc:/Resources/video_thumbnail.jpg";
}
