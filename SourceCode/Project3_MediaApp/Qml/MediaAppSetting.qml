import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.13
import QtQuick.Dialogs 1.3

Item {
    signal backClicked()
    signal saveClicked()

    MyButton {
        id: backButton

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 24
        anchors.leftMargin: 24

        height: 48

        buttonText: "BACK"

        onButtonClicked: {
            sourceList.model = null
            backClicked()
        }
    }

    Rectangle {
        id: sourceListArea
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height * 0.6
        color: "transparent"

        ListView {
            id: sourceList
            anchors.fill: sourceListArea

            model: directories

            clip: true

            delegate: Rectangle {
                width: sourceList.width
                height: sourceList.height / 5
                color: "transparent"

                Text {
                    id: dir
                    anchors.fill: parent
                    anchors.rightMargin: parent.width / 4

                    text: sourceDir

                    font.family: "Helvetica"
                    font.pixelSize: 28
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.NoWrap
                    clip: true
                    color: "lightgray"

                }

                Switch {
                    id: status
                    anchors.fill: parent
                    anchors.leftMargin: parent.width * 0.75
                    height: 24
                    width: 24
                    checked: enableStatus
                    indicator: Rectangle {
                        implicitWidth: 64
                        implicitHeight: 32
                        anchors.centerIn: parent
                        radius: 16
                        color: status.checked ? "#17a81a" : "white"
                        border.color: status.checked ? "#17a81a" : "#cccccc"
                        border.width: 2

                        Rectangle {
                            x: status.checked ? parent.width - width : 0
                            width: 32
                            height: 32
                            radius: 16
                            color: status.down ? "#cccccc" : "#ffffff"
                            border.color: status.checked ? (status.down ? "#17a81a" : "#21be2b") : "#999999"
                            border.width: 2
                        }
                    }

                    visible: index != 0

                    onCheckedChanged: {
                        directories.setEnableStatus(index, checked)
                    }
                }

                Rectangle {
                    id: breakLine
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    height: 1
                    width: parent.width
                    color: "transparent"
                    LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0,0)
                        end: Qt.point(width, 0)
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0;
                                color: "transparent"
                            }

                            GradientStop {
                                position: 0.5;
                                color: "green"
                            }

                            GradientStop {
                                position: 1.0;
                                color: "transparent"
                            }
                        }
                    }
                }
            }
        }
    }

    MyButton {
        id: addDirButton

        anchors.top: sourceListArea.bottom
        anchors.topMargin: 16
        anchors.left: sourceListArea.left

        width: 160
        height: 48

        buttonText: "ADD A SOURCE"

        onButtonClicked: {
            folderDialog.active = true
        }
    }

    Loader {
        id: folderDialog
        x: 320
        y: 140
        source: "qrc:/Qml/FolderBrowser.qml"
        active: false
    }

    Connections {
        target: folderDialog.item

        onSelected: {
            if(url != "")
            {
                directories.addMediaDir(url)
            }
            folderDialog.active = false
        }

        onCanceled: {
            folderDialog.active = false
        }
    }



    MyButton {
        id: loadDefaultButton

        anchors.top: addDirButton.top
        anchors.bottom: addDirButton.bottom
        anchors.left: addDirButton.right
        anchors.leftMargin: 32

        width: addDirButton.width
        height: addDirButton.height

        buttonText: "DEFAULT"

        onButtonClicked: {
            sourceList.model = null
            directories.loadDefault()
            sourceList.model = directories
        }
    }

    MyButton {
        id: saveButton

        anchors.top: addDirButton.top
        anchors.right: sourceListArea.right

        buttonText: "SAVE & EXIT"

        width: addDirButton.width
        height: addDirButton.height

        onButtonClicked: {
            sourceList.model = null
            saveClicked()
        }
    }
}
