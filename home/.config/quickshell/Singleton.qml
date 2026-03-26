pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool overlayVisible: false

    // Watch for toggle trigger file
    FileWatcher {
        id: toggleWatcher
        path: "/tmp/quickshell-toggle-trigger"

        onChanged: {
            root.overlayVisible = !root.overlayVisible
        }
    }
}
