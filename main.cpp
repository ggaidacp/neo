/**
 Version 1.0.1
*/
#include <QApplication>
#include <QLoggingCategory>
#include <QQmlApplicationEngine>
#include <QQuickItem>
#include <QSettings>
#include <QSharedMemory>
#include <QTimer>
#include <QMessageBox>
#include <QQmlContext>
#include "dvaglogger.h"
#include "filemanager.h"
#include "filemetadata.h"
#include "graphclient.h"
#include "neomanager.h"
#include "downloadmanager.h"
#include "AppInfo.h"
#include "app_environment.h"
#include <QtWebView>
#include <QWebEngineView>
#include <QWebEnginePage>
#include <QWebEngineCertificateError>
#include <QQmlContext>
#include <QWebEngineProfile>
#include <QSslConfiguration>
#include <QGestureEvent>
#include "customwebenginepage.h"

#include <dbghelp.h>


// Dump-Datei erstellen
LONG WINAPI CrashHandler(EXCEPTION_POINTERS* ExceptionInfo) {
    HANDLE hFile = CreateFile(L"crashdump.dmp", GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile != INVALID_HANDLE_VALUE) {
        MINIDUMP_EXCEPTION_INFORMATION dumpInfo;
        dumpInfo.ThreadId = GetCurrentThreadId();
        dumpInfo.ExceptionPointers = ExceptionInfo;
        dumpInfo.ClientPointers = FALSE;

        MiniDumpWriteDump(GetCurrentProcess(), GetCurrentProcessId(), hFile,
                          MiniDumpNormal, &dumpInfo, NULL, NULL);

        CloseHandle(hFile);
    }

    // Zusätzlich ins Log schreiben
    QFile f("crash.log");
    if (f.open(QIODevice::WriteOnly | QIODevice::Append)) {
        QTextStream ts(&f);
        ts << QDateTime::currentDateTime().toString()
           << " - Crash at address: " << ExceptionInfo->ExceptionRecord->ExceptionAddress
           << "\n";
    }
    NeoManager::restartApplication();
    return EXCEPTION_EXECUTE_HANDLER;
}

