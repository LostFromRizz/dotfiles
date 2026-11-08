import QtQuick

import qs.shared
import qs.services
import qs.core

AutoDismissableOverlay {
    id: popup

    positionStart: Overlay.overlay.height
    positionEnd: Overlay.overlay.height - height - 16 // margin

    ProgressSlider {
        onHoveredChanged: {
            if (hovered) {
                popup.stopAutoHide();
            } else {
                popup.restartAutoHide();
            }
        }

        Connections {
            target: AudioService
            enabled: !GlobalState.quickSettingsMenuOpen && AudioService.ready
            function onVolumeChanged(): void {
                popup.open(); // if already opened then no-op;
                if (!(popup.contentItem as ProgressSlider).hovered) {
                    popup.restartAutoHide();
                }
            }
        }

        anchors.centerIn: parent
        icon: {
            if (value == 0.0) {
                return "volume_off";
            } else if (value < 0.2) {
                return "volume_down";
            } else {
                return "volume_up";
            }
        }

        onMoved: value => AudioService.setVolume(value)
        value: AudioService.volume
    }
}
