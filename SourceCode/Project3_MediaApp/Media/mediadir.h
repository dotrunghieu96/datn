#ifndef MEDIADIR_H
#define MEDIADIR_H
#include <QString>

class MediaDir
{
public:

    enum DirType {
        Audio = Qt::UserRole + 1,
        Video,
        AudioVideo
    };

    MediaDir(QString sourceDir, bool enableStatus);
    QString sourceDir() const;
    bool enableStatus() const;
    DirType dirType() const;
    void setEnableStatus(bool enableStatus);

private:
    QString m_sourceDir;
    bool m_enableStatus;
    DirType m_dirType;

};

#endif // MEDIADIR_H
