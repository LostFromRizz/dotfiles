pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Material3
import qs.core
import qs.shared.components
import qs.features.bluetooth.models
import QtQuick.Controls as QQC
import Quickshell.Bluetooth

Scaffold {
    id: root

    signal backPressed

    BluetoothPageViewModel {
        id: viewModel
    }

    appBar: ColumnLayout {
        spacing: 0
        TopAppBar {
            Layout.fillWidth: true
            focusPolicy: Qt.TabFocus
            topLeftRadius: root.radius
            topRightRadius: root.radius
            headlineText: "Bluetooth"
            horizontalPadding: LayoutDefaults.pageHorizontalPadding
            leading: BackButton {
                onClicked: root.backPressed()
            }
        }
        LinearProgressIndicator {
            Layout.fillWidth: true
            indeterminate: viewModel.bluetoothEnabled
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
                title: "Use Bluetooth"
            }
            DeviceList {
                title: "Paired Devices"
                model: viewModel.pairedDevices
                Layout.fillWidth: true

                DeviceDelegate {
                    id: pairedDevice
                    checkable: true
                    checked: modelData?.connected ?? false
                    count: viewModel.pairedDevices.values.length
                    trailing: IconButton {
                        icon.name: "more_vert"
                        iconSize: Material.listIconSize
                        onClicked: {
                            pairedDevice.modelData.forget();
                        }
                    }
                    onClicked: {
                        viewModel.toggleConnect(modelData);
                    }
                }
            }

            DeviceList {
                title: "Available Devices"
                model: viewModel.availableDevices
                Layout.fillWidth: true

                DeviceDelegate {
                    id: availableDevice
                    count: viewModel.availableDevices.values.length
                    onClicked: viewModel.pairAndConnect(modelData)

                    BluetoothPageViewModel.ConnectionFailureListener {
                        device: availableDevice.modelData
                        enabled: availableDevice.checked
                        onFailedToConnect: {
                            availableDevice.checked = false;
                        }
                    }
                }
            }
        }
    }

    component DeviceList: LabeledList {}

    component DeviceDelegate: SegmentedListItem {
        id: delegate
        required property BluetoothDevice modelData

        width: parent.width
        subtitleText: viewModel.deviceStatus(modelData)
        // qmllint enable unresolved-type
        title: modelData?.name ?? "[No Name]"
        visible: modelData !== null
        backgroundColor: checked ? Theme.colorScheme.secondaryContainer : Theme.colorScheme.surfaceContainerHigh
        elevation: 0
        checkable: true
        leading: Icon {
            size: Material.listIconSize
            name: viewModel.icon(delegate.modelData?.icon ?? "")
        }
    }
}