void initSettings(int argc, char* argv[])
{

#ifdef WIN32
    QSettings settings("HKEY_CURRENT_USER\\Software\\Unit 08\\DVAG Presenter", QSettings::Registry64Format);
    settings.setDefaultFormat(QSettings::Registry64Format);
#else
    QSettings settings("HKEY_CURRENT_USER\\Software\\Unit 08\\DVAG Presenter", QSettings::NativeFormat);
    settings.setDefaultFormat(QSettings::NativeFormat);
#endif
    settings.setFallbacksEnabled(false);
    settings.sync();
    DVAGLogger::getInstance()->setEnabled(false);
    QString arg1 = QString(argv[1]);

    for (int p = 1; p < argc; p++) {
        if (QString(argv[p]) == "--cfginit") {
            DVAGLogger::getInstance()->log(QString("Initializing Registry..."));
            settings.setValue("PIN", "1234");
            //settings.setValue("E-Mail/SMTP/User", "");
            settings.setValue("E-Mail/MaxSize", 5 * 1024 * 1024);
            settings.setValue("URIs/MediaControl", "qrc:/images/mediacontroldummy.jpg");
            settings.setValue("URIs/NextCloud", "https://dvag.de");
            settings.setValue("Background/Left", FileManager::getDataDir() + "/background1.jpg");
            settings.setValue("Background/Right", FileManager::getDataDir() + "/background2.jpg");

            if (QFile::exists("C:\\Program Files\\Microsoft Office\\root\\Office16\\POWERPNT.EXE")) {
                settings.setValue("Applications/PowerPoint","C:\\Program Files\\Microsoft Office\\root\\Office16\\POWERPNT.EXE");
                DVAGLogger::getInstance()->log("Powerpoint in settings eingetragen2!");
            }
            else if (QFile::exists("C:\\Program Files (x86)\\Microsoft Office\\Office16\\POWERPNT.EXE"))
                settings
                    .setValue("Applications/PowerPoint",
                              "C:\\Program Files (x86)\\Microsoft Office\\Office16\\POWERPNT.EXE");
            else if (QFile::exists(
                         "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\POWERPNT.EXE"))
                settings.setValue(
                    "Applications/PowerPoint",
                    "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\POWERPNT.EXE");
            else
                settings.setValue("Applications/PowerPoint",
                                  "NOT FOUND! MANUAL PATH ENTRY REQUIRED!");

            if (QFile::exists("C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE"))
                settings
                    .setValue("Applications/Word",
                              "C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE");
            else if (QFile::exists(
                         "C:\\Program Files (x86)\\Microsoft Office\\Office16\\WINWORD.EXE"))
                settings
                    .setValue("Applications/Word",
                              "C:\\Program Files (x86)\\Microsoft Office\\Office16\\WINWORD.EXE");
            else if (QFile::exists(
                         "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\WINWORD.EXE"))
                settings.setValue(
                    "Applications/Word",
                    "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\WINWORD.EXE");
            else
                settings.setValue("Applications/Word", "NOT FOUND! MANUAL PATH ENTRY REQUIRED!");

            if (QFile::exists("C:\\Program Files\\Microsoft Office\\root\\Office16\\EXCEL.EXE"))
                settings.setValue("Applications/Excel","C:\\Program Files\\Microsoft Office\\root\\Office16\\EXCEL.EXE");
            else if (QFile::exists(
                         "C:\\Program Files (x86)\\Microsoft Office\\Office16\\EXCEL.EXE"))
                settings.setValue("Applications/Excel",
                                  "C:\\Program Files (x86)\\Microsoft Office\\Office16\\EXCEL.EXE");
            else if (QFile::exists(
                         "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\EXCEL.EXE"))
                settings.setValue(
                    "Applications/Excel",
                    "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\EXCEL.EXE");
            else
                settings.setValue("Applications/Excel", "NOT FOUND! MANUAL PATH ENTRY REQUIRED!");
        }
        if (QString(argv[p]) == "--logfile") {
            DVAGLogger::getInstance()->setEnabled(true);
            if (p <= argc - 1) {
                DVAGLogger::getInstance()->setLogfile(QString(argv[p + 1]));
            }
        }
       /* if (QString(argv[p]) == "--osk") {
                qputenv("QT_VIRTUALKEYBOARD_STYLE", (argv[p + 1]));
        }*/

    }
    //DVAGLogger::getInstance()->log(QString("E-Mail/SMTP/User: ").append(settings.value("E-Mail/SMTP/User").toString()));
    DVAGLogger::getInstance()->log(QString("E-Mail/MaxSize: ").append(settings.value("E-Mail/MaxSize").toChar()));
    DVAGLogger::getInstance()->log(QString("URIs/MediaControl: ").append(settings.value("URIs/MediaControl").toString()));
    DVAGLogger::getInstance()->log(QString("URIs/NextCloud: ").append(settings.value("URIs/NextCloud").toString()));
    DVAGLogger::getInstance()->log(QString("Background/Left: ").append(settings.value("Background/Left").toString()));
    DVAGLogger::getInstance()->log(QString("Background/Right: ").append(settings.value("Background/Right").toString()));
    DVAGLogger::getInstance()->log(QString("Applications/PowerPoint: ").append(settings.value("Applications/PowerPoint").toString()));
    DVAGLogger::getInstance()->log(QString("Applications/Word: ").append(settings.value("Applications/Word").toString()));
    DVAGLogger::getInstance()->log(QString("Applications/Excel: ").append(settings.value("Applications/Excel").toString()));
    //    DVAGLogger::getInstance()->log(QString("Applications/CrestronXPanel: ").append(settings.value("Applications/Excel").toString()));
    DVAGLogger::getInstance()->log(QString("PIN: ").append(settings.value("PIN").toString()));

    if (!QFile::exists(settings.value("Background/Left").toString())) {
        DVAGLogger::getInstance()->log(QString("Copying left background image to data directory: ").append(settings.value("Background/Left").toString()));
        QFile::copy(":/images/background.jpg", settings.value("Background/Left").toString());
    }
    if (!QFile::exists(settings.value("Background/Right").toString())) {
        DVAGLogger::getInstance()->log(QString("Copying right background image to data directory: ").append(settings.value("Background/Right").toString()));
        QFile::copy(":/images/background.jpg", settings.value("Background/Right").toString());
    }

    settings.sync();

}

