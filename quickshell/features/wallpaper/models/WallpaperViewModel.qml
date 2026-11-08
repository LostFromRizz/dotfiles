pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import qs.shared
import qs.core

ViewModel {
    id: model

    readonly property alias ready: listener.ready
    readonly property alias wallpaperPath: listener.wallpaperPath

    PreferencesListener {
        id: listener
        property string wallpaperPath: Paths.wallpaperDir + `/fusu-meiniang.png`
        property bool ready

        function onLoaded(): void {
            wallpaperPath = Preferences.getString("wallpaper", listener.wallpaperPath);
            ready = true;
        }
    }

    IpcHandler {
        target: "wallpaper"

        function set(value: string): void {
            Preferences.setString("wallpaper", value);
            genColors.exec(["matugen", "--quiet", "--prefer=saturation", "image", value]);
        }
    }

    Process {
        id: genColors
        // stdout: StdioCollector {
        //     onStreamFinished: console.log(`${this.text}`)
        // }
        // stderr: StdioCollector {
        //     onStreamFinished: console.log(`${this.text}`)
        // }
    }
}
