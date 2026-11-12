import QtQuick

// One item of a panel. Arrives staggered on open (opacity + 4px slide), leaves at once on close.
Item {
    id: item

    property int order: 0
    property bool shown: false

    opacity: shown ? 1 : 0

    transform: Translate {
        y: item.shown ? 0 : -4

        Behavior on y {
            SequentialAnimation {
                PauseAnimation { duration: item.shown ? Anim.itemStart + item.order * Anim.stagger : 0 }
                NumberAnimation {
                    duration: item.shown ? Anim.base : Anim.exitFade
                    easing.type: item.shown ? Anim.easing : Easing.Linear
                }
            }
        }
    }

    Behavior on opacity {
        SequentialAnimation {
            PauseAnimation { duration: item.shown ? Anim.itemStart + item.order * Anim.stagger : 0 }
            NumberAnimation {
                duration: item.shown ? Anim.base : Anim.exitFade
                easing.type: item.shown ? Anim.easing : Easing.Linear
            }
        }
    }
}
