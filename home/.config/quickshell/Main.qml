import QtQuick
import Quickshell
import Quickshell.Io

import "root:/"
import "./modules" as Modules
import "./windows" as Windows
import "./overlays" as Overlays

Rectangle {
    anchors.fill: parent
    color: "transparent"

    // Find screens by model to avoid index issues when monitors reconnect
    property var middleScreen: {
        for (var i = 0; i < Quickshell.screens.length; i++) {
            if (Quickshell.screens[i].model === "G34WQC A") return Quickshell.screens[i]
        }
        return Quickshell.screens[0] // fallback
    }

    property var rightScreen: {
        for (var i = 0; i < Quickshell.screens.length; i++) {
            var s = Quickshell.screens[i]
            if (s.model === "GS27QCA" && s.name === "DP-2") return s
        }
        return Quickshell.screens.length > 1 ? Quickshell.screens[1] : null
    }

    property var leftScreen: {
        for (var i = 0; i < Quickshell.screens.length; i++) {
            var s = Quickshell.screens[i]
            if (s.model === "GS27QCA" && s.name === "DP-3") return s
        }
        return Quickshell.screens.length > 2 ? Quickshell.screens[2] : null
    }

    // Bar (Primary Display - Middle Ultrawide)
    Windows.Bar {
        id: bar
        screen: middleScreen

        leftItems: [
            Modules.Menu {},
            Modules.Workspaces {},
            Modules.WindowTitle {}
        ]

        centerItems: [
            Modules.Spotify {}
        ]

        rightItems: [
            Modules.GitHub {},
            Modules.Timer {},
            Modules.Ollama {},
            Modules.ScreenRecorder {},
            Modules.SystemStats {},
            Modules.Notifications {},
            Modules.ControlCenter {},
            Modules.Clock {},
        ]
    }

    // Bar (Right Display - Workspaces 11-20)
    Windows.Bar {
        id: barSecondary
        screen: rightScreen
        visible: rightScreen !== null

        leftItems: [
            Modules.Workspaces {
                startWorkspace: 11
                defaultIcon: Icon.emptyWorkspace
            }
        ]

        centerItems: []
        rightItems: []
    }

    // Bar (Left Display - Workspaces 21-30)
    Windows.Bar {
        id: barTertiary
        screen: leftScreen
        visible: leftScreen !== null

        leftItems: [
            Modules.Workspaces {
                startWorkspace: 21
                defaultIcon: Icon.emptyWorkspace
            }
        ]

        centerItems: []
        rightItems: []
    }

    // Spotify overlay
    Overlays.SpotifyOverlay {
        id: spotifyOverlay
        visible: AppState.spotifyOverlayVisible
    }

    // Bluetooth overlay
    Overlays.BluetoothOverlay {
        id: bluetoothOverlay
        visible: AppState.bluetoothOverlayVisible
    }

    // Audio overlay
    Overlays.AudioOverlay {
        id: audioOverlay
        visible: AppState.audioOverlayVisible
    }

    // Notifications overlay
    Overlays.NotificationsOverlay {
        id: notificationsOverlay
        visible: AppState.notificationsOverlayVisible
    }

    // Control Center overlay
    Overlays.ControlCenterOverlay {
        id: controlCenterOverlay
        visible: AppState.controlCenterOverlayVisible
    }

    // System Stats overlay
    Overlays.SystemStatsOverlay {
        id: systemStatsOverlay
        visible: AppState.systemStatsOverlayVisible
    }

    // GitHub overlay
    Overlays.GitHubOverlay {
        id: githubOverlay
        visible: AppState.githubOverlayVisible
    }

    // Timer overlay
    Overlays.TimerOverlay {
        id: timerOverlay
        visible: AppState.timerOverlayVisible
    }

    // Ollama overlay
    Overlays.OllamaOverlay {
        id: ollamaOverlay
        visible: AppState.ollamaOverlayVisible
    }

    // Calendar overlay
    Overlays.CalendarOverlay {
        id: calendarOverlay
        visible: AppState.calendarOverlayVisible
    }

    // Menu overlay
    Overlays.MenuOverlay {
        id: menuOverlay
        visible: AppState.menuOverlayVisible
    }

    // Screen Recorder overlay
    Overlays.ScreenRecorderOverlay {
        id: screenRecorderOverlay
        visible: AppState.screenRecorderOverlayVisible
    }

    // IPC Socket Server
    SocketServer {
        id: ipcSocket
        active: true
        path: "/tmp/quickshell.sock"

        handler: Socket {
            parser: SplitParser {
                onRead: msg => {
                    console.log("Received IPC command:", msg)

                    if (msg === "spotify-toggle") {
                        AppState.toggleSpotifyOverlay()
                    } else if (msg === "spotify-show") {
                        if (!AppState.spotifyOverlayVisible) {
                            AppState.closeAllOverlays()
                        }
                        AppState.spotifyOverlayVisible = true
                    } else if (msg === "spotify-hide") {
                        AppState.spotifyOverlayVisible = false
                    } else {
                        console.log("Unknown command:", msg)
                    }
                }
            }

            onConnectedChanged: {
                if (connected) {
                    console.log("IPC client connected")
                }
            }
        }
    }

    Component.onCompleted: {
        console.log("QuickShell started with IPC on:", ipcSocket.path)
    }
}
