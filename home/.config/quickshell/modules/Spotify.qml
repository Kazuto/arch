import QtQuick
import "root:/"

Rectangle {
    implicitWidth: spotifyText.implicitWidth + Config.moduleHorizontalPadding
    implicitHeight: Config.barHeight
    color: spotifyMouseArea.containsMouse ? Config.moduleHoverBackground : Config.moduleBackground
    radius: Config.moduleRadius

    Behavior on color {
        ColorAnimation { duration: Config.animationDuration }
    }

    Text {
        id: spotifyText
        anchors.centerIn: parent
        text: Icon.spotify + " " + "Placeholder Song"  // TODO: Get from playerctl
        color: Theme.green
        font.pixelSize: Config.moduleFontSize
        font.family: Config.moduleFontFamily
    }

    MouseArea {
        id: spotifyMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            AppState.toggleSpotifyOverlay()
        }
    }
}
