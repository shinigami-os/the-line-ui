pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property var now: clock.date ?? new Date()
    // The date alone: it changes once a day, so what shows a day (the calendar) is not rebuilt every second.
    readonly property string today: Qt.formatDate(now, "yyyy-MM-dd")

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
