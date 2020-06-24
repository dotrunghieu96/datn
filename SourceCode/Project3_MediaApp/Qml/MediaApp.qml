import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    id: root

    SwipeView {
        id: view

        currentIndex: 1
        anchors.fill: parent

        AudioPlayer {

        }
    }
}
