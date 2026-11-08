pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Material3
import qs.services
import qs.features.bar.models
import qs.features.bar.components

LazyLoader {
    id: root

    readonly property BarViewModel model: BarViewModel {}

    Scope {
        GapOut {
            anchors.top: true
            exclusiveZone: root.model.effectiveBarSize
        }
        GapOut {
            anchors.left: true
        }
        GapOut {
            anchors.right: true
        }
        GapOut {
            anchors.bottom: true
        }

        RectangularFrame {
            Item {
                id: content

                final property real availableHeight: height - root.model.effectiveVerticalPadding * 2

                final property real availableWidth: width - root.model.effectiveHorizontalPadding * 2

                final readonly property real effectiveSpacing: 8

                anchors.fill: parent
                anchors.topMargin: root.model.effectiveVerticalPadding
                anchors.bottomMargin: root.model.effectiveVerticalPadding
                anchors.leftMargin: root.model.effectiveHorizontalPadding
                anchors.rightMargin: root.model.effectiveHorizontalPadding

                property real maximumWorkspacesLength: ((width - systemControlGroup.width)) - effectiveSpacing

                Workspaces {
                    id: work
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    buttonHeight: root.model.effectiveButtonHeight
                    maximumWidth: parent.maximumWorkspacesLength
                    model: root.model.workspaces
                    count: root.model.workspaces.values.length
                    onWorkspaceSelected: id => root.model.switchWorkspace(id)

                    // actions: root.model.workspacesActions
                }

                FocusedWindow {
                    anchors.centerIn: parent
                    containerHeight: root.model.effectiveButtonHeight
                    height: containerHeight
                    title: root.model.focusedWindowName
                }

                SystemControlGroup {
                    id: systemControlGroup
                    // visible: false
                    visible: parent.width >= width
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    containerHeight: root.model.effectiveButtonHeight
                    actions: root.model.systemControlsActions
                }
            }
        }
    }

    component GapOut: PanelWindow {
        WlrLayershell.namespace: "materialshell-barborder"
        WlrLayershell.layer: WlrLayer.Bottom
        exclusiveZone: root.model.effectiveBorderWidth
        mask: Region {}
        implicitHeight: 1
        implicitWidth: 1
    }

    component Container: QtObject {
        default final property list<QtObject> data
    }

    component RectangularFrame: PanelWindow {
        id: frame
        color: "transparent"

        WlrLayershell.namespace: "materialshell-barframe"
        WlrLayershell.layer: WlrLayer.Top
        exclusionMode: ExclusionMode.Ignore

        default property alias barContent: barContainer.data

        anchors {
            top: true
            left: true
            bottom: true
            right: true
        }

        mask: Region {
            height: frame.height
            width: frame.width

            intersection: Intersection.Xor

            Region {
                height: root.model.effectiveBarSize
                width: frame.width
                intersection: Intersection.Subtract
            }
        }

        Theme.colorScheme: ThemeService.colorScheme
        Theme.themeMode: ThemeService.themeMode

        Binding {
            target: root.model
            property: "barWindow"
            value: frame
        }

        Item {
            anchors.fill: parent
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: frame.Theme.colorScheme.shadow
                blurMax: 15
            }

            Rectangle {
                anchors.top: parent.top
                width: parent.width
                height: root.model.effectiveBarSize
                color: frame.Theme.backgroundColor
            }

            Rectangle {
                width: root.model.effectiveBorderWidth
                height: parent.height - root.model.effectiveBarSize
                color: frame.Theme.backgroundColor
                y: root.model.effectiveBarSize
                x: 0
            }
            RoundedCorner {
                size: root.model.effectiveCornerRadius
                corner: Qt.TopLeftCorner
                color: frame.Theme.backgroundColor
                y: root.model.effectiveBarSize
                x: root.model.effectiveBorderWidth
            }

            Rectangle {
                width: root.model.effectiveBorderWidth
                height: parent.height - root.model.effectiveBarSize
                color: frame.Theme.backgroundColor
                y: root.model.effectiveBarSize
                x: parent.width - root.model.effectiveBorderWidth
            }
            RoundedCorner {
                size: root.model.effectiveCornerRadius
                corner: Qt.TopRightCorner
                color: frame.Theme.backgroundColor
                y: root.model.effectiveBarSize
                x: parent.width - root.model.effectiveBorderWidth - size
            }

            Rectangle {
                // anchors.bottom: parent.bottom
                width: parent.width
                height: root.model.effectiveBorderWidth
                color: frame.Theme.backgroundColor
                y: parent.height - root.model.effectiveBorderWidth
                x: 0
            }

            RoundedCorner {
                size: root.model.effectiveCornerRadius
                corner: Qt.BottomLeftCorner
                color: frame.Theme.backgroundColor
                y: parent.height - root.model.effectiveBorderWidth - size
                x: root.model.effectiveBorderWidth
            }
            RoundedCorner {
                size: root.model.effectiveCornerRadius
                corner: Qt.BottomRightCorner
                color: frame.Theme.backgroundColor
                y: parent.height - root.model.effectiveBorderWidth - size
                x: parent.width - root.model.effectiveBorderWidth - size
            }
        }

        Item {
            id: barContainer
            height: root.model.effectiveBarSize
            width: parent.width
            Theme.colorScheme: frame.Theme.colorScheme
            Theme.themeMode: frame.Theme.themeMode
        }
    }
}
