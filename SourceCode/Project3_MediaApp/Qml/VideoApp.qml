import QtQuick 2.12
import QtMultimedia 5.12
import QtGraphicalEffects 1.0

Item {
    id: root
    signal backClicked()

    Component.onCompleted: {
        slideIn.stop()
        slideOut.stop()
    }

    MyButton {
        id: backButton

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 24
        anchors.leftMargin: 24

        buttonText: "HOME"

        onButtonClicked: {
            backClicked()
        }
    }


//    ListModel {
//        id: videoPlaylist

//        ListElement {
//            videoSrc: "C:/Users/dotru/Videos/Captures/Hollow_Knight.mp4"
//            title: "Hollow Knight"
//        }

//        ListElement {
//            videoSrc: "C:/Users/dotru/Videos/Captures/Hollow_Knight_Copy.mp4"
//            title: "Hollow Knight"
//        }

//        ListElement {
//            videoSrc: "C:/Users/dotru/Videos/Captures/Hollow_Knight_Copy_1.mp4"
//            title: "Hollow Knight"
//        }

//        ListElement {
//            videoSrc: "C:/Users/dotru/Videos/Captures/Hollow_Knight_Copy_2.mp4"
//            title: "Hollow Knight"
//        }
//    }

    Rectangle {
        id: videoGrid
        anchors.top: backButton.bottom
        anchors.topMargin: 64
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 32
        anchors.right: parent.right
        color: "transparent"

        Component {
            id: videoDelegate
            Item {
                id: delegateItem
                width: 384
                height: 280

                Rectangle {
                    id: thumbnail
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: 384
                    height: 216
                    radius: 5

                    color: "transparent"

                    Image {
                        anchors.fill: parent
                        source: "qrc:/Resources/video_thumbnail.png"

                        TapHandler {
                            acceptedDevices: PointerDevice.TouchScreen
                            onTapped: {
                                player.videoSource = videoSrc
                                backButton.enabled = false
                                videoGrid.enabled = false
                                slideIn.restart()
                            }
                        }

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
                                backButton.enabled = false
                                videoGrid.enabled = false
                                slideIn.restart()
                            }
                        }
                    }
                }


                Text {
                    text: title
                    height: 48
                    width: thumbnail.width
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    anchors.top: thumbnail.bottom
                    anchors.topMargin: 4
                    font.bold: true
                    font.family: "Helvetica"
                    font.pixelSize: 28
                    fontSizeMode: Text.Fit
                    color: "white"
                }

                Image {
                    id: playingState
                    height: 36
                    width: 36
                    anchors.right: thumbnail.right
                    anchors.top: thumbnail.bottom
                    anchors.topMargin: 4

                    source: {
                        if (player.videoSource == videoSrc
                            && player.isPausing == true)
                        {
                            return "qrc:/Resources/video_state_pause.png"
                        }
                        else
                        {
                            return ""
                        }
                    }
                }

            }
        }

        GridView {
            id: grid
            anchors.fill: parent
            cellWidth: 416
            cellHeight: 280
            clip: true
            model: videoPlaylist
            delegate: videoDelegate
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
                    console.log("video visible: " + player.visible)
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

                onFinished: {
                    videoGrid.enabled = true
                    backButton.enabled = true
                }
            }

            onBackClicked: {
                slideOut.restart()
            }

            onVideoStopped: {
                console.log("video stopped")
            }
        }
    }
}
