import QtQuick
import "root:/"

Rectangle {
    id: ghostButton

    property string text: ""
    property string icon: ""
    property color iconColor: Theme.text
    property color textColor: Theme.text
    property int iconSize: 14
    property int fontSize: 14
    signal clicked()

    width: 100
    height: 45


    radius: 8
    color: mouseArea.containsMouse ?  Theme.surface0 : "transparent"

    Behavior on border.color {
        ColorAnimation { duration: Config.animationDuration }
    }

    Item {
        anchors.centerIn: parent
        width: childrenRect.width
        height: ghostButton.height

        Row {
            anchors.centerIn: parent
            spacing: ghostButton.text.length > 0 && ghostButton.icon.length > 0 ? 10 : 0

            Text {
                text: ghostButton.icon
                color: ghostButton.iconColor
                font.pixelSize: ghostButton.iconSize
                font.family: Config.moduleFontFamily
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                visible: ghostButton.icon.length > 0
            }

            Text {
                text: ghostButton.text
                color: ghostButton.textColor
                font.pixelSize: ghostButton.fontSize
                font.family: Config.moduleFontFamily
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                visible: ghostButton.text.length > 0
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: ghostButton.clicked()
    }
}
