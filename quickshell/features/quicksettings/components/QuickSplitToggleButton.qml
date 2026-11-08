import Material3
import QtQuick
import QtQuick.Layouts
import qs.shared.components

Button {
    id: button
    required property int index
    required property int type
    required property bool expanded
    required property bool isChecked
    required property real expandedWidth
    required property real compactWidth

    backgroundColor: {
        if (!enabled) {
            return Material.disabledBackgroundColor(Theme.colorScheme.surface);
        }
        return Theme.colorScheme.surfaceContainer;
    }

    contentColor: {
        if (!enabled) {
            return Material.disabledContentColor(Theme.colorScheme.onSurface);
        }
        return Theme.colorScheme.onSurfaceVariant;
    }

    implicitHeight: containerHeight
    implicitWidth: expanded ? expandedWidth : compactWidth
    checked: button.isChecked
    checkable: !button.expanded
    icon.height: Theme.iconSize.height
    icon.width: Theme.iconSize.width

    verticalPadding: 6
    horizontalPadding: 6
    spacing: 4

    Binding {
        target: button.action
        property: "checked"
        value: button.isChecked
    }
    Binding {
        target: button.action
        property: "checkable"
        value: true
    }

    radius: {
        if (expanded) {
            return Material.buttonSelectedRadius(containerHeight);
        }

        if (checked || hovered) {
            return Material.buttonSelectedRadius(containerHeight);
        }
        return Math.min(height, width) / 2;
    }

    contentItem: RowLayout {
        spacing: button.spacing
        IconButton {
            icon.name: button.action?.icon.name ?? ""
            // action: button.action
            icon.height: Theme.iconSize.height
            icon.width: Theme.iconSize.width
            backgroundColor: checked ? Theme.colorScheme.primary : Theme.colorScheme.surfaceContainerLow
            contentColor: checked ? Theme.colorScheme.onPrimary : Theme.colorScheme.onSurfaceVariant
            containerHeight: button.availableHeight
            onToggled: {
                button.checked = checked;
                button.toggled();
            }
            Layout.fillHeight: true
            radius: checked ? Material.iconButtonSelectedRadius(containerHeight) : height / 2
            horizontalPadding: Material.iconButtonUniformPadding(containerHeight)
        }
        Marquee {
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: button.text
            font: button.font
            color: button.contentColor
            backgroundColor: button.backgroundColor
            addGradient: !button.hovered
            visible: button.expanded
        }
    }
}
