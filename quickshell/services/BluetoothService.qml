pragma Singleton

import QtQuick
import Quickshell as QS
import Quickshell.Bluetooth

QS.Singleton {
    id: root

    readonly property QS.ObjectModel devices: Bluetooth.devices

    readonly property BluetoothDevice connectedDevice: {
        for (let i = 0; i < root.devices.values.length; i++) {
            const device = root.devices.values[i];
            if (device.connected) {
                return device;
            }
        }
        return null;
    }

    // qmllint disable unresolved-type
    readonly property BluetoothAdapter defaultAdapter: Bluetooth.defaultAdapter
    // qmllint enable unresolved-type

    readonly property bool enabled: defaultAdapter.enabled ?? false

    property bool scanEnabled: false

    function enable(): void {
        if (defaultAdapter) {
            defaultAdapter.enabled = true;
        }
    }

    function disable(): void {
        if (defaultAdapter) {
            defaultAdapter.enabled = false;
        }
    }

    function toggle(): void {
        if (!defaultAdapter) {
            return;
        }

        if (enabled) {
            defaultAdapter.enabled = false;
        } else {
            defaultAdapter.enabled = true;
        }
    }

    Binding {
        when: root.enabled
        target: root.defaultAdapter
        property: "discovering"
        value: root.scanEnabled
    }
}
