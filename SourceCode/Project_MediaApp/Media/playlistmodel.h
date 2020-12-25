#ifndef PLAYLISTMODEL_H
#define PLAYLISTMODEL_H

#include <QAbstractListModel>
#include "song.h"

class PlaylistModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        SingerRole,
        SourceRole,
        AlbumArtRole
    };

    explicit PlaylistModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    void addSong(Song &song);

    void clearData();

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    QList<Song> m_data;
};
#endif // PLAYLISTMODEL_H
