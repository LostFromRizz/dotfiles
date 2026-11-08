pragma ComponentBehavior: Bound
import Material3
import QtQuick
import qs.shared.components
import qs.features.quicksettings.models
import QtQuick.Layouts

Button {
    id: button
    required property int index
    required property int type
    required property bool expanded
    required property bool isChecked
    required property real expandedWidth
    required property real compactWidth
    property int pageIndex: 0

    readonly property bool splitToggle: action instanceof SplitToggleAction && expanded

    Binding {
        target: button.action
        property: "checked"
        value: button.isChecked
    }
    Binding {
        target: button.action
        property: "checkable"
        value: !button.splitToggle
    }

    implicitHeight: containerHeight
    implicitWidth: expanded ? expandedWidth : compactWidth

    backgroundColor: {
        if (!enabled) {
            return Material.disabledBackgroundColor(Theme.colorScheme.surface);
        }

        if (splitToggle) {
            return Theme.colorScheme.surfaceContainer;
        }

        return checked ? Theme.colorScheme.primary : Theme.colorScheme.surfaceContainer;
    }

    contentColor: {
        if (!enabled) {
            return Material.disabledContentColor(Theme.colorScheme.onSurface);
        }
        if (splitToggle) {
            return Theme.colorScheme.onSurfaceVariant;
        }

        return checked ? Theme.colorScheme.onPrimary : Theme.colorScheme.onSurfaceVariant;
    }

    verticalPadding: splitToggle ? 6 : Material.buttonVerticalPadding(containerHeight)
    horizontalPadding: splitToggle ? 6 : Material.buttonVerticalPadding(containerHeight)
    spacing: splitToggle ? 4 : Material.buttonSpacing(containerHeight)

    icon.height: iconSize
    icon.width: iconSize

    radius: {
        if (splitToggle) {
            return Material.buttonSelectedRadius(containerHeight);
        }

        if (checked || hovered) {
            return Material.buttonSelectedRadius(containerHeight);
        }

        return Math.min(height, width) / 2;
    }

    contentItem: Loader {
        sourceComponent: {
            if (button.splitToggle) {
                return splitToggleContentItem;
            }
            if (button.expanded) {
                return expandedContentItem;
            }
            return compactContentItem;
        }
    }

    Component {
        id: splitToggleContentItem
        RowLayout {
            spacing: button.spacing
            IconButton {
                icon: button.icon
                backgroundColor: checked ? Theme.colorScheme.primary : Theme.colorScheme.surfaceContainerLow
                contentColor: checked ? Theme.colorScheme.onPrimary : Theme.colorScheme.onSurfaceVariant
                checked: button.isChecked
                containerHeight: button.availableHeight
                checkable: true
                onToggled: {
                    const action = button.action as SplitToggleAction;
                    action.checked = checked;
                    action.innerToggled(button);
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

    Component {
        id: compactContentItem
        Icon {
            font.hintingPreference: Font.PreferNoHinting
            name: button.icon.name
        }
    }

    Component {
        id: expandedContentItem
        RowLayout {
            spacing: button.spacing
            Spacer {}
            Icon {
                Layout.fillHeight: true
                font.hintingPreference: Font.PreferNoHinting
                name: button.icon.name
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            }

            Marquee {
                Layout.maximumWidth: button.availableWidth - parent.children[1].implicitWidth
                Layout.fillHeight: true
                text: button.text
                font: button.font
                color: button.contentColor
                backgroundColor: button.backgroundColor
                addGradient: !button.hovered
                visible: button.expanded
            }
            Spacer {}
        }
    }
}
