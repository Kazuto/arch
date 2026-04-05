import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "root:/"
import "root:/components"

PanelWindow {
    id: screenRecorderOverlay

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    visible: true

    WlrLayershell.layer: slurpActive ? WlrLayer.Background : WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    property bool isRecording: false
    property string recordMode: "screen"  // screen, window, area
    property string audioMode: "both"     // both, system, mic, none
    property string quality: "high"       // high, medium, low
    property string videosPath: ""
    property bool selectingWindow: false
    property var windows: []
    property bool slurpActive: false

    // Get home directory on startup
    Process {
        id: homeProcess
        running: true
        command: ["sh", "-c", "echo $HOME/Videos"]
        stdout: SplitParser {
            onRead: data => {
                videosPath = data.trim()
                console.log("Videos path:", videosPath)
            }
        }
    }

    // Recording process
    Process {
        id: recordingProcess
        running: false

        onExited: (code, status) => {
            console.log("Recording stopped with code:", code)
            isRecording = false
        }
    }

    // Process to open file manager
    Process {
        id: openFolderProcess
        running: false
    }

    // Process to stop recording
    Process {
        id: stopProcess
        running: false
    }

    // Process to get window list with geometry
    Process {
        id: windowListProcess
        running: false
        command: ["sh", "-c", "hyprctl clients -j | jq -r '.[] | \"\\(.address)|\\(.class)|\\(.title)|\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"'"]

        stdout: SplitParser {
            onRead: data => {
                let line = data.trim()
                if (line.length > 0) {
                    let parts = line.split("|")
                    if (parts.length === 4) {
                        let windowList = windows.slice()
                        windowList.push({
                            address: parts[0],
                            class: parts[1],
                            title: parts[2],
                            geometry: parts[3]
                        })
                        windows = windowList
                    }
                }
            }
        }

        onExited: (code, status) => {
            console.log("Found", windows.length, "windows")
        }
    }

    // Click outside to close (disabled when slurp is active)
    MouseArea {
        anchors.fill: parent
        enabled: !slurpActive
        visible: !slurpActive
        onClicked: AppState.toggleScreenRecorderOverlay()
        z: -1
    }

    Rectangle {
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 12
            rightMargin: 20
        }
        width: 400
        height: 520
        color: Config.alpha(Theme.base, 0.95)
        radius: Config.overlayRadius
        border.color: Theme.surface0
        border.width: 1
        visible: !slurpActive

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

            // Header with back button when selecting window
            Row {
                width: parent.width
                spacing: 10

                GhostButton {
                    width: 40
                    height: 40
                    icon: ""
                    visible: selectingWindow
                    onClicked: {
                        selectingWindow = false
                        windows = []
                    }
                }

                Text {
                    text: selectingWindow ? " Select Window" : " Screen Recorder"
                    color: Theme.text
                    font.pixelSize: 18
                    font.bold: true
                    font.family: Config.moduleFontFamily
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.surface0
            }

            // Window picker view
            Column {
                width: parent.width
                spacing: 10
                visible: selectingWindow

                Text {
                    text: "Click a window to record"
                    color: Theme.subtext0
                    font.pixelSize: 12
                    font.family: Config.moduleFontFamily
                }

                Flickable {
                    width: parent.width
                    height: 420
                    contentHeight: windowColumn.height
                    clip: true

                    Column {
                        id: windowColumn
                        width: parent.width
                        spacing: 8

                        Repeater {
                            model: windows

                            GhostButton {
                                width: parent.width
                                height: 60
                                text: modelData.title
                                icon: ""
                                fontSize: 13
                                onClicked: {
                                    console.log("Selected window:", modelData.geometry)
                                    selectingWindow = false
                                    startRecordingWithGeometry(modelData.geometry)
                                }

                                Column {
                                    anchors {
                                        left: parent.left
                                        leftMargin: 45
                                        verticalCenter: parent.verticalCenter
                                    }
                                    spacing: 4

                                    Text {
                                        text: modelData.title
                                        color: Theme.text
                                        font.pixelSize: 13
                                        font.family: Config.moduleFontFamily
                                        width: 300
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        text: modelData.class
                                        color: Theme.subtext0
                                        font.pixelSize: 11
                                        font.family: Config.moduleFontFamily
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Main settings view
            Column {
                width: parent.width
                spacing: 20
                visible: !selectingWindow

            // Recording status
            Rectangle {
                width: parent.width
                height: 60
                radius: 8
                color: isRecording ? Config.alpha(Theme.red, 0.2) : Theme.surface0
                border.color: isRecording ? Theme.red : Theme.surface1
                border.width: 1

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: isRecording ? "" : ""
                        color: isRecording ? Theme.red : Theme.subtext0
                        font.pixelSize: 24
                        font.family: Config.moduleFontFamily

                        SequentialAnimation on opacity {
                            running: isRecording
                            loops: Animation.Infinite
                            NumberAnimation { to: 0.3; duration: 800 }
                            NumberAnimation { to: 1.0; duration: 800 }
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: isRecording ? "Recording..." : "Ready to record"
                        color: Theme.text
                        font.pixelSize: 16
                        font.family: Config.moduleFontFamily
                    }
                }
            }

            // Recording Mode
            Column {
                width: parent.width
                spacing: 10

                Text {
                    text: "Recording Mode"
                    color: Theme.subtext0
                    font.pixelSize: 12
                    font.family: Config.moduleFontFamily
                }

                Row {
                    width: parent.width
                    spacing: 10

                    GhostButton {
                        width: (parent.width - 20) / 3
                        text: "Screen"
                        icon: "󰍹"
                        highlighted: recordMode === "screen"
                        enabled: !isRecording
                        onClicked: recordMode = "screen"
                    }

                    GhostButton {
                        width: (parent.width - 20) / 3
                        text: "Window"
                        icon: ""
                        highlighted: recordMode === "window"
                        enabled: !isRecording
                        onClicked: recordMode = "window"
                    }

                    GhostButton {
                        width: (parent.width - 20) / 3
                        text: "Area"
                        icon: ""
                        highlighted: recordMode === "area"
                        enabled: !isRecording
                        onClicked: recordMode = "area"
                    }
                }
            }

            // Audio Mode
            Column {
                width: parent.width
                spacing: 10

                Text {
                    text: "Audio Source"
                    color: Theme.subtext0
                    font.pixelSize: 12
                    font.family: Config.moduleFontFamily
                }

                Row {
                    width: parent.width
                    spacing: 10

                    GhostButton {
                        width: (parent.width - 20) / 2
                        text: "System + Mic"
                        icon: "󰕾"
                        highlighted: audioMode === "both"
                        enabled: !isRecording
                        onClicked: audioMode = "both"
                    }

                    GhostButton {
                        width: (parent.width - 20) / 2
                        text: "System Only"
                        icon: "󰓃"
                        highlighted: audioMode === "system"
                        enabled: !isRecording
                        onClicked: audioMode = "system"
                    }
                }

                Row {
                    width: parent.width
                    spacing: 10

                    GhostButton {
                        width: (parent.width - 20) / 2
                        text: "Mic Only"
                        icon: "󰍬"
                        highlighted: audioMode === "mic"
                        enabled: !isRecording
                        onClicked: audioMode = "mic"
                    }

                    GhostButton {
                        width: (parent.width - 20) / 2
                        text: "No Audio"
                        icon: "󰝟"
                        highlighted: audioMode === "none"
                        enabled: !isRecording
                        onClicked: audioMode = "none"
                    }
                }
            }

            // Quality
            Column {
                width: parent.width
                spacing: 10

                Text {
                    text: "Video Quality"
                    color: Theme.subtext0
                    font.pixelSize: 12
                    font.family: Config.moduleFontFamily
                }

                Row {
                    width: parent.width
                    spacing: 10

                    GhostButton {
                        width: (parent.width - 20) / 3
                        text: "High"
                        highlighted: quality === "high"
                        enabled: !isRecording
                        onClicked: quality = "high"
                    }

                    GhostButton {
                        width: (parent.width - 20) / 3
                        text: "Medium"
                        highlighted: quality === "medium"
                        enabled: !isRecording
                        onClicked: quality = "medium"
                    }

                    GhostButton {
                        width: (parent.width - 20) / 3
                        text: "Low"
                        highlighted: quality === "low"
                        enabled: !isRecording
                        onClicked: quality = "low"
                    }
                }
            }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Theme.surface0
                }

                // Action buttons
                Row {
                    width: parent.width
                    spacing: 10

                GhostButton {
                    width: (parent.width - 10) / 2
                    height: 50
                    text: isRecording ? "Stop" : "Start Recording"
                    icon: isRecording ? "" : ""
                    iconColor: isRecording ? Theme.red : Theme.green
                    onClicked: {
                        if (isRecording) {
                            stopRecording()
                        } else {
                            startRecording()
                        }
                    }
                }

                GhostButton {
                    width: (parent.width - 10) / 2
                    height: 50
                    text: "Open Folder"
                    icon: "󰉋"
                    enabled: !isRecording
                    onClicked: {
                        openFolderProcess.command = ["xdg-open", videosPath]
                        openFolderProcess.running = false
                        openFolderProcess.running = true
                    }
                }
            }
            }
        }
    }

    function startRecording() {
        // For area mode, get region selection first
        if (recordMode === "area") {
            selectRegionAndRecord()
            return
        }

        // For window mode, show window picker
        if (recordMode === "window") {
            windows = []
            selectingWindow = true
            windowListProcess.running = false
            windowListProcess.running = true
            return
        }

        // Screen recording - start immediately
        startRecordingWithMode("screen")
    }

    function startRecordingWithMode(mode) {
        if (!videosPath) {
            console.log("Videos path not ready yet")
            return
        }

        // Build command for wf-recorder
        let cmd = ["wf-recorder"]

        // Audio
        if (audioMode === "both" || audioMode === "system" || audioMode === "mic") {
            cmd.push("-a")
        }

        // Codec
        cmd.push("-c", "libx264")

        // Frame rate
        cmd.push("-r", "60")

        // Output file
        let timestamp = new Date().toISOString().replace(/[:.]/g, "-").slice(0, -5)
        let outputPath = videosPath + "/recording_" + timestamp + ".mp4"
        cmd.push("-f", outputPath)

        console.log("Starting recording:", cmd.join(" "))

        // Start the process
        recordingProcess.command = cmd
        recordingProcess.running = true
        isRecording = true
    }

    function startRecordingWithGeometry(geometry) {
        if (!videosPath) {
            console.log("Videos path not ready yet")
            return
        }

        // Build command for wf-recorder with geometry
        let cmd = ["wf-recorder"]

        // Geometry for window/region
        cmd.push("-g", geometry)

        // Audio
        if (audioMode === "both" || audioMode === "system" || audioMode === "mic") {
            cmd.push("-a")
        }

        // Codec
        cmd.push("-c", "libx264")

        // Frame rate
        cmd.push("-r", "60")

        // Output file
        let timestamp = new Date().toISOString().replace(/[:.]/g, "-").slice(0, -5)
        let outputPath = videosPath + "/recording_" + timestamp + ".mp4"
        cmd.push("-f", outputPath)

        console.log("Starting recording with geometry:", cmd.join(" "))

        // Start the process
        recordingProcess.command = cmd
        recordingProcess.running = true
        isRecording = true
    }

    // Process for slurp region selection
    Process {
        id: slurpProcess
        running: false
        command: ["sh", "-c", "slurp -d 2>&1"]

        onStarted: {
            console.log("Slurp process started")
            slurpActive = true
        }

        stdout: SplitParser {
            onRead: data => {
                console.log("Slurp output:", data)
                let region = data.trim()
                if (region.length > 0 && !region.includes("selection cancelled")) {
                    console.log("Selected region:", region)
                    startRecordingWithRegion(region)
                }
            }
        }

        onExited: (code, status) => {
            console.log("Slurp exited with code:", code)
            slurpActive = false
            if (code !== 0) {
                console.log("Region selection cancelled")
            } else {
                // Close overlay after successful selection
                AppState.closeAllOverlays()
            }
        }
    }

    // Timer to launch slurp after overlay closes
    Timer {
        id: slurpTimer
        interval: 100
        repeat: false
        onTriggered: {
            console.log("Launching slurp...")
            slurpProcess.running = false
            slurpProcess.running = true
        }
    }

    function selectRegionAndRecord() {
        console.log("Selecting region with slurp...")
        // Launch slurp - overlay will hide its rectangle automatically via slurpActive
        slurpProcess.running = false
        slurpProcess.running = true
    }

    function startRecordingWithRegion(geometry) {
        // wf-recorder uses same function as window recording
        startRecordingWithGeometry(geometry)
    }

    function stopRecording() {
        // Send SIGINT to stop recording gracefully
        stopProcess.command = ["pkill", "-SIGINT", "wf-recorder"]
        stopProcess.running = false
        stopProcess.running = true

        recordingProcess.running = false
        isRecording = false
    }
}
