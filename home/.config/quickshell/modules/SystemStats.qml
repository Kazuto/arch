import QtQuick
import "root:/"

Row {
    spacing: Config.moduleSpacing

    // CPU
    Rectangle {
        implicitWidth: cpuText.implicitWidth + Config.moduleHorizontalPadding
        implicitHeight: Config.barHeight
        color: cpuMouseArea.containsMouse ? Config.moduleHoverBackground : Config.moduleBackground
        radius: Config.moduleRadius

        Text {
            id: cpuText
            anchors.centerIn: parent
            text: Icon.cpu + " " + "15%"  // TODO: Get from /proc/stat
            color: Theme.rosewater 
            font.pixelSize: Config.moduleFontSize
            font.family: Config.moduleFontFamily
        }

        MouseArea {
            id: cpuMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }

    // Memory
    Rectangle {
        implicitWidth: memText.implicitWidth + Config.moduleHorizontalPadding
        implicitHeight: Config.barHeight
        color: memMouseArea.containsMouse ? Config.moduleHoverBackground : Config.moduleBackground
        radius: Config.moduleRadius

        Text {
            id: memText
            anchors.centerIn: parent
            text: Icon.memory + " " + "42%"  // TODO: Get from /proc/meminfo
            color: Theme.rosewater 
            font.pixelSize: Config.moduleFontSize
            font.family: Config.moduleFontFamily
        }

        MouseArea {
            id: memMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }

    // Network
    Rectangle {
        implicitWidth: netText.implicitWidth + Config.moduleHorizontalPadding
        implicitHeight: Config.barHeight
        color: netMouseArea.containsMouse ? Config.moduleHoverBackground : Config.moduleBackground
        radius: Config.moduleRadius

        Text {
            id: netText
            anchors.centerIn: parent
            text: Icon.network + " " + "125 Mb/s"  // TODO: Get from /sys/class/net
            color: Theme.flamingo 
            font.pixelSize: Config.moduleFontSize
            font.family: Config.moduleFontFamily
        }

        MouseArea {
            id: netMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }
}
