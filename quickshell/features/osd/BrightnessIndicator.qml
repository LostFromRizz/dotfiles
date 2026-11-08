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
            target: BrightnessService
            enabled: !GlobalState.quickSettingsMenuOpen && BrightnessService.ready
            function onBrightnessChanged(): void {
                popup.open(); // if already opened then no-op;
                if (!(popup.contentItem as ProgressSlider).hovered) {
                    popup.restartAutoHide();
                }
            }
        }

        anchors.centerIn: parent
        icon: {
            const EPSILON = 0.01;

            if (value > 0.5) {
                return "brightness_7";
            } else if (value > EPSILON) {
                return "brightness_6";
            } else {
                return "brightness_empty";
            }
        }

        onMoved: value => BrightnessService.setBrightness(value)
        value: BrightnessService.brightness
    }
}
