pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.core
import qs.features.wallpaper.models

LazyLoader {
    id: loader

    final property real topInset
    final property real bottomInset
    final property real leftInset
    final property real rightInset

    final readonly property WallpaperViewModel model: WallpaperViewModel {}
    active: model.ready

    PanelWindow {
        id: root

        final readonly property WallpaperViewModel model: loader.model
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.namespace: "quickshell:wallpaper"

        final property string source

        margins.top: loader.topInset
        margins.bottom: loader.bottomInset
        margins.left: loader.leftInset
        margins.right: loader.rightInset

        source: model.wallpaperPath

        color: "transparent"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Image {
            source: root.source
            onStatusChanged: {
                if (status === Image.Error) {
                    // root.hadError = true;
                }
            }
            asynchronous: true
            retainWhileLoading: true
            visible: opacity > 0
            opacity: (status === Image.Ready) ? 1 : 0
            cache: false
            smooth: false
            fillMode: Image.PreserveAspectCrop
            width: parent.width
            height: parent.height
            sourceSize: {
                const dpr = (QsWindow.window as QsWindow)?.devicePixelRatio ?? 1;
                return Qt.size(width * dpr, height * dpr);
            }
        }
    }
}
