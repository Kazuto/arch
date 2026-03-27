import QtQuick
import "root:/"

Rectangle {
    implicitWidth: bluetoothText.implicitWidth + Config.moduleHorizontalPadding
    implicitHeight: Config.barHeight
    color: bluetoothMouseArea.containsMouse ? Config.moduleHoverBackground : Config.moduleBackground
    radius: Config.moduleRadius

    Behavior on color {
        ColorAnimation { duration: Config.animationDuration }
    }

    Text {
        id: bluetoothText
        anchors.centerIn: parent
        text: Icon.bluetooth + " " + "on"  // TODO: Get from blueman-manager
        color: Theme.blue
        font.pixelSize: Config.moduleFontSize
        font.family: Config.moduleFontFamily
    }

    MouseArea {
        id: bluetoothMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: console.log("Bluetooth clicked - TODO: Open blueman-manager")
    }
}
