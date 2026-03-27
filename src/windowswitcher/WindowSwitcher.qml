import QtQuick 2.15
import QtQuick.Controls 2.15
import FileManager 1.0
import DVAGLogger 1.0
import "../settings"

ApplicationWindow {
	id: hoveringSwitcher
    x: Settings.twoScreensWidth / 2 - (width + 32)
    y: Settings.mainWindowHeight - (height + 20)
    width: 115 * 2 - 80
	height: 30
    title: "DVAG Presenter - WindowSwitcher"
    visible: false
	flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.NoFocus

	property FileManager fileManager: FileManager {}
    property bool setPowerPointVisibleOnce: false
    property bool clickIsBlocked: false
    property bool lastShowMain: false
    property int fullWidth: 0
    property int fullHeight: 0
    property bool ppt_screen: true

    color: "transparent"

    Component.onCompleted: {
        fileManager.dataDirContentDeleted.connect(switchToFullScreen)
        DVAGLogger.log("WindowSwitcher onCompleted")
    }

    GridView {
        flickableDirection: Flickable.AutoFlickDirection
        cellWidth: parent.width / 2
        cellHeight: parent.height

		Button {
			id: appSwitch
            width: 63 //hoveringSwitcher.width / 2 - 10
            height: 30
            clip: true

            //text: "Presenter/Office"
			onClicked: {
                if (clickIsBlocked) {
                    return
                }
                if (fileManager.isPowerPointVisible()) {
                     officeImg.source = "qrc:/images/toggle-neo.png"
                 } else {
                    officeImg.source = "qrc:/images/toggle-ppt.png"
                 }

                clickBlockingTimer.start()
                fileManager.setPowerPointVisible( !fileManager.isPowerPointVisible())

			}

            background: {
               radius: 25
            }

			Image {
				id: officeImg
                width: 63 //hoveringSwitcher.width / 2 - 10
                height: 30
				anchors.fill: parent
                source: "qrc:/images/toggle-ppt.png"
			}
		}

		Button {
			id: mcSwitch
            width: 51 //hoveringSwitcher.width / 2 - 10
            height: hoveringSwitcher.height
            clip: true

            x: hoveringSwitcher.width / 2 + 10
			//y: hoveringSwitcher.height / 2
            //text: "MediaControl/Office"
            onReleased: {
                mcImg.source = "qrc:/images/mediensteuerung.png"
            }
            onPressed: {
                mcImg.source = "qrc:/images/mediensteuerung-aktiv.png"
            }
            background: {
               radius: 25
            }
			onClicked: {
                if (clickIsBlocked) {
                    return
                }

                clickBlockingTimer.start()
                if (Settings.embeddedWindow.currentIndex !== 8) {
					Settings.embeddedWindow.currentIndex = 8
					Settings.lastIndex = 8
				} else {
					// Close the embeddedWindow
					Settings.embeddedWindow.currentIndex = 0
					Settings.lastIndex = 0
				}

			}

			Image {
				id: mcImg
                width: 51
                height: 30
				anchors.fill: parent
                source: "qrc:/images/mediensteuerung.png"

			}
		}
	}

    Timer {
        id: visibilityUpdate
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            visible = fileManager.isPowerPointRunning()
            var showMain = !fileManager.isPowerPointVisible() || ! visible;
            
            if( lastShowMain !== showMain ) {
                if ( showMain ) {
                    switchToFullScreen()
                } else {
                    hideApplicationWindow();
                }

                lastShowMain = showMain;
            }
        }
    }

    Timer {
        id: clickBlockingTimer
        interval: 100
        running: false
        repeat: false

        onRunningChanged: {
            if (running) {
                clickIsBlocked = true
            }
        }

        onTriggered: {
            clickIsBlocked = false
        }
    }

    function switchToFullScreen() {
        Settings.mainWindow.visible = true
        Settings.mainWindow.visibility = ApplicationWindow.Windowed
        Settings.mainWindow.flags = Qt.FramelessWindowHint
        Settings.mainWindow.width = Settings.twoScreensWidth
        Settings.mainWindow.height = Settings.mainWindowHeight
    }

    function hideApplicationWindow() {
        Settings.mainWindow.width = 0
        Settings.mainWindow.height = 0
        /*Settings.mainWindow.visible = false
        Settings.mainWindow.visibility = ApplicationWindow.Hidden
        Settings.mainWindow.flags = 0*/
    }
}
