pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property bool spotifyOverlayVisible: false
    property bool bluetoothOverlayVisible: false
    property bool audioOverlayVisible: false

    function toggleSpotifyOverlay() {
        spotifyOverlayVisible = !spotifyOverlayVisible
    }

    function toggleBluetoothOverlay() {
        bluetoothOverlayVisible = !bluetoothOverlayVisible
    }

    function toggleAudioOverlay() {
        audioOverlayVisible = !audioOverlayVisible
    }
}
