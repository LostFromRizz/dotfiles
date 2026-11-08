import QtQuick
import QtQuick.Layouts
import Material3
import qs.core

RowLayout {
    id: root

    final property alias labelWidth: label.width
    final property alias text: label.text
    final property alias icon: micon.name
    final property alias iconSize: micon.size
    final property alias value: slider.value
    final readonly property alias hovered: hoverHandler.hovered

    signal moved(value: real)

    Theme.backgroundColor: Theme.colorScheme.surfaceContainer
    Theme.contentColor: Theme.colorScheme.onSurfaceVariant
    spacing: 6

    HoverHandler {
        id: hoverHandler
    }

    Spacer {}
    Icon {
        id: micon
        size: LayoutDefaults.iconSizeMedium
        name: root.icon
    }
    Slider {
        id: slider
        stopIndicator: null
        onMoved: root.moved(value)
    }
    Label {
        id: label
        Layout.preferredWidth: 32
        text: `${Math.floor(slider.value * 100)}%`
        font: Theme.typography.labelLarge
        horizontalAlignment: Text.AlignHCenter
    }
    Spacer {}
}
