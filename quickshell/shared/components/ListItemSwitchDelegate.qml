pragma ComponentBehavior: Bound
import Material3
import QtQuick

ListItem {
    id: root
    font: Theme.typography.titleSmall
    checkable: true

    trailing: SwitchDelegate {
        checked: root.checked
        icon.name: checked ? "check" : "close"
        onToggled: {
            root.toggle();
        }
    }
}
