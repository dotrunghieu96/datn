import QtQuick 2.12
import QtMultimedia 5.12
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13

Item {
    id: root
    property string videoSource
    property int startPosition: 0
    property bool isPausing: video.playbackState == MediaPlayer.PausedState
    property int countDown: 5

    signal nextVideo()
    signal backClicked()
    signal prevVideo()

    onVideoSourceChanged: {
        video.source = videoSource
        videoPlaylist.setNowPlayingIndex(videoSource)
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        Video {
            id: video
            anchors.fill: parent
            onPlaybackStateChanged: {
                isPausing = video.playbackState == MediaPlayer.PausedState
                if (video.playbackState == MediaPlayer.StoppedState)
                {
                    controlFade.stop()
                    countDown = 5
                    nextVideoTimer.start()
                }
                controlTimer.restart()
            }
        }
    }

    Timer {
        id: nextVideoTimer
        repeat: countDown != 0
        interval: 1000
        triggeredOnStart: false

        onTriggered: {
            if (countDown != 0)
            {
                countDownText.text = "Next video in " + countDown
                countDown--
            }
            else
            {
                nextVideo()
            }
        }

    }


    Rectangle {
        id: controlWidget
        anchors.fill: parent
        color: "transparent"

        Text {
            id: videoName
            anchors.top: parent.top
            anchors.topMargin: 24
            anchors.horizontalCenter: parent.horizontalCenter
            width: 512
            height: 48
            text: mediaPlaybackInfo.lastVideoName
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.pixelSize: 26
            font.bold: true
        }

        Timer {
            id: controlTimer
            interval: 5000
            repeat: false
            triggeredOnStart: false
            onTriggered: {
                if (video.playbackState == MediaPlayer.PlayingState)
                {
                    controlFade.restart()
                }
            }
        }

        Text {
            id: countDownText
            anchors.horizontalCenter: playButton.horizontalCenter
            anchors.top: playButton.bottom
            anchors.topMargin: 32

            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.pixelSize: 26
        }

        NumberAnimation {
            id: controlFade
            target: controlWidget
            property: "opacity"
            from: 1
            to: 0
            duration: 500
            easing.type: Easing.Linear
            onFinished: {
                controlWidget.enabled = false
            }
        }

        MyButton {
            id: backButton

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 24
            anchors.leftMargin: 24

            buttonText: "BACK"

            onButtonClicked: {
                if (video.position != video.duration)
                {
                    mediaPlaybackInfo.setLastVideoPosition(video.position * 100 / video.duration)
                }
                else
                {
                    mediaPlaybackInfo.setLastVideoPosition(0)
                }
                backClicked()
                nextVideoTimer.stop()
                countDownText.text = ""
                video.pause()
                controlFade.stop()
                controlWidget.opacity = 1
                controlWidget.enabled = false
                controlTimer.restart()
                controlTimer.stop()
            }
        }

        RoundButton {
            id: playButton
            anchors.centerIn: parent
            width: 160
            height: width

            background: Image {
                id: bgPlay
                anchors.fill: parent
                source: {
                    if (video.playbackState == MediaPlayer.PlayingState)
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
                    else if (video.playbackState == MediaPlayer.PausedState)
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
                    else
                    {
                        if (playButton.pressed)
                        {
                            return "qrc:/Resources/replay_focus.png"
                        }
                        else
                        {
                            return "qrc:/Resources/replay_idle.png"
                        }
                    }
                }
            }

            onClicked: {
                if (video.playbackState == MediaPlayer.PlayingState)
                {
                    video.pause()
                }
                else if (video.playbackState == MediaPlayer.PausedState)
                {
                    video.play()
                }
                else
                {
                    nextVideoTimer.stop()
                    countDownText.text = ""
                    video.seek(0)
                    video.play()
                }
            }
        }

        RoundButton {
            id: nextButton
            anchors.left: playButton.right
            anchors.leftMargin: 32
            anchors.verticalCenter: playButton.verticalCenter

            width: 128
            height: width

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
                nextVideo()
            }
        }

        RoundButton {
            id: prevButton
            width: nextButton.width
            height: width
            anchors.right: playButton.left
            anchors.rightMargin: 32
            anchors.verticalCenter: playButton.verticalCenter

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
                prevVideo()
            }
        }


        TextField {
            id: videoPosition
            anchors.top: timeSlider.top
            anchors.right: timeSlider.left

            width: 128
            height: 64

            text: audioPlayer.getTimeString(video.position)
            horizontalAlignment: TextInput.AlignRight
            enabled: false
            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
            }
            color:  "white"

            font.family: "Helvetica"
            font.pixelSize: 32

        }

        TextField {
            id: videoDuration
            anchors.top: videoPosition.top
            anchors.left: timeSlider.right
            width: 128
            height: 64

            text: audioPlayer.getTimeString(video.duration)
            enabled: false
            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
            }
            color:  "white"
            font.family: "Helvetica"
            font.pixelSize: 32
        }

        Slider {
            id: timeSlider
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 64
            width: 960
            height: 64

            from: 0

            background: Rectangle {
                x: timeSlider.leftPadding
                y: timeSlider.topPadding + timeSlider.availableHeight / 2 - height / 2
                implicitWidth: timeSlider.width
                implicitHeight: 8
                width: timeSlider.availableWidth
                height: implicitHeight
                radius: 4
                color: "#bdbebf"

                Rectangle {
                    width: timeSlider.visualPosition * parent.width
                    height: parent.height
                    radius: 4
                    color: "#21be2b"
                }
            }

            handle: Rectangle {
                x: timeSlider.visualPosition * (timeSlider.availableWidth - width / 2)
                y: timeSlider.topPadding + timeSlider.availableHeight / 2 - height / 2
                implicitWidth: 24
                implicitHeight: 24
                radius: 12
                color: timeSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                border.color: "#bdbebf"
            }

            value: video.position
            to: video.duration

            onMoved: {
                nextVideoTimer.stop()
                countDownText.text = ""
                controlFade.stop()
                controlWidget.opacity = 1
                controlWidget.enabled = true
                controlTimer.stop()
                video.seek(timeSlider.position * video.duration)
                video.play()
                controlTimer.restart()
            }
        }


    }

    TapHandler {
        onTapped: {
            controlFade.stop()
            controlWidget.opacity = 1
            controlWidget.enabled = true
            controlTimer.restart()
        }

        onDoubleTapped: {
            if (eventPoint.scenePosition.x < root.width / 2)
            {
                video.seek(video.position - 10000)
            }
            else
            {
                video.seek(video.position + 10000)
            }
        }
    }

    function play() {
        video.play()
        nextVideoTimer.stop()
        countDownText.text = ""
        controlFade.stop()
        video.seek(startPosition * video.duration / 100)
        controlWidget.opacity = 1
        controlWidget.enabled = true
        controlTimer.restart()

    }

    function stop() {
        video.pause()
    }
}
