import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: overlay
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    // Make it transparent and click-through by default
    color: "transparent"
    visible: false // Hidden by default, toggle with IPC command

    // Layer configuration for Wayland
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    // Main container
    Rectangle {
        id: container
        anchors.centerIn: parent
        width: 400
        height: 300
        radius: 20

        // Frosted glass effect (blur handled by Hyprland compositor)
        color: "#CC1e1e2e" // Semi-transparent background (Catppuccin Mocha base)

        // Optional: Add a subtle border
        border.color: "#40fab387" // Catppuccin Mocha peach (accent color)
        border.width: 2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            // Header with time
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatTime(new Date(), "hh:mm")
                font.pixelSize: 32
                font.bold: true
                color: "white"
            }

            // Media controls row
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                RoundButton {
                    text: "⏮"
                    onClicked: console.log("Previous")
                }

                RoundButton {
                    text: "⏯"
                    highlighted: true
                    onClicked: console.log("Play/Pause")
                }

                RoundButton {
                    text: "⏭"
                    onClicked: console.log("Next")
                }
            }

            // Settings row
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                Button {
                    text: "Settings"
                    flat: true
                    Layout.fillWidth: true

                    background: Rectangle {
                        color: parent.pressed ? "#40FFFFFF" : "#20FFFFFF"
                        radius: 10
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    text: "Files"
                    flat: true
                    Layout.fillWidth: true

                    background: Rectangle {
                        color: parent.pressed ? "#40FFFFFF" : "#20FFFFFF"
                        radius: 10
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            // Action buttons row
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                RoundButton {
                    text: "⏻"
                    onClicked: console.log("Power")
                }

                RoundButton {
                    text: "↻"
                    onClicked: console.log("Refresh")
                }

                RoundButton {
                    text: "◐"
                    onClicked: console.log("Theme")
                }

                RoundButton {
                    text: "🔒"
                    onClicked: console.log("Lock")
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    // Toggle visibility function (can be called from keybinds)
    function toggle() {
        visible = !visible
    }
}
