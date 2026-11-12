# The Line UI

The design language of [The Line](https://github.com/shinigami-os/the-line) as a QML module, so every app that should
look like it (the shell, its settings, its login screen, the Kira installer, and the next ones) draws with the same
parts instead of its own copies. Black and warm greys, 1 px lines, square corners, one accent, one curve.

```qml
import TheLine.Ui

Toggle {
    label: "Night light"
    on: true
}
```

## What is in it

| | |
|---|---|
| `Theme` | colours, fonts, the tile height, `radius: 0`, and `u()`, which every size goes through |
| `Anim` | the motion: one curve (quartic ease-out), the durations, `d()` for reduced motion and speed |
| `Time`, `Keypad` | the clock (one tick a second) and numpad digits whatever NumLock says |
| `Tile`, `PanelItem`, `CenterDialog` | a tile that grows into a panel, a panel's items arriving one after another, a dialog grown from a line |
| `ListRow`, `Choice`, `Toggle`, `LineSlider`, `Field`, `SearchField`, `HoldButton`, `KeyCap` | rows and controls |
| `Reading`, `Icon`, `Sentence`, `KindBadge` | a labelled value, a line icon from an SVG path, a sentence with lit words, a video / gif badge |

`Time` and `Keypad` need [Quickshell](https://quickshell.org) (0.3 or later); everything else is plain Qt Quick.

## An app sets three things

Nothing in the kit reads an app's own settings. An app binds what its user chooses:

```qml
Binding { target: Theme; property: "accent"; value: Config.accent }         // Kira violet by default
Binding { target: Theme; property: "scale"; value: height / 768 }            // 1 by default (the shell)
Binding { target: Anim; property: "reduce"; value: Config.reduceMotion }    // and Anim.scale, the motion speed
```

## Install

It is a QML module, nothing to build. Copy `TheLine/` into Qt's QML import path:

```sh
sudo cp -r TheLine "$(qtpaths6 --query QT_INSTALL_QML)/"       # usually /usr/lib/qt6/qml
```

On Kira Linux: `sudo flux install kira-the-line-ui` (the shell, its settings and the installer depend on it).
To work on it, link it instead, and every app picks up your edits:

```sh
sudo ln -s "$PWD/TheLine" "$(qtpaths6 --query QT_INSTALL_QML)/TheLine"
```

## License

GPL-3.0-or-later, like The Line.
