import QtQuick 2.15

Item {
	id: buttonMainWindow
    width: (parent.width / 5) * 4
	height: parent.height / 6
    //anchors.horizontalCenter: parent.horizontalCenter

	property bool isClicked: false
	property string sourceEmbeddedWindow
	signal clicked
	property string imgSource
	property string textButton
    property string backgroundColor: "white"
	property string textColor: "black"

	Rectangle {
		id: button
        width: 223 //parent.width
        height: 148 //parent.height
        //color: "transparent" //buttonMainWindow.backgroundColor
        radius: 6
        //opacity: 0.75

		MouseArea {
			id: mouseArea
			width: parent.width
			height: parent.height
			onClicked: {
				buttonMainWindow.clicked()
			}
		}
        Image {
            id: icon
            source: buttonMainWindow.imgSource
            //fillMode: Image.PreserveAspectFit
            //fillMode: Image.Stretch
            /*anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter:  parent.verticalCenter*/
        }

	}
}
