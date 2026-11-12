import QtQuick

// A toggle: 1px border, label with an optional mono sub-label. On = accent border and tinted fill.
Rectangle {
    id: toggle

    property string label
    property string sub
    property bool on: false
    property bool compact: false   // label and sub-label on one row
    signal clicked

    height: compact ? 44 : 48
    color: on ? Theme.accentTint : "transparent"
    border.width: 1
    border.color: on ? Theme.accent : (hover.hovered ? Theme.borderStrong : Theme.border)

    Behavior on color {
        ColorAnimation { duration: Anim.base }
    }
    Behavior on border.color {
        ColorAnimation { duration: Anim.hover }
    }

    Text {
        x: Theme.u(12)
        y: toggle.compact ? (parent.height - height) / 2 : (parent.height - height - subText.height - 2) / 2
        text: toggle.label
        font.family: Theme.fontUi
        font.pixelSize: Theme.u(13)
        font.weight: Font.Medium
        color: Theme.text
    }
    Text {
        id: subText
        visible: toggle.sub !== ""
        x: toggle.compact ? toggle.width - width - 12 : 12
        y: toggle.compact ? (parent.height - height) / 2 : parent.height / 2 + 1
        width: toggle.compact ? implicitWidth : toggle.width - 24
        text: toggle.sub
        elide: Text.ElideRight
        font.family: Theme.fontMono
        font.pixelSize: Theme.u(11)
        color: toggle.on ? Theme.text : Theme.muted
    }

    HoverHandler {
        id: hover
    }
    TapHandler {
        onTapped: toggle.clicked()
    }
}
