#include "videoplaylistmodel.h"

VideoPlaylistModel::VideoPlaylistModel(QObject *parent): QAbstractListModel(parent)
{

}

int VideoPlaylistModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_data.count();
}

QVariant VideoPlaylistModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_data.count())
        return QVariant();

    const Video &song = m_data[index.row()];
    if (role == TitleRole)
        return song.title();
    else if (role == VideoSrcRole)
        return song.videoSrc();
    return QVariant();
}

void VideoPlaylistModel::addVideo(Video &video)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_data << video;
    endInsertRows();
}

void VideoPlaylistModel::clearData()
{
    m_data.clear();
}

QHash<int, QByteArray> VideoPlaylistModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "title";
    roles[VideoSrcRole] = "videoSrc";
    return roles;
}
