import QtQuick
import Quickshell
import Quickshell.Hyprland
import "root:/"

Rectangle {
    implicitWidth: workspaceRow.implicitWidth + Config.moduleHorizontalPadding
    implicitHeight: Config.barHeight
    color: Config.moduleBackground
    radius: Config.moduleRadius

    Row {
        id: workspaceRow
        anchors.centerIn: parent
        spacing: Config.workspaceSpacing

        Repeater {
            model: [
                {num: 1, icon: Icon.firefox},
                {num: 2, icon: Icon.ghostty},
                {num: 3, icon: Icon.database},
                {num: 4, icon: Icon.code},
                {num: 5, icon: Icon.firefox},
                {num: 6, icon: Icon.thunderbird},
                {num: 7, icon: Icon.emptyWorkspace},
                {num: 8, icon: Icon.discord},
                {num: 9, icon: Icon.steam},
                {num: 10, icon: Icon.spotify}
            ]

            delegate: Item {
                property int workspaceNum: modelData.num
                property string workspaceIcon: modelData.icon
                property bool isActive: false
                property bool hasWindows: false

                Binding on isActive {
                    value: {
                        if (!Hyprland.focusedWorkspace) return false
                        return Hyprland.focusedWorkspace.id === workspaceNum
                    }
                    when: Hyprland.focusedWorkspace !== undefined
                }

                Binding on hasWindows {
                    value: {
                        for (var i in Hyprland.workspaces.values) {
                            var ws = Hyprland.workspaces.values[i]
                            if (ws.id === workspaceNum) {
                                return ws.windows && ws.windows.length > 0
                            }
                        }
                        return false
                    }
                    when: Hyprland.workspaces !== undefined
                }

                width: Config.workspaceSize
                height: Config.workspaceSize

                MouseArea {
                    id: wsMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Hyprland.dispatch("workspace", workspaceNum.toString())
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: workspaceIcon
                    color: isActive ? Config.workspaceActive :
                           (wsMouseArea.containsMouse ? Config.workspaceActive :
                           (hasWindows ? Config.moduleText : Config.moduleTextMuted))
                    font.pixelSize: Config.workspaceIconSize
                    font.family: Config.moduleFontFamily

                    Behavior on color {
                        ColorAnimation { duration: Config.animationDuration }
                    }
                }
            }
        }
    }
}
