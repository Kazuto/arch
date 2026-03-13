# Hyprland Installation for Arch Linux

This is a standalone installation script that replicates a complete Hyprland desktop environment on Arch Linux.

## Overview

The script (`install.sh`) automatically installs and configures:

- **Hyprland** - Dynamic tiling Wayland compositor
- **Waybar** - Status bar with 7 custom scripts
- **Rofi** - Application launcher
- **Dunst** - Notification daemon
- **SDDM Theme** - Corners theme with Catppuccin Mocha colors
- **GTK Theming** - Catppuccin Mocha theme
- **18 Desktop Addons** - File managers, utilities, and tools
- **50+ Packages** - All dependencies and tools

## Prerequisites

- Fresh or existing Arch Linux installation
- Internet connection
- Non-root user account with sudo privileges

## Installation

### 1. Clone or Download This Directory

```bash
# Clone to your preferred location
git clone <your-repo-url> hyprland-arch
cd hyprland-arch
```

### 2. Make Script Executable

```bash
chmod +x install.sh
```

### 3. Run Installation

```bash
./install.sh
```

The script will:
1. Check for Arch Linux and install `yay` if needed
2. Install 50+ packages via pacman and AUR
3. Use `stow` to symlink all configuration files
4. Configure system services (keyd, dbus, etc.)
5. Add user to required groups (video, input, render, uinput)
6. Set up environment variables and GTK theming

**Duration:** 10-30 minutes depending on internet speed

### 4. Reboot or Logout

```bash
# Logout to apply group membership changes
logout

# OR reboot to start fresh
sudo reboot
```

## Post-Installation

### Login Manager

The system will boot to **SDDM** with the Corners theme (Catppuccin Mocha colors):
- The theme features a clean, minimal design with UI controls in corners
- Select Hyprland session from the session button (bottom left)
- Enter your username and password
- Power options in bottom right corner

