#include "mediadir.h"

MediaDir::MediaDir(QString sourceDir, bool enableStatus)
{
    m_sourceDir = sourceDir;
    m_enableStatus = enableStatus;
}

QString MediaDir::sourceDir() const
{
    return m_sourceDir;
}

bool MediaDir::enableStatus() const
{
    return m_enableStatus;
}

MediaDir::DirType MediaDir::dirType() const
{
    return m_dirType;
}

void MediaDir::setEnableStatus(bool enableStatus)
{
    m_enableStatus = enableStatus;
}
