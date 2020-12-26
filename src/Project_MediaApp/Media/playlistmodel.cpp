#include "playlistmodel.h"

PlaylistModel::PlaylistModel(QObject *parent): QAbstractListModel(parent)
{

}

int PlaylistModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_data.count();
}


QVariant PlaylistModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_data.count())
        return QVariant();

    const Song &song = m_data[index.row()];
    if (role == TitleRole)
        return song.title();
    else if (role == SingerRole)
        return song.singer();
    else if (role == SourceRole)
        return song.source();
    else if (role == AlbumArtRole)
        return song.albumArt();
    return QVariant();
}

void PlaylistModel::addSong(Song &song)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_data << song;
    endInsertRows();
}

void PlaylistModel::clearData()
{
    m_data.clear();
}

QHash<int, QByteArray> PlaylistModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "title";
    roles[SingerRole] = "singer";
    roles[SourceRole] = "source";
    roles[AlbumArtRole] = "albumArt";
    return roles;
}
