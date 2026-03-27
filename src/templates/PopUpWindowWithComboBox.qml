import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"

PopUpWindow {
	id: popUpWindowWithComboBox

	headerText: ""
	width: Settings.embeddedWindowWidth / 3
    height: Settings.embeddedWindowHeight / 4

	property string text
	property string textButton: "Ok"
	property ListModel listModel
	// The text which should be shown should have the key "name"
	property int currentIndex: 0 // Set the index to the first element
	property string displayText
    property int buttonWidth: 183
    property int buttonHeight: 40
	// : comboBox.currentText
	signal buttonClicked
	signal comboBoxButtonClicked
	signal reloadClicked

	Column {
        width: parent.width - 20
        height: parent.height - 20
        anchors.centerIn: parent


		Rectangle {
			width: parent.width
			height: (parent.height / 10) * 9
			color: "transparent"

			Column {
				width: parent.width
				height: parent.height
				spacing: height / 8

				Text {
					id: popUpText
					width: (parent.width / 5) * 4
					height: (parent.height / 8) * 2
					text: popUpWindowWithComboBox.text
                    font.pointSize: 14
                    color: "#337A96"
					wrapMode: Text.WordWrap
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
					anchors.horizontalCenter: parent.horizontalCenter
				}

				Row {
					id: row
					width: (parent.width / 5) * 4
                    height: (parent.height / 8) * 2
					anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10

					ComboBox {
						id: comboBox
						width: (parent.width / 6) * 5
						height: parent.height
						font.pointSize: 12
						displayText: popUpWindowWithComboBox.displayText
						currentIndex: popUpWindowWithComboBox.currentIndex
						model: popUpWindowWithComboBox.listModel
						popup: Popup {
							y: parent.height
							width: parent.width
							height: contentItem.implicitHeight
							topPadding: 0
							bottomPadding: 0
							contentItem: ListView {
								id: listView
								model: popUpWindowWithComboBox.listModel
								delegate: listDelegate
								implicitHeight: contentHeight
							}
							background: Rectangle {
								width: parent.width
								height: parent.height
								color: "#DDDDDD"
							}
							onClosed: {
								// Show the currently selected item
								displayText = listModel.get(currentIndex).name
							}
						}
					}

					Rectangle {
						id: buttonReload
						width: (parent.width / 6) - row.spacing
						height: parent.height
                        color: "transparent"
                        border.color: "#337A96"
						radius: 5

						Image {
							id: img
							width: parent.width
							height: parent.height
							source: "qrc:/images/buttons/reload.png"
							fillMode: Image.PreserveAspectFit

							MouseArea {
								width: parent.width
								height: parent.height
								onClicked: {
									reloadClicked()
									// Show the currently selected item
									displayText = listModel.get(
												currentIndex).name
								}
								onPressed: {
                                    //buttonReload.color = "#337A96"
									img.source = "qrc:/images/buttons/reload_gold.png"
								}
								onReleased: {
                                    //buttonReload.color = "white"
									img.source = "qrc:/images/buttons/reload.png"
								}
							}
						}
                    }
				}
                Rectangle {
                      width: parent.width // Adjust width as needed
                      height: 1
                      color: "#337A96"

                }
				ButtonEW {
					id: popUpButton
                    width: buttonWidth//parent.width / 3
                    height: buttonHeight // parent.height / 6
					text: popUpWindowWithComboBox.textButton
					anchors.horizontalCenter: parent.horizontalCenter
                    backgroundColor: Settings.blue80
                    textColor: "white"
					onClicked: {
						buttonClicked()
						popUpWindowWithComboBox.visible = false
					}
				}
			}
		}
	}

	Component.onCompleted: {
		displayText = listModel.get(currentIndex).name
        //closeImg.visible = false
	}


	/*
	  *
	  * Delegate for the listView
	  *
	*/
	Component {
		id: listDelegate

		Item {
			width: parent.width
			height: textList.paintedHeight + 25

			MouseArea {
				width: parent.width
				height: parent.height
				onClicked: {
					popUpWindowWithComboBox.currentIndex = index
					comboBox.popup.close()
				}
			}

			Text {
				id: textList
				width: parent.width
				height: parent.height
				text: name // Shows the value of the key "name" from the listModel
                font.pointSize: 12
				color: "black"
				wrapMode: Text.WrapAtWordBoundaryOrAnywhere
				verticalAlignment: Text.AlignVCenter
			}
		}
	}
}
