import QtQuick

// A labelled reading for a tile's top row: a small uppercase label over a mono value, with an optional
// line-drawn decoration before the value (default children). While `expanded` (the tile is open) the longer
// `wide` value cross-fades in and the width follows with the panel timing.
Item {
    id: reading

    property string label
    property string value
    property string wide: value
    property bool expanded: false
    property color valueColor: Theme.text
    property real minWidth: Theme.u(30)
    // The widest value it will ever show ("100%"): the reading keeps that width, so a value changing every second
    // never resizes it (nor the tile around it, which would animate on every screen).
    property string reserve: ""

    default property alias decoration: deco.data

    readonly property real _decoW: deco.childrenRect.width > 0 ? deco.childrenRect.width + 5 : 0

    // Width at rest, whatever the current state: lets a tile size itself without following the expansion.
    readonly property real compactWidth: Math.max(minWidth, labelText.implicitWidth, _decoW + Math.max(valueText.implicitWidth, reserveText.implicitWidth))

    width: expanded ? Math.max(minWidth, labelText.implicitWidth, _decoW + wideText.implicitWidth) : compactWidth
    height: Theme.u(27)
    clip: true

    // Only opening and closing animate the width: a new value takes its width at once.
    property bool resizing: false
    onExpandedChanged: {
        resizing = true;
        resizeEnd.restart();
    }
    Timer {
        id: resizeEnd
        interval: Anim.panel + 40
        onTriggered: reading.resizing = false
    }
    Behavior on width {
        enabled: reading.resizing
        NumberAnimation { duration: Anim.panel; easing.type: Anim.easing }
    }

    Text {
        id: reserveText
        visible: false
        text: reading.reserve
        font.family: Theme.fontMono
        font.pixelSize: Theme.u(12)
    }

    Text {
        id: labelText
        text: reading.label
        font.family: Theme.fontUi
        font.pixelSize: Theme.u(9)
        font.weight: Font.DemiBold
        font.letterSpacing: 0.6
        color: Theme.muted
    }

    Item {
        id: deco
        y: Theme.u(14)
        width: childrenRect.width
        height: Theme.u(10)
    }

    Text {
        id: valueText
        x: reading._decoW
        y: Theme.u(11)
        text: reading.value
        font.family: Theme.fontMono
        font.pixelSize: Theme.u(12)
        color: reading.valueColor
        opacity: reading.expanded ? 0 : 1

        Behavior on opacity {
            NumberAnimation { duration: Anim.base }
        }
        Behavior on color {
            ColorAnimation { duration: Anim.base }
        }
    }

    Text {
        id: wideText
        x: reading._decoW
        y: Theme.u(11)
        text: reading.wide
        font.family: Theme.fontMono
        font.pixelSize: Theme.u(12)
        color: reading.valueColor
        opacity: reading.expanded ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: Anim.base }
        }
        Behavior on color {
            ColorAnimation { duration: Anim.base }
        }
    }
}
