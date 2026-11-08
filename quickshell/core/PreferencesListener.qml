import QtQuick
import qs.core

Connections {
    id: root
    target: Preferences

    function onLoaded(): void {
    }

    Component.onCompleted: {
        if (Preferences.ready) {
            onLoaded();
        }
    }

    // Component.onDestruction: {
    //     if (Preferences.ready) {
    //         onLoaded();
    //     }
    // }
}
