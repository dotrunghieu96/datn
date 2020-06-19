#include "mediadirmodel.h"

MediaDirModel::MediaDirModel(QObject *parent): QAbstractListModel(parent)
{

}

int MediaDirModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_data.count();
}

QVariant MediaDirModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_data.count())
        return QVariant();

    const MediaDir &mediaDir = m_data[index.row()];
    if (role == SourceDirRole)
        return mediaDir.sourceDir();
    else if (role == EnableStatusRole)
        return mediaDir.enableStatus();
    return QVariant();
}

void MediaDirModel::addMediaDir(QString dir, bool enableStatus)
{
    bool isDuplicated = false;

    for (int i = 0; i < m_data.count(); i++)
    {
        if (dir == m_data[i].sourceDir())
        {
            isDuplicated = true;
            break;
        }
    }

    if (!isDuplicated)
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        MediaDir temp(dir, enableStatus);
        m_data << temp;
        endInsertRows();
    }
}

void MediaDirModel::loadDefault()
{
    if (m_data.count() > 0)
    {
        m_data.clear();
    }

    QString defaultDir = QStandardPaths::locate(QStandardPaths::MusicLocation,
                                                "",
                                                QStandardPaths::LocateDirectory);
    addMediaDir(defaultDir);
}

void MediaDirModel::setEnableStatus(int index, bool enableStatus)
{
    m_data[index].setEnableStatus(enableStatus);
}

void MediaDirModel::clearData()
{
    if (m_data.count() > 0)
    {
        m_data.clear();
    }
}

QHash<int, QByteArray> MediaDirModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[SourceDirRole] = "sourceDir";
    roles[EnableStatusRole] = "enableStatus";
    return roles;
}
