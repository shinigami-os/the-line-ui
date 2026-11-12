pragma Singleton

import QtQuick
import Quickshell

// The numpad with NumLock off sends arrows, Home, End… (KP_Home is Key_Home with the keypad modifier). On the lock
// screen and the login screen a password is typed on it all the same: digit(event) says which digit that key is.
Singleton {
    function digit(event) {
        if (!(event.modifiers & Qt.KeypadModifier))
            return "";
        switch (event.key) {
        case Qt.Key_Insert: return "0";
        case Qt.Key_End: return "1";
        case Qt.Key_Down: return "2";
        case Qt.Key_PageDown: return "3";
        case Qt.Key_Left: return "4";
        case Qt.Key_Clear: return "5";
        case Qt.Key_Right: return "6";
        case Qt.Key_Home: return "7";
        case Qt.Key_Up: return "8";
        case Qt.Key_PageUp: return "9";
        case Qt.Key_Delete: return ".";
        }
        return "";
    }
}
