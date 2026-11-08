import Material3
import QtQuick

Item {
    id: root

    final property alias title: label.text
    final property alias labelColor: label.color
    final property alias model: repeater.model
    default final property alias delegate: repeater.delegate

    final property real spacing: 16

    final property int count

    implicitHeight: column.implicitHeight + (label.visible ? label.implicitHeight + spacing : 0)
    implicitWidth: Math.max(label.implicitWidth, column.implicitWidth)

    Label {
        id: label
        font: Theme.typography.titleMedium
        color: Theme.colorScheme.onSurface
        visible: label.text.length > 0
    }

    Column {
        id: column
        y: label.implicitHeight + (label.visible ? root.spacing : 0)
        width: root.width
        spacing: 2

        Repeater {
            id: repeater
            onItemAdded: function (_, item) {
                item.width = Qt.binding(() => root.width);
            }
        }
    }
}
