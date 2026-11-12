pragma Singleton

import QtQuick

// The whole motion system: one curve, a few durations, a few offsets. Every duration goes through d(), so an app's
// "reduce motion" (reduce) and its motion speed (scale) apply everywhere at once.
QtObject {
    property real scale: 1
    property bool reduce: false

    // Quartic ease-out. Used for everything that moves or resizes.
    readonly property int easing: Easing.OutQuart

    function d(ms) {
        return reduce ? 1 : Math.round(ms * scale);
    }

    // The same curve as a function, for animations driven by hand (staggers).
    function out(p) {
        const q = 1 - Math.max(0, Math.min(1, p));
        return 1 - q * q * q * q;
    }

    readonly property int press: d(90)
    readonly property int hover: d(120)
    readonly property int base: d(180)
    readonly property int panel: d(260)
    readonly property int workspace: d(340)
    readonly property int line: d(420)         // a line drawing itself across a dialog
    // The pulse travels at a constant speed (linear), it never slows down on the way.
    readonly property int pulse: d(700)        // along the line, to the centre where the two dashes meet
    readonly property int pulseWrap: d(700)    // back out, down the tile's sides and along its bottom
    readonly property int exitFade: d(90)

    readonly property int fillLag: d(55)
    readonly property int ruleDelay: d(80)
    readonly property int itemStart: d(110)
    readonly property int stagger: d(24)
    readonly property int closeLead: d(70)
    readonly property int toastContent: d(120)

    // Holds are not scaled.
    readonly property int gaugeHold: 1400
    readonly property int toastHold: 4200
}
