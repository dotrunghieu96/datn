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

    const Video &video = m_data[index.row()];
    if (role == TitleRole)
        return video.title();
    else if (role == VideoSrcRole)
        return video.videoSrc();
    else if (role == ThumbnailSrcRole)
        return video.thumbnailSource();
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
    roles[ThumbnailSrcRole] = "thumnailSrc";
    return roles;
}

int VideoPlaylistModel::nowPlayingIndex() const
{
    return m_nowPlayingIndex;
}

void VideoPlaylistModel::setNowPlayingIndex(const int &nowPlayingIndex)
{
    m_nowPlayingIndex = nowPlayingIndex;
}

void VideoPlaylistModel::setNowPlayingIndex(const QString &source)
{
    for (int i = 0; i < rowCount(); i++)
    {
        if (source == data(this->index(i), VideoPlaylistModel::VideoSrcRole).toString())
        {
            m_nowPlayingIndex = i;
            emit nowPlayingIndexChanged(m_nowPlayingIndex);
        }
    }

}
