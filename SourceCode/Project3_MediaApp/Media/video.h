#ifndef VIDEO_H
#define VIDEO_H

#include <QString>

class Video
{
public:
    Video(QString title, QString source);
    QString title() const;
    QString source() const;

private:
    QString m_title;
    QString m_source;
};

#endif // VIDEO_H
