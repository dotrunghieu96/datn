#ifndef MEDIADIRMODEL_H
#define MEDIADIRMODEL_H

#include <QObject>
#include <QString>
#include <QDebug>
#include <QFileInfo>
#include "mediadir.h"

class MediaPlaybackInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString lastVideoName READ lastVideoName NOTIFY lastVideoNameChanged)
    Q_PROPERTY(QString secLastVideoName READ secLastVideoName NOTIFY secLastVideoNameChanged)

public:
    MediaPlaybackInfo(QString lastVideoSource, quint8 lastVideoPosition, QString lastAudioSource, QString secLastVideoSource);

    QString lastVideoName() const;

    QString secLastVideoName() const;

    void setLastVideoSource(const QString &lastVideoSource);

signals:
    void lastVideoNameChanged(QString lastVideoName);
    void secLastVideoNameChanged(QString secLastVideoName);

public slots:
    quint64 lastVideoPosition() const;
    QString lastVideoSource() const;
    QString secLastVideoSource() const;
    QString lastAudioSource() const;
    void setSecLastVideoSource(const QString &secLastVideoSource);
    void updateLastVideo(const QString &videoSource);
    void setLastVideoPosition(const quint8 &position);
    void setLastAudio(const QString &audioSource);

private:
    QString m_lastVideoSource;
    quint8 m_lastVideoPosition;
    QString m_secLastVideoSource;
    QString m_lastVideoName;
    QString m_secLastVideoName;
    QString m_lastAudioSource;
};

#endif // MEDIADIRMODEL_H
