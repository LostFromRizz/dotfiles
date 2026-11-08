pragma ComponentBehavior: Bound

import QtQuick
import Material3

ButtonGroupLayout {
    id: group
    exclusive: true
    required property real containerHeight

    component ContentItem: Loader {
        id: loader
        final required property string iconName
        final required property int display
        final required property string text

        sourceComponent: {
            if (display === Button.IconOnly) {
                return iconList;
            } else {
                return labelOnly;
            }
        }

        Component {
            id: iconList
            Icon {
                name: loader.iconName
                font.letterSpacing: 4
            }
        }

        Component {
            id: labelOnly
            Label {
                text: loader.text
            }
        }
    }

    delegate: SegmentedButton {
        id: buttonDelegate
        style: SegmentedButton.Filled
        containerHeight: group.containerHeight
        implicitHeight: group.containerHeight
        count: group.actions.length
        index: ObjectModel.index
        contentItem: ContentItem {
            display: buttonDelegate.display
            iconName: buttonDelegate.icon.name
            text: buttonDelegate.text
        }
    }
}

//
// Row {
//     id: group
//     visible: parent.width >= width
//
//     required property real containerHeight
//
//     required property string dateTime
//
//     required property string batteryIcon
//     required property string wifiIcon
//     required property string bluetoothIcon
//     required property bool quickSettingsOpened
//
//     signal quickSettingsToggled
//
//     spacing: 4
//
//     ObjectModel {
//         id: buttonsModel
//         readonly property int lastIndex: count - 1
//
//         GroupButton {
//             id: clockButton
//             text: group.dateTime
//         }
//
//         GroupButton {
//             id: quickSettings
//             spacing: Material.iconButtonNarrowPadding(containerHeight)
//             property int index: -1
//
//             contentItem: Row {
//                 spacing: quickSettings.spacing
//
//                 Icon {
//                     name: group.bluetoothIcon
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//                 Icon {
//                     name: group.wifiIcon
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//                 Icon {
//                     name: group.batteryIcon
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//             }
//             checked: group.quickSettingsOpened
//             onToggled: group.quickSettingsToggled()
//         }
//     }
//
//     Repeater {
//         model: buttonsModel
//     }
//
//     component GroupButton: FilledButton {
//         readonly property int index: ObjectModel.index
//         readonly property var leftRadius: {
//             if (index === buttonsModel.lastIndex && !checked && !hovered) {
//                 return 4;
//             }
//
//             return radius;
//         }
//
//         readonly property var rightRadius: {
//             if (index === 0 && !checked && !hovered) {
//                 return 4;
//             }
//             return radius;
//         }
//
//         topLeftRadius: leftRadius
//         bottomLeftRadius: leftRadius
//         topRightRadius: rightRadius
//         bottomRightRadius: rightRadius
//         anchors.verticalCenter: parent?.verticalCenter ?? undefined
//         containerHeight: group.containerHeight
//         height: group.containerHeight
//         checkable: true
//     }
// }
