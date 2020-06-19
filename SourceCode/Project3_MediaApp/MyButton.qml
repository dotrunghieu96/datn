import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    signal buttonClicked()

    property string buttonText: ""

    RoundButton {
        id: root
        width: 160
        height: 48
        radius: 24

        background: Rectangle {
            id: bg
            anchors.fill: parent
            radius: parent.radius
            border.color: "green"
            border.width: 2
            color: "transparent"

            Text {
                anchors.fill: parent
                text: buttonText

                color: "white"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                font.family: root.font.family
                font.pixelSize: 20
            }
        }

        onPressed: {
            bg.color = "gray"
        }

        onReleased: {
            bg.color = "transparent"
        }

        onClicked: {
            buttonClicked()
        }
    }
}
