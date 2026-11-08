pragma Singleton

import Quickshell

Singleton {
    id: root

    final readonly property string home: Quickshell.env("HOME")

    final readonly property string data: `${Quickshell.env("XDG_DATA_HOME") || `${home}/.local/share`}/materialshell`
    final readonly property string state: `${Quickshell.env("XDG_STATE_HOME") || `${home}/.local/state`}/materialshell`
    final readonly property string __cache: `${Quickshell.env("XDG_CACHE_HOME") || `${home}/.cache`}/materialshell`
    final readonly property string __config: `${Quickshell.env("XDG_CONFIG_HOME") || `${home}/.config`}`

    final readonly property string colorSchemeFile: `${state}/colorscheme.json`

    final readonly property string shellDir: Quickshell.shellDir
    final readonly property string wallpaperDir: `${root.home}/Pictures/Wallpapers`
}
