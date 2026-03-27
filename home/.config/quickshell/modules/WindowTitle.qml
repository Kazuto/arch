import QtQuick
import Quickshell.Hyprland
import "root:/"

Rectangle {
    implicitWidth: Math.min(windowText.implicitWidth + Config.moduleHorizontalPadding, 300)
    implicitHeight: Config.barHeight
    color: Config.moduleBackground
    radius: Config.moduleRadius

    property var activeWindow: Hyprland.activeToplevel

    property string windowClass: {
        if (!activeWindow) return ""
        if (activeWindow.lastIpcObject) {
            return activeWindow.lastIpcObject.class || ""
        }
        return ""
    }

    property string displayText: {
        if (!windowClass) return ""

        // Rewrite rules from waybar config
        var rewrites = {
            "com.mitchellh.ghostty": "Ghostty",
            "firefox": "Firefox",
            "firefox-work": "Firefox (Work)",
            "firefox-personal": "Firefox (Personal)",
            "discord": "Discord",
            "Spotify": "Spotify",
            "org.kde.dolphin": "Dolphin",
            "thunar": "Thunar",
            "kitty": "Kitty",
            "obsidian": "Obsidian",
            "code": "VS Code",
            "teams-for-linux": "Microsoft Teams",
            "org.mozilla.Thunderbird": "Thunderbird",
            "com-atlauncher-App": "ATLauncher",
            "steam": "Steam",
            "com.libretro.RetroArch": "RetroArch",
            "vesktop": "Discord"
        }

        if (windowClass in rewrites) {
            return rewrites[windowClass]
        }

        // Firefox patterns
        if (windowClass.indexOf("— Firefox") !== -1) {
            return "Firefox"
        }
        if (windowClass.indexOf("— Firefox Developer Edition") !== -1) {
            return "Firefox Dev"
        }

        return windowClass
    }

    Text {
        id: windowText
        anchors.centerIn: parent
        text: displayText
        color: Config.moduleText
        font.pixelSize: Config.moduleFontSize
        font.family: Config.moduleFontFamily
        elide: Text.ElideRight
        maximumLineCount: 1
    }

}

