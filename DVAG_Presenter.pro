QT += core quick widgets multimedia virtualkeyboard webenginecore webenginewidgets webview

# Definieren Sie die Versionsnummer
VERSION = 2.3.0.7

# Fügen Sie die Versionsnummer zu den DEFINES hinzu, um sie im Code verfügbar zu machen
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
#webengine
static {
    QT += svg
    QTPLUGIN += qtvirtualkeyboardplugin
}
win32: {
        COMPILER_VERSION = MSVC2019
#        COMPILER_VERSION = MinGW
} else {
        COMPILER_VERSION = GCC
}

#CONFIG -= debug
#CONFIG -= release

contains(CONFIG, "dbg"): {
    RELEASE = debug
    CONFIG += debug
    RELEASE_SUBDIR = Debug
} else: {
    RELEASE = release
    CONFIG += release
    RELEASE_SUBDIR = Release
}

message("Building "$$RELEASE" version.")

#CONFIG(release, debug|release) {
##    CONFIG += qtquickcompiler
#	RELEASE_SUBDIR = Release
#}

#CONFIG(debug, debug|release) {
#	DEFINES += DEBUG
#	RELEASE_SUBDIR = Debug
#}

CONFIG += c++17 resources_big multi_touch 


# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

HEADERS += \
	$$files(*.h) \
    AppInfo.h \
    app_environment.h \
    customwebenginepage.h \
    graphclient.h \
    neomanager.h \
    noauthinterceptor.h

SOURCES += \
	$$files(*.cpp) \
	graphclient.cpp
        #DownloadManager.h
          #mailclient.cpp

RESOURCES += \
	qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
#QML_IMPORT_PATH = C:\Qt515\5.15.2\msvc2015_64\qml
QML_IMPORT_PATH = C:\Qt5\6.7.1\msvc2019_64\qml

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

message(QMAKE_TARGET.arch)
!contains(QMAKE_TARGET.arch, x86_64) {
	win32: {
		message("x86 build")
		BITNESS = 32
	} else {
		message("x86_64 build")
		BITNESS = 64
	}
} else {
	message("x86_64 build")
	BITNESS = 64
}

COMPILER_TYPE = "$${COMPILER_VERSION}_$${BITNESS}bit"
#COMPILER_TYPE = "$${COMPILER_VERSION}_$${BITNESS}_bit2"

#INCLUDEPATH += C:/Qt5/6.7.1/msvc2019_64/include/
INCLUDEPATH += $$PWD/include/
#DEPENDPATH +=  $$PWD/lib/

win32 {
	RC_ICONS += images/icon.ico
	LIBS += -luser32 -lshell32 -lmsi
}
LIBS += -ldbghelp


DISTFILES += \
	$$files(*.qml, true) \
        $$files(bin/*, true) \
        #../build-SMTPEmail-Desktop_Qt_5_15_2_MSVC2015_64bit-Release/release/SMTPEmail.lib \
    ../../../../../Qt5/6.7.1/msvc2019_64/qml/QtQuick/VirtualKeyboard/Styles/neokeys/style.qml \
    src/ControlsDelegates_lnk/TouchHandle.qml \
    src/ControlsDelegates_lnk/TouchSelectionMenu.qml \
    src/ControlsDelegates_lnk/qtwebenginequickdelegatesplugin.dll \
    ../../../../../Qt5/6.7.1/msvc2019_64/bin/Qt6WebEngineQuickDelegatesQml.dll \
    src/Styles - Verknüpfung.lnk/KeyIcon.qml \
    src/Styles - Verknüpfung.lnk/KeyPanel.qml \
    src/Styles - Verknüpfung.lnk/KeyboardStyle.qml \
    src/Styles - Verknüpfung.lnk/SelectionListItem.qml \
    src/Styles - Verknüpfung.lnk/TraceCanvas.qml \
    src/Styles - Verknüpfung.lnk/TraceInputKeyPanel.qml \
    src/Styles - Verknüpfung.lnk/TraceUtils.js \
    src/Styles - Verknüpfung.lnk/plugins.qmltypes \
    src/Styles - Verknüpfung.lnk/qmldir \
    src/Styles - Verknüpfung.lnk/qtvkbstylesplugin.dll \
    src/Styles - Verknüpfung.lnk/qtvkbstylesplugin.pdb \
    src/Styles - Verknüpfung.lnk/qtvkbstylesplugind.dll \
    src/Styles - Verknüpfung.lnk/qtvkbstylesplugind.pdb \
    src/templates/NeoFilenameBox.qml


OTHER_FILES += \
        #./SmtpClient-for-Qt-1.1/SMTPEmail.pro \
        $$files(images/*, true) \
        $$files(data/*, true) \
        $$files(scripts/*) \
	$$files(lib/*, true) \
	$$files(*.h, true) \
	$$files(*.cpp, true) \
	$$files(*.txt, true) \

FORMS +=



