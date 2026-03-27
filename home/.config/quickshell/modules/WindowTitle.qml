import QtQuick
import "root:/"

Rectangle {
    implicitWidth: windowText.implicitWidth + Config.moduleHorizontalPadding
    implicitHeight: Config.barHeight
    color: Config.moduleBackground
    radius: Config.moduleRadius

    Text {
        id: windowText
        anchors.centerIn: parent
        text: "Ghostty"  // TODO: Get from Hyprland active window
        color: Config.moduleText
        font.pixelSize: Config.moduleFontSize
        font.family: Config.moduleFontFamily
        elide: Text.ElideRight
    }
}
