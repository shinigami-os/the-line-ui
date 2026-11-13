pragma Singleton

import QtQuick
import Quickshell

// The clock. `now` ticks every second, or only every minute when an app turns `seconds` off (a clock without
// seconds then redraws once a minute instead of every second: on an idle desktop, nothing else moves). `tick` is
// still emitted every second, for what samples on it (the machine's figures, the music's position): they land in the
// same frame as a new second.
Singleton {
    id: root

    property bool seconds: true

    readonly property var now: (seconds ? fast.date : slow.date) ?? new Date()
    // The date alone: it changes once a day, so what shows a day (the calendar) is not rebuilt every second.
    readonly property string today: Qt.formatDate(now, "yyyy-MM-dd")

    signal tick

    SystemClock {
        id: fast
        precision: SystemClock.Seconds
        onDateChanged: root.tick()
    }
    SystemClock {
        id: slow
        precision: SystemClock.Minutes
        enabled: !root.seconds
    }
}
