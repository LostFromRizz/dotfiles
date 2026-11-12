#!/usr/bin/env bash

path="$(pwd)"

function show_help() {
  printf "%s\n" \
      "USAGE: [OPERATION] [OPTIONS] PACKAGE" \
      " "\
      "[OPERATION]"\
      "    -s | -S     Installs the PACKAGE" \
      "    -d | -D     Remove the PACKAGE" \
      "    -r | -R     Reinstalls the PACKAGE (like -d followed by -s)" \
      "    -h | --help Show this help"\
      " "\
      "[OPTIONS]"\
      "    -t | -T     Target directory to install the PACKAGE in (defaults to the parent directory)"\
      "    -n | -N     Name of the PACKAGE (defaults to PACKAGE string)"\
      "    -e | -E     Install each file individually instead of symlinking the PACKAGE to TARGET"
}

declare -A default_targets

default_targets["nvim"]="$HOME/.config"
default_targets["matugen"]="$HOME/.config"
default_targets["ghostty"]="$HOME/.config"
default_targets["hypr"]="$HOME/.config"
default_targets["quickshell"]="$HOME/.config"
default_targets["zsh"]="$HOME"
default_targets["Wallpapers"]="$HOME/Pictures"

parent_dir="$(dirname $PWD)"


function install_package() {
  local target_path=""
  local package_name=""
  local for_each=false

  while getopts "t:T:n:N:eE" opt; do
    case "$opt" in
        t | T) target_path="$OPTARG";;
        n | N) package_name="$OPTARG";;
        e | E) for_each=true;;        
        *)
            echo "Invalid option" >&2
            exit 1
            ;;
    esac
  done

  shift $((OPTIND - 1))

  local package="${1:-}"
  local package_path="$PWD/$package"

  if ! [[ -d $package_path ]] then
    echo "\"$package\" is not a package" >&2
    exit 1
  fi

  package_name=${package_name:-$package}
  target_path="${target_path:-${default_targets[$package]:-$parent_dir}}/$package_name"


  echo "Installing $package to $target_path"
  if [[ $for_each == true ]]; then
    while IFS= read -r -d '' file; do
        ln -snf $file $target_path
    done < <(find "$package_path" -mindepth 1 -maxdepth 1 -print0)
    return
  fi

  ln -snf $package_path $target_path


}

case $1 in 
    -s | -S) 
      install_package "${@:2}"
      exit 0
      ;;
    --help | -h) 
      show_help
      exit 0
      ;;
    *) 
      show_help >&2
      exit 1
      ;;
esac


# # Install zsh dots 
# ln -s "$path/zsh/.zshrc" "$HOME/.zshrc"
# ln -s "$path/zsh/.zshenv" "$HOME/.zshenv"
#
# # Install nvim
# ln -s "$path/nvim" "$HOME/.config/nvim"
#
# # Install hyprland dots
# ln -s "$path/hypr" "$HOME/.config/hypr"
#
# # Install ghostty dots
# ln -s "$path/ghostty" "$HOME/.config/ghostty"
#
# # Install quickshell
# ln -s "$path/quickshell" "$HOME/.config/quickshell"
#
# # Install matugen
# ln -s "$path/matugen" "$HOME/.config/matugen"
#
# # Install wallpapers
# ln -s "$path/wallpapers" "$HOME/Pictures/Wallpapers"
#

