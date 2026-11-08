import QtQuick
import Quickshell.Services.UPower
import Material3
import qs.shared.components
import qs.services

OverlayPopupItem {
    Dialog {
        id: dialog
        Theme.colorScheme: ThemeService.colorScheme
        anchors.centerIn: parent
        title: "Low Battery"
        icon: Icon {
            anchors.horizontalCenter: parent.horizontalCenter
            name: "battery_android_alert"
            color: Theme.colorScheme.error
            size: 32
        }
        implicitWidth: 280 + leftPadding + rightPadding
        contentItem: Label {
            text: "Your battery is running low you might want to plug-in soon to recharge."
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }
        standardButtons: Dialog.Close

        Connections {
            target: UPower.displayDevice
            function onPercentageChanged(): void {
                if (UPower.displayDevice.percentage <= 0.1 || UPower.displayDevice.percentage <= 0.05) {
                    dialog.open();
                }
            }
        }
    }
}
