import QtQuick 2.0

Item {
    id: root
    height: 24
    width: 80
    Text {
        id: currentTime
        width: parent.width / 2
        height: parent.height
        anchors.fill: parent
        text: Qt.formatDateTime(new Date(), "hh:mm")
        font.pixelSize: 20
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignTop
        color: "white"
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            currentTime.text = Qt.formatDateTime(new Date(), "hh:mm")
        }
    }

}
