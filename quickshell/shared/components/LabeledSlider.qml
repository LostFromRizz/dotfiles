import QtQuick
import QtQuick.Layouts
import Material3

ColumnLayout {
    id: layout
    final property alias font: label.font
    final property alias label: label.text
    final property alias sliderHeight: slider.trackHeight
    final property alias value: slider.value
    final property alias from: slider.from
    final property alias to: slider.to
    final readonly property alias icon: slider.icon

    // default final property alias trailing: rowLayout.children
    // RowLayout {
    //     id: rowLayout
    //        Label {
    //     id: label
    //     font: Theme.typography.titleMedium
    // }
    //     Spacer {}
    // }
    Label {
        id: label
        font: Theme.typography.titleMedium
    }
    Slider {
        id: slider
        Layout.fillWidth: true
    }
}
