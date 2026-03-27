import QtQuick 2.11
import "../templates"

EmbeddedWindow {
	id: embeddedWindow

	// Header
	headerText: "Deutsche Akademie für Vermögensberatung"

	// Content
	property alias ma_img1: ma_img1
	property alias ma_img2: ma_img2
	property alias ma_img3: ma_img3
	property alias ma_img4: ma_img4

	Column {
		width: parent.width
		height: parent.height

		Rectangle {
			width: embeddedWindow.width
			height: embeddedWindow.height / 30
			color: "transparent"
		}

		Row {
			id: row
			width: (parent.width / 10) * 8
			height: (parent.height / 30) * 26
			spacing: row.width / 9
			anchors.horizontalCenter: parent.horizontalCenter

			Column {
				id: column1
				width: (parent.width / 9) * 4
				height: (parent.height / 10) * 7
				spacing: column1.width / 7
				anchors.verticalCenter: parent.verticalCenter

				Image {
					width: parent.width
					height: (parent.height / 7) * 3
					source: "qrc:/images/dav/existensgruender.png"
					fillMode: Image.PreserveAspectFit

					MouseArea {
						id: ma_img1
						width: parent.width
						height: parent.height
					}
				}

				Image {
					width: parent.width
					height: (parent.height / 7) * 3
					source: "qrc:/images/dav/weiterbildung.png"
					fillMode: Image.PreserveAspectFit

					MouseArea {
						id: ma_img3
						width: parent.width
						height: parent.height
					}
				}
			}

			Column {
				id: column2
				width: (parent.width / 9) * 4
				height: (parent.height / 10) * 7
				spacing: column2.width / 7
				anchors.verticalCenter: parent.verticalCenter

				Image {
					width: parent.width
					height: (parent.height / 7) * 3
					source: "qrc:/images/dav/ausbildung.png"
					fillMode: Image.PreserveAspectFit

					MouseArea {
						id: ma_img2
						width: parent.width
						height: parent.height
					}
				}

				Image {
					width: parent.width
					height: (parent.height / 7) * 3
					source: "qrc:/images/dav/fuehrungsausbildung.png"
					fillMode: Image.PreserveAspectFit

					MouseArea {
						id: ma_img4
						width: parent.width
						height: parent.height
					}
				}
			}
		}
	}
}
