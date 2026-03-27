import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"
import "../templates"

EmbeddedWindow {
	id: embeddedWindow

	property alias root: root

	// Header
	headerText: "Screenshots"
	overviewButtonVisiblity: false
    presentationModeVisibility: false

	// Content
	property alias gridView: gridView
	property alias scrollView: scrollView
    property alias contentView: rect

	// Footer
	// Right
    /*property alias buttonSort: buttonSort
    property alias buttonSortIcon: buttonSortIcon*/
	property alias buttonDelete: buttonDelete
	property alias buttonDeleteIcon: buttonDeleteIcon

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
			id: rect
            width: embeddedWindow.width
            height: (embeddedWindow.height / 30) * 26
            color: "transparent"
            Rectangle { // roter Rahmen isPresentationMode
                width: parent.width - 4
                height: parent.height - 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                ScrollView {
                    id: scrollView
                    width: parent.width - 20
                    height: (parent.height / 8) * 7
                    contentWidth: rect.width
                    contentHeight: rect.height * 2
                    anchors.top: parent.top
                    clip: true
                    spacing: 10
                    rightPadding: 10
                    leftPadding: 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right:  parent.right
                    ScrollBar.vertical.visible: false
                    ScrollBar.horizontal.visible : false //   : ScrollBar.AsNeeded
                    GridView {
                        id: gridView
                        /*width: 390 //rect.width
                        height: 190 // rect.height / 2*/
                        cellWidth:  gridView.width / 6 //200//
                        cellHeight:  gridView.height / 4 //180
                        //bottomMargin: 5
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
        // Footer
        Rectangle {
            width: embeddedWindow.width
            height: Settings.embeddedWindowFooterHeight
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            SeparatorLine {}
			// Right
			Row {
				id: rowRight
				width: parent.width / 5
				height: parent.height
				spacing: width / 20
                rightPadding: 28
				anchors.left: parent.left
				LayoutMirroring.enabled: true

				Image {
					id: buttonDeleteIcon
                    width: 32 //parent.width / 6
                    height: 32 // parent.height / 2
                    source: "qrc:/images/buttons/delete_gold.png"
					fillMode: Image.PreserveAspectFit
					mipmap: true
					anchors.verticalCenter: parent.verticalCenter

					MouseArea {
						id: buttonDelete
						width: parent.width
						height: parent.height
					}
				}


			}
		}
	}
}
