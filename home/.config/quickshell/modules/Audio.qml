import QtQuick
import "root:/"

Row {
    spacing: Config.moduleSpacing

    // Volume
    Rectangle {
        implicitWidth: volumeText.implicitWidth + Config.moduleHorizontalPadding
        implicitHeight: Config.barHeight
        color: volumeMouseArea.containsMouse ? Config.moduleHoverBackground : Config.moduleBackground
        radius: Config.moduleRadius

        Behavior on color {
            ColorAnimation { duration: Config.animationDuration }
        }

        Text {
            id: volumeText
            anchors.centerIn: parent
            text: Icon.volume + " " + "65%"  // TODO: Get from pamixer/pulseaudio
            color: Theme.mauve
            font.pixelSize: Config.moduleFontSize
            font.family: Config.moduleFontFamily
        }

        MouseArea {
            id: volumeMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: (mouse) => {
                if (mouse.button === Qt.LeftButton) {
                    console.log("Volume clicked - TODO: Toggle mute")
                } else if (mouse.button === Qt.RightButton) {
                    console.log("Volume right-clicked - TODO: Show audio output menu")
                }
            }

            onWheel: (wheel) => {
                if (wheel.angleDelta.y > 0) {
                    console.log("Volume up")
                } else if (wheel.angleDelta.y < 0) {
                    console.log("Volume down")
                }
            }
        }
    }

    // Microphone
    Rectangle {
        implicitWidth: micText.implicitWidth + Config.moduleHorizontalPadding
        implicitHeight: Config.barHeight
        color: micMouseArea.containsMouse ? Config.moduleHoverBackground : Config.moduleBackground
        radius: Config.moduleRadius

        Behavior on color {
            ColorAnimation { duration: Config.animationDuration }
        }

        Text {
            id: micText
            anchors.centerIn: parent
            text: Icon.microphone + " " + "80%"  // TODO: Get from pamixer/pulseaudio
            color: Theme.mauve
            font.pixelSize: Config.moduleFontSize
            font.family: Config.moduleFontFamily
        }

        MouseArea {
            id: micMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: console.log("Microphone clicked - TODO: Toggle mute")

            onWheel: (wheel) => {
                if (wheel.angleDelta.y > 0) {
                    console.log("Mic volume up")
                } else if (wheel.angleDelta.y < 0) {
                    console.log("Mic volume down")
                }
            }
        }
    }
}
