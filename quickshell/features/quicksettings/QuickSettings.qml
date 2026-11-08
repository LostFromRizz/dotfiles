pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.shared.components
import qs.core
import Material3
import qs.features.quicksettings.models
import qs.features.quicksettings.components
import QtQuick.Controls as QQC

QsPopup {
    id: root
    final property int direction: QuickSettings.Right

    signal aboutToHide
    signal aboutToShow

    x: direction === QuickSettings.Right ? Screen.width - implicitWidth - GlobalState.barBorderWidth : 0

    onActiveChanged: {
        GlobalState.quickSettingsMenuOpen = active;
    }

    enum Direction {
        Left,
        Right
    }

    ThemedPopup {
        id: popup

        final readonly property real startX: root.direction === QuickSettings.Right ? width : 0
        final readonly property real endX: root.direction === QuickSettings.Right ? 0 : width

        readonly property QuickSettingsViewModel model: QuickSettingsViewModel {
            navigationStack: popup.contentItem as QQC.StackView
        }

        radius: LayoutDefaults.roundingLarge
        implicitHeight: model.height
        implicitWidth: model.width
        includeElevation: false
        topInset: model.margin
        bottomInset: model.margin
        leftInset: model.margin
        rightInset: model.margin
        horizontalPadding: model.margin
        verticalPadding: model.margin

        contentItem: QQC.StackView {
            clip: true
            Binding {
                target: (popup.contentItem as QQC.StackView).currentItem
                when: target instanceof Scaffold
                property: "radius"
                value: popup.radius
                restoreMode: Binding.RestoreNone
            }

            initialItem: Scaffold {
                id: page
                radius: popup.radius
                background: Rectangle {
                    color: Theme.backgroundColor
                    radius: page.radius
                }
                appBar: TopAppBar {
                    horizontalPadding: LayoutDefaults.pageHorizontalPadding
                    focusPolicy: Qt.TabFocus
                    topLeftRadius: popup.radius
                    topRightRadius: popup.radius
                    headlineText: popup.model.userName
                    subtitleText: `Up ${popup.model.uptime}`
                    leading: Item {
                        implicitHeight: 50
                        implicitWidth: 50
                        Rectangle {
                            implicitHeight: 50
                            implicitWidth: 50
                            radius: 50 / 2
                            anchors.verticalCenter: parent.verticalCenter
                            color: Theme.colorScheme.primary
                            Icon {
                                anchors.centerIn: parent
                                name: "person"
                                color: Theme.colorScheme.onPrimary
                                size: 32
                            }
                        }
                    }
                    trailing: RowLayout {
                        IconButton {
                            icon.name: "edit"
                            onClicked: {
                                // view.push(editPage);
                                // viewModel.toggleEditMode();
                            }
                        }
                        IconButton {
                            icon.name: "settings"
                            onClicked: {}
                        }
                        IconButton {
                            icon.name: "power_settings_new"
                            onClicked: {}
                        }
                    }
                }
                horizontalPadding: LayoutDefaults.pageHorizontalPadding

                height: popup.availableHeight
                width: popup.availableWidth
                spacing: 12
                contentItem: ColumnLayout {
                    spacing: 8
                    MSlider {
                        trackHeight: popup.model.sliderHeight
                        icon.name: popup.model.brightnessIcon
                        value: popup.model.currentBrightness
                        Layout.fillWidth: true
                        onMoved: popup.model.setBrightness(value)
                    }
                    MSlider {
                        trackHeight: popup.model.sliderHeight
                        icon.name: popup.model.volumeIcon
                        value: popup.model.currentVolume
                        Layout.fillWidth: true
                        onMoved: popup.model.setVolume(value)
                    }
                    QuickToggleGroup {
                        actions: popup.model.actions
                        maxHeight: popup.model.buttonGroupMaxHeight
                        contentHeight: popup.model.buttonGroupMaxHeight
                        contentWidth: popup.model.buttonGroupMaxWidth
                        buttonHeight: popup.model.buttonHeight
                        buttonExpandedWidth: popup.model.buttonExpandedWidth
                        buttonCompactWidth: popup.model.buttonCompactWidth
                        spacing: popup.model.buttonGroupSpacing
                        pageModel: popup.model.quickActionsPaged
                    }
                    VerticalSpacer {}
                }
            }
        }

        onAboutToShow: {
            root.aboutToShow();
        }
        onAboutToHide: {
            root.aboutToHide();
        }
        enter: Transition {
            DefaultOpacityAnimation {
                from: 0
                to: 1
            }
            DefaultPositionAnimation {
                from: popup.startX
                to: popup.endX
            }
        }
        exit: Transition {
            DefaultOpacityAnimation {
                from: 1
                to: 0
            }
            DefaultPositionAnimation {
                from: popup.endX
                to: popup.startX
            }
        }
    }

    component DefaultOpacityAnimation: PropertyAnimation {
        property: "opacity"
        easing.type: Easing.BezierSpline
        easing.bezierCurve: MotionSpecs.expressiveDefaultEffectsBezier
        duration: MotionSpecs.expressiveDefaultEffectsDuration
    }

    component DefaultPositionAnimation: NumberAnimation {
        property: "x"
        easing.type: Easing.BezierSpline
        easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
        duration: MotionSpecs.expressiveDefaultSpatialDuration
    }

    component MSlider: Slider {
        id: mslider
        stopIndicator: null
        ToolTip {
            parent: mslider.handle
            x: mslider.horizontal ? -(width / 2) : parent.width + 4
            y: mslider.horizontal ? -(parent.height + 4) : -(height / 2)
            visible: mslider.pressed
            text: `${Math.round(((mslider.value - mslider.from) / (mslider.to - mslider.from)) * 100)}%`
        }
    }
}
