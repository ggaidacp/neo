import QtQuick 2.15
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Components
import QtQuick.VirtualKeyboard.Plugins
import QtQuick.VirtualKeyboard.Styles

InputPanel {
    id: neoInputPanel

    KeyboardStyle.keyboardBackground:  Rectangle {
        width: parent.width
        height: parent.height
        Image {
            source: "qrc:/images/background.jpg"
        }
    }


}
