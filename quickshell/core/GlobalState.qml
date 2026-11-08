pragma Singleton

import Quickshell
import QtQuick
import qs.core

Singleton {
    id: root

    final property bool quickSettingsMenuOpen: false
    final property bool mirrored: false

    final property real barSize
    final property real barBorderWidth

    PreferencesListener {
        id: listener

        function onLoaded(): void {
            root.mirrored = Preferences.getBool("layout_rtl");
        }
    }
}
