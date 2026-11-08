pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // id: root
    function clamp(value: var, min: var, max: var): var {
        return Math.max(min, Math.min(max, value));
    }
}
