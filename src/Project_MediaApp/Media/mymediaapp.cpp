#include "mymediaapp.h"

MyMediaApp::MyMediaApp(QObject *parent) : QObject(parent)
{
    m_audioPlayer = new MyAudioPlayer();
    m_mediaPlaybackInfo = new MediaPlaybackInfo("", 0, "", "");
    m_allAudios = new PlaylistModel();
    m_allVideos = new VideoPlaylistModel();

    QObject::connect(m_audioPlayer, &MyAudioPlayer::nowPlayingIndexChanged,
                     this, &MyMediaApp::updateLastAudio);

    //load media from selected directories
    readMediaPlaybackInfoFromFile();
    scanMedias();
}

MediaPlaybackInfo *MyMediaApp::mediaPlaybackInfo() const
{
    return m_mediaPlaybackInfo;
}

PlaylistModel *MyMediaApp::allAudios() const
{
    return m_allAudios;
}

VideoPlaylistModel *MyMediaApp::allVideos() const
{
    return m_allVideos;
}

MyAudioPlayer *MyMediaApp::audioPlayer() const
{
    return m_audioPlayer;
}

void MyMediaApp::updateLastAudio(int index)
{
    QString source = m_allAudios->data(m_allAudios->index(index), PlaylistModel::SourceRole).toString();
    m_mediaPlaybackInfo->setLastAudio(source);
}

void MyMediaApp::scanMedias()
{
    m_allAudios->clearData();

    QList<QUrl> audioUrls;
    QList<QUrl> videoUrls;
    QStringList fileFilter;
    fileFilter << "*.mp3";
    fileFilter << "*.mp4";

#ifdef _rapsberrypi_
    QString defaultDir = QStandardPaths::locate(QStandardPaths::HomeLocation,
                                                "",
                                                QStandardPaths::LocateDirectory);
    QDirIterator it(defaultDir,
                    fileFilter,
                    QDir::Files,
                    QDirIterator::Subdirectories);
#else
    QString defaultDir = QStandardPaths::locate(QStandardPaths::MusicLocation,
                                                "",
                                                QStandardPaths::LocateDirectory);
    QDirIterator it(defaultDir,
                    fileFilter,
                    QDir::Files,
                    QDirIterator::Subdirectories);
#endif
    while (it.hasNext())
    {
        it.next();
        if (it.filePath().endsWith("mp3"))
        {
            audioUrls.append(QUrl::fromLocalFile(it.filePath()));
        }
        else
        {
            videoUrls.append(QUrl::fromLocalFile(it.filePath()));
        }
    }
    addToAudioPlaylist(audioUrls);
    addToVideoPlaylist(videoUrls);
}

void MyMediaApp::readMediaPlaybackInfoFromFile()
{
    //Open json file
    QFile jsonFile(QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/" + CONFIG_FILE_NAME);
    if(jsonFile.open(QIODevice::ReadOnly))
    {
        QTextStream textStream(&jsonFile);
        QString jsonString;
        jsonString = textStream.readAll();
        jsonFile.close();

        QByteArray jsonBytes = jsonString.toLocal8Bit();

        auto jsonDoc = QJsonDocument::fromJson(jsonBytes);

        if(!jsonDoc.isNull() && jsonDoc.isObject())
        {
            //Parse data
            QJsonObject jsonObj = jsonDoc.object().take("mediaPlaybackInfo").toObject();

            QString videoSouce = jsonObj.take("videoSource").toString();
            quint8 videoPosition = QVariant(jsonObj.take("videoPosition").toString()).toULongLong();
            QString audioSource = jsonObj.take("audioSource").toString();
            QString secVideoSouce = jsonObj.take("secVideoSource").toString();
            m_mediaPlaybackInfo->setLastVideoSource(secVideoSouce);
            m_mediaPlaybackInfo->updateLastVideo(videoSouce);
            m_mediaPlaybackInfo->setLastVideoPosition(videoPosition);
            m_mediaPlaybackInfo->setLastAudio(audioSource);
        }
    }
}

void MyMediaApp::writePlaybackInfoToFile()
{
    //push data to json
    QJsonObject jsonObject;
    jsonObject.insert("videoSource",m_mediaPlaybackInfo->lastVideoSource());
    jsonObject.insert("videoPosition",QString::number(m_mediaPlaybackInfo->lastVideoPosition()));
    jsonObject.insert("audioSource",m_mediaPlaybackInfo->lastAudioSource());
    jsonObject.insert("secVideoSource",m_mediaPlaybackInfo->secLastVideoSource());


    QJsonObject finalObject;
    finalObject.insert("mediaPlaybackInfo", QJsonValue(jsonObject));
    QJsonDocument jsonDoc(finalObject);

    //Open file to write data
    QDir appLocalDataDir(QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation));
    if (!appLocalDataDir.exists())
    {
        QDir().mkdir(QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation));
    }

    QFile jsonFile(QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/" + CONFIG_FILE_NAME);

    //The below open function tries to open the file, and creates the file if it doesn't exist
    if(jsonFile.open(QIODevice::WriteOnly))
    {
        jsonFile.write(jsonDoc.toJson());
        jsonFile.close();
    }
    //If failed to open file, ignore write attemp
}

