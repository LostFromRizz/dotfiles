import QtQuick
import Material3

FilledTonalButton {
    id: button

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    horizontalPadding: 16
    font: Theme.emphasizedTypography.labelLarge

    final property alias title: button.text

    visible: text.length > 0

    contentItem: Item {
        implicitWidth: label.width
        implicitHeight: label.implicitHeight
        clip: true

        Behavior on implicitWidth {
            NumberAnimation {
                id: widthAnimation
                easing.type: Easing.BezierSpline
                easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
                duration: MotionSpecs.expressiveDefaultSpatialDuration
            }
        }

        final readonly property Label label: Label {
            parent: button.contentItem
            height: parent.height
            text: button.text
            width: Math.min(248, implicitWidth)
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
