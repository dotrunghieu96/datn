import QtQuick 2.12
import QtMultimedia 5.12
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13

Item {
    id: root
    property string videoSource
    property bool isLongPressLeft: false
    property bool isLongPressright: false
    property bool isPausing: video.playbackState == MediaPlayer.PausedState

    signal videoStopped()
    signal backClicked()

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        Video {
            id: video
            source: videoSource
            anchors.fill: parent
            onStopped: {
                videoStopped()
            }
            onPlaybackStateChanged: {
                console.log(playbackState)
                isPausing = video.playbackState == MediaPlayer.PausedState
                console.log(isPausing)
            }
        }
    }

    Rectangle {
        id: controlWidget
        anchors.fill: parent
        color: "transparent"

        Timer {
            id: controlTimer
            interval: 5000
            repeat: false
            triggeredOnStart: false
            onTriggered: {
                controlFade.restart()
            }
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
                video.pause()
                console.log("pausing: " + isPausing)
                controlFade.stop()
                controlWidget.opacity = 1
                controlWidget.enabled = true
                controlTimer.restart()
                controlTimer.stop()
                backClicked()
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
                if (video.playbackState == MediaPlayer.PlayingState)
                {
                    video.pause()
                }
                else
                {
                    video.play()
                }
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
                controlFade.stop()
                controlWidget.opacity = 1
                controlWidget.enabled = true
                controlTimer.stop()
                video.seek(timeSlider.position * video.duration)
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
                console.debug("left double touch")
                video.seek(video.position - 10000)
            }
            else
            {
                console.debug("right double touch")
                video.seek(video.position + 10000)
            }
        }
    }


    function play(){
        if (audioPlayer.isPlaying)
        {
            audioPlayer.togglePlay()
        }

        controlFade.stop()
        video.play()
        controlWidget.opacity = 1
        controlWidget.enabled = true
        controlTimer.restart()
        console.log("play: " + videoSource)

    }

    function stop() {
        video.pause()
        console.log("video stop")
    }
}
