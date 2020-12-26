#ifndef VIDEO_H
#define VIDEO_H

#include <QString>

class Video
{
public:
    Video(QString title, QString videoSrc, QString thumbnailSource);
    QString title() const;
    QString videoSrc() const;
    QString thumbnailSource() const;

private:
    QString m_title;
    QString m_videoSrc;
    QString m_thumbnailSource;
};

#endif // VIDEO_H
