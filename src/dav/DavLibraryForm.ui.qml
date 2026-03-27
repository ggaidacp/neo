import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"
import "../templates"

EmbeddedWindow {
	id: embeddedWindow

	property alias root: root

	// Header
	headerText: "Deutsche Akademie für Vermögensberatung"
	overviewButtonVisiblity: true

	// Content
	property alias gridView: gridView
	property alias scrollView: scrollView

	// Footer
	// Center
	property alias buttonVideos: buttonVideos
	property alias buttonPowerpoints: buttonPowerpoints
	property alias buttonDocuments: buttonDocuments
	property alias buttonEntertainment: buttonEntertainment
	// Right
	property alias buttonSearch: buttonSearch
	property alias buttonSearchIcon: buttonSearchIcon
	property alias buttonSearchStart: buttonSearchStart
	property alias buttonSearchStartIcon: buttonSearchStartIcon
	property alias searchField: searchField
	property alias busyIndicator: busyIndicator

	Column {
		id: root
		width: parent.width
		height: parent.height

		// Header
		Rectangle {
			width: embeddedWindow.width
			height: embeddedWindow.height / 30
			color: "transparent"
		}

		// Content
		Rectangle {
			width: embeddedWindow.width
			height: (embeddedWindow.height / 30) * 26
			color: "transparent"

			ScrollView {
				id: scrollView
				width: parent.width
				height: (parent.height / 8) * 7
				clip: true
				anchors.verticalCenter: parent.verticalCenter
				ScrollBar.vertical.policy: ScrollBar.AlwaysOn

				GridView {
					id: gridView
					width: parent.width
					height: parent.height
					cellWidth: gridView.width / 7
					cellHeight: gridView.height / 5
					//model: fileModel
					delegate: gridDelegate
				}
			}

			Text {
				id: folderEmptyText
				text: "Keine verfügbaren Dateien vorhanden"
				//visible: fileModel.count > 0 ? false : true
				visible: gridView.model.count > 0 ? false : true
				color: "black"
				font.pointSize: 20
				verticalAlignment: Text.AlignVCenter
				horizontalAlignment: Text.AlignHCenter
				anchors.centerIn: parent
			}
		}

		// Footer
		Rectangle {
			width: (embeddedWindow.width / 20) * 19
			height: (embeddedWindow.height / 30) * 3
			color: "transparent"
			anchors.horizontalCenter: parent.horizontalCenter

			// Center
			Row {
				id: rowCenter
				width: parent.width / 2
				height: parent.height
				spacing: width / 15
				anchors.centerIn: parent

				ButtonFilterEW {
					id: buttonVideos
					width: (parent.width / 15) * 3
					height: parent.height / 2
					isClicked: false
					text: "Videos"
					anchors.verticalCenter: parent.verticalCenter
				}

				ButtonFilterEW {
					id: buttonPowerpoints
					width: (parent.width / 15) * 3
					height: parent.height / 2
					isClicked: false
					text: "Powerpoints"
					anchors.verticalCenter: parent.verticalCenter
				}

				ButtonFilterEW {
					id: buttonDocuments
					width: (parent.width / 15) * 3
					height: parent.height / 2
					isClicked: false
					text: "Dokumente"
					anchors.verticalCenter: parent.verticalCenter
				}

				ButtonFilterEW {
					id: buttonEntertainment
					width: (parent.width / 15) * 3
					height: parent.height / 2
					isClicked: false
                    text: "Audio"
					anchors.verticalCenter: parent.verticalCenter
				}
			}

			// Right
			Row {
				id: rowRight
				width: parent.width / 4
				height: parent.height
				spacing: width / 18
				anchors.left: parent.left
				LayoutMirroring.enabled: true

				Row {
					id: search
					width: parent.width
					height: parent.height / 2
					anchors.verticalCenter: parent.verticalCenter
					LayoutMirroring.enabled: true

					Image {
						id: buttonSearchIcon
						width: parent.width / 6
						height: parent.height
						source: searchField.visible ? "qrc:/images/buttons/search_gold.png" : "qrc:/images/buttons/search.png"
						fillMode: Image.PreserveAspectFit
						mipmap: true

						MouseArea {
							id: buttonSearch
							width: parent.width
							height: parent.height
						}
					}

					Rectangle {
						width: parent.width / 18
						height: parent.height
						color: "transparent"
					}

					Rectangle {
						width: parent.width / 8
						height: parent.height / 1.1
						color: "white"
						border.color: "#8D8D8D"
						visible: searchField.visible ? true : false
						anchors.verticalCenter: parent.verticalCenter

						Image {
							id: buttonSearchStartIcon
							width: parent.width / 1.2
							height: parent.height / 1.2
							source: "qrc:/images/buttons/search_arrow.png"
							fillMode: Image.PreserveAspectFit
							mipmap: true
							anchors.centerIn: parent
						}

						MouseArea {
							id: buttonSearchStart
							width: parent.width
							height: parent.height
						}
					}

                    NeoTextField {
						id: searchField
						visible: false
						width: (parent.width / 6) * 3
						height: parent.height / 1.1
						anchors.verticalCenter: parent.verticalCenter
						font.pointSize: 15
						background: Rectangle {
							width: parent.width
							height: parent.height
							color: "white"
							opacity: 0.75
							border.color: "#8D8D8D"
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
			}
		}
	}
}
