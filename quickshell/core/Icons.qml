pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    final readonly property int battery_0_bar: 0xebdc
    final readonly property int battery_1_bar: 0xebd9
    final readonly property int battery_2_bar: 0xebe0
    final readonly property int battery_3_bar: 0xebdd
    final readonly property int battery_4_bar: 0xebe2
    final readonly property int battery_5_bar: 0xebd4
    final readonly property int battery_6_bar: 0xebd2
    final readonly property int battery_full: 0xe1a4

    final readonly property int signal_wifi_4_bar: 0xe1d8

    final readonly property int bluetooth_connected: 0xe1a8

    final readonly property int wifi_1_bar: 0xe4ca
    final readonly property int wifi_2_bar: 0xe4d9
    final readonly property int wifi_3_bar: 0xef16
}
