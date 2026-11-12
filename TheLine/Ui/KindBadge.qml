import QtQuick

// The "▶ video" / "▶ gif" badge on a wallpaper thumbnail's corner (nothing for a still). Place it with x and y.
Rectangle {
    property string kind: "still"

    visible: kind !== "still"
    width: label.implicitWidth + 10
    height: Theme.u(16)
    color: Qt.rgba(0, 0, 0, 0.6)

    Text {
        id: label
        anchors.centerIn: parent
        text: parent.kind === "video" ? "▶ video" : "▶ gif"
        font.family: Theme.fontMono
        font.pixelSize: Theme.u(9)
        color: "white"
    }
}
