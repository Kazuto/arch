import QtQuick
import "root:/"

Rectangle {
    implicitWidth: githubText.implicitWidth + Config.moduleHorizontalPadding
    implicitHeight: Config.barHeight
    color: githubMouseArea.containsMouse ? Config.moduleHoverBackground : Config.moduleBackground
    radius: Config.moduleRadius

    Behavior on color {
        ColorAnimation { duration: Config.animationDuration }
    }

    Text {
        id: githubText
        anchors.centerIn: parent
        text: Icon.github + " " + "0"  // TODO: Get from GitHub API
        color: Theme.mauve
        font.pixelSize: Config.moduleFontSize
        font.family: Config.moduleFontFamily
    }

    MouseArea {
        id: githubMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: console.log("GitHub clicked - TODO: Show notifications")
    }
}
