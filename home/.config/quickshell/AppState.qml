pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property bool spotifyOverlayVisible: false
    property bool bluetoothOverlayVisible: false
    property bool audioOverlayVisible: false
    property bool notificationsOverlayVisible: false
    property bool controlCenterOverlayVisible: false
    property string controlCenterView: "main"  // main, bluetooth, audio
    property bool systemStatsOverlayVisible: false
    property bool githubOverlayVisible: false
    property bool timerOverlayVisible: false
    property bool ollamaOverlayVisible: false

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

    function toggleControlCenterOverlay() {
        controlCenterOverlayVisible = !controlCenterOverlayVisible
        if (controlCenterOverlayVisible) {
            controlCenterView = "main"
        }
    }

    function setControlCenterView(view) {
        controlCenterView = view
    }

    function toggleSystemStatsOverlay() {
        systemStatsOverlayVisible = !systemStatsOverlayVisible
    }

    function toggleGitHubOverlay() {
        githubOverlayVisible = !githubOverlayVisible
    }

    function toggleTimerOverlay() {
        timerOverlayVisible = !timerOverlayVisible
    }

    function toggleOllamaOverlay() {
        ollamaOverlayVisible = !ollamaOverlayVisible
    }
}
