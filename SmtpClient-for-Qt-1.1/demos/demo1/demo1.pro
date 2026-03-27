#-------------------------------------------------
#
# Project created by QtCreator 2014-10-30T22:48:32
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = demo1
TEMPLATE = app

SOURCES += \
    demo1.cpp \


# Location of SMTP Library
SMTP_LIBRARY_LOCATION = $$PWD/../../../build-SMTPEmail-Desktop_Qt_5_15_2_MSVC2015_64bit-Debug

win32:CONFIG(release, debug|release): LIBS += -L$$SMTP_LIBRARY_LOCATION/release/ -lSMTPEmail
else:win32:CONFIG(debug, debug|release): LIBS += -L$$SMTP_LIBRARY_LOCATION/debug/ -lSMTPEmail
else:unix: LIBS += -L$$SMTP_LIBRARY_LOCATION -lSMTPEmail

INCLUDEPATH += $$SMTP_LIBRARY_LOCATION
DEPENDPATH += $$SMTP_LIBRARY_LOCATION




