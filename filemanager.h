#ifndef FILEMANAGER_H
#define FILEMANAGER_H

#include <QDir>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQuickItem>
#include <QSettings>
#include <QStringList>

/*#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <string.h>
#include <string>
#include <vector>*/

#ifdef WIN32
#include <Windows.h>
#include <WinUser.h>
#include <conio.h>
#include <comdef.h>
#include <shellapi.h>
#include <ShObjIdl.h>
#include <initguid.h>
#include <objbase.h>
#include <process.h>
#include <TlHelp32.h>
#include <WinBase.h>
#include <Msi.h>

#endif

#ifndef WIN32
#define HWND void*
#endif

class FileManager : public QQuickItem {
    Q_OBJECT

public:
    FileManager();

    Q_INVOKABLE QString getRandomString(int length = 12);
    // Getter/"Setter" for the global vars
    Q_INVOKABLE QStringList getNotCopiedFiles();
    Q_INVOKABLE int getCopiedFiles();
    Q_INVOKABLE void clearNotCopiedFiles();
    Q_INVOKABLE QStringList getSearchResults();
    Q_INVOKABLE void clearSearchResults();

    // Get folder
    static Q_INVOKABLE QString getDataDir();
    Q_INVOKABLE QString getStoryboardDir();
    Q_INVOKABLE QString getImportDir();
    Q_INVOKABLE QString getExportDir(const QString& path);
    Q_INVOKABLE QString getScreenshotDir();
    Q_INVOKABLE QString getMediaDir();
    Q_INVOKABLE QString getDavDir();
    Q_INVOKABLE QString getCurrentDir();
    Q_INVOKABLE QString getExistenzgruenderDir();
    Q_INVOKABLE QString getAusbildungDir();
    Q_INVOKABLE QString getWeiterbildungDir();
    Q_INVOKABLE QString getFuehrungsausbildungDir();
    Q_INVOKABLE QString getTempDir();
    Q_INVOKABLE void deleteSession();
    Q_INVOKABLE void initWebEngine();
    Q_INVOKABLE void abortWindowsSecurityDialog(void);


    // Copy
    Q_INVOKABLE int copyFile(const QString& filename, const QString& fromPath, const QString& toPath);
    Q_INVOKABLE int copyFileExtended(const QString& filename, const QString& fromPath, const QString& toPath, bool override);
    Q_INVOKABLE int copyFiles(const QList<QString>& filename, const QString& fromPath, const QString& toPath, bool override);
    Q_INVOKABLE int copyFolder(const QString& fromPath, const QString& toPath, bool override);
    // Move
    Q_INVOKABLE int moveFile(const QString& filename, const QString& fromPath, const QString& toPath);

    // Delete
    Q_INVOKABLE void deleteFile(const QString& filename, const QString& path);
    Q_INVOKABLE void deleteFilesInFolder(const QString& path);
    Q_INVOKABLE void deleteFilesOlderThan(const QString& path, int ageInSec);
    Q_INVOKABLE void deleteBrowserStorage();
    Q_INVOKABLE void deleteBrowserStorage( const QString& path );

    // Filetypes
    Q_INVOKABLE bool isDir(const QString& filename, const QString& path);
    Q_INVOKABLE QString getMimeType(const QString& filename, const QString& path);
    Q_INVOKABLE bool isMimeTypeSupported(const QString& typeName);
    Q_INVOKABLE QString getSupportedFileType(const QString& typeName); // "Convert" the mime type to a readable name

    // Get files
    Q_INVOKABLE QStringList getFilesInDir(const QString& dir);
    Q_INVOKABLE QStringList getSupportedFilesInDir(const QString& dir); // "Supported" based on the mime type
    Q_INVOKABLE QStringList getSupportedFilesInDir(const QString& dir, int sortFlag); // "Supported" based on the mime type; With sorting option

    // Get volumes
    Q_INVOKABLE QStringList getVolumes();
    Q_INVOKABLE QStringList getSupportedVolumes();

    // Search for files
    Q_INVOKABLE QStringList searchInDir(const QString& keyword, const QString& path);
    Q_INVOKABLE void searchInDirThread(QString keyword, QString path); // Return via the signal "searchFinished()" and the result is stored in "searchResults"
    Q_INVOKABLE void copyFileThread(QList<QString> file, QString from, QString to, bool override);
    // Json
    Q_INVOKABLE QStringList readStoryboardJson();
    Q_INVOKABLE void writeStoryboardJson(QStringList storyboard);
    Q_INVOKABLE QStringList readOnlinePlatformsJson();

    // Create url file
    Q_INVOKABLE bool createUrlFile(const QString& fileName, const QString& filePath, const QString& fileUrl);

    // Open files
    Q_INVOKABLE void startProgram(const QString& fileType, QString filePath);
    Q_INVOKABLE QString findProgram(const wchar_t* prog);

    // Read file to base64 string
    Q_INVOKABLE QString readFileToBase64(const QString& file);

    // Gee file size
    Q_INVOKABLE qint64 getFileSize(const QString& file);

    // Toggle the onscreen keyboard
   // Q_INVOKABLE void toggleOnScreenKeyboard();

    // Get settings from registry
    Q_INVOKABLE int getSettingInt(const QString& key);
    Q_INVOKABLE QString getSettingQString(const QString& key);

    Q_INVOKABLE void setPowerPointVisible(bool visible);
    Q_INVOKABLE bool isPowerPointVisible();
    Q_INVOKABLE bool isPowerPointRunning();

    Q_INVOKABLE void startPowerPointDetectionThread();

    Q_INVOKABLE void killProcess(QString exeName);
    Q_INVOKABLE void killAllOfficeProcesses();

    //Q_INVOKABLE void pressKey(QString ch);

    Q_INVOKABLE void unzip(QString file);

    Q_INVOKABLE void logTMX(QString msg);

    Q_INVOKABLE void quitPowerPointWorker();


    QQmlApplicationEngine* engine;


private:
    void killProcessByName(const char* filename);
    QSettings settings;
    int copiedFiles;


public slots:
    void handleResult(QStringList results);
    void handleCopyResult(int c);

#ifdef WIN32
    void watchDirectory();
    bool extractAllZipFiles(const QString& directoryPath);
    bool extractZipUsingWindows(const QString& zipFilePath, const QString& outputDir);
    bool moveExtractedFiles(const QString& sourceDirPath, const QString& targetDirPath);
    bool deleteDirectory(const QString& dirPath);
#endif

signals:
    void setPptVisible(bool show);
    void searchFinished();
    void copyFinished();
    void dataDirContentChanged();
    void dataDirContentDeleted();
    void finished();
};

// Stores the not copied files e.g. file existed already
extern QStringList notCopiedFiles;

// Stores the results of the threaded search
extern QStringList searchResults;

#ifdef WIN32

struct ITipInvocation : IUnknown {
    virtual HRESULT STDMETHODCALLTYPE Toggle(HWND wnd) = 0;
};

extern "C" const IID CLSID_UIHostNoLaunch;
extern "C" const IID IID_ITipInvocation;

#endif

#endif // FILEMANAGER_H
