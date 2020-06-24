#ifndef VIDEO_H
#define VIDEO_H

#include <QString>

class Video
{
public:
    Video(QString title, QString videoSrc);
    QString title() const;
    QString videoSrc() const;

private:
    QString m_title;
    QString m_videoSrc;
};

#endif // VIDEO_H
