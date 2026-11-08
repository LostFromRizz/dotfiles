import QtQuick
import qs.shared
import qs.services
import Quickshell
import Quickshell.Bluetooth

ViewModel {
    id: viewModel

    final readonly property ScriptModel pairedDevices: ScriptModel {
        values: [...BluetoothService.devices.values].filter((e => e.paired))
    }

    final property ScriptModel availableDevices: ScriptModel {
        values: [...BluetoothService.devices.values].filter((e => !e.paired))
    }

    readonly property bool bluetoothEnabled: BluetoothService.enabled

    function deviceStatus(device: BluetoothDevice): string {
        if (!device) {
            return "";
        }

        // qmllint disable unresolved-type
        let text = Qt.enumValueToString(BluetoothDeviceState.Enum, device.state);
        if (device.connected && device.batteryAvailable) {
            text += ` • ${Math.round(device.battery * 100)}%`;
        }
        // qmllint enable unresolved-type
        return text;
    }

    function icon(name: string): string {
        if (name.includes("headset") || name.includes("headphones"))
            return "headphones";
        if (name.includes("audio"))
            return "speaker";
        if (name.includes("phone"))
            return "phone";
        if (name.includes("mouse"))
            return "bluetooth";
        if (name.includes("keyboard"))
            return "keyboard";
        return "bluetooth";
    }

    function pairAndConnect(device: BluetoothDevice): void {
        if (device) {
            device.pair();
            // device.connect();
        }
    }

    function toggleConnect(device: BluetoothDevice): void {
        if (!device && !device.paired) {
            return;
        }

        if (device.connected) {
            device.disconnect();
        } else {
            device.connect();
        }
    }

    Component.onCompleted: {
        BluetoothService.scanEnabled = true;
    }

    Component.onDestruction: {
        BluetoothService.scanEnabled = false;
    }

    component ConnectionFailureListener: Connections {
        required property BluetoothDevice device
        target: device

        signal failedToConnect

        // qmllint disable unresolved-type
        function onStateChanged(): void {
            if (device?.state === BluetoothDeviceState.Disconnected) {
                failedToConnect();
            }
        }
        // qmllint enable unresolved-type
    }
}
