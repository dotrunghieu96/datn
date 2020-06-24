import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Window {
    visible: true
    width: 1280
    height: 720
    flags: Qt.FramelessWindowHint


    Image {
        id: background
        anchors.fill: parent
        source: "qrc:/Resources/background.jpg"
    }

    StackView {
        id: stackView
        anchors.fill: parent

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 200
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 200
            }
        }

        initialItem: mainView
    }

    Button {
        x: 0
        y: 0
        width: 80
        height: 30

        onClicked: {
            stackView.push(videoApp)
        }

        text: "video"
    }

    Component {
        id: mainView

        Item {
            Rectangle {
                id: mediaWidget
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: parent.width / 4
                width: parent.width * 0.45
                height: width
                color: "white"

                radius: 10

                gradient: Gradient{

                    GradientStop {
                        position: 0.0
                        color: "transparent"
                    }
                    GradientStop {
                        position: 1.0
                        color: "black"
                    }
                }

                Image {
                    id: bgBlur

                    anchors.fill: mediaWidget
                    clip: true
                    fillMode: Image.PreserveAspectFit

                    source: {
                        if (playlist.rowCount() > 0 && playlist.rowCount() >  audioPlayer.nowPlayingIndex)
                            return playlist.data(playlist.index(audioPlayer.nowPlayingIndex, 0), 260)
                        else
                            return "qrc:/Resources/album_art.png"
                    }

                    OpacityMask {
                        source: mask
                        maskSource: bgBlur
                    }

                    LinearGradient {
                        id: mask
                        anchors.fill: parent
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "transparent"}
                            GradientStop { position: 1.0; color: "black" }
                        }
                    }
                }



                Text {
                    id: currentSongTitle
                    anchors.bottom: currentSinger.top
                    anchors.bottomMargin: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 32
                    width: parent.width - 64

                    text: playlist.data(playlist.index(audioPlayer.nowPlayingIndex, 0), 257)
                    clip: true

                    font.family: "Helvetica"
                    font.bold: true
                    font.pixelSize: 32
                    color: "white"
                }

                Text {
                    id: currentSinger
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 32
                    anchors.left: currentSongTitle.left
                    anchors.right: currentSongTitle.right

                    text: playlist.data(playlist.index(audioPlayer.nowPlayingIndex, 0), 258)
                    clip: true

                    font.family: "Helvetica"
                    font.pixelSize: 24
                    color: "lightgray"
                }

                MouseArea {
                    id:openMediaApp
                    anchors.fill: parent

                    onPressed: {
                        parent.opacity = 0.7
                    }

                    onReleased: {
                        parent.opacity = 1
                    }

                    onCanceled: {
                        parent.opacity = 1
                    }

                    onClicked: {
                        stackView.push(appMediaComponent)
                    }
                }

                RoundButton {
                    id: playButton
                    anchors.centerIn: parent
                    width: 160
                    height: width

                    enabled: audioPlayer.mediaAvailable

                    background: Image {
                        id: bgPlay
                        anchors.fill: parent
                        source: {
                            if (audioPlayer.isPlaying)
                            {
                                if (playButton.pressed)
                                {
                                    return "qrc:/Resources/pause_focus.png"
                                }
                                else
                                {
                                    return "qrc:/Resources/pause_idle.png"
                                }
                            }
                            else
                            {
                                if (playButton.pressed)
                                {
                                    return "qrc:/Resources/play_focus.png"
                                }
                                else
                                {
                                    return "qrc:/Resources/play_idle.png"
                                }
                            }
                        }
                    }
                    onClicked: {
                        audioPlayer.togglePlay()
                    }

                }

                RoundButton {
                    id: nextButton
                    anchors.left: playButton.right
                    anchors.leftMargin: 24
                    anchors.verticalCenter: playButton.verticalCenter

                    width: 128
                    height: width

                    enabled: audioPlayer.mediaAvailable

                    background: Image {
                        id: bgNext
                        anchors.fill: parent
                        source: {
                            if (nextButton.pressed)
                            {
                                return "qrc:/Resources/next_focus.png"
                            }
                            else
                            {
                                return "qrc:/Resources/next_idle.png"
                            }
                        }
                    }
                    onClicked: {
                        audioPlayer.next()
                    }
                }

                RoundButton {
                    id: prevButton
                    anchors.right: playButton.left
                    anchors.rightMargin: 24
                    anchors.verticalCenter: playButton.verticalCenter

                    width: nextButton.width
                    height: width

                    enabled: audioPlayer.mediaAvailable

                    background: Image {
                        id: bgPrev
                        anchors.fill: parent
                        source: {
                            if (prevButton.pressed)
                            {
                                return "qrc:/Resources/prev_focus.png"
                            }
                            else
                            {
                                return "qrc:/Resources/prev_idle.png"
                            }
                        }
                    }

                    onClicked: {
                        audioPlayer.previous()
                    }
                }
            }

            Rectangle {
                id: dateTime
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: - parent.width / 4
                width: mediaWidget.width
                height: width

                color: "transparent"
                border.color: "transparent"

                Timer {
                    interval: 5000
                    running: true
                    repeat: true
                    onTriggered: {
                        currentTime.text = Qt.formatDateTime(new Date(), "hh:mm")
                        currentDate.text = Qt.formatDateTime(new Date(), "dd - MM - yyyy")
                    }
                }

                Text {
                    id: currentTime
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: - parent.height / 4
                    text: Qt.formatDateTime(new Date(), "hh:mm")
                    font.pixelSize: 128
                    color: "white"
                }

                Text {
                    id: currentDate
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: parent.height / 6
                    text: Qt.formatDateTime(new Date(), "dd - MM - yyyy")
                    font.pixelSize: 64
                    color: "white"
                }
            }
        }
    }

    Component {
        id: appMediaComponent

        Item {
            AudioPlayer {
                id: appMedia
                anchors.fill: parent

                onBackClicked: {
                    stackView.push(mainView)
                }

                onSettingClicked: {
                    stackView.push(setting)
                }
            }
        }
    }

    Component {
        id: setting

        Item {
            MediaAppSetting {
                anchors.fill: parent

                onBackClicked: {
                    appCore.resetMediaDirList()
                    stackView.push(appMediaComponent)
                }

                onSaveClicked: {
                    appCore.saveDirectoriesAndReload()
                    stackView.push(appMediaComponent)
                }
            }
        }
    }

    Component {
        id: videoApp

        Item {
            VideoApp {
                anchors.fill: parent

                onBackClicked: {
                    stackView.push(mainView)
                }
            }
        }
    }
}
