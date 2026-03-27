import QtQuick
import Quickshell
import Quickshell.Wayland
import "root:/"
import "root:/singletons"

PanelWindow {
    id: menuOverlay

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    visible: true

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    onVisibleChanged: {
        if (visible) {
            SystemData.refresh()
        }
    }

    // Click outside to close
    MouseArea {
        anchors.fill: parent
        onClicked: AppState.toggleMenuOverlay()
        z: -1
    }

    Rectangle {
        anchors {
            top: parent.top
            left: parent.left
            topMargin: 12
            leftMargin: 20
        }
        width: 320
        height: 450
        color: Config.alpha(Theme.base, 0.95)
        radius: Config.overlayRadius
        border.color: Theme.surface0
        border.width: 1

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        Column {
            anchors {
                fill: parent
                margins: 20
            }
            spacing: 20

            // Header
            Text {
                text: Icon.arch + " System"
                color: Theme.text
                font.pixelSize: 18
                font.bold: true
                font.family: Config.moduleFontFamily
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.surface0
            }

            // System Information
            Column {
                width: parent.width
                spacing: 12

                // Distro
                Row {
                    width: parent.width
                    spacing: 10

                    Text {
                        text: "OS"
                        color: Theme.subtext0
                        font.pixelSize: 12
                        font.family: Config.moduleFontFamily
                        width: 80
                    }

                    Text {
                        text: SystemData.distro
                        color: Theme.text
                        font.pixelSize: 12
                        font.family: Config.moduleFontFamily
                    }
                }

                // Kernel
                Row {
                    width: parent.width
                    spacing: 10

                    Text {
                        text: "Kernel"
                        color: Theme.subtext0
                        font.pixelSize: 12
                        font.family: Config.moduleFontFamily
                        width: 80
                    }

                    Text {
                        text: SystemData.kernel
                        color: Theme.text
                        font.pixelSize: 12
                        font.family: Config.moduleFontFamily
                    }
                }

                // Uptime
                Row {
                    width: parent.width
                    spacing: 10

                    Text {
                        text: "Uptime"
                        color: Theme.subtext0
                        font.pixelSize: 12
                        font.family: Config.moduleFontFamily
                        width: 80
                    }

                    Text {
                        text: SystemData.uptime
                        color: Theme.text
                        font.pixelSize: 12
                        font.family: Config.moduleFontFamily
                    }
                }

                // DE/WM
                Row {
                    width: parent.width
                    spacing: 10

                    Text {
                        text: "WM"
                        color: Theme.subtext0
                        font.pixelSize: 12
                        font.family: Config.moduleFontFamily
                        width: 80
                    }

                    Text {
                        text: SystemData.de
                        color: Theme.text
                        font.pixelSize: 12
                        font.family: Config.moduleFontFamily
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.surface0
            }

            // Power Options
            Text {
                text: "Power Options"
                color: Theme.subtext0
                font.pixelSize: 12
                font.family: Config.moduleFontFamily
            }

            Column {
                width: parent.width
                spacing: 8

                // Lock
                Rectangle {
                    width: parent.width
                    height: 45
                    radius: 8
                    color: lockMouseArea.containsMouse ? Theme.surface1 : Theme.surface0
                    border.color: Theme.surface2
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            text: Icon.lock
                            color: Theme.text
                            font.pixelSize: 16
                            font.family: Config.moduleFontFamily
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "Lock"
                            color: Theme.text
                            font.pixelSize: 14
                            font.family: Config.moduleFontFamily
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: lockMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Quickshell.Io.Process.exec("hyprlock")
                            AppState.toggleMenuOverlay()
                        }
                    }
                }

                // Logout
                Rectangle {
                    width: parent.width
                    height: 45
                    radius: 8
                    color: logoutMouseArea.containsMouse ? Theme.surface1 : Theme.surface0
                    border.color: Theme.surface2
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            text: Icon.logout
                            color: Theme.text
                            font.pixelSize: 16
                            font.family: Config.moduleFontFamily
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "Logout"
                            color: Theme.text
                            font.pixelSize: 14
                            font.family: Config.moduleFontFamily
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: logoutMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Quickshell.Io.Process.exec("hyprctl", "dispatch", "exit")
                            AppState.toggleMenuOverlay()
                        }
                    }
                }

                // Reboot
                Rectangle {
                    width: parent.width
                    height: 45
                    radius: 8
                    color: rebootMouseArea.containsMouse ? Theme.surface1 : Theme.surface0
                    border.color: Theme.surface2
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            text: Icon.refresh
                            color: Theme.yellow
                            font.pixelSize: 16
                            font.family: Config.moduleFontFamily
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "Reboot"
                            color: Theme.text
                            font.pixelSize: 14
                            font.family: Config.moduleFontFamily
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: rebootMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Quickshell.Io.Process.exec("systemctl", "reboot")
                        }
                    }
                }

                // Shutdown
                Rectangle {
                    width: parent.width
                    height: 45
                    radius: 8
                    color: shutdownMouseArea.containsMouse ? Theme.surface1 : Theme.surface0
                    border.color: Theme.surface2
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            text: Icon.power
                            color: Theme.red
                            font.pixelSize: 16
                            font.family: Config.moduleFontFamily
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "Shutdown"
                            color: Theme.text
                            font.pixelSize: 14
                            font.family: Config.moduleFontFamily
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: shutdownMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Quickshell.Io.Process.exec("systemctl", "poweroff")
                        }
                    }
                }
            }
        }
    }
}
