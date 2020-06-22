import QtQuick 2.12
import QtMultimedia 5.12

Item {
    signal backClicked()

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
            source: "C:/Users/dotru/Videos/Captures/Hollow_Knight.mp4"
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

                VideoPlayer {
                    id: player
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: 384
                    height: 216
                    videoSource: source

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            player.goFullScreen()
                        }
                    }
                }

                Text {
                    text: title
                    height: 30
                    anchors.left: parent.left
                    anchors.top: player.bottom
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
}
