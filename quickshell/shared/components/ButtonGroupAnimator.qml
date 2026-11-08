import QtQuick.Templates as T
import QtQuick
import Material3

ButtonGroup {
    id: group

    final property real from: 0
    final property real to: 1
    final property real animationValue: 0
    final property real animatedWidth: 0
    final property int currentIndex: -1
    final property real expandRatio: 0.15

    // slot
    final property var animationFinished

    function getSibling(index: int, centerY = 0): T.AbstractButton {
        const button = buttons[index];
        if (button && button.y === centerY) {
            return button;
        }
        return null;
    }

    final readonly property PropertyAnimation animation: NumberAnimation {
        id: animation
        target: group
        from: group.from
        to: group.to
        property: "animationValue"
        property bool reverse: false
        easing.bezierCurve: MotionSpecs.expressiveFastSpatialBezier
        duration: MotionSpecs.expressiveFastSpatialDuration
        easing.type: Easing.BezierSpline
        onFinished: {
            if (reverse) {
                group.reset();
            } else if (group.animationFinished) {
                group.animationFinished();
            }
        }
    }

    function animateWidth(center: Button, autoReset = false) {
        if (!center) {
            return;
        }

        if (animation.running) {
            group.reset(true);
        }

        // already expanded
        if (group.animatedWidth > 0) {
            return;
        }

        const buttons = group.buttons;
        const index = buttons.indexOf(center);

        if (index === -1) {
            console.error(`Unable to find ${center} in group`);
            return;
        }

        const left = getSibling(index - 1, center.y);
        const right = getSibling(index + 1, center.y);

        // capture the widths
        const centerWidth = center.implicitWidth;
        const leftWidth = left?.implicitWidth ?? 0;
        const rightWidth = right?.implicitWidth ?? 0;

        function setWidth(button: Button, binding: var) {
            console.assert(button !== null);
            if (button.Layout?.preferredWidth !== undefined) {
                button.Layout.preferredWidth = binding;
            } else {
                button.width = binding;
            }
        }

        if (left && right) {
            setWidth(left, Qt.binding(() => leftWidth - Math.floor(group.animatedWidth / 2)));
            setWidth(right, Qt.binding(() => rightWidth - Math.ceil(group.animatedWidth / 2)));
        } else if (left) {
            setWidth(left, Qt.binding(() => leftWidth - group.animatedWidth));
        } else if (right) {
            setWidth(right, Qt.binding(() => rightWidth - group.animatedWidth));
        }

        setWidth(center, Qt.binding(() => centerWidth + group.animatedWidth));

        group.animatedWidth = Qt.binding(() => Math.round(group.animationValue * group.expandRatio * centerWidth));
        group.currentIndex = index;
        group.from = 0;
        group.to = 1;
        animation.reverse = autoReset;
        animation.start();
    }

    function reset(force = false) {
        animation.complete();

        // We have already expanded, time to shrink back
        if (group.animatedWidth > 0) {
            group.animationFinished = function () {
                const index = group.currentIndex;
                const buttons = group.buttons;

                let center = buttons[index];

                if (!center) {
                    return;
                }

                const left = getSibling(index - 1, center.y);
                const right = getSibling(index + 1, center.y);

                function resetWidth(button: Button) {
                    if (!button) {
                        return;
                    }
                    if (button?.Layout?.preferredWidth !== undefined) {
                        button.Layout.preferredWidth = Qt.binding(() => button.implicitWidth);
                    } else {
                        button.width = Qt.binding(() => button.implicitWidth);
                    }
                }

                resetWidth(left);
                resetWidth(center);
                resetWidth(right);

                console.assert(group.animatedWidth === 0 && group.from === 1 && group.to === 0, "ButtonGroup: Bad State");
                group.currentIndex = -1;
                group.animationFinished = null;
            };

            if (force) {
                animation.reverse = false;
                group.animationFinished();
            } else {
                group.from = 1;
                group.to = 0;
                animation.reverse = false;
                animation.start();
            }
        }
    }
}
