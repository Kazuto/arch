pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property bool spotifyOverlayVisible: false
    property bool bluetoothOverlayVisible: false
    property bool audioOverlayVisible: false
    property bool notificationsOverlayVisible: false

    function toggleSpotifyOverlay() {
        spotifyOverlayVisible = !spotifyOverlayVisible
    }

    function toggleBluetoothOverlay() {
        bluetoothOverlayVisible = !bluetoothOverlayVisible
    }

    function toggleAudioOverlay() {
        audioOverlayVisible = !audioOverlayVisible
    }

    function toggleNotificationsOverlay() {
        notificationsOverlayVisible = !notificationsOverlayVisible
    }
}
