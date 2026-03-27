import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"
import "../templates"
import FileManager 1.0

EmbeddedWindow {
	id: embeddedWindow

	property alias root: root

	// Header
	headerText: "USB Import"
	overviewButtonVisiblity: !popUpWindowVolumes.visible
    localsearchavailable: !popUpWindowVolumes.visible
    presentationModeVisibility: false
	// Content
	property alias gridView: gridView
	property alias scrollView: scrollView
    //property alias scrollBar: scrollBar

    // PopUpWindow Volume Selection
    property alias popUpWindowVolumes: popUpWindowVolumes
    // PopUpWindow Import Override
    property alias popUpWindowImportOverride: popUpWindowImportOverride
    // PopUpWindow Import Done
    property alias popUpWindowImportDone: popUpWindowImportDone
    // Search Prperties in header and Content
    // Search
    property alias localsearchField: localsearchField
    property alias searchfieldrow: searchfieldrow
    property alias buttonSearchIconInside: buttonSearchIconInside
    property alias busyIndicator: busyIndicator
	// Footer
	// Left
	property alias buttonBack: buttonBack
	property alias buttonBackIcon: buttonBackIcon
	property alias buttonForward: buttonForward
	property alias buttonForwardIcon: buttonForwardIcon
	// Center
	property alias buttonImport: buttonImport
    //property alias buttonStartBusy: buttonStartBusy

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
            color: "white"
            //y: 40
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
                        height: 48 //parent.height / 1.1
                        anchors.verticalCenter :  parent.verticalCenter
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

                    }

                }
                Rectangle {
                    width: parent.width
                    height: parent.height  - (localsearchField.visible ? localsearchField.height : 0)
                    color: "white"
                        ScrollView {
                            id: scrollView
                            width: parent.width - 60
                            height: parent.height - (localsearchField.visible ? localsearchField.height : 0)
                            clip: true
                            anchors.verticalCenter: parent.verticalCenter
                            //anchors.horizontalCenter:  parent.horizontalCenter
                            x: 70
                            topPadding: 30
                            ScrollBar.vertical.visible: false /*ScrollBar {
                                id: scrollBar
                                height: parent.height
                                anchors.right: parent.right
                                policy: ScrollBar.AsNeeded
                            }*/

                            GridView {
                                id: gridView
                                width: parent.width
                                height: parent.height
                                cellWidth: Settings.isFullscreen ? Settings.fileGridCellWidthFull : Settings.fileGridCellWidth
                                cellHeight: Settings.isFullscreen ? Settings.fileGridCellHeightFull :  Settings.fileGridCellHeight
                                model: (popUpWindowVolumes.visible) ? fileModelEmpty : fileModel
                                delegate: gridDelegate
                            }
                        }
                        Text {
                            id: folderEmptyText
                            text: "Keine verfügbaren Dateien vorhanden"
                            visible: fileModel.count > 0 || popUpWindowVolumes.visible ? false : true
                            color: "black"
                            font.pointSize: 20
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            anchors.centerIn: parent
                        }
                        BusyIndicator {
                            id: busyIndicator
                            width: 50
                            height: 50
                            running: false
                            visible: false
                            anchors.centerIn: parent

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

			// Left
			Row {
				id: rowLeft
				width: parent.width / 4
				height: parent.height
                spacing: 12
                leftPadding: 28
				anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
				Image {
					id: buttonBackIcon
                    width: 32
                    height: 32
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
                    width: 32
                    height: 32
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

			// Center
			ButtonEW {
				id: buttonImport
				width: (parent.width / 2) / 3
				height: parent.height / 2
				visible: popUpWindowVolumes.visible ? false : true
				text: "Import"
                backgroundColor: Settings.blue80
                textColor: "white"
				anchors.centerIn: parent
                onClicked: busyIndicator.visible = true
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

        text: "Bitte wählen Sie einen Import-Datenträger aus."
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
		id: popUpWindowImportOverride
        default_active: false
		visible: false
        anchors.centerIn : parent
	}


	/*
	  *
	  * PopUpWindow for the completed export
	  *
	*/
	PopUpWindowWithOneButton {
		id: popUpWindowImportDone

		textButton: "Ok"
		visible: false
		anchors.centerIn: parent
	}
}

/*##^## Designer {
	D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

