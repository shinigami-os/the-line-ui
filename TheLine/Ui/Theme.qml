pragma Singleton

import QtQuick

// Every colour, font and size of The Line's design language. Nothing here reads an app's settings: an app that lets
// the user pick the accent binds it (Binding { target: Theme; property: "accent"; value: … }), one that scales
// with the screen sets `scale`, and every size in the kit goes through u().
QtObject {
    // the screen, then the surfaces on it, from the darkest
    readonly property color bg: "#000000"
    readonly property color inset: "#161513"       // sunk into a panel: a field, code
    readonly property color surface: "#1B1A18"     // tiles, windows, dialogs
    readonly property color surface2: "#24221F"    // a raised or selected row on a surface
    readonly property color panel: "#262420"       // a panel inside a window (the settings app's page)
    readonly property color row: "#302D29"         // a lit row on a panel
    readonly property color border: "#3A3631"
    readonly property color borderStrong: "#5A544C"

    readonly property color text: "#ECE8E1"
    readonly property color read: "#B8B1A6"        // running text on a panel
    readonly property color muted: "#9C968C"
    readonly property color faint: "#77716A"

    // Kira violet unless the app sets it
    property color accent: "#9A5CFF"
    readonly property color accentSoft: Qt.tint(accent, Qt.rgba(1, 1, 1, 0.3))   // the accent for small text on a panel
    readonly property color accentText: "#0F0D12"
    // a toggled control: the accent at 14% over a surface
    readonly property color accentTint: Qt.tint(surface, Qt.rgba(accent.r, accent.g, accent.b, 0.14))
    readonly property color ok: "#6CC495"
    readonly property color error: "#EF7A5E"

    // the accents offered where the user picks one
    readonly property var accents: [
        { value: "#9A5CFF", label: "Kira violet" }, { value: "#5C8DFF", label: "Blue" },
        { value: "#4FC3B5", label: "Teal" }, { value: "#6CC495", label: "Green" },
        { value: "#E8B04B", label: "Amber" }, { value: "#EF7A5E", label: "Coral" },
        { value: "#E86FA5", label: "Pink" }, { value: "#ECE8E1", label: "Bone" }
    ]

    readonly property string fontUi: "Raleway"
    readonly property string fontMono: Qt.fontFamilies().indexOf("IBM Plex Mono") >= 0 ? "IBM Plex Mono" : "JetBrains Mono"

    // A tile hangs from the line at y = 10 and is this tall.
    readonly property int tileHeight: 42

    // Square corners, always.
    readonly property int radius: 0

    // Sizes are written for scale 1 (The Line's shell); an app on a bigger canvas (the installer) sets it.
    property real scale: 1
    function u(n) {
        return Math.max(1, Math.round(n * scale));
    }
}
