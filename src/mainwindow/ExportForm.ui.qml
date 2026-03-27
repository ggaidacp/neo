import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../settings"
import "../templates"

import FileManager 1.0

EmbeddedWindow {
    id: embeddedWindow
    localsearchavailable: popUpWindowVolumes.visible ? false : true
    property alias root: root
    property int checkboxheight : 32
    property int checkboxwidth : 32
    // Header
    headerText: Settings.isComposingEmail ? "Anhängen" : "Download"
    overviewButtonVisiblity: !popUpWindowVolumes.visible

    presentationModeVisibility: false

    // Content
    property alias content: content // Used by drag and drop
    property alias dropColumn : dropColumn

    property alias gridView: gridView
    property alias scrollView: scrollView
    //property alias scrollBar: scrollBar

    property alias dragTarget: dragTarget
    property alias listViewExport: listViewExport
    property alias scrollViewExport: scrollViewExport
    property alias scrollBarExportList: scrollBarExportList
    property alias buttonExport: buttonExport
    // Search in content and header
    //property alias buttonlocalSearch: buttonlocalSearch
    //property alias buttonlocalSearchIcon: buttonlocalSearchIcon

    property alias localsearchField: localsearchField
    property alias searchfieldrow: searchfieldrow
    property alias buttonSearchIconInside: buttonSearchIconInside
    property alias busyIndicator: busyIndicator

    property alias contentrowwithoutsearch: contentrowwithoutsearch

    // Footer
    // Left
    property alias buttonBack: buttonBack
    property alias buttonBackIcon: buttonBackIcon
    property alias buttonForward: buttonForward
    property alias buttonForwardIcon: buttonForwardIcon
    // Center
    property alias buttonPresentation: buttonPresentation
    //property alias buttonDav: buttonDav
    property alias buttonMedialibrary: buttonMedialibrary
    property alias buttonOnlinePlatform: buttonOnlinePlatform
    property alias buttonScreenshots: buttonScreenshots

    // PopUpWindow Volume Selection
    property alias popUpWindowVolumes: popUpWindowVolumes

    // PopUpWindow Export Override
    property alias popUpWindowExportOverride: popUpWindowExportOverride

    // PopUpWindow Export Done
    property alias popUpWindowExportDone: popUpWindowExportDone

    Column {
        id: root
        width: parent.width
        height: parent.height
        enabled: false
        // Header
        Rectangle {
            width: embeddedWindow.width
            height: Settings.embeddedWindowHeaderHeight
            color: "transparent"
        }
        // Content
        Rectangle {
            id: content
            width: embeddedWindow.width
            height: (embeddedWindow.height / 30) * 26
            color: "transparent"
            //anchors.verticalCenter: parent.verticalCenter
            Rectangle {
                width: parent.width - 4
                height: parent.height - 4
                color: "transparent"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                Column {
                    id: contentcolumn
                    width: (parent.width / 10) * 9 + 100
                    height: parent.height
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    // local Search
                    Row {
                        id: searchfieldrow
                        height: 70
                        width: parent.width
                        visible: false
                        NeoTextField {
                            id: localsearchField
                            visible: true
                            width: (parent.width / 6) * 3
                            height: 48 //parent.height / 1.1
                            //anchors.verticalCenter :  parent.verticalCenter
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter : parent.horizontalCenter
                            font.pointSize: 14
                            rightPadding : 50
                            background: Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "white"
                                //opacity: 0.75
                                border.color: "#8D8D8D"
                                radius: 25
                        }
                        // Search Button im TextFeld (Lupe)
                            Image {
                                id: searchImg
                                width: parent.width / 10
                                height: 32 //parent.height
                                source: localsearchField.visible ? "qrc:/images/buttons/search.png" : "qrc:/images/buttons/search_gold.png"
                                fillMode: Image.PreserveAspectFit
                                mipmap: true
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right

                                MouseArea {
                                    id: buttonSearchIconInside
                                    width: parent.width
                                    height: 32 //parent.height

                                }
                            }
                            BusyIndicator {
                                id: busyIndicator
                                width: parent.width
                                height: parent.height
                                running: true
                                visible: false
                                anchors.centerIn: parent
                            }
                        }
                    }
                    //Spacekeeper Row
                    Row {
                        width: parent.width
                        height: 35
                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "transparent"
                        }
                    }

                    // content-row mit linken quelle Box und rechten targe7-Box und Button
                    Row {
                        id: contentrowwithoutsearch
                        width: parent.width
                        height: parent.height - 70
                        //y: 70
                        //anchors.verticalCenter:  parent.verticalCenter
                        //linke ScrollView mit zu exportierenden dateien
                        Rectangle {
                            id: leftcontentbox
                            width: (parent.width / 6) * 5
                            height: parent.height - (localsearchField.visible ? localsearchField.height : 0)//(parent.height / 8) * 7
                            color: "white"
                            border.color: Settings.blue80
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.top: parent.top
                            visible: popUpWindowVolumes.visible ? false : true
                            ScrollView {
                                id: scrollView
                                width: parent.width - 30
                                height: parent.height
                                clip: true
                                //anchors.centerIn: parent
                                topPadding: 30
                                anchors.horizontalCenter: parent.horizontalCenter
                                ScrollBar.vertical.visible : false /*: ScrollBar {
                                    id: scrollBar
                                    height: parent.height
                                    anchors.right:  parent.right
                                    //policy: Qt.ScrollBarAsNeeded
                                }*/
                                GridView {
                                    id: gridView
                                    width: parent.width
                                    height: parent.height
                                    cellWidth: Settings.isFullscreen ? Settings.fileGridCellWidthFull : Settings.fileGridCellWidth
                                    cellHeight: Settings.isFullscreen ? Settings.fileGridCellHeightFull :  Settings.fileGridCellHeight
                                    model: fileModel
                                }

                            }
                            Text {
                                id: folderEmptyText
                                text: "Keine verfügbaren Dateien vorhanden"
                                visible: fileModel.count > 0 || popUpWindowVolumes.visible ? false : true
                                color: "black"
                                font.pointSize: 20
                                font.family: Settings.defaultFont
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                anchors.centerIn: parent
                            }
                        }
                        // separator rectangle zwischen links (quelle) und rechts (ziel zum dropen)
                        Rectangle {
                            id: separatorsourcetarget
                            width: parent.width / 40
                            height: parent.height
                            color: "white"
                        }
                        // drop target plus button
                        Column {
                            id: dropColumn
                            width: (parent.width / 6) - (parent.width / 40)
                            height: parent.height//(parent.height / 8) * 7
                            //anchors.verticalCenter: parent.verticalCenter
                            visible: popUpWindowVolumes.visible ? false : true

                            // Box zum dropen von zu exportierenden dateien
                            Rectangle {
                                id: droptargetbox
                               /* width: parent.width
                                height: (parent.height / 10) * 9'
                                color:  Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.5) */

                                border.color: Settings.blue80
                                width: parent.width//(parent.width / 6) * 5
                                height: parent.height - rectButtonExport.height //(parent.height / 8) * 7
                                color: "white" // dropArea.containsDrag ? Qt.darker(palette.base) : palette.base
                                //border.color: "#337A96"
                                //anchors.verticalCenter: parent.verticalCenter
                                //anchors.top: parent.top

                                Image {
                                    width: parent.width
                                    height: parent.height
                                    source: "qrc:/images/presentation/draganddrop.png"
                                    fillMode: Image.PreserveAspectFit
                                    visible: exportModel.count > 0 ? false : true
                                    //anchors.centerIn: parent
                                }

                                ScrollView {
                                    id: scrollViewExport
                                    width: (parent.width / 20) * 19
                                    height: parent.height
                                    clip: true
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    ScrollBar.vertical: ScrollBar {
                                        id: scrollBarExportList
                                        height: parent.height
                                        anchors.right: parent.right
                                        policy: "AlwaysOff"
                                    }

                                    ListView {
                                        id: listViewExport
                                        width: parent.width
                                        height: parent.height
                                        model: exportModel
                                        delegate: exportListDelegate
                                        z: 100 // Something was overlapping and blocking the mouseArea of the listElements, not sure what

                                    }
                                }
                                Drag.active: mouseArea.drag.active
                                DropArea {
                                    id: dragTarget
                                    width: parent.width
                                    height: parent.height
                                    anchors.centerIn: parent

                                }

                            }
                            // button Anhängen
                            Rectangle {
                                id: rectButtonExport
                                width: parent.width
                                height: parent.height / 12
                                color: "transparent"
                                //anchors.bottom: parent.bottom

                                ButtonEW {
                                    id: buttonExport
                                    width: parent.width
                                    height: (parent.height / 3) * 2 +10
                                    text: Settings.isComposingEmail ? "Anhängen" : "Download"
                                    visible: popUpWindowVolumes.visible ? false : true
                                    backgroundColor: "white"
                                    textColor: Settings.blue80
                                    textSize: Settings.isFullscreen ? 17 : 12
                                    anchors.bottom: parent.bottom
                                }
                            }

                        }
                    }
                }
            }
        }
        // Footer
        Rectangle {
                width:  embeddedWindow.width
                height: Settings.embeddedWindowFooterHeight
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
                SeparatorLine {}
                // Left
                Row {
                    id: rowLeft
                    width: parent.width * 21 / 60
                    height: parent.height
                    spacing: width / 30
                    leftPadding: 28
                    anchors.left: parent.left

                    Image {
                        id: buttonBackIcon
                        width: 32 //parent.width / 6
                        height: 32//parent.height / 2
                        source: "qrc:/images/buttons/back.png"
                        visible: popUpWindowVolumes.visible ? false : true
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea {
                            id: buttonBack
                            width: parent.width
                            height: parent.height
                        }
                    }

                    Image {
                        id: buttonForwardIcon
                        width: 32 //parent.width / 6
                        height: 32 //parent.height / 2
                        source: "qrc:/images/buttons/forward.png"
                        visible: popUpWindowVolumes.visible ? false : true
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea {
                            id: buttonForward
                            width: parent.width
                            height: parent.height
                        }
                    }
                }
                // Right
                // Radio-buttons
                Row {
                    id: rowCenter
                    width: parent.width * 39 / 60
                    height: parent.height
                    spacing: width * 10 / 40
                    anchors.left: parent.left
                    anchors.bottom:  parent.bottom

                    leftPadding: Settings.isFullscreen ? (parent.width * 165 / 1000 + 55)  :  parent.width * 165 / 1000 //210

                    RadioButton {
                        id: buttonPresentation
                        width: checkboxwidth//(parent.width / 19) * 3
                        height: checkboxheight //parent.height / 2
                        checked: true
                        visible: popUpWindowVolumes.visible ? false : true
                        anchors.verticalCenter: parent.verticalCenter

                        indicator:  Rectangle {
                            y: 5
                                        width: 20
                                        height: 20
                                        radius: 10
                                        border.color: Settings.blue120

                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: 10
                                            height: 10
                                            radius: 10
                                            visible: true
                                            color: buttonPresentation.checked ? Settings.blue80 : "white"
                                        }
                        }
                        Text {
                            y: Settings.isFullscreen ? -5 : 0
                            leftPadding: 30
                            text: "Präsentation"
                            font.pointSize: Settings.isFullscreen ? 20 : 14
                            color: Settings.blue80
                           // anchors.left : parent.left
                            wrapMode: Text.WordWrap
                        }
                    }

                    RadioButton {
                        id: buttonMedialibrary
                        width: checkboxwidth//(parent.width / 19) * 3
                        height: checkboxheight //parent.height / 2
                         visible: popUpWindowVolumes.visible ? false : true
                        anchors.verticalCenter: parent.verticalCenter
                        indicator:  Rectangle {
                            y: 5
                                        width: 20
                                        height: 20
                                        radius: 10
                                        border.color: Settings.blue120

                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: 10
                                            height: 10
                                            radius: 10
                                            visible: true
                                            color: buttonMedialibrary.checked ? Settings.blue80 : "white"
                                        }
                        }
                        Text {
                            y: Settings.isFullscreen ? -5 : 0
                            leftPadding: 30
                            text: "Mediathek"
                            font.pointSize: Settings.isFullscreen ? 20 : 14
                            color: Settings.blue80
                           // anchors.left : parent.left
                            wrapMode: Text.WordWrap
                        }
                    }

                    RadioButton {
                        id: buttonOnlinePlatform
                        width: checkboxwidth//(parent.width / 19) * 3
                        height: checkboxheight //parent.height / 2
                        visible: popUpWindowVolumes.visible ? false : true
                        anchors.verticalCenter: parent.verticalCenter
                        indicator:  Rectangle {
                            y: 5
                                        width: 20
                                        height: 20
                                        radius: 10
                                        border.color: Settings.blue120

                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: 10
                                            height: 10
                                            radius: 10
                                            visible: true
                                            color: buttonOnlinePlatform.checked ? Settings.blue80 : "white"
                                        }
                        }
                        Text {
                            y: Settings.isFullscreen ? -5 : 0
                            leftPadding: 30
                            text: "Online Platformen"
                            font.pointSize: Settings.isFullscreen ? 20 : 14
                            color: Settings.blue80
                           // anchors.left : parent.left
                            wrapMode: Text.WordWrap
                        }
                    }

                    RadioButton {
                        id: buttonScreenshots
                        width: checkboxwidth//(parent.width / 19) * 3
                        height: checkboxheight //parent.height / 2
                        visible: popUpWindowVolumes.visible ? false : true
                        anchors.verticalCenter: parent.verticalCenter
                        indicator:  Rectangle {
                            y: 5
                                        width: 20
                                        height: 20
                                        radius: 10
                                        border.color: Settings.blue120

                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: 10
                                            height: 10
                                            radius: 10
                                            visible: true
                                            color: buttonScreenshots.checked ? Settings.blue80 : "white"
                                        }
                        }
                        Text {
                            y: Settings.isFullscreen ? -5 : 0
                            leftPadding: 30
                            text: "Screenshots"
                            font.pointSize: Settings.isFullscreen ? 20 : 14
                            color: Settings.blue80
                           // anchors.left : parent.left
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
        }



/*
  *
  * PopUpWindow for the volume selection
  *
*/
PopUpWindowWithComboBox {
    id: popUpWindowVolumes
    text: "Bitte wählen Sie einen Export-Datenträger aus."
    textButton: "Ok"

    listModel: volumeModel
    anchors.centerIn: parent
}


    /*
      *
      * PopUpWindow for the completed export when override is necessary
      *
    */
    PopUpWindowWithTwoButtons {
        id: popUpWindowExportOverride
        default_active: false
        visible: false
        anchors.centerIn: parent
    }


    /*
      *
      * PopUpWindow for the completed export
      *
    */
    PopUpWindowWithOneButton {
        id: popUpWindowExportDone

        textButton: "Ok"
        visible: false
        anchors.centerIn: parent
    }
}



