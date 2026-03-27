import QtQuick 2.11
import FileManager 1.0
import DVAGLogger 1.0
import QtWebEngine 1.8
import "../settings"
import "../templates"



MediaControlForm {
	id: mediaControlForm

    property FileManager filemanager: FileManager {}


   Component.onCompleted: {
        webengineview.url = filemanager.getSettingQString("URIs/MediaControl")
        DVAGLogger.log("ggi **************** MediaControlForm.completed")
    }


}
