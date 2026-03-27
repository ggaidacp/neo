import QtQuick 2.15
import DVAGLogger 1.0
import "../settings"

Item {
	id: linkIcon
	width: parent.width
	height: parent.height
	property string text
    property string link
    property int rectWidth: (((linkIcon.width / 5) * 4)
                             > ((linkIcon.height / 5) * 4)) ? ((linkIcon.height / 5) * 4) : ((linkIcon.width / 5) * 4)
    property int rectHeight: (((linkIcon.width / 5) * 4)
                              > ((linkIcon.height / 5) * 4)) ? ((linkIcon.height / 5) * 4) : ((linkIcon.width / 5) * 4)
    property int columnWidth: linkIcon.width
    property int columnHeight: linkIcon.height
	property string imgSource
	property string backgroundColor: "transparent"
    property string borderColor : "transparent"
    property int borderWidth : 0
    property int borderRadius : 0


    /*onTextChanged: {
        DVAGLogger.log("text = " + linkIcon.text)
    }

    onLinkChanged: {
        DVAGLogger.log("link = " + linkIcon.link)
    }

    onImgSourceChanged: {
        DVAGLogger.log("imgSource = " + linkIcon.imgSource)
    }*/

    Column {
		id: column
		width: linkIcon.columnWidth
		height: linkIcon.columnHeight
		anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: rect
            width: linkIcon.rectWidth
            height: linkIcon.rectHeight
            color: linkIcon.backgroundColor
            border.color: borderColor
            border.width: borderWidth
            radius: borderRadius
//            anchors.centerIn: parent
            anchors.horizontalCenter: parent.horizontalCenter
            y: 0

            Image {
                id: img
                width: parent.width - (parent.border.width * 8)
                height: parent.height - (parent.border.width * 8)
                clip: true
                source: linkIcon.imgSource
                fillMode: Image.PreserveAspectFit
                mipmap: true
                anchors.centerIn: parent
            }

            MouseArea {
                id: ma
                width: parent.width
                height: parent.height
                onClicked: {
                    //DVAGLogger.log("Opening Webpage: " + linkIcon.link)
                    if (linkIcon.link === "") return
                    Settings.url = linkIcon.link
                    openWebview()
                }
            }
        }

        Text {
            id: textElm
            width: linkIcon.width
            height: linkIcon.height / 5 - 10
            y: rect.height
            text: linkIcon.text
            font.pointSize: Settings.isFullscreen ? 17 : 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }


	}


	/*
	  *
	  * Functions
	  *
	*/
	function openWebview() {
		Settings.loader4.source = "qrc:/src/onlineplatform/WebViewPage.qml"
	}
}
