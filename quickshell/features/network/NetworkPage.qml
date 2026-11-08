pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import Material3
import qs.core
import qs.shared.components
import qs.features.network.models
import Quickshell.Networking

Scaffold {
    id: root

    signal backPressed

    NetworkPageViewModel {
        id: viewModel
    }

    appBar: ColumnLayout {
        spacing: 0
        TopAppBar {
            Layout.fillWidth: true
            focusPolicy: Qt.TabFocus
            topLeftRadius: root.radius
            topRightRadius: root.radius
            headlineText: "Internet"
            horizontalPadding: LayoutDefaults.pageHorizontalPadding
            leading: BackButton {
                onClicked: root.backPressed()
            }
        }
        LinearProgressIndicator {
            Layout.fillWidth: true
            indeterminate: true
            stopIndicator: null
        }
    }

    contentItem: QQC.ScrollView {
        clip: true
        height: root.availableHeight - root.implicitHeaderHeight
        width: root.availableWidth
        horizontalPadding: LayoutDefaults.pageHorizontalPadding
        verticalPadding: LayoutDefaults.pageVerticalPadding

        ColumnLayout {
            width: (root.contentItem as QQC.ScrollView).availableWidth
            spacing: 18
            ListItemSwitchDelegate {
                Layout.fillWidth: true
                radius: height / 2
                title: "Use Wifi"
            }
            NetworkList {
                title: "Saved Network"
                model: viewModel.savedNetworks
                Layout.fillWidth: true

                NetworkDelegate {
                    id: pairedNetwork
                    checkable: true
                    checked: modelData?.connected ?? false
                    count: viewModel.savedNetworks.count
                    trailing: IconButton {
                        icon.name: "more_vert"
                        iconSize: Material.listIconSize
                        onClicked: {}
                    }
                    onClicked: {}
                }
            }

            NetworkList {
                title: "Available Networks"
                model: viewModel.availableNetworks
                Layout.fillWidth: true

                NetworkDelegate {
                    id: availableNetwork
                    count: viewModel.availableNetworks.count
                }
            }
        }
    }

    component NetworkList: LabeledList {}

    component NetworkDelegate: SegmentedListItem {
        id: delegate
        required property WifiNetwork modelData

        width: parent.width
        subtitleText: viewModel.networkStatus(modelData)
        // qmllint enable unresolved-type
        title: modelData?.name ?? "[No Name]"
        visible: modelData !== null
        backgroundColor: checked ? Theme.colorScheme.secondaryContainer : Theme.colorScheme.surfaceContainerHigh
        elevation: 0
        checkable: true
        leading: Icon {
            size: Material.listIconSize
            name: viewModel.wifiIconMaxStrength
            color: delegate.Theme.colorScheme.outline
            Icon {
                color: delegate.leadingContentColor
                anchors.fill: parent
                size: Material.listIconSize
                name: viewModel.iconFromSignalStrength(delegate.modelData?.signalStrength ?? 0)
            }
        }
    }
}
