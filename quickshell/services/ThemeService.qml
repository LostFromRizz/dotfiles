pragma Singleton

import Quickshell
import Material3
import Quickshell.Io
import QtQuick
import qs.core

Singleton {
    id: service

    final property colorscheme __dark: Material.colorScheme(true)
    final property colorscheme __light: Material.colorScheme(false)
    final property int themeMode: Theme.Dark

    final readonly property colorscheme colorScheme: themeMode == Theme.Dark ? __dark : __light

    Theme.colorScheme: colorScheme
    Theme.themeMode: themeMode

    onThemeModeChanged: {
        updateHyprlandTheme.exec(["hyprctl", "eval", `SetTheme("${service.themeMode == Theme.Dark ? "dark" : "light"}")`]);
    }

    FileView {
        id: fileWatcher
        path: Paths.colorSchemeFile
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            const json = JSON.parse(text());
            for (const [type, colorScheme] of Object.entries(json)) {
                if (type !== "dark" && type !== "light") {
                    // todo log
                    console.error(`ThemeService: unable to load colorScheme, Invaild json schema ${type}.`);
                    return;
                }

                service[`__${type}`] = Material.colorScheme(colorScheme);
            }
        }
    }

    Process {
        id: updateHyprlandTheme
        running: false
        stdout: StdioCollector {
            onStreamFinished: console.log(`line read: ${this.text}`)
        }
        stderr: StdioCollector {
            onStreamFinished: console.log(`line read: ${this.text}`)
        }
    }
}
