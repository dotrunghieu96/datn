#ifndef VIDEOPLAYLISTMODEL_H
#define VIDEOPLAYLISTMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include "video.h"


class VideoPlaylistModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int nowPlayingIndex READ nowPlayingIndex WRITE setNowPlayingIndex NOTIFY nowPlayingIndexChanged)
public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        VideoSrcRole,
        ThumbnailSrcRole
    };

    explicit VideoPlaylistModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    void addVideo(Video &video);

    void clearData();

    int nowPlayingIndex() const;

signals:
    void nowPlayingIndexChanged(int nowPlayingIndex);

public slots:
    void setNowPlayingIndex(const int &nowPlayingIndex);
    void setNowPlayingIndex(const QString &source);

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    QList<Video> m_data;
    int m_nowPlayingIndex;
};

#endif // VIDEOPLAYLISTMODEL_H
