hl.config({
  debug = {
    disable_logs = true,
  },
})

-- === Environment === --
hl.env("QT_STYLE_OVERRIDE", "Adwaita-Dark")
hl.env("ELECTRON_ENABLE_FEATURES", "WebContentsForceDarkMode")
hl.env("GOOGLE_CHROME_EXTRA_FLAGS", "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer")
hl.env("XDG_DATA_DIRS", os.getenv("HOME") .. "/.local/share:/home/nikmayer/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share/:/usr/share/:/var/lib/snapd/desktop")

-- Environment variables
require("env")

-- === Monitors === --
-- Use monitor descriptions (with serial) for persistent identification
hl.monitor({ output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. GS27QCA 25465B003652", mode = "2560x1440@180", position = "0x0", scale = 1, transform = 1 })
-- Behind the KVM's HDMI this one reports no serial and tops out at 100 Hz. desc: matches the
-- start of the description, so leaving the serial out works with or without the KVM.
hl.monitor({ output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G34WQC A", mode = "3440x1440@100", position = "1440x640", scale = 1 })
hl.monitor({ output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. GS27QCA 25355B006220", mode = "2560x1440@180", position = "4880x0", scale = 1, transform = 3 })

-- === Status Bar, OSD, Wallpaper === --
hl.on("hyprland.start", function()
  hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
  hl.exec_cmd("quickshell")
  hl.exec_cmd("wl-paste --watch cliphist store")

  hl.exec_cmd("awww-daemon")
  hl.exec_cmd([[sleep 2 && ~/.config/swww/set-wallpaper.sh "$(find $HOME/Wallpaper/ -maxdepth 1 -type f -iregex '.*\.\(avif\|jpe?g\|png\|webp\|gif\)' | shuf -n 1)"]])

  hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland")

  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland HYPRLAND_INSTANCE_SIGNATURE DBUS_SESSION_BUS_ADDRESS")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")

  hl.exec_cmd("$POLKIT_AUTH_AGENT")

  hl.exec_cmd("vivaldi", { workspace = "1 silent" })
  hl.exec_cmd("ghostty", { workspace = "2 silent" })
  hl.exec_cmd("vesktop", { workspace = "6 silent" })
  hl.exec_cmd("spotify", { workspace = "8 silent" })
end)

-- A reload resets the border color, so the accent has to be applied again. config.reloaded
-- also fires during startup, but too early for the color to stick, so both are needed.
local function syncAccent()
  hl.exec_cmd("~/.config/quickshell/scripts/apply-accent.sh --sync")
end
hl.on("hyprland.start", syncAccent)
hl.on("config.reloaded", syncAccent)

-- === Keyboard === --
hl.config({
  input = {
    follow_mouse = 1,
    sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
    numlock_by_default = true,

    kb_layout = "eu",
  },
})

-- === Layout === --
hl.config({
  general = {
    layout = "dwindle",

    gaps_in = 5,
    gaps_out = 15,
    border_size = 2,

    col = {
      active_border = { colors = { "rgb(fab387)", "rgb(1e1e2e)", "rgb(1e1e2e)", "rgb(fab387)" }, angle = 45 },
      inactive_border = "rgba(1e1e2eff)",
    },
  },
})

-- === Misc === --
hl.config({
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    mouse_move_enables_dpms = true,
    enable_swallow = true,
    swallow_regex = "^(kitty)$",
  },
})

-- === Decorations === --
hl.config({
  decoration = {
    rounding = 20,
    rounding_power = 10,

    active_opacity = 1,
    inactive_opacity = 0.85,

    blur = {
      enabled = true,
      size = 5,
      passes = 3,
      new_optimizations = true,
      vibrancy = 0.1696,
      ignore_opacity = true,
    },

    shadow = {
      enabled = false,
      range = 20,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },
  },
})

hl.layer_rule({ name = "gtk-layer-shell", match = { namespace = "gtk-layer-shell" }, blur = true })
hl.layer_rule({ name = "lockscreen", match = { namespace = "lockscreen" }, blur = true })

-- === Animations === --
hl.config({
  animations = {
    enabled = true,
  },
})

hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("smoothOut", { type = "bezier", points = { { 0.36, 0 }, { 0.66, -0.56 } } })
hl.curve("smoothIn", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "smoothOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "smoothIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

-- === Layouts === --
hl.config({
  dwindle = {
    preserve_split = true,
  },
})

-- === Window rules === --
require("windowrules")

-- === Keybinds === --
-- Keep each bind on one line with its command inline: Quickshell's hotkey sheet
-- (js/Hotkeys.js) reads these lines as text.
hl.bind("SUPER + B", hl.dsp.exec_cmd("vivaldi"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("slack"))
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("thunar"))
hl.bind("SUPER + Y", hl.dsp.exec_cmd("ghostty -e yazi"))

hl.bind("SUPER + C", hl.dsp.exec_cmd("hyprpicker -a -n"))

hl.bind("SUPER + R", hl.dsp.exec_cmd("hyprctl reload; pkill quickshell; quickshell &")) -- Reload Hyprland + Quickshell
hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd('echo "emoji-toggle" | socat - UNIX-CONNECT:/tmp/quickshell.sock'))
hl.bind("SUPER + COMMA", hl.dsp.exec_cmd('echo "wallpaper-toggle" | socat - UNIX-CONNECT:/tmp/quickshell.sock'))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd([[~/.config/swww/set-wallpaper.sh "$(find $HOME/Wallpaper/ -maxdepth 1 -type f -iregex '.*\.\(avif\|jpe?g\|png\|webp\|gif\)' | shuf -n 1)"]]))
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd('echo "power-toggle" | socat - UNIX-CONNECT:/tmp/quickshell.sock'))

hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + W", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.exec_cmd("~/.config/hypr/smart-fullscreen.sh"))
hl.bind("SUPER + Space", hl.dsp.exec_cmd('echo "launcher-toggle" | socat - UNIX-CONNECT:/tmp/quickshell.sock'))
hl.bind("SUPER + Q", hl.dsp.exec_cmd('echo "quick-toggle" | socat - UNIX-CONNECT:/tmp/quickshell.sock'))
hl.bind("SUPER + SLASH", hl.dsp.exec_cmd('echo "hotkeys-toggle" | socat - UNIX-CONNECT:/tmp/quickshell.sock'))

-- === Screenshots === --
local screenshotDir = "$(xdg-user-dir PICTURES)/Screenshots"
local screenshotFile = '"' .. screenshotDir .. "/$(date +'screenshot_%Y%m%d_%H%M%S.png')\""
-- Makes grimblast use the yarn selector from Quickshell for area screenshots
local areaSelect = "PATH=$HOME/.config/quickshell/scripts/area-select:$PATH"

-- Screenshots with grimblast - Save to file
hl.bind("SUPER + ALT + 2", hl.dsp.exec_cmd("mkdir -p " .. screenshotDir .. " && grimblast --notify save screen " .. screenshotFile))
hl.bind("SUPER + ALT + 3", hl.dsp.exec_cmd("mkdir -p " .. screenshotDir .. " && grimblast --notify save output " .. screenshotFile))
hl.bind("SUPER + ALT + 4", hl.dsp.exec_cmd("mkdir -p " .. screenshotDir .. " && " .. areaSelect .. " grimblast --notify save area " .. screenshotFile))
hl.bind("SUPER + ALT + 5", hl.dsp.exec_cmd("mkdir -p " .. screenshotDir .. " && " .. areaSelect .. " grimblast --notify --freeze save area " .. screenshotFile))

-- Screenshots with grimblast - Copy to clipboard
hl.bind("SUPER + CTRL + 2", hl.dsp.exec_cmd("grimblast --notify copy screen"))
hl.bind("SUPER + CTRL + 3", hl.dsp.exec_cmd("grimblast --notify copy output"))
hl.bind("SUPER + CTRL + 4", hl.dsp.exec_cmd(areaSelect .. " grimblast --notify copy area"))
hl.bind("SUPER + CTRL + 5", hl.dsp.exec_cmd(areaSelect .. " grimblast --notify --freeze copy area"))

-- === Other === --

-- === Focus === --
-- Hyper key (CapsLock) + hjkl = focus (matches Aerospace alt-shift-cmd-ctrl-hjkl)
hl.bind("SUPER + h", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + j", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + k", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "right" }))

