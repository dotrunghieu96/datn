#ifndef MEDIADIR_H
#define MEDIADIR_H
#include <QString>


class MediaDir
{
public:
    MediaDir(QString sourceDir, bool enableStatus);
    QString sourceDir() const;
    bool enableStatus() const;
    void setEnableStatus(bool enableStatus);

private:
    QString m_sourceDir;
    bool m_enableStatus;

};

#endif // MEDIADIR_H