See [SDDM Theme Customization](#sddm-theme-customization) below for wallpaper and color changes.

### Manual Start (Optional)

If you prefer to start Hyprland manually:

```bash
Hyprland
```

## Key Bindings

Your configuration uses these default bindings (check `~/.config/hypr/hyprland.conf` for full list):

| Key Combo | Action |
|-----------|--------|
| `SUPER + Return` | Terminal |
| `SUPER + D` | Rofi launcher |
| `SUPER + Q` | Close window |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + 1-9` | Switch workspace |
| `SUPER + Shift + 1-9` | Move window to workspace |
| `SUPER + Mouse Left` | Move window |
| `SUPER + Mouse Right` | Resize window |
| `Caps Lock` (tap) | Escape |
| `Caps Lock` (hold) + Key | Ctrl+Shift+Alt+Key (Hyper) |

### Hyper Layer (Caps Lock Hold)

The keyd service maps Caps Lock to a Hyper modifier:
- **Tap:** Escape
- **Hold:** Ctrl+Shift+Alt modifier for custom bindings

## Installed Components

### Core Desktop

- **Hyprland** - Window manager
- **Waybar** - Status bar
- **Rofi** - Application launcher
- **Dunst** - Notification daemon
- **SDDM** - Login manager with Corners theme (Catppuccin Mocha)

### Utilities

- **SWWW** - Wallpaper daemon
- **Hyprpicker** - Color picker
- **Wlogout** - Logout menu
- **Avizo** - Volume/brightness OSD
- **Libinput-gestures** - Touchpad gestures

### File Managers

- **Nautilus** - GNOME file manager
- **Thunar** - XFCE file manager (with plugins)

### System Services

- **Keyd** - Keyboard remapping (Caps Lock → Hyper)
- **Polkit** - Authorization agent
- **Blueman** - Bluetooth manager
- **D-Bus** - Inter-process communication

### Theming

- **Catppuccin Mocha** - GTK theme
- **Catppuccin Cursors** - Cursor theme
- **Papirus Dark** - Icon theme

## Configuration Files

All configs are managed with **GNU Stow**, which creates symlinks automatically:

```bash
# Install script uses stow to link configs
cd <install-dir>
stow --adopt -t ~ home          # User configs
sudo stow --adopt -t / system   # System configs
```

**Directory structure after stowing:**

```
~/.config/
├── hypr/              → <install-dir>/home/.config/hypr/
├── waybar/            → <install-dir>/home/.config/waybar/
├── rofi/              → <install-dir>/home/.config/rofi/
├── dunst/             → <install-dir>/home/.config/dunst/
├── wlogout/           → <install-dir>/home/.config/wlogout/
├── avizo/             → <install-dir>/home/.config/avizo/
├── swww/              → <install-dir>/home/.config/swww/
├── nvim/              → <install-dir>/home/.config/nvim/
├── gtk-3.0/           → <install-dir>/home/.config/gtk-3.0/
├── gtk-4.0/           → <install-dir>/home/.config/gtk-4.0/
├── starship.toml      → <install-dir>/home/.config/starship.toml
├── libinput-gestures.conf → <install-dir>/home/.config/libinput-gestures.conf
└── electron-flags.conf → <install-dir>/home/.config/electron-flags.conf

~/.zshrc               → <install-dir>/home/.zshrc

/etc/keyd/default.conf → <install-dir>/system/etc/keyd/default.conf
/etc/sddm.conf.d/theme.conf → <install-dir>/system/etc/sddm.conf.d/theme.conf
/usr/share/sddm/themes/corners-catppuccin/ → <install-dir>/system/usr/share/sddm/themes/corners-catppuccin/
```

**Benefits of using stow:**
- Version control your dotfiles easily
- Single source of truth for configs
- Easy to update: just edit files in the repo and changes are immediately reflected
- Easy to restore or move to another machine

## Troubleshooting

### Hyprland won't start

1. Check Xorg/Wayland conflicts:
   ```bash
   echo $XDG_SESSION_TYPE  # Should be empty before login
   ```

2. Check logs:
   ```bash
   journalctl -xe | grep hyprland
   ```

3. Try starting manually:
   ```bash
   Hyprland
   ```

### Waybar not showing

1. Check if running:
   ```bash
   pgrep waybar
   ```

2. Restart Waybar:
   ```bash
   killall waybar && waybar &
   ```

3. Check Hyprland config for exec-once:
   ```bash
   grep "exec-once.*waybar" ~/.config/hypr/hyprland.conf
   ```

### Gestures not working

1. Add user to input group (should be done by script):
   ```bash
   sudo usermod -aG input $USER
   logout
   ```

2. Check libinput-gestures:
   ```bash
   systemctl --user status libinput-gestures
   systemctl --user restart libinput-gestures
   ```

### Caps Lock / Keyd not working

1. Check keyd service:
   ```bash
   sudo systemctl status keyd
   sudo systemctl restart keyd
   ```

2. Verify config:
   ```bash
   cat /etc/keyd/default.conf
   ```

3. Test keyd:
   ```bash
   sudo keyd -m  # Monitor mode
   # Press Caps Lock and see output
   ```

### GTK theme not applied

1. Reload GTK settings:
   ```bash
   gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Mocha-Standard-Blue-Dark"
   gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
   gsettings set org.gnome.desktop.interface cursor-theme "Catppuccin-Mocha-Dark-Cursors"
   ```

2. Verify theme files exist:
   ```bash
   ls /usr/share/themes/ | grep -i catppuccin
   ls /usr/share/icons/ | grep -i papirus
   ```

## SDDM Theme Customization

The SDDM login screen uses the Corners theme with Catppuccin Mocha colors.

### Changing the Wallpaper

1. Add your wallpaper to the backgrounds folder:
   ```bash
   sudo cp /path/to/your-wallpaper.png /usr/share/sddm/themes/corners-catppuccin/backgrounds/
   ```

2. Edit the theme configuration:
   ```bash
   sudo nvim /usr/share/sddm/themes/corners-catppuccin/theme.conf
   ```

3. Update the `BgSource` line:
   ```ini
   BgSource="backgrounds/your-wallpaper.png"
   ```

### Customizing Colors

Edit `/usr/share/sddm/themes/corners-catppuccin/theme.conf` to customize colors:

```ini
# Current Catppuccin Mocha colors:
InputBorderColor="#cba6f7"      # Mauve - input field border
LoginButtonColor="#89b4fa"      # Blue - login button
UserBorderColor="#b4befe"       # Lavender - user avatar border
PowerButtonColor="#f38ba8"      # Red - power button
SessionButtonColor="#b4befe"    # Lavender - session button
```

Other customization options:
- `FontFamily` - Change font (default: JetBrainsMono Nerd Font)
- `Scale` - Adjust UI size (default: 1.2, try 1.0-2.0)
- `Radius` - Corner radius (default: 10, set 0 for sharp corners)
- `Padding` - Distance from screen edges (default: 50)

See the [theme README](system/usr/share/sddm/themes/corners-catppuccin/README.md) for full options.

## Differences from NixOS Config

### Features NOT Available

1. **Hyprload** - Plugin manager (disabled in your Nix config anyway)
2. **Automatic rollback** - No declarative system state
3. **Atomic updates** - Standard Arch package management

### Manual Maintenance Required

1. **Updates:** Run `yay -Syu` instead of `nixos-rebuild switch`
2. **Config changes:** Edit files in `~/.config/` directly
3. **Package management:** Use pacman/yay instead of Nix modules
4. **Rollback:** Manual backup/restore instead of Nix generations

### Customization

To modify your setup:

1. **Add packages:**
   ```bash
   yay -S <package-name>
   ```

2. **Edit configs:**

   Since configs are symlinked via stow, edit files in the repo:
   ```bash
   cd <install-dir>
   # Edit any config in home/.config/
   nvim home/.config/hypr/hyprland.conf
   nvim home/.config/waybar/config.jsonc
   nvim home/.config/rofi/config.rasi
   # Changes are immediately reflected in ~/.config/
   ```

3. **Remove components:**
   ```bash
   yay -Rns <package-name>
   # Unstow if you want to remove the symlinks
   cd <install-dir>
   stow -D home
   ```

## Uninstallation

To remove Hyprland and all components:

```bash
# Unstow configs
cd <install-dir>
stow -D home              # Remove user config symlinks
sudo stow -D system       # Remove system config symlinks

# Remove packages
yay -Rns waybar rofi swww wlogout keyd libinput-gestures \
    nautilus thunar blueman polkit-gnome avizo hyprpicker

# Note: Don't remove hyprland, dunst, sddm - installed by Arch base

# Disable services
sudo systemctl disable --now keyd
pkill libinput-gestures

# Remove user from groups
sudo gpasswd -d $USER video
sudo gpasswd -d $USER input
sudo gpasswd -d $USER render
sudo gpasswd -d $USER uinput

# Optionally remove the install directory
rm -rf <install-dir>
```

## Comparison: Nix vs Bash Script

| Feature | NixOS Config | Bash Script |
|---------|-------------|-------------|
| **Declarative** | ✅ Full system state | ❌ Imperative install |
| **Reproducible** | ✅ Bit-for-bit | ⚠️ Time-dependent |
| **Rollback** | ✅ Instant rollback | ❌ Manual restore |
| **Updates** | `nixos-rebuild` | `yay -Syu` |
| **Portability** | ✅ Any Linux distro | ❌ Arch only |
| **Setup time** | 15-30 min | 10-20 min |
| **Complexity** | High (Nix learning) | Low (bash script) |
| **Maintenance** | Low (declarative) | Medium (manual) |

## Directory Structure

```
.
├── home/                     # User-level configs (stowed to ~)
│   ├── .config/
│   │   ├── hypr/            # Hyprland (main, keybind, env)
│   │   ├── waybar/          # Waybar (config, scripts, style)
│   │   ├── rofi/            # Rofi launcher
│   │   ├── dunst/           # Notification daemon
│   │   ├── wlogout/         # Logout menu
│   │   ├── avizo/           # Volume/brightness OSD
│   │   ├── swww/            # Wallpaper daemon
│   │   ├── nvim/            # Neovim config (Lazy.nvim, LSP, plugins)
│   │   ├── gtk-3.0/         # GTK 3 theme settings
│   │   ├── gtk-4.0/         # GTK 4 theme settings
│   │   ├── starship.toml    # Starship prompt
│   │   ├── libinput-gestures.conf
│   │   └── electron-flags.conf
│   └── .zshrc               # ZSH configuration
├── system/                   # System-level configs (stowed to /)
│   ├── etc/
│   │   ├── keyd/            # Keyboard remapping
│   │   └── sddm.conf.d/     # SDDM configuration
│   └── usr/share/sddm/themes/
│       └── corners-catppuccin/  # SDDM theme (Catppuccin Mocha)
├── install.sh               # Main installation script
├── uninstall.sh             # Uninstallation script
└── README.md                # This file
```

**Note:** The directory structure mirrors the home directory structure, making it easy to use with GNU Stow.

## Support

- **Script issues:** Check `/tmp/hyprland-install-*.log`
- **Hyprland docs:** https://wiki.hyprland.org/
- **Arch wiki:** https://wiki.archlinux.org/

## Credits

Generated from a NixOS Hyprland configuration using Snowfall Lib architecture.