int main(int argc, char* argv[])
{
    set_qt_environment();
    qputenv("QT_VIRTUALKEYBOARD_STYLE", "neokeys");
    initSettings(argc, argv);
    SetUnhandledExceptionFilter(CrashHandler); // Registrieren
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("Unit 08");
    QCoreApplication::setOrganizationDomain("unit08.de");
    QCoreApplication::setApplicationName("DVAG Presenter");
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);

    QtWebView::initialize();
    
    QApplication app(argc, argv);
    //MyWindowHandle myWindowHandle;
    // Event Filter erstellen
    //FocusEventFilter * focusEventFilter = new FocusEventFilter();


    // Event Filter auf die gesamte Anwendung anwenden
    //app.installEventFilter(focusEventFilter);

    QSharedMemory shared("a43450dd-3145-4fa8-aa2c-a5e70e491bf1");
    if (!shared.create(512, QSharedMemory::ReadWrite))
    {
        QMessageBox msgBox;
        msgBox.setText( QObject::tr("Cannot start more than one instance of the application.") );
        msgBox.setIcon( QMessageBox::Critical );
        msgBox.exec();
        exit(0);
    }

    DownloadManager downloadManager;
    AppInfo appInfo;

    QLoggingCategory::setFilterRules(QStringLiteral("qt.qml.binding.removal.info=true"));

    // Register our native classes in QML
    qmlRegisterType<FileManager>("FileManager", 1, 0, "FileManager");
    qmlRegisterType<FileMetaData>("FileMetaData", 1, 0, "FileMetaData");
    qmlRegisterType<GraphClient>("GraphClient", 1, 0, "GraphClient");
    qmlRegisterType<QWebEngineCertificateError>("QWebEngineCertificateError", 1, 0, "QWebEngineCertificateError");


    qmlRegisterSingletonType<DVAGLogger>("DVAGLogger", 1, 0, "DVAGLogger", [](QQmlEngine* engine, QJSEngine* scriptEngine) -> QObject* {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)
        return DVAGLogger::getInstance();
    });

    FileManager filemanager;
    // Delete files older than 48h = 172800 sec
    // Check the files in the import dir
    filemanager.deleteFilesOlderThan(filemanager.getImportDir(), 172800);
    // Check the files in the screenshot dir
    filemanager.deleteFilesOlderThan(filemanager.getScreenshotDir(), 172800);
    // Delete temp folder contents
    filemanager.deleteFilesOlderThan(filemanager.getTempDir(), 0);
    filemanager.deleteBrowserStorage();
    
    NeoManager appManager;
    // Mache den Download-Manager für die QML-Engine verfügbar

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("NeoManager", &appManager);
//   engine.rootContext()->setContextProperty("MyWindowHandle", &myWindowHandle);
   // engine.rootContext()->setContextProperty("TextFocusHandler", focusEventFilter);
    engine.rootContext()->setContextProperty("downloadManager", &downloadManager);
    engine.rootContext()->setContextProperty("AppInfo", &appInfo);

    QWebEngineView view;
    auto *customPage = new CustomWebEnginePage(&view);
    view.setPage(customPage);
    //CustomWebEnginePage *customPage = new CustomWebEnginePage();

    // Registriere die benutzerdefinierte Seite für den Zugriff in QML
    engine.rootContext()->setContextProperty("customWebEnginePage", customPage);
    engine.rootContext()->setContextProperty("mcWebView", &view);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);

    filemanager.engine = &engine;
    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
       DVAGLogger::getInstance()->log(QString("No Objects to view found"));
       return -1;
    }

    return app.exec();
}


