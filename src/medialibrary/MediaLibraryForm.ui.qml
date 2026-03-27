import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"
import "../templates"

EmbeddedWindow {
	id: embeddedWindow

	property alias root: root

	// Header
	headerText: "Mediathek"
    localsearchavailable: true
    presentationModeVisibility: false
	// Content
	property alias gridView: gridView
	property alias scrollView: scrollView
    property alias contentmedia: contentmedia
    // Search in content and header
    // Search
    property alias localsearchField: localsearchField
    property alias searchfieldrow: searchfieldrow
    property alias buttonSearchIconInside: buttonSearchIconInside
    property alias busyIndicator: busyIndicator

	// Footer
	// Center
    property alias buttonVideos: buttonVideos
    property alias buttonPictures: buttonPictures
	property alias buttonEntertainment: buttonEntertainment


	Column {
		id: root
		width: parent.width
		height: parent.height
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
            Rectangle {
                id: contentmedia
                width: parent.width // -4
                height: parent.height //- 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                Column {
                    width: parent.width
                    height: parent.height
                    Row {
                        id: searchfieldrow
                        height: 90
                        width: parent.width
                        visible: false
                        NeoTextField {
                            id: localsearchField
                            visible: true
                            width: (parent.width / 6) * 3
                            height: 48
                            anchors.verticalCenter :  parent.verticalCenter
                            anchors.horizontalCenter : parent.horizontalCenter
                            font.pointSize: 14
                            rightPaddingVal: 50
                            background: Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "white"
                                //opacity: 0.75
                                border.color: "#8D8D8D"
                                radius: 25
                            }
                            // Search Button (Lupe)
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
                    Rectangle  {
                        width: parent.width - 60
                        height: parent.height  - (localsearchField.visible ? localsearchField.height : 0)
                        ScrollView {
                            id: scrollView
                            width: parent.width - 60
                            height: parent.height
                            clip: true
                            x: 70
                            anchors.verticalCenter: parent.verticalCenter
                            //anchors.horizontalCenter:  parent.horizontalCenter
                            ScrollBar.vertical.visible: false /*ScrollBar {
                                id: scrollBarGrid
                                height: parent.height
                                anchors.right: parent.right
                                //policy: ScrollBar.AsNeeded
                                visible: false
                            }*/
                            //verticalPadding: 50
                            topPadding: 30

                            GridView {
                                id: gridView
                                width: parent.width
                                height: parent.height
                                cellWidth: Settings.isFullscreen ? Settings.fileGridCellWidthFull : Settings.fileGridCellWidth
                                cellHeight: Settings.isFullscreen ? Settings.fileGridCellHeightFull :  Settings.fileGridCellHeight
                                delegate: gridDelegate
                                clip: true
                            }
                        }
                        //}
                        Text {
                            id: folderEmptyText
                            text: "Keine verfügbaren Dateien vorhanden"
                            visible: fileModel.count > 0 ? false : true
                            color: "black"
                            font.pointSize: 20
                            font.family: Settings.defaultFont
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
        // Footer
        Rectangle {
            width: embeddedWindow.width
            height: Settings.embeddedWindowFooterHeight
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            SeparatorLine {}
			// Center
            Rectangle {
                width: parent.width * 60 / 100
                height: parent.height
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                Row {
                    id: rowCenter
                    width: parent.width * 9 / 10
                    height: parent.height
                    spacing: width / 16
                    anchors.horizontalCenter:  parent.horizontalCenter
                    leftPadding: parent.width * 6 / 100  //parent.width * 22 / 100

                        ButtonFilterEW {
                            id: buttonVideos
                            width: parent.width * 22 / 100
                            height: parent.height / 2
                            isClicked: true
                            boxchecked: true
                            customtext : "Videos"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        ButtonFilterEW {
                            id: buttonEntertainment
                            width: parent.width * 22 / 100
                            height: parent.height / 2
                            isClicked: true
                            boxchecked: true
                            customtext : "Audio"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        ButtonFilterEW {
                            id: buttonPictures
                            width: parent.width * 22 / 100
                            height: parent.height / 2
                            isClicked: true
                            boxchecked: true
                            customtext : "Bilder"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
            }
		}
	}
}
