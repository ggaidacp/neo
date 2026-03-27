import QtQuick 2.15
import GraphClient 1.0
import FileManager 1.0
import DVAGLogger 1.0
import "../settings"

EmailForm {
	id: emailForm
	// Stores the delegate for the emailList
	property alias emailListDelegate: emailListDelegate
	property GraphClient graphclient: GraphClient {}
	property FileManager filemanager: FileManager {}
	property bool isValid: true
	property var emailList: []

	function updateStatus() {
		var mb = Math.floor(Settings.attachmentsSize / 1000000)
		var tkb = Math.floor(Settings.attachmentsSize / 10000 - mb * 100)
		var out = " " + mb + "," + tkb
		if (Settings.attachmentsSize <= filemanager.getSettingInt(
					"E-Mail/MaxSize")) {
			statusLine.text = "Größe der Anhänge:" + out + "MB"
		} else {
			statusLine.text = "Größe der Anhänge:" + out
					+ "MB - MAXIMALGRÖßE ÜBERSCHRITTEN! SENDEN NICHT MÖGLICH!"
		}
	}

	function initStatus() {
		var mb = Math.floor(Settings.attachmentsSize / 1000000)
		var tkb = Math.floor(Settings.attachmentsSize / 10000 - mb * 100)
		var out = " " + mb + "," + tkb
		statusLine.text = "Größe der Anhänge:" + out + "MB"
		inputTo.text = ""
		inputBody.text = ""
		inputSubject.text = ""
	}

	function showError() {
		statusLine.text = graphclient.getLastError()
	}

	function showGraphStatus() {
		statusLine.text = graphclient.getLastError()
		inputTo.text = ""
		inputSubject.text = ""
		inputBody.text = ""
		Settings.attachmentsModel.clear()
		Settings.isComposingEmail = false
		Settings.embeddedWindow.currentIndex = 0
		Settings.lastIndex = 10
		initStatus()
	}
	onVisibleChanged: {
		if (visible) {
			//Settings.isPresentationMode = presentationModeVisibility
		} else {

		}
	}
	/*
	  *
	  * Delegate for the email listView
	  *
	*/
	Component {
		id: emailListDelegate

		MouseArea {
			width: parent.width
			height: textEmailList.paintedHeight + 40
			onClicked: {
				listViewEmail.currentIndex = index
				Settings.attachmentsModel.remove(listViewEmail.currentIndex)
			}

			Row {
				id: emailRow
				width: parent.width
				height: parent.height

				Image {
					width: parent.width / 5
					height: (parent.height / 5) * 4
					source: "qrc:/images/fileicons/" + type + ".png"
					fillMode: Image.PreserveAspectFit
                    mipmap: true
					anchors.verticalCenter: parent.verticalCenter
				}

				Text {
					id: textEmailList
					width: (parent.width / 5) * 3.5
					height: parent.height
					text: name
					font.pointSize: 12
                    font.family: Settings.defaultFont
					color: "black"
					clip: true
					verticalAlignment: Text.AlignVCenter
				}

				Image {
					width: (parent.width / 5) * 0.5
					height: (parent.height / 5) * 4
					source: "qrc:/images/close.png"
					fillMode: Image.PreserveAspectFit
					mipmap: true
					anchors.verticalCenter: parent.verticalCenter
				}
			}
		}
	}

	Component.onCompleted: {
		Settings.emailForm = emailForm
        Settings.contentArea = contentView
		updateStatus()
		graphclient.errorOccurred.connect(showError)
		graphclient.tokenReceived.connect(sendGraphMail)
		graphclient.mailSent.connect(showGraphStatus)
	}

    // second screen
    Connections {
        target: Settings.embeddedWindow
        onCurrentIndexChanged: {
            if (Settings.embeddedWindow.currentIndex === 11) {
                // Used for the second screen view
                Settings.contentArea = contentView
            }
        }
    }

	buttonSend.onClicked: {
		updateStatus()
		DVAGLogger.log("authentifiziere dich bei Graph!")
		if (validateInputTo() === true) {
			graphclient.authenticate()
		} else {
			DVAGLogger.log("dies sein nicht valide " + inputTo.text)
			statusLine.text = "Keine gültige Email-Adresse!"
		}

	}
	inputTo.onTextChanged: // Wird bei jeder Änderung ausgelöst
	{
		updateStatus()
		return validateInputTo()

	}
	function validateInputTo() {
		emailList = inputTo.text.split(/[\s;]+/).filter(e => e.length > 0)

	   // Validierung jeder Email-Adresse
		isValid = emailList.every(function(address) {
		   // einfache RFC-5322-kompatible Regex (für Praxis ausreichend)
		   var res = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(address)
		   DVAGLogger.log("RegEx von " + address + " ist " + res)
		   if (res) {
			   buttonSend.backgroundColor = "#337A96"
			   buttonSend.textColor = "white"
			} else {
			   buttonSend.backgroundColor =  "white"
			   buttonSend.textColor = "#337A96"
		   }

		   return res
	   })
		return isValid

	}

	function attachmentsToArray() {
		var attachments = ""
		var i
		for (i = 0; i < Settings.attachmentsModel.count; i++) {
			DVAGLogger.log(JSON.stringify(Settings.attachmentsModel.get(i)))
			if (i > 0) attachments += ";"
			if (Settings.attachmentsModel.get(i).type !== "web") {

				attachments += Settings.attachmentsModel.get(i).path + "/" + Settings.attachmentsModel.get(i).name
			} else {
				attachments += filemanager.getTempDir() + "/" + Settings.attachmentsModel.get(i).name + ".url"
			}
		}
		return attachments
	}

	function sendGraphMail(token) {
		var att = attachmentsToArray().split(";")
		statusLine.text = "Sende Email ..."
		DVAGLogger.log("sende Email via Graph!")
		graphclient.sendMail(inputTo.text.split(";"), inputSubject.text,inputBody.text, att)

	}

	buttonAttachments.onClicked: {
		Settings.isComposingEmail = true
		Settings.embeddedWindow.currentIndex = 10
		Settings.lastIndex = 11
		Settings.contentArea = Settings.exportForm
	}

	Timer {
		id: statusTimer
		interval: 5000
		onTriggered: {
			updateStatus()
		}
	}
}
