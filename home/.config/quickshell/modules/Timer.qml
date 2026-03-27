import QtQuick
import "root:/"

Rectangle {
    implicitWidth: timerText.implicitWidth + Config.moduleHorizontalPadding
    implicitHeight: Config.barHeight
    color: timerMouseArea.containsMouse ? Config.moduleHoverBackground : Config.moduleBackground
    radius: Config.moduleRadius

    Behavior on color {
        ColorAnimation { duration: Config.animationDuration }
    }

    Text {
        id: timerText
        anchors.centerIn: parent
        text: Icon.clock + " " + "--:--"  // TODO: Get from timer script
        color: Theme.yellow
        font.pixelSize: Config.moduleFontSize
        font.family: Config.moduleFontFamily
    }

    MouseArea {
        id: timerMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: console.log("Timer clicked - TODO: Show timer menu")
    }
}
