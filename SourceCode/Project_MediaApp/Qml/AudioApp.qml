import QtQuick 2.0
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13

Item {
    signal backClicked()
    signal settingClicked()

    MyButton {
        id: backButton

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 24
        anchors.leftMargin: 24

        buttonText: "HOME"

        onButtonClicked: {
            backClicked()
            playlistBrowser.interactive = false
        }
    }

    DateTimeWidget {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 16
        anchors.rightMargin: 16
    }

    ListModel {
        id: pathViewModel
        ListElement {
            artSrc: "qrc:/Resources/album_art.png"
        }
        ListElement {
            artSrc: "qrc:/Resources/album_art.png"
        }
        ListElement {
            artSrc: "qrc:/Resources/album_art.png"
        }
    }

    Rectangle {
        id: pathViewArea
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 32
        anchors.bottom: currentSongTitle.bottom
        anchors.bottomMargin: 64
        height: 336
        width: height

        color: "transparent"

        PathView {
            id: pathView
            anchors.fill: parent

            interactive: false

            model: pathViewModel

            delegate: Component {
                id: delegate

                Column {
                    id: wrapper
                    width: 336

                    property real angle: PathView.itemAngle
                    scale: PathView.itemScale

                    z: parent.z + PathView.itemZPos

                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        height: width

                        source: artSrc

                        transform: Rotation {
                            origin.x: 168
                            origin.y: 168
                            axis { x: 0; y: 1; z: 0 }
                            angle: wrapper.angle
                        }
                    }
                }
            }

            path: Path {
                startX: 168; startY: 168
                PathAttribute { name: "itemAngle"; value: 1.0}
                PathAttribute { name: "itemScale"; value: 1.0}
                PathAttribute { name: "itemZPos"; value: 1}

                PathLine { x: 480; y: 168 }
                PathPercent { value: 1 / 3}
                PathAttribute { name: "itemAngle"; value: 36}
                PathAttribute { name: "itemScale"; value: 0.6}
                PathAttribute { name: "itemZPos"; value: 0}

                PathQuad { x: -144; y: 168; controlX: 168; controlY: -250 }
                PathPercent { value: 2 / 3}
                PathAttribute { name: "itemAngle"; value: -36}
                PathAttribute { name: "itemScale"; value: 0.6}
                PathAttribute { name: "itemZPos"; value: 0}

                PathLine { x: 168; y: 168 }
                PathPercent { value: 1}
            }

            Component.onCompleted: {
                if (playlist.rowCount() > 0)
                {
                    pathViewModel.setProperty(0, "artSrc",
                                              playlist.data(playlist.index(audioPlayer.nowPlayingIndex, 0), 260))
                    if (audioPlayer.nowPlayingIndex == playlist.rowCount() - 1)
                    {
                        pathViewModel.setProperty(1, "artSrc",
                                                  playlist.data(playlist.index(0, 0), 260))
                    }
                    else
                    {
                        pathViewModel.setProperty(1, "artSrc",
                                                  playlist.data(playlist.index(audioPlayer.nowPlayingIndex + 1, 0), 260))
                    }

                    if (audioPlayer.nowPlayingIndex == 0)
                    {
                        pathViewModel.setProperty(2, "artSrc",
                                                  playlist.data(playlist.index(playlist.rowCount() - 1, 0), 260))
                    }
                    else
                    {
                        pathViewModel.setProperty(2, "artSrc",
                                                  playlist.data(playlist.index(audioPlayer.nowPlayingIndex - 1, 0), 260))
                    }
                }
            }

            onCurrentIndexChanged: {
                pathViewModel.setProperty(pathView.currentIndex, "artSrc",
                                          playlist.data(playlist.index(audioPlayer.nowPlayingIndex, 0), 260))

                if (pathView.currentIndex == 0)
                {
                    if (playlist.rowCount() > 0 && playlist.rowCount() >  audioPlayer.nowPlayingIndex)
                    {
                        if (audioPlayer.nowPlayingIndex == 0)
                        {
                            pathViewModel.setProperty(pathView.count - 1, "artSrc",
                                                      playlist.data(playlist.index(playlist.rowCount() - 1, 0), 260))
                        }
                        else
                        {
                            pathViewModel.setProperty(pathView.count - 1, "artSrc",
                                                      playlist.data(playlist.index(audioPlayer.nowPlayingIndex - 1, 0), 260))
                        }
                    }
                    else
                    {
                        pathViewModel.setProperty(pathView.count - 1, "artSrc", "qrc:/Resources/album_art.png")
                    }
                }
                else
                {
                    if (playlist.rowCount() > 0 && playlist.rowCount() >  audioPlayer.nowPlayingIndex)
                    {
                        if (audioPlayer.nowPlayingIndex == 0)
                        {
                            pathViewModel.setProperty(pathView.currentIndex - 1, "artSrc",
                                                      playlist.data(playlist.index(playlist.rowCount() - 1, 0), 260))
                        }
                        else
                        {
                            pathViewModel.setProperty(pathView.currentIndex - 1, "artSrc",
                                                      playlist.data(playlist.index(audioPlayer.nowPlayingIndex - 1, 0), 260))
                        }
                    }
                    else
                    {
                        pathViewModel.setProperty(pathView.currentIndex - 1, "artSrc", "qrc:/Resources/album_art.png")
                    }
                }

                if (pathView.currentIndex == pathView.count - 1)
                {
                    if (playlist.rowCount() > 0 && playlist.rowCount() >  audioPlayer.nowPlayingIndex)
                    {
                        if (audioPlayer.nowPlayingIndex == playlist.rowCount() - 1)
                        {
                            pathViewModel.setProperty(0, "artSrc",
                                                      playlist.data(playlist.index(0, 0), 260))
                        }
                        else
                        {
                            pathViewModel.setProperty(0, "artSrc",
                                                      playlist.data(playlist.index(audioPlayer.nowPlayingIndex + 1, 0), 260))
                        }
                    }
                    else
                    {
                        pathViewModel.setProperty(0, "artSrc", "qrc:/Resources/album_art.png")
                    }

                }
                else
                {
                    if (playlist.rowCount() > 0 && playlist.rowCount() >  audioPlayer.nowPlayingIndex)
                    {
                        if (audioPlayer.nowPlayingIndex == playlist.rowCount() - 1)
                        {
                            pathViewModel.setProperty(pathView.currentIndex + 1, "artSrc",
                                                      playlist.data(playlist.index(0, 0), 260))
                        }
                        else
                        {
                            pathViewModel.setProperty(pathView.currentIndex + 1, "artSrc",
                                                      playlist.data(playlist.index(audioPlayer.nowPlayingIndex + 1, 0), 260))
                        }
                    }
                    else
                    {
                        pathViewModel.setProperty(pathView.currentIndex + 1, "artSrc", "qrc:/Resources/album_art.png")
                    }
                }
            }
        }

        Connections {
            target: audioPlayer
            onNexted:{
                if (isNext)
                {
                    pathView.incrementCurrentIndex()
                }
                else
                {
                    pathView.decrementCurrentIndex()
                }
            }
        }
    }

    Text {
        id: currentSongTitle
        anchors.left: timeSlider.left
        anchors.leftMargin: 16
        anchors.bottom: timeSlider.top
        anchors.bottomMargin: 40

        text: playlist.data(playlist.index(audioPlayer.nowPlayingIndex, 0), 257)
        clip: true

        font.family: "Helvetica"
        font.bold: true
        font.pixelSize: 36
        color: "white"
    }

    Text {
        id: currentSinger
        text: playlist.data(playlist.index(audioPlayer.nowPlayingIndex, 0), 258)
        anchors.left: currentSongTitle.left
        anchors.top: currentSongTitle.bottom
        anchors.topMargin: 8

        font.family: "Helvetica"
        font.pixelSize: 24
        color: "lightgray"
    }

    Drawer {
        id: playlistBrowser
        width: parent.width * 0.3
        height: parent.height
        dragMargin: 16

        Rectangle {
            id: playlistArea
            anchors.fill: parent
            color: "black"

            MyButton {
                id: closeDrawer
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 24
                anchors.leftMargin: 24

                height: 48

                buttonText: "HIDE"

                onButtonClicked: {
                    playlistBrowser.close()
                }
            }

            Rectangle {
                id: areaSplit
                anchors.top: closeDrawer.bottom
                anchors.topMargin: 16
                anchors.left: parent.left
                z: mediaList.z + 1

                height: 1
                width: parent.width

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
                            position: 0.5;
                            color: "green"
                        }

                        GradientStop {
                            position: 1.0;
                            color: "black"
                        }
                    }
                }

            }

            ListView {
                id: mediaList
                anchors.fill: parent
                anchors.topMargin: 96
                anchors.bottomMargin: 96

                clip: true

                currentIndex: -1

                model: playlist

                ScrollBar.vertical: ScrollBar {
                    id: vBar
                    height: parent.height
                    interactive: false
                }

                delegate: Rectangle {
                    id: mediaItem
                    width: mediaList.width
                    height: mediaList.height / 6
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    color: "black"

                    Text {
                        id: titleText
                        anchors.top: mediaItem.top
                        anchors.left: mediaItem.left
                        anchors.leftMargin: 8
                        anchors.right: mediaItem.right
                        height: mediaItem.height / 2

                        clip: true
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap

                        font.bold: true
                        font.family: "Helvetica"
                        font.pixelSize: 24
                        fontSizeMode: Text.Fit
                        color: "white"

                        text: title

                    }

                    Text {
                        id: singerText
                        anchors.top: titleText.bottom
                        anchors.left: titleText.left
                        anchors.right: titleText.right

                        clip: true
                        wrapMode: Text.WordWrap
                        verticalAlignment: Text.AlignTop

                        font.family: "Helvetica"
                        font.pixelSize: 16
                        color: "lightgray"

                        text: singer
                    }

                    Rectangle {
                        id: breakLine
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter

                        height: 1
                        width: parent.width

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
                                    position: 0.5;
                                    color: "green"
                                }

                                GradientStop {
                                    position: 1.0;
                                    color: "black"
                                }
                            }
                        }
                    }

                    LinearGradient {
                        id: mask
                        anchors.fill: parent
                        visible: false
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "green"}
                            GradientStop { position: 0.2; color: "transparent"}
                            GradientStop { position: 0.8; color: "transparent"}
                            GradientStop { position: 1.0; color: "green" }
                        }
                    }

                    MouseArea {
                        anchors.fill: mediaItem

                        hoverEnabled: true

                        onPressed: {
                            mask.visible = true
                        }

                        onCanceled: {
                            mask.visible = false
                        }

                        onReleased: {
                            mask.visible = false
                        }

                        onClicked: {
                            mediaList.currentIndex = index
                            audioPlayer.setMedia(index)
                        }
                    }
                }
            }
        }

        onClosed: {
            mediaList.currentIndex = -1
        }
    }

    RoundButton {
        id: playButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        width: 160
        height: width

        background: Image {
            id: bgPlay
            anchors.fill: parent
            source: {
                if (audioPlayer.isPlaying)
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

        enabled: audioPlayer.mediaAvailable

        onClicked: {
            audioPlayer.togglePlay()
        }
    }

    RoundButton {
        id: nextButton
        anchors.left: playButton.right
        anchors.leftMargin: 32
        anchors.verticalCenter: playButton.verticalCenter

        width: 128
        height: width

        enabled: audioPlayer.mediaAvailable

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
            audioPlayer.next()
        }
    }

    RoundButton {
        id: prevButton
        width: nextButton.width
        height: width
        anchors.right: playButton.left
        anchors.rightMargin: 32
        anchors.verticalCenter: playButton.verticalCenter

        enabled: audioPlayer.mediaAvailable

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
            audioPlayer.previous()
        }
    }

    Button {
        id: drawerButton
        width: nextButton.width / 2
        height: width
        anchors.right: prevButton.left
        anchors.rightMargin: 64
        anchors.verticalCenter: playButton.verticalCenter

        background: Image {
            id: bgShuffle
            anchors.fill: parent
            source: {
                if (drawerButton.pressed)
                {
                    return "qrc:/Resources/playlist_focus.png"
                }
                else
                {
                    return "qrc:/Resources/playlist_idle.png"
                }
            }
        }

        onClicked: {
            playlistBrowser.open()
        }
    }

    RoundButton {
        id: repeatButton
        width: nextButton.width
        height: width
        anchors.left: nextButton.right
        anchors.leftMargin: 32
        anchors.verticalCenter: playButton.verticalCenter

        enabled: audioPlayer.mediaAvailable

        background: Image {
            id: bgRepeat
            source: {
                if (audioPlayer.playbackMode === 1)
                {
                    if (repeatButton.pressed)
                    {
                        return "qrc:/Resources/repeat_none_focus.png"
                    }
                    else
                    {
                        return "qrc:/Resources/repeat_none_idle.png"
                    }
                }
                else if (audioPlayer.playbackMode === 2)
                {
                    if (repeatButton.pressed)
                    {
                        return "qrc:/Resources/repeat_all_focus.png"
                    }
                    else
                    {
                        return "qrc:/Resources/repeat_all_idle.png"
                    }
                }
                else
                {
                    if (repeatButton.pressed)
                    {
                        return "qrc:/Resources/repeat_one_focus.png"
                    }
                    else
                    {
                        return "qrc:/Resources/repeat_one_idle.png"
                    }
                }
            }
        }

        onClicked: {
            audioPlayer.switchPlaybackMode()
        }
    }

    TextField {
        id: mediaPosition
        anchors.bottom: playButton.top
        anchors.bottomMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 32

        width: 128
        height: 64

        text: audioPlayer.getTimeString(audioPlayer.position)
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
        id: mediaDuration
        anchors.top: mediaPosition.top
        anchors.right: parent.right
        anchors.rightMargin: 32

        width: 128
        height: 64

        text: audioPlayer.getTimeString(audioPlayer.duration)
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
        anchors.left: mediaPosition.right
        anchors.verticalCenter: mediaPosition.verticalCenter
        anchors.right: mediaDuration.left

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

        value: audioPlayer.position
        to: audioPlayer.duration

        onMoved: {
            audioPlayer.setPositionByPercent(timeSlider.position * 100)
        }
    }
}
