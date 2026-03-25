#!/bin/bash
#
# Hyprland Desktop Environment Installation Script for Arch Linux
# Generated from Nix configuration at /Users/kazuto/.nix/modules/nixos/desktop/
#
# This script replicates the complete Hyprland setup including:
# - Hyprland window manager with 18 addons
# - Waybar, Rofi, Dunst, and all desktop components
# - GTK theming (Catppuccin)
# - All configuration files and scripts
#
# Usage: ./install-hyprland-arch.sh
#

set -e          # Exit on error
set -o pipefail # Catch errors in pipes

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_LOG="/tmp/hyprland-install-$(date +%Y%m%d-%H%M%S).log"

# Helper functions
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$INSTALL_LOG"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$INSTALL_LOG"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$INSTALL_LOG"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1" | tee -a "$INSTALL_LOG"
}

# Spinner for long-running commands
spinner() {
  local pid=$1
  local msg=$2
  local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0

  while kill -0 $pid 2>/dev/null; do
    i=$(((i + 1) % 10))
    printf "\r${BLUE}[${spin:$i:1}]${NC} %s" "$msg"
    sleep 0.1
  done
  printf "\r"
}

check_root() {
  if [[ $EUID -eq 0 ]]; then
    log_error "This script should NOT be run as root. Run as a regular user."
    exit 1
  fi
}

check_arch() {
  if [[ ! -f /etc/arch-release ]]; then
    log_error "This script is designed for Arch Linux only."
    exit 1
  fi
}

check_yay() {
  if ! command -v yay &>/dev/null; then
    log_warning "yay AUR helper not found. Installing yay..."

    # Install build dependencies
    if ! sudo pacman -S --needed --noconfirm git base-devel; then
      log_error "Failed to install yay dependencies"
      exit 1
    fi

    # Clone and build yay
    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm

    # Verify installation
    cd "$SCRIPT_DIR"
    if ! command -v yay &>/dev/null; then
      log_error "Failed to install yay"
      exit 1
    fi

    log_success "yay installed successfully"
  else
    log_info "yay is already installed"
  fi
}

enable_multilib() {
  if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
    log_info "Enabling multilib repository (for 32-bit support and Steam)..."
    sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
    sudo pacman -Sy --noconfirm 2>&1 | tee -a "$INSTALL_LOG"
    log_success "multilib repository enabled"
  else
    log_info "multilib repository already enabled"
  fi
}

