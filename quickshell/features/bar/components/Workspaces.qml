pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Material3
import Quickshell.Hyprland

RowLayout {
    id: layout
    final property alias model: repeater.model
    final property int count

    required property real buttonHeight
    required property real maximumWidth

    signal workspaceSelected(id: int)

    spacing: 2

    ButtonGroup {
        buttons: layout.children.filter(e => e !== repeater)
        exclusive: true
        onClicked: function (button) {
            layout.workspaceSelected((button as ButtonDelegate).modelData?.id ?? 0);
        }
    }

    Repeater {
        id: repeater
        delegate: ButtonDelegate {}
    }

    component ButtonDelegate: SegmentedButton {
        required property HyprlandWorkspace modelData
        style: SegmentedButton.Filled
        text: modelData?.name ?? ""
        checked: modelData?.active ?? false
        count: layout.count
        containerHeight: layout.buttonHeight
        implicitWidth: layout.buttonHeight
        implicitHeight: layout.buttonHeight
    }
}

//     overflowIndicator: ButtonGroupItem {
//         // radius: checked ? Material.buttonSelectedRadius(containerHeight) : containerHeight / 2
//         Layout.alignment: Qt.AlignVCenter
//         containerHeight: group.buttonHeight
//         Layout.preferredHeight: group.buttonHeight
//         implicitWidth: group.buttonHeight
//         style: ButtonGroupItem.Tonal
//         icon.name: "more_vert"
//     }

