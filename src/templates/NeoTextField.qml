import QtQuick 2.15
import QtQuick.Controls 2.15
import DVAGLogger 1.0

import "../settings"

TextField {
    property int topPaddingVal : (height - font.pixelSize) / 2 - font.pixelSize / 4
    property int bottomPaddingVal : 0 //(height - font.pixelSize) / 2
    property int rightPaddingVal : 0
    id: neoTextField
    width: 200
    height: 40
    font.italic: false
    font.family: Settings.defaultFont
    font.pixelSize: 16
    placeholderText: "Hier Text eingeben"
    //focus: true
    topPadding: topPaddingVal //
    rightPadding : rightPaddingVal
    bottomPadding: bottomPaddingVal
    leftPadding: width / 36

    signal enterPressed()
    signal makeInputPanelTransparent()

   /* onVisibleChanged: {
        if (visible) {
            focus = true
        } else {
            focus = false
        }
    }*/

    // Methode beim Erlangen des Fokus
    function onFocusGained() {
        Settings.activeTextField = neoTextField
            makeInputPanelTransparent()
            //Qt.inputMethod.keyboardRectangle.color = "black"
            //DVAGLogger.log("*********** NeoTextField::focusGained -> makeInputPanelTransparent*********** y-Koordinate = " + y)
    }
    // Methode beim Verlieren des Fokus
    function onFocusLost() {
      /*  if (!TextField.textEdited) {
            font.italic = true
        }*/

    }

    onActiveFocusChanged: {
        //DVAGLogger.log("NeoTextField::onActiveFocusChanged")
        if (focus) {
            //DVAGLogger.log("NeoTextField::onActiveFocusChanged -> onFocusGained")
            onFocusGained()
        } else {
            //DVAGLogger.log("NeoTextField::onActiveFocusChanged -> onFocusLost")
            onFocusLost()
        }
    }
    onFocusChanged: {
        //DVAGLogger.log("NeoTextField::onActiveFocusChanged")
        if (focus) {
            //DVAGLogger.log("NeoTextField::onActiveFocusChanged -> onFocusGained")
            onFocusGained()
        } else {
            //DVAGLogger.log("NeoTextField::onActiveFocusChanged -> onFocusLost")
            onFocusLost()
        }

    }



    Keys.onPressed: {
        //DVAGLogger.log("NeoTextField::on Pressed Event-key: " + event.key)
    }

    Keys.onReturnPressed: {
               // Signal auslösen, wenn Enter gedrückt wird
               //DVAGLogger.log("NeoTextField send event" + " " + displayText)
               enterPressed()
    }
   // onPressed: font.italic = false
}
