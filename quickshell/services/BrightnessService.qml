pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    final readonly property alias brightness: getBrightness.brightness
    final readonly property alias ready: getBrightness.ready

    Process {
        id: getBrightness
        final property real brightness: 0.0
        final property bool ready: false
        running: true
        command: ["sh", "-c", "echo \"$(brightnessctl g) $(brightnessctl m)\""]
        stdout: StdioCollector {
            onStreamFinished: {
                const [curr, max] = text.split(" ");
                const value = parseInt(curr) / parseInt(max);
                getBrightness.brightness = value;
                getBrightness.ready = true;
            }
        }
    }

    Process {
        id: _setBrightness
        // qmllint disable signal-handler-parameters
        onExited: {
            getBrightness.running = true;
        }
        // qmllint enable signal-handler-parameters
    }

    IpcHandler {
        target: "brightness"

        function increase(value: string): void {
            _setBrightness.exec(["brightnessctl", "-n2", "set", `${value}+`]);
        }

        function decrease(value: string): void {
            _setBrightness.exec(["brightnessctl", "-n2", "set", `${value}-`]);
        }

        function set(value: string): void {
            _setBrightness.exec(["brightnessctl", "set", value]);
        }
    }

    function setBrightness(value: real): void {
        _setBrightness.exec(["brightnessctl", "set", `${Math.round(value * 100)}%`]);
    }
}
