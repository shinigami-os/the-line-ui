import QtQuick

// A slider whose track is a 1px line: accent up to the value, borderStrong after it.
Item {
    id: slider

    property real value: 0   // 0..1
    signal moved(real value)

    implicitHeight: Theme.u(18)
    Rectangle {
        y: Theme.u(8)
        width: slider.width * slider.value
        height: 1
        color: Theme.accent
    }
    Rectangle {
        x: slider.width * slider.value
        y: Theme.u(8)
        width: slider.width - x
        height: 1
        color: Theme.borderStrong
    }
    Rectangle {
        x: slider.value * (slider.width - width)
        y: Theme.u(2)
        width: Theme.u(8)
        height: Theme.u(14)
        color: Theme.text
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        function update(mouse) {
            slider.moved(Math.max(0, Math.min(1, (mouse.x - 4) / (slider.width - 8))));
        }

        onPressed: mouse => update(mouse)
        onPositionChanged: mouse => {
            if (pressed)
                update(mouse);
        }
    }
}
