pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell as QS
import QtQuick.Templates as T
import Quickshell.Wayland
import QtQuick

QS.Singleton {
    id: root

    function addRegion(r: QS.Region): int {
        region.regions.push(r);
        return region.regions.length - 1;
    }

    function removeRegion(index: int): void {
        if (index >= 0 && index < region.regions.length) {
            region.regions.splice(index, 1);
        }
    }

    final property alias contentModel: container.contentModel
    final property alias overlay: container
    final readonly property real centerX: container.width / 2
    final readonly property real centerY: container.height / 2
    final readonly property alias region: panelWindow.mask
    // property alias contentItem: container

    QS.PanelWindow {
        id: panelWindow
        exclusionMode: QS.ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        T.Container {
            id: container
            hoverEnabled: true
            anchors.fill: parent
            contentItem: Item {
                anchors.fill: parent
            }
        }

        mask: QS.Region {
            height: container.height
            width: container.width
            intersection: QS.Intersection.Xor
        }
        color: "transparent"
    }

    // QS.LazyLoader {
    //     id: loader
    //     loading: true
    //     property QS.QsWindow window
    //     property ObjectModel contentModel: ObjectModel {}
    //     onActiveChanged: {
    //         if (active) {
    //             window = item;
    //         } else {
    //             window = null;
    //         }
    //     }
    //
    //
    // }

    Component {
        id: regionDelegate
        QS.Region {
            intersection: QS.Intersection.Subtract
            // Component.onCompleted: {
            //     console.log(height, width);
            // }
            // property Binding _: Binding {
            //     r {
            //         height: r.item.height
            //         width: r.item.width
            //     }
            // }
        }
    }
}
