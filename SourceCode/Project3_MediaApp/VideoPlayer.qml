import QtQuick 2.0
import QtMultimedia 5.12

Item {
    property string videoSource

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        Video {
            id: video
            source: videoSource
            anchors.fill: parent


            transitions: [
                Transition {
                    ParallelAnimation {
                        PropertyAnimation {
                            property: "width"
                            easing.type: Easing.Linear
                            duration: 250
                        }
                        PropertyAnimation {
                            property: "height"
                            easing.type: Easing.Linear
                            duration: 250
                        }
                    }
                }
            ]
        }
    }

    function goFullScreen(){
        video.play()
        console.log("------------------------play")
    }
}
