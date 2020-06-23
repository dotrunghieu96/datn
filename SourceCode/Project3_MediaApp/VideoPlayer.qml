import QtQuick 2.12
import QtMultimedia 5.12
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13

Item {
    id: root
    property string videoSource

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
            onStarted: {
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
                video.seek(video.position - 5000)
            }
            else
            {
                console.debug("right double touch")
                video.seek(video.position + 5000)
            }
        }
    }


    function play(){
        controlFade.stop()
        video.play()
        controlTimer.start()
        console.log("play: " + videoSource)
    }

    function stop() {
        video.stop()
        console.log("video stop")
    }
}
