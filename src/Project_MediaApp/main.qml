import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import "./Qml"

Window {
    visible: true
    width: 1280
    height: 720
    flags: Qt.FramelessWindowHint

    Component.onDestruction: {
        appCore.writePlaybackInfoToFile()
    }

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

    Component {
        id: mainView
        Item {
            DateTimeWidget {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 16
                anchors.rightMargin: 16
            }

            AudioWidget {
                id: audioWidget
                x: 20
                y: 72
                onOpenApp: {
                    stackView.push(audioApp)
                }
            }

            Rectangle {
                id: videoWidget
                width: 600
                height: 216

                anchors.left: audioWidget.left
                anchors.top: audioWidget.bottom
                anchors.topMargin: 40
                color: "transparent"
//                border.color: "green"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        stackView.push(videoApp)
                    }
                }

                Image {
                    id: videoIcon

                    anchors.top: parent.top
                    anchors.left: parent.left
                    height: parent.height
//                    width: height
//                    clip: true
                    fillMode: Image.PreserveAspectFit

                    source: "qrc:/Resources/video-icon.png"

//                    OpacityMask {
//                        source: mask
//                        maskSource: albumArt
//                    }


                }

                LinearGradient {
                    id: mask
                    anchors.fill: parent
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "transparent"}
                        GradientStop { position: 1.0; color: "black" }
                    }
                }

                Text {
                    id: videoButtonTitle
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8
                    anchors.left: videoIcon.right
                    anchors.leftMargin: 16

                    text: "Video Player"
                    clip: true

                    font.family: "Helvetica"
                    font.bold: true
                    font.pixelSize: 32
                    fontSizeMode: Text.Fit
        //            wrapMode: Text.WordWrap
                    color: "white"
                }
            }
        }
    }

    Component {
        id: audioApp

        Item {
            AudioApp {
                id: appMedia
                anchors.fill: parent

                onBackClicked: {
                    stackView.push(mainView)
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

                onStartVideo: {
                    if (audioPlayer.isPlaying)
                    {
                        audioPlayer.togglePlay()
                    }
                }
            }
        }
    }
}
