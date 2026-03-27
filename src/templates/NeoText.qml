import QtQuick 2.11
import QtQuick.Controls 2.15
import DVAGLogger 1.0
import "../settings"

Text {
    id: neoText
    property bool secondscreen: false
    property bool  light: false
    property string ntext
    font.family: light ? Settings.defaultFontLight : Settings.defaultFont
    font.pointSize: secondscreen ? 20 : 12
    color: "black"
    text: ntext
    wrapMode: Text.Wrap
}
