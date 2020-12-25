#include "song.h"

Song::Song(QString title, QString singer, QString source, QString albumArt)
{
    m_title = title;
    m_singer = singer;
    m_source = source;
    m_albumArt = albumArt;
}

QString Song::title() const
{
    return m_title;
}

QString Song::singer() const
{
    return m_singer;
}

QString Song::source() const
{
    return m_source;
}

QString Song::albumArt() const
{
    return m_albumArt;
}
