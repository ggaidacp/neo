import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.VirtualKeyboard
import "../settings"
import "../templates"

EmbeddedWindow {
	id: embeddedWindow
    z: 99
	property alias root: root
    overviewButtonVisiblity: false
    presentationModeVisibility: false
	// Header
	headerText: "Präsentationen"
    localsearchavailable: true
	// Content
	property alias content: content
    property alias scrollListView: scrollListView
	property alias listView: listView
    property alias scrollBarList: scrollBarList
	property alias scrollView: scrollView
    property alias gridView: gridView
    //property alias scrollBarGrid: scrollBarGrid
	property alias buttonScrollLeftIcon: buttonScrollLeftIcon
	property alias buttonScrollLeft: buttonScrollLeft
	property alias buttonScrollRightIcon: buttonScrollRightIcon
	property alias buttonScrollRight: buttonScrollRight
    property alias buttonNewEmbedded: buttonNewEmbedded
    property alias buttonNewEmbeddedIcon: buttonNewEmbeddedIcon



    // Footer
    // Left
    /*property alias buttonBack: buttonBack
    property alias buttonBackIcon: buttonBackIcon
    property alias buttonForward: buttonForward
    property alias buttonForwardIcon: buttonForwardIcon*/
    // Center
    //    property alias buttonDav: buttonDav
	property alias buttonMedialibrary: buttonMedialibrary
	property alias buttonImport: buttonImport
    // Right
    // Search
    property alias localsearchField: localsearchField
    property alias searchfieldrow: searchfieldrow
    property alias buttonSearchIconInside: buttonSearchIconInside
    property alias busyIndicator: busyIndicator



    // PopUpWindow Saved
    //property alias popUpWindowSaved: popUpWindowSaved

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
            color: "white"

            Column {
				width: parent.width
				height: parent.height
                // local search row
                Row {
                    id: searchfieldrow
                    height: 90
                    width: parent.width
                    visible: false
                    NeoTextField {
                        id: localsearchField
                        visible: true
                        width: (parent.width / 6) * 3
                        height: 48 //parent.height / 1.1
                        anchors.verticalCenter :  parent.verticalCenter
                        anchors.horizontalCenter : parent.horizontalCenter
                        font.pointSize: 14
                        rightPadding : 50
                        background: Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "white"
                            opacity: 0.75
                            border.color: "#8D8D8D"
                            radius: 25
                        }
                        // Search Button (Lupe)
                        Image {
                            id: searchImg
                            width: parent.width / 10
                            height: 32 //parent.height
                            source: searchField.visible ? "qrc:/images/buttons/search.png" : "qrc:/images/buttons/search_gold.png"
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
                // story-board
                Rectangle {
                    id: rect
                    width: parent.width
                    height: (parent.height / 8) * 3
                    color: "transparent"

                    Row {
                        width: parent.width
                        height: parent.height

                        Image {
                            id: buttonScrollLeftIcon
                            width: 100 //(parent.width / 8) * 0.5
                            height: 100 //parent.height / 8
                            source: "qrc:/images/presentation/scroll_left.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter

                            MouseArea {
                                id: buttonScrollLeft
                                width: parent.width
                                height: parent.height
                            }
                        }

                        ScrollView {
                            id: scrollListView
                            width: storyboardModel.count >= 4 ?  (parent.width / 8) * 6 : storyElementWidth * storyboardModel.count//storyElementWidth
                            height: (parent.height / 8) * 6
                            clip: true
                            anchors.verticalCenter: parent.verticalCenter


                            ScrollBar.horizontal:  ScrollBar {
                                id: scrollBarList
                                //stepSize: 1
                                anchors.bottom: parent.bottom
                                policy: ScrollBar.AsNeeded
                                contentItem: Rectangle {
                                                height: 20
                                                radius: 6
                                                color: "black"  // Farbe der Scrollbar
                                            }
                                background: Rectangle {
                                    width: 200 //parent.width
                                    height: 20 //parent.height
                                    color: "grey"
                                }
                            }

                            ScrollBar.vertical.visible: false

                            ListView {
                                id: listView
                                width: parent.width
                                height: parent.height * 9 /10
                                orientation: ListView.Horizontal
                                model: storyboardModel
                                delegate: listDelegate

                            }
                        }
                        // Plus-Button
                        Image {
                            id: buttonNewEmbeddedIcon
                            width: 100 //(parent.width / 12)
                            height: 115 //parent.height / 4
                            source: "qrc:/images/presentation/add_story.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter

                            MouseArea {
                                id: buttonNewEmbedded
                                width: parent.width
                                height: parent.height
                            }
                        }
                        // PfeilRechts Button
                        Image {
                            id: buttonScrollRightIcon
                            width: 100 //(parent.width / 8) * 0.5
                            height: 100 //parent.height / 8
                            source: "qrc:/images/presentation/scroll_right.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                            //anchors.horizontalCenter: parent.right

                            MouseArea {
                                id: buttonScrollRight
                                width: parent.width
                                height: parent.height
                            }
                        }
                    }
                }
                // Grid mit vorhandenen Dateien
                Rectangle {
                    width: parent.width
                    height: (parent.height / 8) * 5 - (localsearchField.visible ? localsearchField.height : 0)
                    color: "transparent"
                    anchors.horizontalCenter: parent.horizontalCenter

                    ScrollView {
                        id: scrollView
                        width: parent.width - 60
                        height: parent.height
                        clip: true
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        ScrollBar.vertical.visible : false
                        GridView {
                            id: gridView
                            width: parent.width
                            height: parent.height
                            cellWidth: Settings.isFullscreen ? Settings.fileGridCellWidthFull : Settings.fileGridCellWidth
                            cellHeight: Settings.isFullscreen ? Settings.fileGridCellHeightFull :  Settings.fileGridCellHeight
                            model: fileModel
                            delegate: gridDelegate
                        }
                    }

                    Text {
                        id: folderEmptyText
                        text: "Keine verfügbaren Dateien vorhanden"
                        visible: fileModel.count > 0 ? false : true
                        color: "black"
                        font.pointSize: 20
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.centerIn: parent
                    }
                }
            }
		}
        // Footer
        Rectangle {
            width: embeddedWindow.width
            height: Settings.embeddedWindowFooterHeight//(embeddedWindow.height / 30) * 3
            color: "white"
            SeparatorLine {}
            Row {
                width: parent.width
                height: parent.height

			// Left
                Rectangle {
                    width: parent.width / 4
                    height: parent.height
                    color: "transparent"
                }
                // Center
                Rectangle {
                    width: parent.width * 2 / 4
                    height: parent.height
                    color: "transparent"
                    Row {
                        id: rowCenter
                        width: parent.width / 2
                        height: parent.height / 4
                        spacing: width / 15
                        anchors.centerIn: parent
                        leftPadding: 30

                        RadioButton {
                            id: buttonMedialibrary
                            width: parent.width / 2
                            height: parent.height
                            checked: true
                            anchors.verticalCenter: parent.verticalCenter
                            indicator:  Rectangle {
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
                                y: Settings.isFullscreen ? -11 : -5
                                leftPadding: 30
                                text: "Mediathek"
                                font.pointSize: Settings.isFullscreen ? 20 : 14
                                color: Settings.blue80
                               // anchors.left : parent.left
                                wrapMode: Text.WordWrap
                            }
                        }

                        RadioButton {
                            id: buttonImport
                            width: parent.width / 2
                            height: parent.height
                            anchors.verticalCenter: parent.verticalCenter
                            indicator:  Rectangle {
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
                                                color: buttonImport.checked ? Settings.blue80 : "white"
                                            }
                            }
                            Text {
                                y: Settings.isFullscreen ? -11 : -5
                                leftPadding: 30
                                text: "Import"
                                font.pointSize: Settings.isFullscreen ? 20 : 14
                                color: Settings.blue80
                                //anchors.left : parent.left
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }
                // Right
                Rectangle {
                    id: rowRightRect
                    width: parent.width / 4
                    color: "transparent"
                    Row {
                        id: rowRight
                        width: parent.width
                        height: parent.height
                        anchors.left: parent.left
                        LayoutMirroring.enabled: true
                    }
                }
            }
		}
	}

}
