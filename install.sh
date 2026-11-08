#!/usr/bin/env bash

path="$(pwd)"

# Install zsh dots 
ln -s "$path/zsh/.zshrc" "$HOME/.zshrc"
ln -s "$path/zsh/.zshenv" "$HOME/.zshenv"

# Install nvim
ln -s "$path/nvim" "$HOME/.config/nvim"

# Install hyprland dots
ln -s "$path/hypr" "$HOME/.config/hypr"

# Install ghostty dots
ln -s "$path/ghostty" "$HOME/.config/ghostty"

# Install quickshell
ln -s "$path/quickshell" "$HOME/.config/quickshell"

# Install matugen
ln -s "$path/matugen" "$HOME/.config/matugen"

# Install wallpapers
ln -s "$path/wallpapers" "$HOME/Pictures/Wallpapers"


