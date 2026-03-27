import QtQuick
import "root:/"

Rectangle {
    implicitWidth: ollamaText.implicitWidth + Config.moduleHorizontalPadding
    implicitHeight: Config.barHeight
    color: ollamaMouseArea.containsMouse ? Config.moduleHoverBackground : Config.moduleBackground
    radius: Config.moduleRadius

    Behavior on color {
        ColorAnimation { duration: Config.animationDuration }
    }

    Text {
        id: ollamaText
        anchors.centerIn: parent
        text: Icon.ollama  // TODO: Get from ollama script
        color: Theme.green
        font.pixelSize: Config.moduleFontSize
        font.family: Config.moduleFontFamily
        opacity: 1  // Dimmed when inactive
    }

    MouseArea {
        id: ollamaMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: console.log("Ollama clicked - TODO: Toggle service")
    }
}
