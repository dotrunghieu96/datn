#ifndef MEDIADIRMODEL_H
#define MEDIADIRMODEL_H

#include <QAbstractListModel>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include "mediadir.h"

class MediaDirModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        SourceDirRole = Qt::UserRole + 1,
        EnableStatusRole
    };

    explicit MediaDirModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    void clearData();

public slots:
    void addMediaDir(QString dir, bool enableStatus = true);
    void loadDefault();
    void setEnableStatus(int index, bool enableStatus);

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    QList<MediaDir> m_data;
};

#endif // MEDIADIRMODEL_H
