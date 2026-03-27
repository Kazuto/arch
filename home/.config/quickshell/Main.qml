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

    // Bar
    Windows.Bar {
        id: bar

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
            Modules.SystemStats {},
            Modules.Bluetooth {},
            Modules.Audio {},
            Modules.Clock {}
        ]
    }

    // Spotify overlay
    Overlays.SpotifyOverlay {
        id: spotifyOverlay
        visible: AppState.spotifyOverlayVisible
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
                        spotifyOverlay.visible = !spotifyOverlay.visible
                    } else if (msg === "spotify-show") {
                        spotifyOverlay.visible = true
                    } else if (msg === "spotify-hide") {
                        spotifyOverlay.visible = false
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
