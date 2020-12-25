#ifndef SONG_H
#define SONG_H

#include <QString>

class Song
{
public:
    Song(QString title, QString singer, QString source, QString albumArt);
    QString title() const;
    QString singer() const;
    QString source() const;
    QString albumArt() const;

private:
    QString m_title;
    QString m_singer;
    QString m_source;
    QString m_albumArt;
};

#endif // SONG_H
