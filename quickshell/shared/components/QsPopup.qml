pragma ComponentBehavior: Bound
import QtQuick
import Material3
import Quickshell
import Quickshell.Hyprland

LazyLoader {
    id: root

    function open() {
        loading = true;
    }

    function close() {
        if (active) {
            const popup = (item as QsPopupWindow).popup;
            popup.close();
        }
    }

    final required property QtObject window
    final property real x
    final property real y

    final property real implicitWidth: implicitPopupWidth
    final property real implicitHeight: implicitPopupHeight

    final property real implicitPopupWidth
    final property real implicitPopupHeight

    default property Component popup

    component: QsPopupWindow {}

    component QsPopupWindow: PopupWindow {
        id: popupWindow
        anchor.window: root.window
        anchor.rect.x: root.x
        anchor.rect.y: root.y
        Binding {
            root {
                implicitPopupWidth: popupWindow.popup?.implicitWidth ?? 0
                implicitPopupHeight: popupWindow.popup?.implicitHeight ?? 0
            }
        }

        implicitHeight: root.implicitHeight
        implicitWidth: root.implicitWidth

        visible: true
        color: 'transparent'
        // color: 'red'

        final readonly property alias popup: loader.popup

        Connections {
            target: loader.popup
            function onClosed(): void {
                root.active = false;
            }
        }

        Loader {
            id: loader
            final readonly property Popup popup: item instanceof Popup ? item as Popup : null
            sourceComponent: root.popup
            onLoaded: {
                if (popup) {
                    popupWindow.visible = true;
                    popup.open();
                }
            }
        }

        Connections {
            target: Hyprland
            function onRawEvent(event) {
                if (event.name === "openwindow" || event.name === "fullscreen") {
                    grab.active = false;
                }
            }
        }

        HyprlandFocusGrab {
            id: grab
            active: true
            windows: [popupWindow, root.window]
            onActiveChanged: {
                if (!active && loader.popup) {
                    loader.popup.close();
                }
            }
        }
    }
}
