#include "video.h"

Video::Video(QString title, QString source)
{
    m_title = title;
    m_source = source;
}

QString Video::title() const
{
    return m_title;
}

QString Video::source() const
{
    return m_source;
}
