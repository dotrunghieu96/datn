import QtQuick 2.13
import QtQuick.Controls 1.4
import QtQml.Models 2.13
import Qt.labs.folderlistmodel 2.0

Item {
    id: root
    width: 640
    height: 440
    signal selected(string url)
    signal canceled()

    property int itemHeight: Math.min(parent.width, parent.height) / 15
    property bool showFocusHighlight: false
    property variant folders: folders1
    property variant view: view1
    property alias folder: folders1.folder
    property color textColor: "white"

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "black"

        SystemPalette {
            id: palette
        }


        FolderListModel {
            id: folders1
            folder: "file:///"
        }

        Rectangle {
            id: titleBar
            width: parent.width
            height: 36
            anchors.top: parent.top
            anchors.left: parent.left
            color: "black"

            Rectangle {
                width: parent.width;
                height: titleBar.height
                color: "#212121"
                anchors.margins: 5
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                Rectangle {
                    id: upButton
                    width: titleBar.height
                    height: titleBar.height
                    color: "transparent"
                    Image {
                        anchors.fill: parent
                        clip: true
                        source: "qrc:/Resources/up.png"
                    }
                    MouseArea { id: upRegion; anchors.centerIn: parent
                        anchors.fill: parent
                        onClicked: up()
                    }
                    states: [
                        State {
                            name: "pressed"
                            when: upRegion.pressed
                            PropertyChanges { target: upButton; color: palette.highlight }
                        }
                    ]
                }

                Text {
                    anchors.left: upButton.right;
                    anchors.right: parent.right;
                    height: titleBar.height
                    anchors.leftMargin: 5; anchors.rightMargin: 5
                    text: folders.folder
                    color: "white"
                    elide: Text.ElideLeft;
                    horizontalAlignment: Text.AlignLeft;
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 16
                }
            }
        }

        Component {
            id: folderDelegate

            Rectangle {
                id: wrapper
                function launch() {
                    var path = "file://";
                    if (filePath.length > 2 && filePath[1] === ':') // Windows drive logic, see QUrl::fromLocalFile()
                        path += '/';
                    path += filePath;
                    if (folders.isFolder(index))
                        down(path);
                    else
                        fileBrowser.selectFile(path)
                }
                width: bg.width
                height: folderImage.height
                color: "transparent"
                visible: folders.isFolder(index)
                Rectangle {
                    id: highlight
                    visible: false
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    color: "#212121"
                }

                Item {
                    id: folderImage
                    width: itemHeight
                    height: itemHeight
                    Image {
                        id: folderPicture
                        source: "qrc:/Resources/folder.png"
                        width: itemHeight * 0.9
                        height: itemHeight * 0.9
                        anchors.left: parent.left
                        anchors.margins: 5
//                        visible: folders.isFolder(index)
                    }
                }

                Text {
                    id: nameText
                    anchors.fill: parent;
                    verticalAlignment: Text.AlignVCenter
                    text: fileName
                    anchors.leftMargin: itemHeight + 10
                    color: (wrapper.ListView.isCurrentItem && bg.showFocusHighlight) ? palette.highlightedText : textColor
                    elide: Text.ElideRight
                }

                MouseArea {
                    id: mouseRegion
                    anchors.fill: parent
                    onPressed: {
                        root.showFocusHighlight = false;
                        wrapper.ListView.view.currentIndex = index;
                    }
                    onClicked: { if (folders === wrapper.ListView.view.model) launch() }
                }

                states: [
                    State {
                        name: "pressed"
                        when: mouseRegion.pressed
                        PropertyChanges { target: highlight; visible: true }
                        PropertyChanges { target: nameText; color: palette.highlightedText }
                    }
                ]
            }
        }

        ListView {
            id: view1
            anchors.fill: parent
            anchors.topMargin: titleBar.height + 8
            model: folders1
            delegate: folderDelegate
            highlight: Rectangle {
                color: "#212121"
                visible: bg.showFocusHighlight && view1.count != 0
                width: view1.currentItem == null ? 0 : view1.currentItem.width
            }
            highlightMoveVelocity: 1000
            pressDelay: 100
            focus: true
            state: "current"
            states: [
                State {
                    name: "current"
                    PropertyChanges { target: view1; x: 0 }
                },
                State {
                    name: "exitLeft"
                    PropertyChanges { target: view1; x: -root.width }
                },
                State {
                    name: "exitRight"
                    PropertyChanges { target: view1; x: root.width }
                }
            ]
            transitions: [
                Transition {
                    to: "current"
                    SequentialAnimation {
                        NumberAnimation { properties: "x"; duration: 250 }
                    }
                },
                Transition {
                    NumberAnimation { properties: "x"; duration: 250 }
                    NumberAnimation { properties: "x"; duration: 250 }
                }
            ]
        }
    }

    MyButton {
        id: btnCancel
        anchors.bottom: bg.bottom
        anchors.bottomMargin: 16
        anchors.right: bg.right
        anchors.rightMargin: 16

        height: 48
        width: 160

        buttonText: "Cancel"

        onButtonClicked: {
            canceled()
        }
    }

    MyButton {
        id: btnSelect
        anchors.bottom: btnCancel.bottom
        anchors.right: btnCancel.left
        anchors.rightMargin: 16

        height: 48
        width: 160

        enabled: true

        buttonText: "Select"

        onButtonClicked: {
            selected(fileSystemModel.data(treeModel.currentIndex, 257))
        }
    }

    function down(path) {
        if (folders == folders1) {
            view = view2
            folders = folders2;
            view1.state = "exitLeft";
        } else {
            view = view1
            folders = folders1;
            view2.state = "exitLeft";
        }
        view.x = root.width;
        view.state = "current";
        view.focus = true;
        folders.folder = path;
    }

    function up() {
        var path = folders.parentFolder;
        if (path.toString().length === 0 || path.toString() === 'file:')
            return;
        if (folders == folders1) {
            view = view2
            folders = folders2;
            view1.state = "exitRight";
        } else {
            view = view1
            folders = folders1;
            view2.state = "exitRight";
        }
        view.x = -root.width;
        view.state = "current";
        view.focus = true;
        folders.folder = path;
    }
}



