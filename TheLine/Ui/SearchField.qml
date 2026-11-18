import QtQuick

// The "›" search field of the line's dialogs. Arrow keys, Enter and Esc are passed up as signals.
Rectangle {
    id: field

    property alias text: input.text
    property alias echoMode: input.echoMode   // TextInput.Password for a password
    property string placeholder: "Search"
    // ← and → always go up as `moved` (a grid under the field), never move the cursor in the text. Otherwise they
    // do so only while the field is empty.
    property bool sideArrowsMove: false
    signal moved(int dx, int dy)
    signal accepted
    signal cancelled
    signal keyPressed(var event)   // anything else worth handling (Shift+Delete...)

    function focusInput() {
        input.forceActiveFocus();
    }

    height: Theme.u(40)
    color: Theme.bg
    border.width: 1
    border.color: input.activeFocus ? Theme.accent : Theme.borderStrong

    Behavior on border.color {
        ColorAnimation { duration: Anim.hover }
    }

    Text {
        id: prompt
        x: Theme.u(12)
        anchors.verticalCenter: parent.verticalCenter
        text: "›"
        font.family: Theme.fontMono
        font.pixelSize: Theme.u(14)
        color: Theme.accent
    }

    TextInput {
        id: input

        anchors.left: prompt.right
        anchors.leftMargin: Theme.u(10)
        anchors.right: parent.right
        anchors.rightMargin: Theme.u(12)
        anchors.verticalCenter: parent.verticalCenter
        font.family: Theme.fontUi
        font.pixelSize: Theme.u(14)
        font.weight: Font.Medium
        color: Theme.text
        selectionColor: Theme.accent
        clip: true

        Keys.onUpPressed: field.moved(0, -1)
        Keys.onDownPressed: field.moved(0, 1)
        Keys.onReturnPressed: field.accepted()
        Keys.onEnterPressed: field.accepted()
        Keys.onEscapePressed: field.cancelled()
        Keys.onPressed: event => {
            if ((event.key === Qt.Key_Left || event.key === Qt.Key_Right) && (field.sideArrowsMove || input.text === "")) {
                field.moved(event.key === Qt.Key_Left ? -1 : 1, 0);
                event.accepted = true;
            } else {
                field.keyPressed(event);
            }
        }

        Text {
            visible: input.text === ""
            anchors.verticalCenter: parent.verticalCenter
            text: field.placeholder
            font: input.font
            color: Theme.muted
        }
    }
}
