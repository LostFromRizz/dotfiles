import QtQuick
import Material3
import qs.shared.components
import qs.shared
import qs.services
import qs.core

OverlayPopupItem {
    id: root

    enum Behavior {
        AlwaysDismiss,
        StopOnHover
    }

    property string animatablePosition: "y"
    property real positionStart
    property real positionEnd
    readonly property alias height: popupItem.height
    readonly property alias width: popupItem.width
    property alias x: popupItem.x
    property alias y: popupItem.x
    property alias enter: popupItem.enter
    property alias exit: popupItem.exit
    property alias autoHideInterval: timer.interval
    default property alias contentItem: popupItem.contentItem

    function stopAutoHide(): void {
        timer.stop();
    }

    function restartAutoHide(): void {
        if (popupItem.visible) {
            timer.restart();
        }
    }

    function open() {
        popupItem.open();
    }

    Popup {
        id: popupItem
        Theme.themeMode: ThemeService.themeMode
        Theme.colorScheme: ThemeService.colorScheme
        radius: implicitHeight / 2
        horizontalPadding: LayoutDefaults.horizontalPaddingMedium + shadowElevationSize.width
        verticalPadding: LayoutDefaults.verticalPaddingMedium + shadowElevationSize.height
        elevation: 6
        x: (Overlay.overlay.width - popupItem.width) / 2
        y: (Overlay.overlay.height - popupItem.height) / 2

        Timer {
            id: timer
            interval: MotionSpecs.durationExtraLong4
            onTriggered: function (): void {
                popupItem.close();
            }
        }

        onOpened: timer.start()
        opacity: 0
        enter: Transition {
            DefaultOpacityAnimation {
                from: 0
                to: 1
            }
            DefaultPositionAnimation {
                property: root.animatablePosition
                from: root.positionStart
                to: root.positionEnd
            }
        }
        exit: Transition {
            DefaultOpacityAnimation {
                from: 1
                to: 0
            }
            DefaultPositionAnimation {
                property: root.animatablePosition
                from: root.positionEnd
                to: root.positionStart
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
        easing.type: Easing.BezierSpline
        easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
        duration: MotionSpecs.expressiveDefaultSpatialDuration
    }
}
