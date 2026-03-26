import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    id: root

    // Overlay window
    Overlay {
        id: overlay
    }

    // Spotify overlay
    SpotifyOverlay {
        id: spotifyOverlay
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

                    if (msg === "overlay-toggle") {
                        overlay.visible = !overlay.visible
                    } else if (msg === "overlay-show") {
                        overlay.visible = true
                    } else if (msg === "overlay-hide") {
                        overlay.visible = false
                    } else if (msg === "spotify-toggle") {
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
