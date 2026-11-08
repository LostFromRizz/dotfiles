pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

import Material3
import qs.features.bar
import qs.features.wallpaper
import qs.features.osd
import qs.services
import qs.core

ShellRoot {
    id: root

    FontLoader {
        id: materialIcons
        source: ":/icons/MaterialSymbolsRounded.ttf"
    }

    Bar {
        id: bar
        loading: true
    }

    Wallpaper {
        topInset: GlobalState.barSize
        bottomInset: GlobalState.barBorderWidth
        leftInset: GlobalState.barBorderWidth
        rightInset: GlobalState.barBorderWidth
        loading: true
        // loading: bar.active
    }

    SystemOverlay {}
}
