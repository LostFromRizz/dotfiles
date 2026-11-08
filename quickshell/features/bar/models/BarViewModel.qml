pragma ComponentBehavior: Bound
import qs.core
import qs.shared
import qs.features.quicksettings
import QtQuick
import Material3
import Quickshell as QS
import Quickshell.Hyprland
import Quickshell.Services.UPower

ViewModel {
    id: viewModel

    enum Size {
        Small,
        Medium,
        Large
    }

    final property QtObject barWindow

    final readonly property bool ready: listener.ready

    final readonly property alias roundedCorners: listener.roundedCorners
    final readonly property alias barSize: listener.barSize

    final readonly property real effectiveBarSize: {
        switch (viewModel.barSize) {
        case BarViewModel.Large:
            return 72;
        case BarViewModel.Medium:
            return 52;
        case BarViewModel.Small:
        default:
            return 40;
        }
    }

    final property real effectiveButtonHeight: {
        switch (viewModel.barSize) {
        case BarViewModel.Large:
            return Material.buttonHeightMedium;
        case BarViewModel.Medium:
            return Material.buttonHeightSmall;
        case BarViewModel.Small:
        default:
            return Material.buttonHeightExtraSmall;
        }
    }

    final property real effectiveVerticalPadding: {
        switch (viewModel.barSize) {
        case BarViewModel.Large:
            return 8.0;
        case BarViewModel.Medium:
            return 6.0;
        case BarViewModel.Small:
        default:
            return 4.0;
        }
    }

    final property real effectiveHorizontalPadding: {
        switch (viewModel.barSize) {
        case BarViewModel.Large:
            return 16.0;
        case BarViewModel.Small:
        case BarViewModel.Medium:
        default:
            return 16.0;
        }
    }

    // TODO: decide whether these properties should be configurable
    final readonly property real effectiveCornerRadius: 20
    final property real effectiveBorderWidth: {
        switch (viewModel.barSize) {
        case BarViewModel.Large:
            return 20.0;
        case BarViewModel.Small:
        case BarViewModel.Medium:
        default:
            return 10.0;
        }
    }

    final property string focusedWindowName: Hyprland.activeToplevel?.title ?? ""

    // Battery State
    final readonly property list<string> __batteryIcons: [Icons.battery_0_bar, Icons.battery_1_bar, Icons.battery_2_bar, Icons.battery_3_bar, Icons.battery_4_bar, Icons.battery_5_bar, Icons.battery_6_bar, Icons.battery_full]
    final readonly property real __batteryPercentage: Utils.clamp(UPower.displayDevice.percentage, 0.0, 1.0)

    final readonly property real batteryDisplayString: `${Math.round(__batteryPercentage) * 100}%`

    final readonly property int batteryIcon: __batteryIcons[Math.round(__batteryPercentage * (__batteryIcons.length - 1))]

    // Wifi State
    final readonly property int wifiIcon: Icons.signal_wifi_4_bar

    // Bluetooth State
    final readonly property int bluetoothIcon: Icons.bluetooth_connected

    // Date and Time State
    final readonly property string dateTimeDisplayString: Qt.formatDateTime(sysClock.date, "dd MMM hh:mm AP")

    QS.SystemClock {
        id: sysClock
        precision: QS.SystemClock.Seconds
    }

    // Hyprland Workspaces
    readonly property QS.ObjectModel workspaces: Hyprland.workspaces

    function switchWorkspace(id: int) {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = ${id} })`);
    }

    PreferencesListener {
        id: listener
        final property bool ready: false
        final property bool roundedCorners: true
        final property int barSize: BarViewModel.Small

        function onLoaded(): void {
            const prefs = Preferences.getObject("bar_prefs", {
                roundedCorners: viewModel.roundedCorners,
                barSize: viewModel.barSize
            });

            roundedCorners = prefs.roundedCorners;
            barSize = Math.min(Math.max(prefs.barSize, BarViewModel.Small), BarViewModel.Large);
            ready = true;
        }
    }

    // Gobal State
    Binding {
        target: GlobalState
        property: "barSize"
        value: viewModel.effectiveBarSize
    }

    Binding {
        target: GlobalState
        property: "barBorderWidth"
        value: viewModel.effectiveBorderWidth
    }

    function toggleQuickSettings() {
        if (quickSettingsPanel.active) {
            quickSettingsPanel.close();
        } else {
            quickSettingsPanel.open();
        }
    }

    final readonly property bool quickSettingsOpened: quickSettingsPanel.opened

    QuickSettings {
        id: quickSettingsPanel
        window: viewModel.barWindow
        property bool opened: false
        y: viewModel.effectiveBarSize
        // about show and hide lets us update state before animation is finished for showing checked button state
        onAboutToShow: {
            opened = true;
        }
        onAboutToHide: {
            opened = false;
        }
    }

    readonly property list<Action> systemControlsActions: [
        Action {
            text: viewModel.dateTimeDisplayString
            checkable: true
        },
        Action {
            checkable: true
            icon.name: String.fromCodePoint(viewModel.bluetoothIcon, viewModel.wifiIcon, viewModel.batteryIcon)
            checked: viewModel.quickSettingsOpened
            onTriggered: {
                viewModel.toggleQuickSettings();
            }
        }
    ]
}

// function __writePrefs() {
//         const roundedCorners = viewModel.roundedCorners;
//         const barSize = Math.min(Math.max(viewModel.barSize, BarViewModel.Small), BarViewModel.Large);
//         // const barSize = viewModel.barSize;
//
//         // Preferences.setObject("bar_prefs", {
//         //     direction: viewModel.direction,
//         //     roundedCorners: viewModel.roundedCorners,
//         //     size: viewModel.size
//         // });
//     }