-- === Move Windows === --
-- SUPER+ALT+hjkl = move window (matches aerospace alt-shift-hjkl)
hl.bind("SUPER + ALT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + ALT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + ALT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + ALT + l", hl.dsp.window.move({ direction = "right" }))

-- === Resize Windows === --
-- Alt+minus/equal = resize (matches Aerospace alt-minus/equal)
hl.bind("ALT + minus", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind("ALT + equal", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind("SUPER + SHIFT + h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }))
hl.bind("SUPER + SHIFT + j", hl.dsp.window.resize({ x = 0, y = -20, relative = true }))
hl.bind("SUPER + SHIFT + k", hl.dsp.window.resize({ x = 0, y = 20, relative = true }))
hl.bind("SUPER + SHIFT + l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }))

-- === Window Groups === --
hl.bind("SUPER + g", hl.dsp.group.toggle())
hl.bind("SUPER + tab", hl.dsp.group.next())

-- Hyper key (CapsLock) + numbers = switch workspace (matches Aerospace)
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))

-- Hyper key + left/right = workspace prev/next (matches Aerospace)
-- hl.bind("CTRL + SHIFT + ALT + left", hl.dsp.focus({ workspace = "e-1" }))
-- hl.bind("CTRL + SHIFT + ALT + right", hl.dsp.focus({ workspace = "e+1" }))

-- Hyper key + f = fullscreen (matches Aerospace alt-shift-cmd-ctrl-f)
-- hl.bind("CTRL + SHIFT + ALT + f", hl.dsp.exec_cmd("~/.config/hypr/smart-fullscreen.sh"))

-- Alt+Tab = workspace back-and-forth (matches Aerospace)
-- hl.bind("ALT + tab", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind("ALT + SHIFT + tab", hl.dsp.focus({ workspace = "e-1" }))

-- === Move to Workspace === --
-- Alt+Shift+numbers = move window to workspace (matches Aerospace)
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- === Mouse Binds === --
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- === Audio === --
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd('pamixer -u -i 5 && VOL=$(pamixer --get-volume) && echo "osd-volume:$VOL:unmuted" | socat - UNIX-CONNECT:/tmp/quickshell.sock'), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd('pamixer -u -d 5 && VOL=$(pamixer --get-volume) && echo "osd-volume:$VOL:unmuted" | socat - UNIX-CONNECT:/tmp/quickshell.sock'), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd('pamixer -t && MUTED=$(pamixer --get-mute) && VOL=$(pamixer --get-volume) && echo "osd-volume:$VOL:$([ "$MUTED" = "true" ] && echo muted || echo unmuted)" | socat - UNIX-CONNECT:/tmp/quickshell.sock'), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd('echo "media-play-pause" | socat - UNIX-CONNECT:/tmp/quickshell.sock'))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd('echo "media-play-pause" | socat - UNIX-CONNECT:/tmp/quickshell.sock'))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd('echo "media-next" | socat - UNIX-CONNECT:/tmp/quickshell.sock'))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd('echo "media-previous" | socat - UNIX-CONNECT:/tmp/quickshell.sock'))

-- === Brightness === --
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd([[brightnessctl set +5% && echo "osd-brightness:$(brightnessctl get | awk -v max=$(brightnessctl max) 'BEGIN{} {printf "%d", ($1/max)*100}')" | socat - UNIX-CONNECT:/tmp/quickshell.sock]]), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[brightnessctl set 5%- && echo "osd-brightness:$(brightnessctl get | awk -v max=$(brightnessctl max) 'BEGIN{} {printf "%d", ($1/max)*100}')" | socat - UNIX-CONNECT:/tmp/quickshell.sock]]), { repeating = true })

-- === Workspaces === --
require("workspaces")
