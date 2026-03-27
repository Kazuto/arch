import QtQuick
import "root:/"
import "root:/singletons"

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
            text: Icon.cpu + " " + SystemStatsData.cpuUsage + "%"
            color: SystemStatsData.cpuUsage >= 80 ? Theme.red : Theme.sky
            font.pixelSize: Config.moduleFontSize
            font.family: Config.moduleFontFamily
        }

        MouseArea {
            id: cpuMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                var proc = Qt.createQmlObject(
                    'import Quickshell.Io; Process { command: ["ghostty", "-e", "btop"]; running: true }',
                    parent
                )
            }
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
            text: Icon.memory + " " + SystemStatsData.memoryUsage + "%"
            color: SystemStatsData.memoryUsage >= 80 ? Theme.red : Theme.sky
            font.pixelSize: Config.moduleFontSize
            font.family: Config.moduleFontFamily
        }

        MouseArea {
            id: memMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                var proc = Qt.createQmlObject(
                    'import Quickshell.Io; Process { command: ["ghostty", "-e", "btop"]; running: true }',
                    parent
                )
            }
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
            text: Icon.network + " " + SystemStatsData.networkSpeed
            color: Theme.sky
            font.pixelSize: Config.moduleFontSize
            font.family: Config.moduleFontFamily
        }

        MouseArea {
            id: netMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                var proc = Qt.createQmlObject(
                    'import Quickshell.Io; Process { command: ["ghostty", "-e", "btop"]; running: true }',
                    parent
                )
            }
        }
    }
}
