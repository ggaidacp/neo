import QtQuick 2.15
import QtWebEngine 6.7
import FileManager 1.0
import DVAGLogger 1.0
import "../settings"
import "../templates"


OnlinePlatformForm {
	// Counter
	property int i: 0
	property int j: 0

	Component.onCompleted: {
        loadContent()
        DVAGLogger.log("Online Content geladen")
        //searchIconArea.clicked.connect(startSearch())
        Settings.contentArea = scrollView

    }
    // Second screen
    Connections {
        target: Settings.embeddedWindow
        onCurrentIndexChanged: {

            if (Settings.embeddedWindow.currentIndex === 4) {
                // Used for the second screen view
                Settings.contentArea = scrollView
                DVAGLogger.log("*********** CurrentIndex = " + Settings.embeddedWindow.currentIndex)
                //Settings.contentAreaEditMode = laserPointerArea
            }
        }
    }
    onVisibleChanged: {
        if (visible) {
            Settings.isPresentationMode = presentationModeVisibility
        } else {

        }
        loadContent()
    }

    urlField.onEnterPressed: startSearch()
    searchIconArea.onClicked: startSearch()

    function startSearch() {

        if (urlField.displayText.startsWith("http://") || urlField.displayText.startsWith("https://")) {
            Settings.url = urlField.displayText
        } else {
            Settings.url = "https://" + urlField.displayText
        }

        Settings.loader4.source = "qrc:/src/onlineplatform/WebViewPage.qml"
        DVAGLogger.log("Search icon clicked!")

    }




    function handleEnterPressed(text) {
        startSearch()
        DVAGLogger.log("Search icon clicked!")

    }



    function loadContent() {
        //DVAGLogger.log("onlineplatforms: Component.onCompleted:")
        // Get the content for the "LinkIcons" from the json
        var obj
        var bp = fileManager.getDataDir() + "/"
        //DVAGLogger.log("GGI Icon Pfad " + bp )
        var onlinePlatforms = fileManager.readOnlinePlatformsJson()
        //DVAGLogger.log("GGI Online Platformen Anzahl =  " + onlinePlatforms.length )
        if (onlinePlatforms.length > 0) {
            intranetModel.clear()
            socialMediaModel.clear()
            partnersModel.clear()
            for (i = 0; i < onlinePlatforms.length; i += 4) {
                if (onlinePlatforms[i] === "intranet") {
                    obj = {
                                                    "name": onlinePlatforms[i + 1],
                                                    "url": onlinePlatforms[i + 2],
                                                    "icon": bp + onlinePlatforms[i + 3]
                                                }
                    //DVAGLogger.log("GGI Icon Pfad " + bp + onlinePlatforms[i + 3])//JSON.stringify(obj))

                    intranetModel.append(obj)
                }
                if (onlinePlatforms[i] === "socialmedia") {
                    obj = {
                                                    "name": onlinePlatforms[i + 1],
                                                    "url": onlinePlatforms[i + 2],
                                                    "icon": bp + onlinePlatforms[i + 3]
                                                }
                    //DVAGLogger.log(JSON.stringify(obj))
                    socialMediaModel.append(obj)
                }
                if (onlinePlatforms[i] === "partners") {
                    obj = {
                                                    "name": onlinePlatforms[i + 1],
                                                    "url": onlinePlatforms[i + 2],
                                                    "icon": bp + onlinePlatforms[i + 3]
                                                }
                    //DVAGLogger.log(JSON.stringify(obj))
                    partnersModel.append(obj)
                }
               /* if (onlinePlatforms[i] === "headlines") {
                   // DVAGLogger.log("GGI headlines " + JSON.stringify(onlinePlatforms[i]))

                    intranetTitle.text = onlinePlatforms[i + 1]

                    //DVAGLogger.log("GGI headlines " + JSON.stringify(onlinePlatforms[i+1]))

                    socialMediaTitle.text = onlinePlatforms[i + 2]
                   // DVAGLogger.log("GGI headlines " + JSON.stringify(onlinePlatforms[i+2]))
                    partnersTitle.text = onlinePlatforms[i + 3]
                   // DVAGLogger.log("GGI headlines " + JSON.stringify(onlinePlatforms[i+3]))
                }
                if (onlinePlatforms[i] === "headline2") {
                }*/
            }
		}

        intranetTitle.text = "Unsere Webseiten"
        socialMediaTitle.text = "Die Deutsche Vermögensberatung auf Social Media"
        partnersTitle.text = "Link zu Partnerseiten"

        intranetGrid.update()
        socialMediaGrid.update()
        partnersGrid.update()
    }



	FileManager {
		id: fileManager
	}


    // Stores the online platforms
    ListModel {
        id: intranetModel
    }

    // Stores the online platforms
    ListModel {
        id: socialMediaModel
    }

    // Stores the online platforms
    ListModel {
        id: partnersModel
    }



    Component {
        id: intranetDelegate

        LinkIcon {
            width: (Settings.embeddedWindow != undefined) ? Settings.embeddedWindow.width / 7 + 6 : 0
            height: width
            rectWidth: 120 //width * 0.5
            rectHeight: 120 //rectWidth
//            columnWidth: Settings.embeddedWindow.width / 7
//            columnHeight: columnWidth
            text: name
            link: url
            imgSource: "file:///" + icon
        }
    }

    Component {
        id: socialMediaDelegate

        LinkIcon {
            width: (Settings.embeddedWindow != undefined) ? Settings.embeddedWindow.width / 11 : 0
            height: width
            rectWidth: 80//width * 0.48
            rectHeight: 80 //rectWidth
//            columnWidth: Settings.embeddedWindow.width / 11
//            columnHeight: columnWidth
            text: name
            link: url
            imgSource: "file:///" + icon
        }
    }

    Component {
        id: partnersDelegate

        LinkIcon {
            id: li
            width: (Settings.embeddedWindow != undefined) ? Settings.embeddedWindow.width / 7 : 0
            height: li.width
            rectWidth: 120 //width * 0.5
            rectHeight: 120 //rectWidth
            borderRadius: 0 //Settings.isFullscreen ? 75 : 50
            borderWidth: 0
            borderColor: Settings.blue80
            //text: name
            link: url
            imgSource: "file:///" + icon

        }
    }


	/*
	  *
	  * Functions
	  *
	*/
	// Retrun the qml object by id
	function findItembyId(id) {
		return idMap[id]
	}


}
