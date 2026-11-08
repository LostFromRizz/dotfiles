pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    final readonly property PwNode sink: Pipewire.defaultAudioSink
    final readonly property PwNode source: Pipewire.defaultAudioSource
    final property real volume: sink?.audio.volume ?? 0
    final readonly property bool muted: sink?.audio.muted ?? false

    property bool isBluetoothSource: (sink?.name ?? "").includes("bluez")

    final readonly property bool ready: sink?.ready ?? false
    final readonly property PwObjectTracker tracker: PwObjectTracker {
        objects: [root.sink, root.source]
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {}
    }

    function setVolume(value: real): void {
        root.sink.audio.volume = value;
    }

    function muteToggle(): void {
        if (!sink) {
            return;
        }
        sink.audio.muted = !sink.audio.muted;
    }
}
