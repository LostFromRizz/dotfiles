import QtQuick
import QtQuick.Templates as T
import Material3
import Quickshell
import qs.shared

QtObject {
    id: root
    default property T.Popup popup

    readonly property Region region: Region {
        height: root.popup.visible ? root.popup.height : 0
        width: root.popup.visible ? root.popup.width : 0
        x: root.popup.anchors.centerIn !== null ? (Overlay.overlay.width - root.popup.width) / 2 : root.popup.x
        y: root.popup.anchors.centerIn !== null ? (Overlay.overlay.height - root.popup.height) / 2 : root.popup.y

        intersection: Intersection.Subtract
    }

    property int regionId: -1

    Component.onCompleted: {
        popup.parent = Qt.binding(() => Overlay.overlay);
        regionId = Overlay.addRegion(region);
    }

    Component.onDestruction: {
        popup.parent = null;
        Overlay.removeRegion(regionId);
    }
}
