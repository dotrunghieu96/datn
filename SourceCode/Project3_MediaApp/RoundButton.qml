import QtQuick 2.0

Item {
    signal clicked()
    property string borderColor: ""

    Rectangle {
        radius: width / 2
        border.color: borderColor

        MouseArea {
            anchors.fill: parent
            onClicked: {
                clicked()
            }
        }
    }
}
