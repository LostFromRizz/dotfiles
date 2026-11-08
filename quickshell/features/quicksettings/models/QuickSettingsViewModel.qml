pragma ComponentBehavior: Bound
import qs.shared
import QtQuick
import Quickshell.Io
import Quickshell.Networking
import Quickshell.Bluetooth
import QtQuick.Controls as QQC
import Material3
import qs.services
import qs.core
import qs.features.quicksettings
import qs.features.quicksettings.components
import qs.features.network
import qs.features.bluetooth

ViewModel {
    id: model

    property string userName: "Unknown"

    readonly property alias uptime: uptimeUpdater.value

    Process {
        id: proc
        running: true
        command: ["sh", "-c", "whoami"]
        stdout: StdioCollector {
            onStreamFinished: {
                let str = text;
                str = str.replace(/[\r\n]+$/, "");
                model.userName = str.charAt(0).toUpperCase() + str.slice(1);
                proc.destroy();
            }
        }
    }

    Timer {
        id: uptimeUpdater
        property string value: "0h, 0m"
        interval: 10
        running: true
        repeat: true
        onTriggered: {
            fileUptime.reload();
            const textUptime = fileUptime.text();
            const uptimeSeconds = Number(textUptime.split(" ")[0] ?? 0);

            // Convert seconds to days, hours, and minutes
            const days = Math.floor(uptimeSeconds / 86400);
            const hours = Math.floor((uptimeSeconds % 86400) / 3600);
            const minutes = Math.floor((uptimeSeconds % 3600) / 60);

            // Build the formatted uptime string
            let formatted = "";
            if (days > 0)
                formatted += `${days}d`;
            if (hours > 0)
                formatted += `${formatted ? ", " : ""}${hours}h`;
            if (minutes > 0 || !formatted)
                formatted += `${formatted ? ", " : ""}${minutes}m`;
            value = formatted;
            interval = 3000;
        }
    }

    FileView {
        id: fileUptime
        path: "/proc/uptime"
    }

    final readonly property real sliderHeight: Material.sliderHeightMedium
    final readonly property real currentBrightness: BrightnessService.brightness
    readonly property string brightnessIcon: {
        if (currentBrightness > 0.5) {
            return "brightness_7";
        } else if (currentBrightness > 0.01) {
            return "brightness_6";
        } else {
            return "brightness_empty";
        }
    }
    function setBrightness(value: real): void {
        BrightnessService.setBrightness(value);
    }

    final readonly property real currentVolume: AudioService.volume
    final readonly property string volumeIcon: {
        if (currentVolume == 0.0) {
            return "volume_off";
        } else if (currentVolume < 0.2) {
            return "volume_down";
        } else {
            return "volume_up";
        }
    }

    function setVolume(value: real): void {
        AudioService.setVolume(value);
    }

    final property real buttonGroupSpacing: 6
    final property int buttonGroupRow: 2
    final property int buttonGroupColumn: 3
    final property real buttonHeight: Material.buttonHeightMedium
    final property real buttonExpandedWidth: 180
    final property real buttonCompactWidth: (buttonExpandedWidth / 2) - (buttonGroupSpacing / 2)
    final readonly property real buttonGroupMaxHeight: (buttonHeight * buttonGroupColumn) + ((buttonGroupColumn - 1) * buttonGroupSpacing)

    final readonly property real buttonGroupMaxWidth: (buttonExpandedWidth * buttonGroupRow) + ((buttonGroupRow - 1) * buttonGroupSpacing)
    final property bool sync: true

    onSyncChanged: {
        if (sync) {
            // qmllint disable missing-property
            model.quickActionsPaged.generatePages();
            // qmllint enable missing-property
        }
    }

    ListModel {
        id: quickActionsModel
        final property int syncedCount
    }

    final readonly property alias quickActionsPaged: quickActionsPagedModel

    ListModel {
        id: quickActionsPagedModel

        function sync(): void {
            if (!model) {
                return;
            }

            let currentWidth = 0;
            let columnCount = 0;
            let page = 0;
            let pagedIndex = 0;
            const maxWidth = model.buttonExpandedWidth * model.buttonGroupRow;

            for (let i = 0; i < quickActionsModel.count; i++) {
                let pageModel = quickActionsPagedModel.get(page)?.model;
                if (!pageModel) {
                    quickActionsPagedModel.append({
                        model: []
                    });
                    pageModel = quickActionsPagedModel.get(page)?.model;
                }

                const modelData = quickActionsModel.get(i);
                let action = pageModel.get(pagedIndex);

                if (action) {
                    action.type = modelData.type;
                    action.expanded = modelData.expanded;
                    action.isChecked = modelData.isChecked;
                } else {
                    pageModel.append({
                        type: modelData.type,
                        expanded: modelData.expanded,
                        isChecked: modelData.isChecked
                    });
                    action = pageModel.get(pagedIndex);
                }

                const width = action.expanded ? model.buttonExpandedWidth : (model.buttonCompactWidth + (model.buttonGroupSpacing / 2));

                currentWidth += width;

                if (currentWidth >= maxWidth) {
                    currentWidth = 0;
                    columnCount++; // move to next line
                }

                if (columnCount == model.buttonGroupColumn) {
                    columnCount = 0;
                    pagedIndex = 0;
                    page++; // move to next page
                    continue;
                }

                pagedIndex++;
            }

            const nextPage = quickActionsPagedModel.get(page);

            if (pagedIndex > 0 && pagedIndex < nextPage.model.count) {
                nextPage.model.remove(pagedIndex, nextPage.model.count - pagedIndex);
            } else if (pagedIndex === 0 && page < quickActionsPagedModel.count) {
                quickActionsPagedModel.remove(page, quickActionsPagedModel.count - page);
            }
        }
    }

    PreferencesListener {
        function onLoaded(): void {
            const quickActionsPrefs = Preferences.getList("quick_actions", [
                {
                    type: Qt.enumValueToString(QuickAction.Type, QuickAction.Wifi),
                    expanded: true,
                    isChecked: true
                },
                {
                    type: Qt.enumValueToString(QuickAction.Type, QuickAction.Bluetooth),
                    expanded: true,
                    isChecked: true
                },
                {
                    type: Qt.enumValueToString(QuickAction.Type, QuickAction.DoNotDisturb),
                    expanded: false,
                    isChecked: false
                },
                {
                    type: Qt.enumValueToString(QuickAction.Type, QuickAction.DarkMode),
                    expanded: false,
                    isChecked: true
                },
                {
                    type: Qt.enumValueToString(QuickAction.Type, QuickAction.PowerMode),
                    expanded: true,
                    isChecked: true
                },

                /////
                {
                    type: Qt.enumValueToString(QuickAction.Type, QuickAction.Wifi),
                    expanded: true,
                    isChecked: true
                },
                {
                    type: Qt.enumValueToString(QuickAction.Type, QuickAction.Bluetooth),
                    expanded: true,
                    isChecked: true
                },
                {
                    type: Qt.enumValueToString(QuickAction.Type, QuickAction.DoNotDisturb),
                    expanded: false,
                    isChecked: false
                },
                {
                    type: Qt.enumValueToString(QuickAction.Type, QuickAction.DarkMode),
                    expanded: false,
                    isChecked: true
                },
                {
                    type: Qt.enumValueToString(QuickAction.Type, QuickAction.PowerMode),
                    expanded: true,
                    isChecked: true
                }
            ]);

            for (const action of quickActionsPrefs) {
                try {
                    const actionType = Qt.enumStringToValue(QuickAction.Type, action.type);
                    quickActionsModel.append({
                        type: actionType,
                        expanded: action.expanded ?? false,
                        isChecked: action.isChecked ?? false
                    });
                } catch (_) {
                    continue;
                }
            }
            quickActionsPagedModel.sync();
        }
    }

    final readonly property Network connectedNetwork: NetworkService.connectedNetwork

    final readonly property BluetoothDevice connectedBluetoothDevice: BluetoothService.connectedDevice

    function toggleBluetooth() {
        BluetoothService.toggle();
    }

    final readonly property list<Action> actions: [
        SplitToggleAction {
            icon.name: "wifi"
            text: model.connectedNetwork?.name ?? "No Internet"
            onTriggered: {
                model.navigationStack.push(networksPage);
            }
            onInnerToggled: source => {
                const button = source as QuickToggleButton;
            // console.log(button.index, button.pageIndex);
            }
        },
        SplitToggleAction {
            icon.name: "bluetooth"
            text: model.connectedBluetoothDevice?.name ?? "Disconnected"
            onTriggered: {
                model.navigationStack.push(bluetoothPage);
            }
            onInnerToggled: source => {
                const button = source as QuickToggleButton;
                console.log(button.index, button.pageIndex);
                model.toggleBluetooth();
            }
        },
        Action {
            icon.name: "do_not_disturb_on"
            text: "Do not disturb"
            onTriggered: {
                // console.log("do not disturb");
            }
        },
        Action {
            icon.name: "dark_mode"
            text: "Dark mode"
            checkable: true
            onToggled: function (source: QtObject): void {
                if (checked) {
                    ThemeService.themeMode = Theme.Dark;
                } else {
                    ThemeService.themeMode = Theme.Light;
                }
            }
        },
        Action {
            icon.name: "local_fire_department"
            text: "Performance"
            onTriggered: {
                // console.log("power mode");
            }
        }
    ]

    required property QQC.StackView navigationStack
    readonly property real margin: GlobalState.barBorderWidth
    readonly property real height: Screen.height - GlobalState.barSize - margin // top + bottom
    readonly property real width: (183 * 2) + (margin * 2) + (LayoutDefaults.pageHorizontalPadding * 2)

    Component {
        id: networksPage
        NetworkPage {
            height: model.navigationStack.height
            width: model.navigationStack.width
            onBackPressed: {
                model.navigationStack.pop();
            }
        }
    }

    Component {
        id: bluetoothPage
        BluetoothPage {
            height: model.navigationStack.height
            width: model.navigationStack.width
            onBackPressed: {
                model.navigationStack.pop();
            }
        }
    }
}
