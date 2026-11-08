
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export BUILDS="$HOME/dev/builds"
export PROJECTS="$HOME/dev/projects"
export DEV="$HOME/dev"

export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_AVD_HOME=$HOME/.config/.android/avd
export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH

export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$BUILDS/flutter/bin

export CHROME_EXECUTABLE=$(which firefox)

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

export EDITOR='nvim'

. "$HOME/.cargo/env"


