#ifndef VIDEOPLAYLISTMODEL_H
#define VIDEOPLAYLISTMODEL_H

#include <QAbstractListModel>
#include "video.h"


class VideoPlaylistModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        SourceRole
    };

    explicit VideoPlaylistModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    void addSong(Video &video);

    void clearData();

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    QList<Video> m_data;
};

#endif // VIDEOPLAYLISTMODEL_H
