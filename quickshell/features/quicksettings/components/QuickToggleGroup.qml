pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Templates as T
import Material3
import qs.features.quicksettings
import qs.shared.components

Item {
    id: root
    final required property real buttonHeight
    final required property real buttonExpandedWidth
    final required property real buttonCompactWidth
    final required property real maxHeight
    final required property list<T.Action> actions

    final property alias contentWidth: view.contentWidth
    final property alias contentHeight: view.contentHeight
    final property alias pageModel: pageRepeater.model
    final property alias spacing: view.spacing

    final readonly property real __columnSpacing: 8
    implicitHeight: view.implicitHeight + indicator.implicitHeight + __columnSpacing
    implicitWidth: view.implicitWidth

    QQC.SwipeView {
        id: view
        clip: true
        orientation: Qt.Vertical

        implicitWidth: contentWidth
        implicitHeight: contentChildren[0].implicitHeight

        Repeater {
            id: pageRepeater

            Flow {
                id: flowLayout
                required property int index
                required property ListModel model
                height: index == 0 ? implicitHeight : view.contentHeight
                width: view.contentWidth
                spacing: view.spacing

                ButtonGroupAnimator {
                    id: animator
                    buttons: flowLayout.children.filter(e => e !== repeater)
                    exclusive: false
                }

                Repeater {
                    id: repeater
                    model: flowLayout.model
                    onItemAdded: function (index, item): void {
                        const button = (item as T.AbstractButton);
                        button.downChanged.connect(function () {
                            if (button.down) {
                                animator.animateWidth(item, false);
                            } else {
                                animator.reset();
                            }
                        });
                    // .downChanged
                    }
                    delegate: QuickToggleButton {
                        action: root.actions[type]
                        pageIndex: flowLayout.index
                        containerHeight: root.buttonHeight
                        expandedWidth: root.buttonExpandedWidth
                        compactWidth: root.buttonCompactWidth
                    }
                }
            }
        }
    }

    QQC.PageIndicator {
        id: indicator
        currentIndex: view.currentIndex
        count: view.count
        visible: count > 1
        anchors.top: view.bottom
        anchors.horizontalCenter: view.horizontalCenter
        anchors.topMargin: root.__columnSpacing
    }
}
