import QtQuick 2.4

ScreenshotViewForm {

    onOverviewClicked: {
        Settings.loaderNewWindow.visible = false
        Settings.loaderNewWindow.source = ""
        Settings.contentArea = Settings.embeddedWindow
        if (Settings.loaderNewWindow.visible) {
            Settings.loaderNewWindow.visible = false
            Settings.loaderNewWindow.source = ""
        } else if (Settings.loader2.visible) {
            Settings.loader2.source = "qrc:/src/dav/DavLibrary.qml"
        } else if (Settings.loader3.visible) {
            Settings.loader3.source = "qrc:/src/medialibrary/MediaLibrary.qml"
        } else if (Settings.loader4.visible) {
            Settings.loader4.source = "qrc:/src/onlineplatform/OnlinePlatform.qml"
        } else if (Settings.loader6.visible) {
            Settings.loader6.source = "qrc:/src/screenshots/Screenshots.qml"
        } else if (Settings.loader9.visible) {
            Settings.loader9.source = "qrc:/src/mainwindow/GlobalSearch.qml"
        }
    }

}
