import QtQuick

// A tile that grows into a panel. Four layers:
//   fill    surface-coloured rectangle with its own size, so it can lag behind the frame
//   topRow  the always-visible tile content (default children go here)
//   rule    1px divider under the top row, drawn from the anchor side
//   body    the panel content, fixed at the open width and revealed by the frame (bodyData)
// The frame is this item: it clips, has no top border (the line is the top edge) and leads the fill.
Item {
    id: tile

    property string anchorSide: "left"   // left | center | right
    property string mode: "rest"         // rest | toast | open
    property real margin: Theme.u(16)
    property real restW: Theme.u(176)
    property real restH: Theme.tileHeight
    property real toastW: restW
    property real toastH: restH
    property real openW: restW
    property real openH: restH

    // When driven, the frame and the fill take these sizes directly (no animation of their own).
    property bool driven: false
    property real drivenW: restW
    property real drivenH: restH
    property real drivenFillW: restW
    property real drivenFillH: restH

    // Folded up into the line (fullscreen): height goes to 0, the top row fades out first.
    property bool collapsed: false

    readonly property bool open: mode === "open"
    readonly property real targetW: mode === "open" ? openW : (mode === "toast" ? toastW : restW)
    readonly property real targetH: collapsed ? 0 : (mode === "open" ? openH : (mode === "toast" ? toastH : restH))

    default property alias topData: topRow.data
    property alias bodyData: body.data

    property bool bodyVisible: false
    property color borderColor: hover.hovered ? Theme.borderStrong : Theme.border

    function _sideX(w) {
        return anchorSide === "left" ? 0 : (anchorSide === "right" ? tile.width - w : (tile.width - w) / 2);
    }

    y: Theme.u(10)
    x: anchorSide === "left" ? margin : (anchorSide === "right" ? parent.width - margin - width : (parent.width - width) / 2)
    width: driven ? drivenW : targetW
    height: driven ? drivenH : targetH
    clip: true

    // Frame: no pause when growing, a short lead when shrinking so the content leaves first.
    Behavior on width {
        enabled: !tile.driven
        SequentialAnimation {
            PauseAnimation { duration: tile.targetW < tile.width ? Anim.closeLead : 0 }
            NumberAnimation { duration: Anim.panel; easing.type: Anim.easing }
        }
    }
    Behavior on height {
        enabled: !tile.driven
        SequentialAnimation {
            PauseAnimation { duration: tile.targetH < tile.height ? Anim.closeLead : 0 }
            NumberAnimation { duration: Anim.panel; easing.type: Anim.easing }
        }
    }
    Behavior on borderColor {
        ColorAnimation { duration: Anim.hover }
    }

    onModeChanged: {
        if (mode !== "rest") {
            hideTimer.stop();
            bodyVisible = true;
        } else {
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: Anim.panel
        onTriggered: tile.bodyVisible = false
    }

    HoverHandler {
        id: hover
    }

    // Swallows clicks on empty parts of the tile, so they don't reach the scrim that closes panels.
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
    }

    Rectangle {
        id: fill
        color: Theme.surface
        width: tile.driven ? tile.drivenFillW : tile.targetW
        height: tile.driven ? tile.drivenFillH : tile.targetH
        x: tile._sideX(width)

        Behavior on width {
            enabled: !tile.driven
            SequentialAnimation {
                PauseAnimation { duration: tile.targetW < fill.width ? Anim.closeLead : Anim.fillLag }
                NumberAnimation { duration: Anim.panel; easing.type: Anim.easing }
            }
        }
        Behavior on height {
            enabled: !tile.driven
            SequentialAnimation {
                PauseAnimation { duration: tile.targetH < fill.height ? Anim.closeLead : Anim.fillLag }
                NumberAnimation { duration: Anim.panel; easing.type: Anim.easing }
            }
        }
    }

    // Spans the whole frame, so its content can use the extra room while the tile is open.
    Item {
        id: topRow
        width: tile.width
        height: Theme.tileHeight - 1
        opacity: tile.collapsed ? 0 : 1

        Behavior on opacity {
            SequentialAnimation {
                PauseAnimation { duration: tile.collapsed ? 0 : Math.round(Anim.panel * 0.6) }
                NumberAnimation { duration: tile.collapsed ? Anim.exitFade : Anim.base }
            }
        }
    }

    Rectangle {
        id: rule
        y: Theme.tileHeight - 1
        width: tile.width
        height: 1
        color: Theme.border

        transform: Scale {
            origin.x: tile.anchorSide === "left" ? 0 : (tile.anchorSide === "right" ? rule.width : rule.width / 2)
            xScale: tile.mode === "rest" ? 0 : 1

            Behavior on xScale {
                SequentialAnimation {
                    PauseAnimation { duration: tile.mode === "rest" ? 0 : Anim.ruleDelay }
                    NumberAnimation { duration: Anim.panel; easing.type: Anim.easing }
                }
            }
        }
    }

    Item {
        id: body
        y: Theme.tileHeight
        width: tile.openW
        height: tile.openH - Theme.tileHeight
        x: tile._sideX(width)
        visible: tile.bodyVisible
        enabled: tile.mode !== "rest"
    }

    // Borders: left, right and bottom, on top of everything.
    Rectangle { x: 0; width: 1; height: parent.height; color: tile.borderColor }
    Rectangle { x: parent.width - 1; width: 1; height: parent.height; color: tile.borderColor }
    Rectangle { y: parent.height - 1; width: parent.width; height: 1; color: tile.borderColor }
}
