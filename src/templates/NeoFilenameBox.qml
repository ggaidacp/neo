import QtQuick 2.15
import QtQuick.Controls 2.15
import DVAGLogger 1.0
import "../settings"
import "../functions"

Text {
    id: neoFilenameBox
    property bool  light: false
    property string filename: "file.txt"
    font.family: light ? Settings.defaultFontLight : Settings.defaultFont
    font.pointSize: 10
    color: "black"
    text: QmlFileManager.shortenFilename(filename, text.width, text.height, font.pointSize)
    wrapMode: Text.WrapAnywhere
    horizontalAlignment: Text.AlignLeft
   /* verticalAlignment: (isClicked
                        && (text.paintedHeight
                            > text.height)) ? Text.AlignBottom : Text.AlignTop*/
    verticalAlignment: Text.AlignTop
    clip: !isClicked
    //anchors.horizontalCenter: parent.horizontalCenter
}
