-- Hyprland environment variables

-- Wayland-specific
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("NIXOS_OZONE_WL", "1")

-- GTK theming
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Cursor theme
hl.env("XCURSOR_THEME", "Catppuccin-Mocha-Dark-Cursors")
hl.env("XCURSOR_SIZE", "24")

-- Default browser
hl.env("BROWSER", "chromium")

-- GTK portal integration
hl.env("GTK_USE_PORTAL", "1")

-- Polkit agent
hl.env("POLKIT_AUTH_AGENT", "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
