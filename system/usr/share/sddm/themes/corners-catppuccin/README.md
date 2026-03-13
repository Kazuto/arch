# Corners SDDM Theme - Catppuccin Mocha

A customized version of the [sddm-theme-corners](https://github.com/aczw/sddm-theme-corners) with Catppuccin Mocha color palette.

## Color Scheme

This theme uses the Catppuccin Mocha palette:

- **Base**: `#1e1e2e` (background)
- **Text**: `#cdd6f4` (primary text)
- **Lavender**: `#b4befe` (session button, user border)
- **Blue**: `#89b4fa` (login button, active selections)
- **Mauve**: `#cba6f7` (input borders)
- **Red**: `#f38ba8` (power button)
- **Surface0**: `#313244` (popup backgrounds)

## Customization

Edit `theme.conf` to customize the theme. Key options:

- **BgSource**: Path to wallpaper image (place in `backgrounds/` folder)
- **FontFamily**: Font name (default: JetBrainsMono Nerd Font)
- **Scale**: UI size multiplier (default: 1.2)
- **Radius**: Corner radius (default: 10)
- **Colors**: All color values can be customized

See [upstream CONFIG.md](https://github.com/aczw/sddm-theme-corners/blob/main/CONFIG.md) for full options.

## Adding Custom Wallpaper

1. Copy your wallpaper to `backgrounds/your-wallpaper.png`
2. Edit `theme.conf`:
   ```ini
   BgSource="backgrounds/your-wallpaper.png"
   ```

## Credits

- Original theme: [sddm-theme-corners](https://github.com/aczw/sddm-theme-corners) by aczw
- Color scheme: [Catppuccin Mocha](https://github.com/catppuccin/catppuccin)
