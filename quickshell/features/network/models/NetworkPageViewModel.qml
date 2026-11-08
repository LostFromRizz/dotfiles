import QtQuick
import qs.shared
import qs.services
import Quickshell
import Quickshell.Networking
import qs.core

ViewModel {
    id: viewModel

    final readonly property list<WifiDevice> wifiDevices: [...NetworkService.devices.values].filter(e => e.type === DeviceType.Wifi)

    final readonly property list<WifiNetwork> wifiNetworks: wifiDevices.reduce(function (acc, device) {
        return acc.concat(device.networks.values);
    }, [])

    final readonly property ScriptModelWithCount savedNetworks: ScriptModelWithCount {
        values: [...viewModel.wifiNetworks].filter((e => e.known)).sort((a, b) => {
            if (a.connected !== b.connected) {
                return b.connected - a.connected;
            }
            return b.signalStrength - a.signalStrength;
        })
    }

    final readonly property ScriptModelWithCount availableNetworks: ScriptModelWithCount {
        values: [...viewModel.wifiNetworks].filter((e => !e.known)).sort((a, b) => b.signalStrength - a.signalStrength)
    }

    final readonly property string wifiIconMaxStrength: String.fromCodePoint(Icons.wifi_3_bar)

    function iconFromSignalStrength(signalStrength: real): string {
        if (signalStrength < 0.33) {
            return String.fromCodePoint(Icons.wifi_1_bar);
        }
        if (signalStrength < 0.66) {
            return String.fromCodePoint(Icons.wifi_2_bar);
        }
        return String.fromCodePoint(Icons.wifi_3_bar);
    }

    function networkStatus(network: Network): string {
        if (!network) {
            return "";
        }

        // qmllint disable unresolved-type
        let text = Qt.enumValueToString(ConnectionState.Enum, network.state);

        if (network.connected && network instanceof WifiNetwork) {
            text += ` • ${Math.round((network as WifiNetwork).signalStrength * 100)} db`;
        }

        return text;
    }

    Component.onCompleted: {
        Qt.callLater(function () {
            wifiDevices.forEach(function (device) {
                device.scannerEnabled = true;
            });
        });
    }

    Component.onDestruction: {
        wifiDevices.forEach(function (device) {
            device.scannerEnabled = false;
        });
    }
}
