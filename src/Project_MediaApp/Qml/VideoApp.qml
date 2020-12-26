import QtQuick 2.12
import QtQuick.Controls 2.12
import QtMultimedia 5.12
import QtGraphicalEffects 1.0

Item {
    id: root
    signal backClicked()
    signal startVideo()

    Component.onCompleted: {
        slideIn.stop()
        slideOut.stop()
    }

    Component.onDestruction: {
        lastPlayVideos.destroy()
        player.destroy()
    }

    MyButton {
        id: backButton

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 24
        anchors.leftMargin: 24

        buttonText: "HOME"

        onButtonClicked: {
            lastVideoPreview.source = ""
            player.videoSource = ""
            backClicked()
        }
    }

    DateTimeWidget {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 16
        anchors.rightMargin: 16
    }

    Text {
        id: continuePlayingText
        anchors.top: backButton.bottom
        anchors.topMargin: 64
        anchors.left: backButton.left
        color: "white"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignBottom

        font.pixelSize: 26

        text: "Continue Playing"
    }

    Rectangle {
        id: lastPlayVideos
        anchors.top: backButton.bottom
        anchors.topMargin: 112
        anchors.left: backButton.left
        anchors.right: parent.right
        anchors.rightMargin: 24
        height: 288
        color: "transparent"

        Rectangle {
            id: lastVideo
            anchors.top: lastPlayVideos.top
            anchors.left: lastPlayVideos.left
            height: parent.height
            width: 512

            color: "black"

            OpacityMask {
                source: mask
                maskSource: lastVideo
            }

            LinearGradient {
                id: mask
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent"}
                    GradientStop { position: 1.0; color: "black" }
                }
            }

            Video {
                id: lastVideoPreview
                anchors.fill: parent

                source: mediaPlaybackInfo.lastVideoSource()

                onDurationChanged: {
                    if (source !== "" && duration != 0)
                    {
                        play()
                        seek(mediaPlaybackInfo.lastVideoPosition() * duration / 100)
                        pause()
                    }
                }

                function refresh() {
                    source = mediaPlaybackInfo.lastVideoSource()
                    if (source !== "")
                    {
                        play()
                        seek(mediaPlaybackInfo.lastVideoPosition() * duration / 100)
                        pause()
                    }
                }
            }

            Image {
                anchors.centerIn: parent
                width: 160
                height: width
                opacity: 0.5
                source: {
                    if (playButton.pressed)
                    {
                        playButton.opacity = 1
                        return "qrc:/Resources/play_focus.png"
                    }
                    else
                    {
                        playButton.opacity = 0.5
                        return "qrc:/Resources/play_idle.png"
                    }
                }
            }

            MouseArea {
                id: playButton
                anchors.fill: parent

                onClicked: {
                    if (mediaPlaybackInfo.lastVideoSource() !== "")
                    {
                        player.videoSource = mediaPlaybackInfo.lastVideoSource()
                        player.startPosition = mediaPlaybackInfo.lastVideoPosition()
                        lastVideoPreview.source = ""
                        backButton.enabled = false
                        videoGrid.enabled = false
                        slideIn.restart()
                    }
                }
            }

            Text {
                id: lastVideoName
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                anchors.left: parent.left
                anchors.leftMargin: 8
                width: parent.width

                text: mediaPlaybackInfo.lastVideoName
                clip: true

                font.family: "Helvetica"
                font.bold: true
                font.pixelSize: 26
                wrapMode: Text.WordWrap
                color: "white"
            }

        }

        Rectangle {
            id: secLastVideo
            anchors.top: parent.top
            anchors.left: lastVideo.right
            anchors.leftMargin: 32
            width: 384
            height: width / 16 * 9
            color: "transparent"

            visible: mediaPlaybackInfo.secLastVideoName !== ""
            enabled: visible

            Image {
                id: secVideoThumbnail
                anchors.fill: parent
                source: "qrc:/Resources/video_thumbnail.jpg"

                visible: mediaPlaybackInfo.secLastVideoName !== ""

                MouseArea {
                    id: secMouseArea
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
                        player.videoSource = mediaPlaybackInfo.secLastVideoSource()
                        player.startPosition = 0
                        backButton.enabled = false
                        videoGrid.enabled = false
                        mediaPlaybackInfo.updateLastVideo(mediaPlaybackInfo.secLastVideoSource())
                        slideIn.restart()
                    }
                }
            }
        }

        Text {
            id: secLastVideoName
            anchors.left: secLastVideo.left
            anchors.top: secLastVideo.bottom
            anchors.topMargin: 4
            width: secLastVideo.width

            wrapMode: Text.WordWrap

            font.bold: true
            font.family: "Helvetica"
            font.pixelSize: 16
            color: "white"

            text: mediaPlaybackInfo.secLastVideoName
        }
    }

    Rectangle {
        id: spliter

        anchors.left: lastPlayVideos.left
        anchors.top: lastPlayVideos.bottom
        anchors.topMargin: 24

        height: 1
        width: lastPlayVideos.width

        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0,0)
            end: Qt.point(width, 0)
            gradient: Gradient {
                GradientStop {
                    position: 0.0;
                    color: "black"
                }

                GradientStop {
                    position: 0.25;
                    color: "green"
                }

                GradientStop {
                    position: 0.75;
                    color: "green"
                }

                GradientStop {
                    position: 1.0;
                    color: "black"
                }
            }
        }
    }

    Text {
        id: allVideoText
        anchors.top: spliter.bottom
        anchors.topMargin: 8
        anchors.left: backButton.left
        color: "white"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        font.pixelSize: 26

        text: "All Videos"
    }

    Rectangle {
        id: videoGrid
        anchors.top: lastPlayVideos.bottom
        anchors.topMargin: 82
        anchors.bottom: parent.bottom
        anchors.left: backButton.left
        anchors.right: parent.right
        color: "transparent"

        Component {
            id: videoDelegate
            Item {
                id: delegateItem
                width: 256+32
                height: 280

                Rectangle {
                    id: thumbnail
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: 256
                    height: width / 16 * 9

                    color: "black"

                    Image {
                        anchors.fill: parent
                        source: thumbnailSrc

                        MouseArea {
                            anchors.fill: parent

                            onPressed: {
                                thumbnail.opacity = 0.7
                            }

                            onReleased: {
                                thumbnail.opacity = 1
                            }

                            onCanceled: {
                                thumbnail.opacity = 1
                            }

                            onClicked: {
                                player.videoSource = videoSrc
                                player.startPosition = 0
                                backButton.enabled = false
                                videoGrid.enabled = false
                                mediaPlaybackInfo.updateLastVideo(videoSrc)
                                slideIn.restart()
                            }
                        }
                    }
                }


                Text {
                    text: title
                    width: thumbnail.width
                    anchors.left: parent.left
                    anchors.top: thumbnail.bottom
                    anchors.topMargin: 4
                    font.bold: true
                    font.family: "Helvetica"
                    font.pixelSize: 16
                    wrapMode: Text.WordWrap
                    color: "white"
                }
            }
        }

        ListView {
            id: grid
            anchors.fill: parent
            anchors.rightMargin: 24
            anchors.bottomMargin: 16
            orientation: Qt.Horizontal
            clip: true
            model: videoPlaylist
            delegate: videoDelegate

            ScrollBar.horizontal: ScrollBar {
                id: hBar
                active: true
                width: parent.width
            }
        }
    }

    Rectangle {
        id: playerBase
        width: root.width
        height: root.height
        x: parent.width
        y: 0

        color: "black"

        VideoPlayer {
            id: player
            anchors.fill: parent

            videoSource: ""

            z: playerBase.z + 1

            NumberAnimation {
                id: slideIn
                target: playerBase
                property: "x"
                from: root.width
                to: 0
                duration: 500
                easing.type: Easing.InOutQuad

                onFinished: {
                    startVideo()
                    player.play()
                }
            }

            NumberAnimation {
                id: slideOut
                target: playerBase
                property: "x"
                from: 0
                to: root.width
                duration: 500
                easing.type: Easing.InOutQuad

            }

            onBackClicked: {
                slideOut.restart()
                videoGrid.enabled = true
                backButton.enabled = true
                player.videoSource = ""
                lastVideoPreview.refresh()
                appCore.writePlaybackInfoToFile()
            }

            onNextVideo: {
                if (player.videoSource == "")
                {
                    console.log("do nothing")
                }
                else
                {
                    if (videoPlaylist.nowPlayingIndex === videoPlaylist.rowCount() - 1)
                    {
                        player.videoSource = videoPlaylist.data(videoPlaylist.index(0,0), 258)
                    }
                    else
                    {
                        player.videoSource = videoPlaylist.data(videoPlaylist.index(videoPlaylist.nowPlayingIndex + 1,0), 258)
                    }
                    console.log("request next video: " + player.videoSource)
                    mediaPlaybackInfo.updateLastVideo(player.videoSource)
                    startVideo()
                    player.play()
                }
            }

            onPrevVideo: {
                if (player.videoSource == "")
                {
                    console.log("do nothing")
                }
                else
                {
                    if (videoPlaylist.nowPlayingIndex === 0)
                    {
                        player.videoSource = videoPlaylist.data(videoPlaylist.index(videoPlaylist.rowCount() - 1,0), 258)
                    }
                    else
                    {
                        player.videoSource = videoPlaylist.data(videoPlaylist.index(videoPlaylist.nowPlayingIndex - 1,0), 258)
                    }
                    console.log("request prev video: " + player.videoSource)
                    mediaPlaybackInfo.updateLastVideo(player.videoSource)
                    startVideo()
                    player.play()
                }
            }
        }
    }
}
