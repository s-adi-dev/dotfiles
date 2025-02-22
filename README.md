# Dotfiles Setup for Arch Linux

This repository contains the dotfiles configuration for my Arch Linux setup, including essential tools, utilities, and themes. The following packages are used for a polished and efficient desktop environment.

## Installation

To install the dotfiles and configurations, you can clone this repository and run the appropriate installation scripts. Here's how you can get started:

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/dotfiles.git
cd dotfiles
```

### 2. Install the Packages
The following packages are installed from the AUR and other sources (e.g., GitHub for the GTK theme):

```bash
sudo paru -S
  hyprland
  kitty
  firefox
  zsh
  stow
  ttf-jetbrains-mono-nerd
  ttf-firacode-nerd 
  neovim
  zoxide
  bat
  fzf
  eza
  oh-my-posh
  clipman
  jq
  zip
  unzip
  nautilus
  blueman
  brightnessctl
  pavucontrol
  yazi
  pywal16
  python-pywalfox-librewolf
  nwg-look
  waybar
  waypaper
  hyprlock
  hyprpaper
  hypridle
  hyprshot
  wlogout
  pulseaudio
  bibata-cursor-theme
  gnome-calculator
  gnome-clocks
  rofi-wayland
  gammastep
  smile
  pamixer
```

### 3. Install `graphite-gtk-theme` (from GitHub)
This package isn't available in the AUR, so it's installed directly from GitHub.

1. **Clone the repository**:
   ```bash
   git clone https://github.com/vinceliuice/Graphite-gtk-theme.git
   cd Graphite-gtk-theme
   ```

2. **Run the install script**:
   ```bash
   ./install.sh -d ~/.themes/ -t -c dark -s standard -l --tweaks darker rimless normal
   ```

## Customization

Feel free to tweak or modify the configurations in the dotfiles as per your preferences. The theme settings, cursor themes, and window manager settings can be adjusted through the respective config files.
