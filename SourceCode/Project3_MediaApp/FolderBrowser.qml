import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQml.Models 2.13

Item {

    signal selected(string url)
    signal canceled()



    Rectangle {
        id: bg
        width: 640
        height: 440
        color: "black"

        TreeView {
            id: treeModel
            anchors.fill: parent
            anchors.bottomMargin: 80
            model: fileSystemModel

            headerDelegate: null

            TableViewColumn {
                id: dirRow
                title: "Name"
                role: "fileName"
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

            enabled: treeModel.currentIndex !== -1

            buttonText: "Select"

            onButtonClicked: {
                selected(fileSystemModel.data(treeModel.currentIndex, 257))
            }
        }
    }


}
