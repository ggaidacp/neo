import QtQuick 2.11
import "../settings"

DavForm {

	ma_img1.onClicked: {
		Settings.davNumber = 1
		Settings.loader2.source = "qrc:/src/dav/DavLibrary.qml"
	}

	ma_img2.onClicked: {
		Settings.davNumber = 2
		Settings.loader2.source = "qrc:/src/dav/DavLibrary.qml"
	}

	ma_img3.onClicked: {
		Settings.davNumber = 3
		Settings.loader2.source = "qrc:/src/dav/DavLibrary.qml"
	}

	ma_img4.onClicked: {
		Settings.davNumber = 4
		Settings.loader2.source = "qrc:/src/dav/DavLibrary.qml"
	}
}