void MyMediaApp::addToAudioPlaylist(const QList<QUrl> &urls)
{
    int lastPlayIndex = 0;
    for (int i = 0; i < urls.size(); i++)
    {
        QUrl url = urls.at(i);
        QString title = "";
        QString singer = "Unknown Artist";

        {
            FileRef f(url.toString().replace("file:///","").toStdString().c_str());
            Tag *tag = f.tag();
            if (tag->title().length() > 0)
            {
                title = QString::fromWCharArray(tag->title().toCWString());
            }
            else {
                QFileInfo info(url.toDisplayString());
                title = info.baseName();
            }
            if (tag->artist().length() > 0)
            {
                singer = QString::fromWCharArray(tag->artist().toCWString());
            }
        }

        Song song(title,
                  singer,
                  url.toDisplayString(),
                  getAlbumArt(url));
        m_allAudios->addSong(song);
        if (m_mediaPlaybackInfo->lastAudioSource() == url.toDisplayString())
        {
            lastPlayIndex = i;
        }

    }
    m_audioPlayer->setOriginalPlaylist(m_allAudios);
    m_audioPlayer->setMedia(lastPlayIndex);
    m_audioPlayer->stopMedia();
}

void MyMediaApp::addToVideoPlaylist(const QList<QUrl> &urls)
{
    for (auto &url: urls)
    {
        QFileInfo fileInfo(url.toDisplayString());
        QString title = fileInfo.baseName();
        QString videoSrc = url.toDisplayString();
        Video video(title, videoSrc, "");
        m_allVideos->addVideo(video);
    }
}

QString MyMediaApp::getAlbumArt(QUrl url)
{
    static const char *IdPicture = "APIC" ;
    TagLib::MPEG::File mpegFile(url.toString().replace("file:///","").toStdString().c_str());
    TagLib::ID3v2::Tag *id3v2tag = mpegFile.ID3v2Tag();
    TagLib::ID3v2::FrameList Frame ;
    TagLib::ID3v2::AttachedPictureFrame *PicFrame ;
    void *SrcImage ;
    unsigned long Size ;

    FILE *jpegFile;
    jpegFile = fopen(QString(url.fileName()+".jpg").toStdString().c_str(),"wb");

    if (id3v2tag)
    {
        // picture frame
        Frame = id3v2tag->frameListMap()[IdPicture] ;
        if (!Frame.isEmpty())
        {
            for(TagLib::ID3v2::FrameList::ConstIterator it = Frame.begin(); it != Frame.end(); ++it)
            {
                PicFrame = static_cast<TagLib::ID3v2::AttachedPictureFrame*>(*it) ;
                {
                    // extract image (in it’s compressed form)
                    Size = PicFrame->picture().size() ;
                    SrcImage = malloc(Size) ;
                    if (SrcImage)
                    {
                        memcpy(SrcImage, PicFrame->picture().data(), Size);
                        fwrite(SrcImage,Size,1, jpegFile);
                        fclose(jpegFile);
                        free(SrcImage);
                        return QUrl::fromLocalFile(url.fileName()+".jpg").toDisplayString();
                    }

                }
            }
        }
    }
    return "qrc:/Resources/album_art.png";
}
