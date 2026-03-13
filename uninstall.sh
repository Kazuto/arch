#!/bin/bash
#
# Hyprland Desktop Environment Uninstallation Script for Arch Linux
# Removes all components installed by install.sh
#
# Usage: ./uninstall.sh
#

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

confirm() {
    echo -e "${YELLOW}WARNING:${NC} This will remove Hyprland and ALL related components!"
    echo ""
    echo "The following will be removed:"
    echo "  - All Hyprland packages and addons"
    echo "  - Configuration files in ~/.config/"
    echo "  - System services (greetd, keyd, etc.)"
    echo "  - User group memberships"
    echo ""
    read -p "Are you sure? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Uninstallation cancelled"
        exit 0
    fi
}

backup_configs() {
    log_info "Creating backup of configs..."

    BACKUP_DIR="$HOME/hyprland-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    for dir in hypr waybar rofi dunst wlogout avizo; do
        if [[ -d "$HOME/.config/$dir" ]]; then
            cp -r "$HOME/.config/$dir" "$BACKUP_DIR/" 2>/dev/null || true
        fi
    done

    [[ -f "$HOME/.config/libinput-gestures.conf" ]] && cp "$HOME/.config/libinput-gestures.conf" "$BACKUP_DIR/"
    [[ -f "$HOME/.config/electron-flags.conf" ]] && cp "$HOME/.config/electron-flags.conf" "$BACKUP_DIR/"

    if [[ -n "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
        log_success "Backup saved to: $BACKUP_DIR"
    else
        rmdir "$BACKUP_DIR"
        log_info "No configs found to backup"
    fi
}

stop_services() {
    log_info "Stopping services..."

    # Stop libinput-gestures (no systemd service)
    pkill libinput-gestures 2>/dev/null || true

    # System services
    sudo systemctl stop keyd 2>/dev/null || true
    sudo systemctl disable keyd 2>/dev/null || true

    log_success "Services stopped"
}

remove_packages() {
    log_info "Removing packages..."

    # Core packages (note: hyprland, dunst, sddm installed by Arch base, don't remove)
    PACKAGES_TO_REMOVE=(
        waybar
        rofi
        hyprpicker
        swww
        wlogout
        xdg-desktop-portal-hyprland
        keyd
        libinput-gestures
        avizo
        solaar
        nautilus
        sushi
        thunar
        thunar-archive-plugin
        thunar-volman
        blueman
        polkit-gnome
        catppuccin-gtk-theme-mocha
        catppuccin-cursors-mocha
        playerctl
        inotify-tools
        pamixer
        brightnessctl
        wmctrl
        xdotool
        wl-clipboard
        grim
        slurp
    )

    log_info "Removing ${#PACKAGES_TO_REMOVE[@]} packages..."
    yay -Rns --noconfirm "${PACKAGES_TO_REMOVE[@]}" 2>/dev/null || log_warning "Some packages may have already been removed"

    log_success "Packages removed"
}

remove_configs() {
    log_info "Removing configuration files..."

    # Unstow configs using stow
    cd "$SCRIPT_DIR"

    if [[ -d "home" ]]; then
        stow -D home 2>/dev/null || log_warning "Failed to unstow home configs (may already be removed)"
        log_success "Unstowed user configs"
    fi

    if [[ -d "system" ]]; then
        sudo stow -D system 2>/dev/null || log_warning "Failed to unstow system configs (may already be removed)"
        log_success "Unstowed system configs"
    fi

    log_success "Configuration files removed"
}

remove_from_groups() {
    log_info "Removing user from groups..."

    for group in video input render uinput; do
        if groups "$USER" | grep -q "\b$group\b"; then
            sudo gpasswd -d "$USER" "$group" 2>/dev/null || log_warning "Failed to remove from $group"
            log_success "Removed from group: $group"
        fi
    done

    log_warning "Group changes require logout/login to take effect"
}

cleanup_orphans() {
    log_info "Cleaning up orphaned packages..."

    yay -Yc --noconfirm 2>/dev/null || true

    log_success "Cleanup complete"
}

print_summary() {
    echo ""
    echo "=================================="
    log_success "Uninstallation Complete!"
    echo "=================================="
    echo ""
    echo "Removed components:"
    echo "  ✓ Hyprland and all addons"
    echo "  ✓ Configuration files"
    echo "  ✓ System services"
    echo "  ✓ User group memberships"
    echo ""
    echo "Next steps:"
    echo "1. ${YELLOW}REBOOT${NC} to complete removal"
    echo "2. Install another window manager/desktop environment"
    echo ""
    if [[ -d "$BACKUP_DIR" ]]; then
        echo "Backup location: ${GREEN}$BACKUP_DIR${NC}"
    fi
    echo ""
}

main() {
    log_info "Hyprland Uninstallation Script"
    echo ""

    confirm
    backup_configs
    stop_services
    remove_packages
    remove_configs
    remove_from_groups
    cleanup_orphans
    print_summary
}

main "$@"
