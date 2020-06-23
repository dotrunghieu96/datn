#include "mymediaapp.h"

MyMediaApp::MyMediaApp(QObject *parent) : QObject(parent)
{
    m_audioPlayer = new MyAudioPlayer();
    m_mediaDirModel = new MediaDirModel();
    m_allAudios = new PlaylistModel();
    m_actualDir = new QList<MediaDir>();

    //load media from selected directories
    readDirectoriesInfoFromFile();
    scanMedias();
}

MediaDirModel *MyMediaApp::mediaDirModel() const
{
    return m_mediaDirModel;
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

void MyMediaApp::saveDirectoriesAndReload()
{
    //save directories
    writeDirectoriesInfoToFile();

    //Stop the current media player
    m_audioPlayer->stopMedia();

    //reload media from recently saved directories
    readDirectoriesInfoFromFile();
    scanMedias();
}

void MyMediaApp::resetMediaDirList()
{
    m_mediaDirModel->clearData();

    QList<MediaDir>::iterator i;
    for(i = m_actualDir->begin(); i != m_actualDir->end(); ++i)
    {
        m_mediaDirModel->addMediaDir(i->sourceDir(), i->enableStatus());
    }
}

void MyMediaApp::scanMedias()
{
    m_allAudios->clearData();

    QList<QUrl> urls;
    for (int i = 0; i < m_mediaDirModel->rowCount(); i++)
    {
        if (m_mediaDirModel->data(m_mediaDirModel->index(i),
                                  MediaDirModel::EnableStatusRole).toBool())
        {
            QDir directory(m_mediaDirModel->data(m_mediaDirModel->index(i),
                                                 MediaDirModel::SourceDirRole).toString());
            QFileInfoList musics = directory.entryInfoList(QStringList() << "*.mp3",QDir::Files);

            for (int i = 0; i < musics.length(); i++)
            {
                urls.append(QUrl::fromLocalFile(musics[i].absoluteFilePath()));
            }
        }
    }
    addToPlaylist(urls);
    m_audioPlayer->setOriginalPlaylist(m_allAudios);
}

void MyMediaApp::readDirectoriesInfoFromFile()
{
    //Clear old data
    m_mediaDirModel->clearData();
    m_actualDir->clear();

    //Open json file
    //parse directories
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
            QJsonObject jsonObj = jsonDoc.object();

            QJsonArray directories = jsonObj.take("Directories").toArray();

            int dirCount = directories.count();

            for (int i = 0; i < dirCount; i++)
            {
                QJsonObject leafObj = directories.takeAt(0).toObject();
                QString sourceDir = leafObj.take("sourceDir").toString();
                bool enableStatus = QVariant(leafObj.take("enableStatus").toString()).toBool();
                m_mediaDirModel->addMediaDir(sourceDir, enableStatus);
                MediaDir mediaDir(sourceDir, enableStatus);
                m_actualDir->append(mediaDir);
            }
        }
    }

    //If open failed or data is invalid, load default
    if (m_mediaDirModel->rowCount() == 0)
    {
        m_mediaDirModel->loadDefault();
        //override corrupted data with default data
        writeDirectoriesInfoToFile();
    }
}

void MyMediaApp::writeDirectoriesInfoToFile()
{
    //Clear the hidden actual directories list
    m_actualDir->clear();

    //Create JSON data
    QJsonArray jsonArray;

    for(int i = 0; i < m_mediaDirModel->rowCount(); i++)
    {
        //sync the actual directories list with configured one
        QString source = m_mediaDirModel->data(m_mediaDirModel->index(i),
                                               MediaDirModel::SourceDirRole).toString();
        bool enableStatus = m_mediaDirModel->data(m_mediaDirModel->index(i),
                                                  MediaDirModel::EnableStatusRole).toBool();
        MediaDir mediaDir(source, enableStatus);
        m_actualDir->append(mediaDir);

        //push data to json
        QJsonObject jsonObject;
        jsonObject.insert("sourceDir",source);
        jsonObject.insert("enableStatus", QVariant(enableStatus).toString());
        jsonArray.push_back(jsonObject);
    }


    QJsonObject finalObject;
    finalObject.insert("Directories", QJsonValue(jsonArray));
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

void MyMediaApp::addToPlaylist(const QList<QUrl> &urls)
{
    for (auto &url: urls)
    {
        QString title = "";
        QString singer = "";

        {
            FileRef f(url.toString().replace("file:///","").toStdString().c_str());
            Tag *tag = f.tag();
            title = QString::fromWCharArray(tag->title().toCWString());
            singer = QString::fromWCharArray(tag->artist().toCWString());
        }

        Song song(title,
                  singer,
                  url.toDisplayString(),
                  getAlbumArt(url));
        m_allAudios->addSong(song);
    }
    m_audioPlayer->setOriginalPlaylist(m_allAudios);
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
    else
    {
        qDebug() <<"id3v2 not present";
        return "qrc:/Resources/album_art.png";
    }
    return "qrc:/Resources/album_art.png";
}
