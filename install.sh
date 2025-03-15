#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print header
print_header() {
    echo -e "${BLUE}
    _       __     __                         _____ __        __
   | |     / /__  / /________  ____ ___  ___ / ___// /_____  / /
   | | /| / / _ \\/ / ___/ __ \\/ __ \`__ \\/ _ \\\\__ \\/ __/ __ \\/ / 
   | |/ |/ /  __/ / /__/ /_/ / / / / / /  __/__/ / /_/ /_/ / /  
   |__/|__/\\___/_/\\___/\\____/_/ /_/ /_/\\___/____/\\__/\\____/_/   
    ${NC}"
    echo -e "${YELLOW}---------------------------------------------${NC}"
}

# Function to print status messages
print_status() {
    echo -e "${YELLOW}[*] $1${NC}"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}[+] $1${NC}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}[-] $1${NC}"
    exit 1
}

# Install base packages
install_pacman_packages() {
    #print_status "Updating system and installing packages..."
    #sudo pacman -Syu --noconfirm || print_error "Failed to update system"
    sudo pacman -Sy --noconfirm hyprland kitty zsh git base-devel pipewire brightnessctl \
        waybar neovim tmux nautilus rofi firefox imagemagick ttf-jetbrains-mono file-roller mpv qt5-base qt5-svg qt5-quickcontrols2 qt5-graphicaleffects htop scrcpy || print_error "Failed to install packages"
    print_success "Base packages installed successfully"
}

# Install yay and AUR packages
install_aur_packages() {
    print_status "Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel || print_error "Failed to install dependencies for yay"
    git clone https://aur.archlinux.org/yay.git || print_error "Failed to clone yay repository"
    cd yay && makepkg -si --noconfirm || print_error "Failed to build yay"
    cd ..
    
    print_status "Installing AUR packages..."
    yay -Sy --noconfirm wlogout hyprshade sddm freedownloadmanager hyprlock hypridle hyprpicker xdg-desktop-portal-hyprland gradience rofi-lbonn-wayland-git libnotify jq slurp grim hyprland-scratchpad-git xstow android-tools visual-studio-code-bin || print_error "Failed to install AUR packages"
    print_success "AUR packages installed successfully"
}

install_nvchad() {
   print_status "Installing NvChad"
   git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
}

install_starship() {
  print_status "Cloning OhMyZsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  curl -sS https://starship.rs/install.sh | sh
  echo 'eval "$(starship init zsh)"'>> ~/.zshrc
}

install_hyprlock() {
  git clone https://github.com/Thunder-Blaze/BlazinLock/ ~/BlazinLock
  cd ~/BlazinLock
  chmod +x installer.sh
  ./installer.sh
}

install_textfox() {
  print_status "Cloning TextFox"
  git clone --depth=1 https://github.com/adriankarlen/textfox.git 
  cd textfox
  chmod +x tf-install.sh 
  ./tf-install.sh 
}

setting_sddm() {
  print_status "Setting Up SDDM"
  sudo cp -r ./assets/sugar-candy /usr/share/sddm/themes/ 
  sudo echo "[Theme]\n Current=sugar-candy" > /etc/sddm.conf
  sudo mkdir /usr/lib/sddm/sddm.conf.d/ && sudo touch /usr/lib/sddm/sddm.conf.d/sddm.conf 
  sudo echo "[Theme]\n Current=sugar-candy" > /usr/lib/sddm/sddm.conf.d/sddm.conf
}

# Enable system services
enable_services() {
    print_status "Enabling system services..."
    sudo systemctl enable NetworkManager && print_success "NetworkManager enabled"
    sudo systemctl enable sddm && print_success "SDDM display manager enabled"
}

# Setup user files
setup_files() {
    print_status "Setting up user files..."
    
    # Create directories
    mkdir -p ~/{Documents,Downloads,Pictures}
    
    # Copy configurations
    cp -r ./.config ~/ && print_success "Config files copied"
    cp -r ./.icons ~/ && print_success "Icons copied"
    cp -r ./.themes ~/ && print_success "Themes copied"
    cp -r ./.config/.tmux ~/ && print_success "Tmux plugins copied" 
    cp -r ./.config/.tmux.conf ~/ && print_success "Tmux config copied"
    cp ./assets/start.sh ~/ && print_success "Start script copied" && chmod +x ~/start.sh
    cp ./assets/swwwwalhash.sh ~/ && ptint_success "SwwwWalhash script copied" && chmod +x ~/swwwwalhash.sh
    
    # Move wallpapers
    mv ./assets/wallpapers ~/Pictures/ && print_success "Wallpapers moved"

    #Setting Up Essential Files:
    chmod +x ~/.config/rofi/applets/bin/*
    chmod +x ~/.config/rofi/launchers/type-7/launcher.sh
    chmod +x ~/.config/rofi/launchers/type-2/launcher.sh
    chmod +x ~/.config/hypr/rofi-control.sh
    chmod +x ~/.config/hypr/hyprlock.backup/blazinscripts.sh
}

# Main installation flow
main() {
    print_header
    install_pacman_packages
    install_aur_packages
    install_nvchad
    install_hyprlock
    setting_sddm
    install_starship
    enable_services
    setup_files
    
    echo -e "${GREEN}"
    echo "---------------------------------------------"
    echo " Installation Complete! "
    echo "---------------------------------------------"
    echo -e "${NC}"
}

# Start main function
main
