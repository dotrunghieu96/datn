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


    ListModel {
        id: videoPlaylist

        ListElement {
            source: "C:/Users/dotru/Videos/Captures/Hollow_Knight.mp4"
            title: "Hollow Knight"
        }

        ListElement {
            source: "C:/Users/dotru/Videos/Captures/Hollow_Knight_Copy.mp4"
            title: "Hollow Knight"
        }

        ListElement {
            source: "C:/Users/dotru/Videos/Captures/Hollow_Knight.mp4"
            title: "Hollow Knight"
        }

        ListElement {
            source: "C:/Users/dotru/Videos/Captures/Hollow_Knight.mp4"
            title: "Hollow Knight"
        }
    }

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
                width: grid.cellWidth
                height: grid.cellHeight

                Rectangle {
                    id: thumbnail
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: 384
                    height: 216
                    radius: 5

                    Image {
                        anchors.fill: parent
                        source: "qrc:/Resources/video_thumbnail.png"

                        OpacityMask {
                            source: mask
                            maskSource: thumbnail
                        }

                        LinearGradient {
                            id: mask
                            anchors.fill: parent
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "transparent"}
                                GradientStop { position: 1.0; color: "black" }
                            }
                        }

                        TapHandler {
                            acceptedDevices: PointerDevice.TouchScreen
                            onTapped: {
                                console.log("tapped")
                                backButton.visible = false
                                videoGrid.enabled = false
                                player.videoSource = source
                                player.play()
                            }
                        }


                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                player.videoSource = source
                                backButton.enabled = false
                                videoGrid.enabled = false
                                slideIn.restart()
                            }
                        }
                    }
                }


                Text {
                    text: title
                    height: 36
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    anchors.bottom: thumbnail.bottom
                    anchors.bottomMargin: 4
                    font.bold: true
                    font.family: "Helvetica"
                    font.pixelSize: 28
                    fontSizeMode: Text.Fit
                    color: "white"
                }

            }
        }

        GridView {
            id: grid
            anchors.fill: parent
            cellWidth: 416
            cellHeight: 260
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
                player.stop()
                slideOut.restart()
            }

            onVideoStopped: {
                slideOut.restart()
            }
        }
    }
}