# Main installation function
install_packages() {
  log_info "Installing additional packages (Hyprland Desktop Profile already installed base packages)..."

  # Packages NOT included in Arch's Hyprland Desktop Profile
  # Profile includes: dolphin, dunst, grim, htop, hyprland, iwd, kitty, nano,
  #                   openssh, polkit-kde-agent, qt5/qt6-wayland, slurp,
  #                   smartmontools, uwsm, vim, wget, wireless_tools, wofi,
  #                   xdg-desktop-portal-hyprland, xdg-utils

  # Additional core utilities
  local CORE_PACKAGES=(
    cmake
    cpio
    ghostty # Terminal emulator
    hyprland-protocols
    jq
    mpv
    ninja
    nss
    qt5-graphicaleffects # SDDM theme dependencies
    qt5-quickcontrols2
    qt5-svg
    usbutils
    viewnior
    wl-clipboard
    xdg-user-dirs
    xsel
  )

  # CLI tools (from modules/home/cli/)
  local CLI_PACKAGES=(
    base-devel # Build tools
    bat        # Better cat
    btop
    bun
    yarn
    eza                     # Better ls
    fastfetch               # System info
    fd                      # Fast find
    fzf                     # Fuzzy finder
    git                     # Version control
    github-cli              # gh command
    gitleaks                # Secret scanner
    lazygit                 # Git TUI
    neovim                  # Text editor
    ollama                  # LLM runner
    pwgen                   # Password generator
    ripgrep                 # Fast grep
    starship                # Shell prompt
    stow                    # Dotfile manager
    tmux                    # Terminal multiplexer
    trash-cli               # Safe rm
    tree                    # Directory tree
    wget                    # Downloader
    xclip                   # Clipboard
    yazi                    # Terminal file manager
    zoxide                  # Smart cd
    zsh                     # Shell
    zsh-autosuggestions     # ZSH plugin
    zsh-syntax-highlighting # ZSH plugin
  )

  # Development languages (from modules/home/development/languages/)
  local DEV_PACKAGES=(
    docker         # Container platform
    docker-buildx  # Docker buildx
    docker-compose # Docker compose
    ghostscript    # PostScript interpreter
    go             # Go language
    lua            # Lua language
    nodejs         # Node.js
    npm            # Node package manager
    php            # PHP
    pyenv          # Python version manager
    python         # Python 3
    python-pip     # Python package manager
    rust           # Rust language
    sqlite         # Database

    # Code formatters (pacman)
    python-black # Python formatter
    python-isort # Python import sorter
    shfmt        # Shell script formatter
    stylua       # Lua formatter

    # LSP servers (pacman)
    bash-language-server         # Bash LSP
    gopls                        # Go LSP
    lua-language-server          # Lua LSP
    typescript-language-server   # TypeScript/JavaScript LSP
    vscode-langservers-extracted # CSS, HTML, JSON LSP
    yaml-language-server         # YAML LSP

    # Linters (pacman)
    shellcheck # Shell script linter

    # Debug adapters (pacman)
    delve # Go debugger
  )

  # Waybar and dependencies
  local WAYBAR_PACKAGES=(
    inotify-tools
    libnotify
    playerctl
    waybar
  )

  # Desktop addons (not in profile)
  local ADDON_PACKAGES=(
    blueman
    brightnessctl
    gvfs     # Virtual filesystem
    nautilus # GNOME file manager
    pamixer
    polkit-gnome # We use GNOME agent, profile has KDE agent
    rofi         # Profile has wofi, we want rofi
    rofimoji     # Emoji picker for rofi
    sushi        # File previewer
    swww         # Wallpaper daemon
    thunar       # XFCE file manager
    thunar-archive-plugin
    thunar-volman
    tumbler # Thumbnail support
    wmctrl
    wtype                  # Wayland typing tool (for rofimoji)
    xdg-desktop-portal-gtk # GTK portal
    xdotool
    ydotool # Alternative typing tool
  )

  # GTK theming
  local GTK_PACKAGES=(
    dconf-editor
    gnome-themes-extra
    papirus-icon-theme
    sassc
  )

  # Fonts
  local FONT_PACKAGES=(
    noto-fonts              # Base fonts (Latin, Cyrillic, Greek, etc.)
    noto-fonts-cjk          # Chinese, Japanese, Korean fonts
    noto-fonts-emoji        # Emoji support
    noto-fonts-extra        # Arabic, Hebrew, Thai, Devanagari, and other scripts
    otf-font-awesome        # Font Awesome icons
    ttf-jetbrains-mono-nerd # Nerd Font with icons
    ttf-nerd-fonts-symbols  # Additional Nerd Font symbols
    ttf-firacode-nerd
    ttf-fira-code
    ttf-fira-mono
  )

  # Essential applications (from modules/home/apps/)
  local APP_PACKAGES=(
    discord        # Chat
    firefox        # Web browser
    obs-studio     # Streaming/recording
    retroarch      # Emulation frontend
    signal-desktop # Secure messaging
    steam          # Gaming platform (requires multilib)
  )

  # AMD GPU/CPU performance & monitoring + Gaming peripherals
  local AMD_PACKAGES=(
    amdgpu_top          # GPU monitoring tool
    corectrl            # GPU/CPU control GUI
    gamemode            # Gaming performance optimization
    gamescope           # Gaming microcompositor (fixes mouse/fullscreen issues)
    lib32-gamemode      # 32-bit gamemode support
    lib32-mesa          # 32-bit Mesa drivers
    lib32-vulkan-radeon # 32-bit Vulkan support
    libva-mesa-driver   # Hardware video acceleration
    mangohud            # Gaming overlay
    nvtop               # GPU monitoring TUI
    powertop            # Power consumption analysis

    # Controller support
    linuxconsole # Joystick utilities (includes jstest)
  )

  # Virtualization (QEMU/KVM + libvirt)
  local VIRT_PACKAGES=(
    qemu-full    # Full QEMU system emulation
    libvirt      # Virtualization API
    virt-manager # GUI for managing VMs
    virt-viewer  # VM console viewer
    dnsmasq      # DNS/DHCP for VM networking
    bridge-utils # Network bridge utilities
    iptables-nft # Firewall for VM networking
    edk2-ovmf    # UEFI firmware for VMs
    swtpm        # TPM emulation (for Windows 11)
    dmidecode    # Hardware info for VMs
  )

  # Combine all packages (no login manager - SDDM already installed by Arch)
  local ALL_PACKAGES=(
    "${CORE_PACKAGES[@]}"
    "${CLI_PACKAGES[@]}"
    "${DEV_PACKAGES[@]}"
    "${WAYBAR_PACKAGES[@]}"
    "${ADDON_PACKAGES[@]}"
    "${GTK_PACKAGES[@]}"
    "${FONT_PACKAGES[@]}"
    "${APP_PACKAGES[@]}"
    "${AMD_PACKAGES[@]}"
    "${VIRT_PACKAGES[@]}"
  )

  log_info "Installing ${#ALL_PACKAGES[@]} packages via pacman (including AMD/gaming/virtualization)..."

  # Debug: show packages to be installed
  echo "Packages to install:" >>"$INSTALL_LOG"
  printf '%s\n' "${ALL_PACKAGES[@]}" >>"$INSTALL_LOG"

  # Test sudo access first
  if ! sudo -v; then
    log_error "sudo authentication failed. Please run this script with sudo access."
    exit 1
  fi

  # System update first (separate from package installation)
  log_info "Updating system..."
  if ! sudo pacman -Syu --noconfirm 2>&1 | tee -a "$INSTALL_LOG"; then
    log_warning "System update had issues, continuing with package installation..."
  fi

  # Install packages individually to handle failures gracefully
  log_info "Installing ${#ALL_PACKAGES[@]} packages with pacman..."

  local FAILED_PACKAGES=()
  local INSTALLED_COUNT=0
  local SKIPPED_COUNT=0

  for pkg in "${ALL_PACKAGES[@]}"; do
    # Check if already installed
    if pacman -Q "$pkg" &>/dev/null; then
      SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
      log_info "[$INSTALLED_COUNT/${#ALL_PACKAGES[@]}] $pkg (already installed)"
      INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
      continue
    fi

    # Show spinner during installation
    echo -ne "${BLUE}[⠋]${NC} [$INSTALLED_COUNT/${#ALL_PACKAGES[@]}] Installing: $pkg..."
    sudo pacman -S --needed --noconfirm "$pkg" >>"$INSTALL_LOG" 2>&1 &
    spinner $! "[$INSTALLED_COUNT/${#ALL_PACKAGES[@]}] Installing: $pkg..."
    wait $!

    if [ $? -eq 0 ]; then
      INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
      log_success "[$INSTALLED_COUNT/${#ALL_PACKAGES[@]}] Installed: $pkg"
    else
      FAILED_PACKAGES+=("$pkg")
      log_warning "[$INSTALLED_COUNT/${#ALL_PACKAGES[@]}] Failed: $pkg"
    fi
  done

  # Summary
  echo "" | tee -a "$INSTALL_LOG"
  log_info "Installation summary:"
  log_success "  Installed/Already present: $INSTALLED_COUNT/${#ALL_PACKAGES[@]}"
  log_info "  Skipped (already installed): $SKIPPED_COUNT"

  if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
    log_warning "  Failed packages (${#FAILED_PACKAGES[@]}):"
    printf '    - %s\n' "${FAILED_PACKAGES[@]}" | tee -a "$INSTALL_LOG"
    log_warning "You may need to install these manually or check if they exist"
  else
    log_success "  All packages installed successfully!"
  fi
  echo "" | tee -a "$INSTALL_LOG"

  # Verify critical packages are installed
  for pkg in zsh git neovim; do
    if ! pacman -Q "$pkg" &>/dev/null; then
      log_error "$pkg is not installed. Package installation may have failed."
      exit 1
    fi
  done

  # AUR packages
  log_info "Installing AUR packages..."
  local AUR_PACKAGES=(
    # Desktop utilities
    avizo
    catppuccin-cursors-mocha
    catppuccin-gtk-theme-mocha
    grimblast-git      # Screenshot utility wrapper
    gtk-engine-murrine # GTK2 murrine engine
    hyprpicker
    keyd
    libinput-gestures # Touchpad gestures
    solaar
    wleave-git # Modern logout menu (GTK4)

    # Applications (AUR)
    bitwarden     # Password manager
    obsidian      # Note-taking
    spotify       # Music streaming
    spicetify-cli # Spotify customization tool
    vencord       # Discord customization tool

    # Gaming (AUR)
    atlauncher-bin

    # Development tools (from modules/home/development/tools/)
    bruno-bin    # API client
    gh-ost       # MySQL schema migration
    jira-cli     # Jira CLI tool
    tableplus    # Database GUI (if available)
    tmuxifier    # Tmux session manager
    opencode-bin # AI coding assistant

    # Code formatters (AUR)
    blade-formatter # Laravel Blade template formatter
    gofumpt         # Go formatter (stricter than gofmt)
    oxfmt           # Fast JavaScript/TypeScript formatter from oxc project
    php-cs-fixer    # PHP coding standards fixer
    prettierd       # Prettier daemon (faster formatting)
    laravel-pint    # Laravel PHP code style fixer

    # LSP servers (AUR)
    emmet-ls                    # Emmet LSP
    intelephense                # PHP LSP
    phpactor                    # PHP LSP (alternative)
    tailwindcss-language-server # Tailwind CSS LSP
    vue-language-server         # Vue LSP

    # Linters (AUR)
    eslint_d # Fast ESLint daemon
    oxlint   # Fast JavaScript/TypeScript linter from oxc project

    # System performance (AUR)
    auto-cpufreq # Automatic CPU frequency scaling

    # Controller support (AUR)
    jstest-gtk-git # Joystick testing GUI
    xpadneo-dkms   # Xbox/GameSir controller driver (Bluetooth)
    # Note: claude, opencode might not be in AUR
  )

  # Install AUR packages individually
  local AUR_FAILED=()
  local AUR_INSTALLED=0

  for pkg in "${AUR_PACKAGES[@]}"; do
    if pacman -Q "$pkg" &>/dev/null; then
      log_info "[$AUR_INSTALLED/${#AUR_PACKAGES[@]}] $pkg (already installed)"
      AUR_INSTALLED=$((AUR_INSTALLED + 1))
      continue
    fi

    # Show spinner for AUR builds (can take several minutes)
    echo -ne "${BLUE}[⠋]${NC} [$AUR_INSTALLED/${#AUR_PACKAGES[@]}] Building (AUR): $pkg..."
    yay -S --needed --noconfirm "$pkg" >>"$INSTALL_LOG" 2>&1 &
    spinner $! "[$AUR_INSTALLED/${#AUR_PACKAGES[@]}] Building (AUR): $pkg (this may take a few minutes)..."
    wait $!

    if [ $? -eq 0 ]; then
      AUR_INSTALLED=$((AUR_INSTALLED + 1))
      log_success "[$AUR_INSTALLED/${#AUR_PACKAGES[@]}] Installed (AUR): $pkg"
    else
      AUR_FAILED+=("$pkg")
      log_warning "[$AUR_INSTALLED/${#AUR_PACKAGES[@]}] Failed (AUR): $pkg"
    fi
  done

  # AUR Summary
  echo "" | tee -a "$INSTALL_LOG"
  log_info "AUR installation summary:"
  log_success "  Installed/Already present: $AUR_INSTALLED/${#AUR_PACKAGES[@]}"

  if [ ${#AUR_FAILED[@]} -gt 0 ]; then
    log_warning "  Failed AUR packages (${#AUR_FAILED[@]}):"
    printf '    - %s\n' "${AUR_FAILED[@]}" | tee -a "$INSTALL_LOG"
  fi
  echo "" | tee -a "$INSTALL_LOG"

  log_success "Package installation complete"
}

symlink_configs() {
  log_info "Symlinking configuration files using stow..."

  # Change to script directory for stow
  cd "$SCRIPT_DIR"

  # Stow user configurations (home directory)
  if [[ -d "home" ]]; then
    log_info "Stowing home directory configs..."
    stow --adopt -t ~ home 2>&1 | tee -a "$INSTALL_LOG" || {
      log_error "Failed to stow home configs"
      return 1
    }
    log_success "Stowed user configs to ~"
  else
    log_error "home/ directory not found"
    return 1
  fi
}

configure_services() {
  log_info "Configuring system services (idempotent)..."

  # Stow system configurations (requires sudo)
  if [[ -d "${SCRIPT_DIR}/system" ]]; then
    log_info "Stowing system configs..."
    cd "$SCRIPT_DIR"
    sudo stow --adopt -t / system 2>&1 | tee -a "$INSTALL_LOG" || log_warning "Failed to stow system configs"
    log_success "Stowed system configs to /"
  fi

  # Enable and start keyd service
  if ! systemctl is-enabled keyd &>/dev/null; then
    sudo systemctl enable keyd 2>&1 | tee -a "$INSTALL_LOG" || log_warning "Failed to enable keyd"
  fi
  if ! systemctl is-active keyd &>/dev/null; then
    sudo systemctl start keyd 2>&1 | tee -a "$INSTALL_LOG" || log_warning "Failed to start keyd"
  else
    sudo systemctl restart keyd 2>&1 | tee -a "$INSTALL_LOG" || log_warning "Failed to restart keyd"
  fi

  # Enable D-Bus (if not already enabled)
  if ! systemctl is-enabled dbus &>/dev/null; then
    sudo systemctl enable dbus 2>&1 | tee -a "$INSTALL_LOG"
  fi
  if ! systemctl is-active dbus &>/dev/null; then
    sudo systemctl start dbus 2>&1 | tee -a "$INSTALL_LOG"
  fi

  # Enable and configure SDDM (login manager)
  log_info "Configuring SDDM login manager..."
  if ! systemctl is-enabled sddm &>/dev/null; then
    sudo systemctl enable sddm 2>&1 | tee -a "$INSTALL_LOG"
    log_success "SDDM enabled"
  else
    log_info "SDDM already enabled"
  fi

  # Enable and start libinput-gestures user service
  if command -v libinput-gestures &>/dev/null; then
    # Stop any background instances
    pkill -u "$USER" libinput-gestures 2>/dev/null || true
    # Enable and start systemd user service
    systemctl --user enable --now libinput-gestures
    log_success "Enabled libinput-gestures user service"
  else
    log_warning "libinput-gestures not installed"
  fi

  # Install Oh-My-Zsh (if not already installed)
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log_info "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_success "Oh-My-Zsh installed"
  else
    log_info "Oh-My-Zsh already installed"
  fi

  # Enable auto-cpufreq if installed
  if command -v auto-cpufreq &>/dev/null; then
    if ! systemctl is-enabled auto-cpufreq &>/dev/null; then
      sudo auto-cpufreq --install 2>&1 | tee -a "$INSTALL_LOG"
      log_success "auto-cpufreq service installed"
    else
      log_info "auto-cpufreq already enabled"
    fi
  fi

  # Enable and start ollama service if installed
  if command -v ollama &>/dev/null; then
    if ! systemctl is-enabled ollama &>/dev/null; then
      sudo systemctl enable ollama 2>&1 | tee -a "$INSTALL_LOG"
      log_success "ollama service enabled"
    else
      log_info "ollama already enabled"
    fi
    if ! systemctl is-active ollama &>/dev/null; then
      sudo systemctl start ollama 2>&1 | tee -a "$INSTALL_LOG"
      log_success "ollama service started"
    else
      log_info "ollama already running"
    fi
  fi

  # Enable and start libvirt services if installed
  if command -v virsh &>/dev/null; then
    log_info "Configuring libvirt virtualization services..."

    if ! systemctl is-enabled libvirtd &>/dev/null; then
      sudo systemctl enable libvirtd 2>&1 | tee -a "$INSTALL_LOG"
      log_success "libvirtd service enabled"
    else
      log_info "libvirtd already enabled"
    fi

    if ! systemctl is-active libvirtd &>/dev/null; then
      sudo systemctl start libvirtd 2>&1 | tee -a "$INSTALL_LOG"
      log_success "libvirtd service started"
    else
      log_info "libvirtd already running"
    fi

    # Enable virtlogd (logging daemon)
    if ! systemctl is-enabled virtlogd &>/dev/null; then
      sudo systemctl enable virtlogd 2>&1 | tee -a "$INSTALL_LOG"
    fi

    # Start default network
    if ! sudo virsh net-list --all | grep -q "default.*active"; then
      sudo virsh net-autostart default 2>&1 | tee -a "$INSTALL_LOG" || log_warning "Failed to autostart default network"
      sudo virsh net-start default 2>&1 | tee -a "$INSTALL_LOG" || log_warning "Failed to start default network"
      log_success "libvirt default network configured"
    else
      log_info "libvirt default network already active"
    fi
  fi

  log_success "Services configured"
}

configure_user_groups() {
  log_info "Adding user to required groups (idempotent)..."

  local REQUIRED_GROUPS=(video input render uinput libvirt)
  local ADDED=0

  for group in "${REQUIRED_GROUPS[@]}"; do
    # Create group if it doesn't exist (mainly for uinput)
    if ! getent group "$group" &>/dev/null; then
      sudo groupadd "$group"
      log_success "Created group: $group"
    fi

    # Add user to group if not already in it
    if ! groups "$USER" | grep -q "\b$group\b"; then
      sudo usermod -aG "$group" "$USER"
      log_success "Added $USER to group: $group"
      ADDED=1
    else
      log_info "User already in group: $group"
    fi
  done

  if [[ $ADDED -eq 1 ]]; then
    log_warning "Group changes require logout/login to take effect"
  else
    log_success "All groups already configured"
  fi
}

configure_environment() {
  log_info "Configuring environment variables..."

  # Environment file should already be symlinked by symlink_configs()
  # Just need to ensure hyprland.conf sources it
  if [[ -f ~/.config/hypr/hyprland.conf ]]; then
    if ! grep -q "source.*env.conf" ~/.config/hypr/hyprland.conf 2>/dev/null; then
      echo "" >>~/.config/hypr/hyprland.conf
      echo "# Environment variables" >>~/.config/hypr/hyprland.conf
      echo "source = ~/.config/hypr/env.conf" >>~/.config/hypr/hyprland.conf
      log_success "Added env.conf source to hyprland.conf"
    else
      log_info "env.conf already sourced in hyprland.conf"
    fi
  else
    log_warning "hyprland.conf not found, cannot add env.conf source"
  fi
}

setup_gtk_theme() {
  log_info "Setting up GTK theme..."

  mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

  # GTK 3 settings
  cat >~/.config/gtk-3.0/settings.ini <<'EOF'
[Settings]
gtk-theme-name=catppuccin-mocha-pink-standard+default
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Sans 10
gtk-cursor-theme-name=Catppuccin-Mocha-Dark-Cursors
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
gtk-application-prefer-dark-theme=1
EOF

  # GTK 4 settings
  cat >~/.config/gtk-4.0/settings.ini <<'EOF'
[Settings]
gtk-theme-name=catppuccin-mocha-pink-standard+default
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Sans 10
gtk-cursor-theme-name=Catppuccin-Mocha-Dark-Cursors
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF

  # Apply theme via gsettings
  gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-pink-standard+default'
  gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
  gsettings set org.gnome.desktop.interface cursor-theme 'Catppuccin-Mocha-Dark-Cursors'

  log_success "GTK theme configured"

  # Refresh font cache
  log_info "Refreshing font cache..."
  fc-cache -fv
  log_success "Font cache refreshed"
}

install_hyprland_plugins() {
  log_info "Installing Hyprland plugins via hyprpm..."

  # Install split-monitor-workspaces plugin
  log_info "Adding split-monitor-workspaces plugin..."
  hyprpm add https://github.com/Duckonaut/split-monitor-workspaces 2>&1 | tee -a "$INSTALL_LOG" || {
    log_warning "Failed to add split-monitor-workspaces plugin"
    return 0
  }

  log_info "Enabling split-monitor-workspaces plugin..."
  hyprpm enable split-monitor-workspaces 2>&1 | tee -a "$INSTALL_LOG" || {
    log_warning "Failed to enable split-monitor-workspaces plugin"
    return 0
  }

  log_success "Hyprland plugins installed"
}

print_summary() {
  echo ""
  echo "=================================="
  log_success "Installation/Update Complete!"
  echo "=================================="
  echo ""
  echo "Next steps:"
  echo ""
  echo "1. ${YELLOW}LOGOUT and LOGIN${NC} (if groups were added)"
  echo "2. System will boot to SDDM (login manager)"
  echo "3. Select Hyprland session and login"
  echo ""
  echo "${BLUE}Note:${NC} This script is idempotent - safe to run multiple times"
  echo ""
  echo "Key bindings (from your config):"
  echo "  - ${BLUE}SUPER${NC} = Main modifier key"
  echo "  - ${BLUE}Caps Lock${NC} = Hyper layer (Ctrl+Shift+Alt) / Esc on tap"
  echo "  - ${BLUE}SUPER + Return${NC} = Terminal"
  echo "  - ${BLUE}SUPER + D${NC} = Rofi launcher"
  echo "  - ${BLUE}SUPER + Q${NC} = Close window"
  echo ""
  echo "AMD GPU/Performance tools:"
  echo "  - ${BLUE}nvtop${NC} = GPU monitoring"
  echo "  - ${BLUE}amdgpu_top${NC} = AMD GPU stats"
  echo "  - ${BLUE}corectrl${NC} = GPU/CPU control GUI"
  echo "  - ${BLUE}auto-cpufreq --stats${NC} = CPU frequency info"
  echo ""
  echo "Virtualization tools:"
  echo "  - ${BLUE}virt-manager${NC} = VM management GUI"
  echo "  - ${BLUE}virsh${NC} = CLI for managing VMs"
  echo "  - Includes UEFI/TPM support for Windows 11 VMs"
  echo ""
  echo "Installed components:"
  echo "  ✓ Hyprland (Wayland compositor)"
  echo "  ✓ Waybar (status bar)"
  echo "  ✓ Rofi + rofimoji (launcher & emoji picker)"
  echo "  ✓ Dunst (notifications)"
  echo "  ✓ SWWW (wallpaper daemon)"
  echo "  ✓ Catppuccin GTK theme"
  echo "  ✓ AMD GPU tools (amdgpu_top, nvtop, corectrl)"
  echo "  ✓ Gaming (Steam, GameMode, MangoHUD)"
  echo "  ✓ Virtualization (QEMU/KVM, libvirt, virt-manager)"
  echo "  ✓ Development (Docker, Ollama, Node, Go, Rust, Python)"
  echo "  ✓ And many more..."
  echo ""
  echo "Logs saved to: ${INSTALL_LOG}"
  echo ""
  log_warning "Remember to logout/login for group changes to take effect!"
  echo ""
}

# Main execution
main() {
  log_info "Starting Hyprland installation for Arch Linux..."
  log_info "Log file: $INSTALL_LOG"

  check_root
  check_arch
  enable_multilib
  check_yay

  install_packages
  symlink_configs
  configure_services
  configure_user_groups
  configure_environment
  setup_gtk_theme
  install_hyprland_plugins

  print_summary
}

# Run main function
main "$@"
