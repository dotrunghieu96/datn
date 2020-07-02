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
                anchors.left: parent.left
                anchors.leftMargin: 86
                anchors.verticalCenter: parent.verticalCenter
                onOpenApp: {
                    stackView.push(audioApp)
                }
            }

            Rectangle {
                id: videoWidget
                anchors.right: parent.right
                anchors.rightMargin: 86
                width: 512
                height: width
                anchors.verticalCenter: parent.verticalCenter
                color: "lightsteelblue"
                Text {
                    anchors.centerIn: parent
                    text: "open VideoApp"
                }

                border.color: "green"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        stackView.push(videoApp)
                    }
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
