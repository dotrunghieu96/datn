#include "video.h"

Video::Video(QString title, QString source)
{
    m_title = title;
    m_videoSrc = source;
}

QString Video::title() const
{
    return m_title;
}

QString Video::videoSrc() const
{
    return m_videoSrc;
}
