import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Item {

    signal openApp()
    width: 600
    height: 216

    Rectangle {
        id: mediaWidget

        //        border.color: "green"

        anchors.fill: parent

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
            id: albumArt

            anchors.top: parent.top
            anchors.left: parent.left
            height: parent.height
            width: height
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
                maskSource: albumArt
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
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16

            text: playlist.data(playlist.index(audioPlayer.nowPlayingIndex, 0), 257)
            clip: true

            font.family: "Helvetica"
            font.bold: true
            font.pixelSize: 32
            fontSizeMode: Text.Fit
//            wrapMode: Text.WordWrap
            color: "white"
        }


        MouseArea {
            id:openMediaApp
            anchors.fill: parent

            onClicked: {
                openApp()
            }
        }

        Rectangle {
            id: controller
            anchors.fill: parent
            anchors.leftMargin: albumArt.width
//            border.color: "blue"
            color: "transparent"

            RoundButton {
                id: playButton
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -24
                width: 128
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

                width: 96
                height: width

                //                opacity: 0.5

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

                //                opacity: 0.5

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

    }
}
