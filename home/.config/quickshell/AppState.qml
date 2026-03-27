pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property bool spotifyOverlayVisible: false

    function toggleSpotifyOverlay() {
        spotifyOverlayVisible = !spotifyOverlayVisible
    }
}
