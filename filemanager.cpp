#include <QDateTime>
#include <QDesktopServices>
#include <QDir>
#include <QString>
#include <QThread>
#include <QFileInfo>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QMimeDatabase>
#include <QMimeType>
#include <QProcess>
#include <QStandardPaths>
#include <QStorageInfo>
#include <QWindow>
#include <QDebug>
//#include <QTextCodec>
#include <QDirIterator>
#include <QRandomGenerator>
//#include<QQuickWebEngineProfile>
#include <QWebEngineView>
#include <QWebEngineProfile>
#include <QWebEngineCookieStore>
#include <QApplication>


#include "dvaglogger.h"
#include "filemanager.h"
#include "filemetadata.h"
#include "worker.h"
#include "PowerPointSingleton.h"

//#include <QtWebEngine>


QStringList notCopiedFiles;
QStringList searchResults;
// Stores the currently opened file
static QString currentOpenFile;

static bool ppdThreadStarted = false;
static QThread * ppdThread2 = new QThread();


FileManager::FileManager()
{
 
}

#ifdef Q_OS_WIN
#include <windows.h>
#endif

void FileManager::abortWindowsSecurityDialog()
{
#ifdef Q_OS_WIN
    // Aktives Fenster ermitteln
    HWND hwndActive = GetForegroundWindow();
    if (!hwndActive) {
        qDebug() << "Kein aktives Fenster gefunden.";
        return;
    }

    // HWND deines Qt-Hauptfensters ermitteln
    QWindow * mainWindow = (QWindow *)QApplication::activeWindow();
    HWND hwndQt = nullptr;
    if (mainWindow)
        hwndQt = reinterpret_cast<HWND>(mainWindow->winId());

    // Prüfen, ob es dein eigenes Fenster ist
    if (hwndActive == hwndQt) {
        qDebug() << "Aktives Fenster gehört zur Qt-App – kein Abort nötig.";
        return;
    }

    // Fenstertitel ermitteln
    wchar_t title[256];
    GetWindowTextW(hwndActive, title, 255);
    QString windowTitle = QString::fromWCharArray(title);

    // Prüfen, ob es der Windows-Sicherheit-Dialog ist
    if (windowTitle.contains("Windows-Sicherheit", Qt::CaseInsensitive)) {
        DVAGLogger::getInstance()->log( "Windows-Sicherheit-Dialog gefunden, sende Abort...");
        // Dialog schließen
        PostMessage(hwndActive, WM_CLOSE, 0, 0);
    } else {
        //qDebug() << "Aktives Fenster ist nicht 'Windows-Sicherheit':" << windowTitle;
    }
#else
    qWarning() << "abortWindowsSecurityDialog() nur unter Windows verfügbar.";
#endif
}

QStringList FileManager::getNotCopiedFiles()
{
    return notCopiedFiles;
}

void FileManager::clearNotCopiedFiles()
{
    QThread::yieldCurrentThread();

    notCopiedFiles.clear();
}

QStringList FileManager::getSearchResults()
{
    return searchResults;
}

void FileManager::clearSearchResults()
{
    searchResults.clear();
}

QString FileManager::getDataDir()
{
    QDir dir = QDir::currentPath();
    dir.setPath(dir.path().append("/data"));
    if (!dir.exists()) {
        dir.mkdir(dir.path());
        DVAGLogger::getInstance()->log(QString("Create data folder at: ").append(dir.path()));
    } else {
        DVAGLogger::getInstance()->log(QString("FileManager::getDataDir(): ").append(dir.path()));
    }
    return dir.path();
}
QString FileManager::getCurrentDir()
{
    return QDir::currentPath();
}

QString FileManager::getStoryboardDir()
{
    QDir dir;
    dir.setPath(QDir::homePath());
    dir.setPath(dir.path().append("/neo"));
    if (!dir.exists()) {
        dir.mkdir(dir.path());
        DVAGLogger::getInstance()->log(QString("Create neo folder at: ").append(dir.path()));
    }
    dir.setPath(dir.path().append("/data"));
    if (!dir.exists()) {
        dir.mkdir(dir.path());
        DVAGLogger::getInstance()->log(QString("Create data folder at: ").append(dir.path()));
    }

    dir.setPath(dir.path().append("/storyboard"));
    if (!dir.exists()) {
        //DVAGLogger::getInstance()->log(QString("Create storyboard folder at: ").append(dir.path()));
        dir.mkdir(dir.path());
    } else {
        //DVAGLogger::getInstance()->log(QString("FileManager::getStoryboardDir(): ").append(dir.path()));
    }
    DVAGLogger::getInstance()->log("created : " + dir.path());
    return dir.path();
}

QString FileManager::getImportDir()
{
    QDir dir;
    dir.setPath(QDir::homePath());
    dir.setPath(dir.path().append("/neo"));
    if (!dir.exists()) {
        dir.mkdir(dir.path());
        DVAGLogger::getInstance()->log(QString("Create neo folder at: ").append(dir.path()));
    }
    dir.setPath(dir.path().append("/data"));
    if (!dir.exists()) {
        dir.mkdir(dir.path());
        DVAGLogger::getInstance()->log(QString("Create data folder at: ").append(dir.path()));
    }
    dir.setPath(dir.path().append("/import"));
    if (!dir.exists()) {
        DVAGLogger::getInstance()->log(QString("Create import folder at: ").append(dir.path()));
        dir.mkdir(dir.path());
    }
    DVAGLogger::getInstance()->log("created : " + dir.path());
    return dir.path();
}

QString FileManager::getExportDir(const QString& path)
{
    QDir dir;
    dir.setPath(path);
    dir.setPath(dir.path().append("/DVAG_Export"));
    if (!dir.exists()) {
        DVAGLogger::getInstance()->log(QString("Create export folder at: ").append(dir.path()));
        dir.mkdir(dir.path());
    }
    return dir.path();
}

QString FileManager::getScreenshotDir()
{
    QDir dir;
    dir.setPath(QDir::homePath());
    dir.setPath(dir.path().append("/neo"));
    if (!dir.exists()) {
        dir.mkdir(dir.path());
        DVAGLogger::getInstance()->log(QString("Create neo folder at: ").append(dir.path()));
    }
    dir.setPath(dir.path().append("/data"));
    if (!dir.exists()) {
        dir.mkdir(dir.path());
        DVAGLogger::getInstance()->log(QString("Create data folder at: ").append(dir.path()));
    }
    dir.setPath(dir.path().append("/screenshots"));
    if (!dir.exists()) {
        dir.mkdir(dir.path());
        DVAGLogger::getInstance()->log(QString("Create screenshots folder at: ").append(dir.path()));
    }
    DVAGLogger::getInstance()->log("created : " + dir.path());
    return dir.path();
}

QString FileManager::getMediaDir()
{
    QDir dir;
    dir.setPath(QDir::homePath());
    dir.setPath(dir.path().append("/neo"));
    if (!dir.exists()) {
        dir.mkdir(dir.path());
        DVAGLogger::getInstance()->log(QString("Create neo folder at: ").append(dir.path()));
    }
    dir.setPath(dir.path().append("/data"));
    if (!dir.exists()) {
        dir.mkdir(dir.path());
        DVAGLogger::getInstance()->log(QString("Create data folder at: ").append(dir.path()));
    }
    dir.setPath(dir.path().append("/medialibrary"));
    if (!dir.exists()) {
        dir.mkdir(dir.path());
    }
    DVAGLogger::getInstance()->log(QString("Create medialibrary at: ").append("created folder : " + dir.path()));
    return dir.path();
}

QString FileManager::getDavDir()
{
    QDir dir;
    dir.setPath(getDataDir());
    dir.setPath(dir.path().append("/dav"));
    if (!dir.exists()) {
        //DVAGLogger::getInstance()->log(QString("Create dav folder at: ").append(dir.path()));
        dir.mkdir(dir.path());
    }
    return dir.path();
}

QString FileManager::getExistenzgruenderDir()
{
    QDir dir;
    dir.setPath(getDavDir());
    dir.setPath(dir.path().append("/1 Existenzgründer"));
    if (!dir.exists()) {
        //DVAGLogger::getInstance()->log(QString("Create Existenzgründer folder at: ").append(dir.path()));
        dir.mkdir(dir.path());
    }
    return dir.path();
}

QString FileManager::getAusbildungDir()
{
    QDir dir;
    dir.setPath(getDavDir());
    dir.setPath(dir.path().append("/2 Ausbildung"));
    if (!dir.exists()) {
        //DVAGLogger::getInstance()->log(QString("Create Ausbildung folder at: ").append(dir.path()));
        dir.mkdir(dir.path());
    }
    return dir.path();
}

QString FileManager::getWeiterbildungDir()
{
    QDir dir;
    dir.setPath(getDavDir());
    dir.setPath(dir.path().append("/3 Weiterbildung"));
    if (!dir.exists()) {
        //DVAGLogger::getInstance()->log(QString("Create Weiterbildung folder at: ").append(dir.path()));
        dir.mkdir(dir.path());
    }
    return dir.path();
}

QString FileManager::getFuehrungsausbildungDir()
{
    QDir dir;
    dir.setPath(getDavDir());
    dir.setPath(dir.path().append("/4 Führungsausbildung"));
    if (!dir.exists()) {
        //DVAGLogger::getInstance()->log(QString("Create Führungsausbildung folder at: ").append(dir.path()));
        dir.mkdir(dir.path());
    }
    return dir.path();
}

QString FileManager::getTempDir()
{
    QDir dir;
    dir.setPath(getDataDir());
    dir.setPath(dir.path().append("/temp"));
    if (!dir.exists()) {
        //DVAGLogger::getInstance()->log(QString("Create temporary folder at: ").append(dir.path()));
        dir.mkdir(dir.path());
    }
    return dir.path();
}

// Returns the amount of copied files
int FileManager::moveFile(const QString& filename, const QString& fromPath, const QString& toPath)
{
    DVAGLogger() << "**** move file ********" << filename << fromPath << toPath;
    QFile file(toPath + "/" + filename);
    QFile file1(fromPath + "/" + filename);
    QFileInfo fileInfo(fromPath + "/" + filename);
    if (!file.exists() && !fileInfo.isDir()) {
        QFile::copy(fromPath + "/" + filename, toPath + "/" + filename);
        file1.remove();
        //DVAGLogger() << fromPath + "/" + filename + "was copied to" + toPath;
        return true;
    }
    notCopiedFiles.append(fromPath + "/" + filename);
    //DVAGLogger() << filename + "already exists.";
    return false;
}
int FileManager::copyFiles(const QList<QString>& filename, const QString& fromPath, const QString& toPath, bool override) {
    int counter = 0;

    for (const QString &item : filename) {
        DVAGLogger() << "********************** ITEM = " << item << "** from = " << fromPath << "  ** to = " << toPath << " ** override = " << override;
        counter += copyFileExtended(item, fromPath, toPath, override);
    }
    DVAGLogger() << counter ;
    return counter;
}
// Returns the amount of copied files
int FileManager::copyFile(const QString& filename, const QString& fromPath, const QString& toPath)
{
    DVAGLogger() << "**** copy file ********" << filename << fromPath << toPath;

    QFile file(toPath + "/" + filename);
    QFileInfo fileInfo(fromPath + "/" + filename);
    if ((!file.exists() && !fileInfo.isDir())) {
        QFile::copy(fromPath + "/" + filename, toPath + "/" + filename);
        DVAGLogger() << fromPath + "/" + filename + "was copied to" + toPath;
        return true;
    }
    notCopiedFiles.append(fromPath + "/" + filename);
    //DVAGLogger() << filename + "already exists.";
    return false;
}
// Returns the amount of copied files
int FileManager::copyFileExtended(const QString& filename, const QString& fromPath, const QString& toPath, bool override)
{
    DVAGLogger() << "**** copy file ********" << filename << fromPath << toPath;

    QFile file(toPath + "/" + filename);
    QFileInfo fileInfo(fromPath + "/" + filename);

    if (fileInfo.isDir()) {
        return copyFolder(fromPath + "/" + filename, toPath, override);
    } else {
        if (!file.exists() || override) {
                QFile::copy(fromPath + "/" + filename, toPath + "/" + filename);
                DVAGLogger() << fromPath + "/" + filename + "was copied to" + toPath;
                return 1;
        }
    }
    notCopiedFiles.append(filename);
    //DVAGLogger() << filename + "already exists.";
    return 0;
}

// Returns the amount of copied files
int FileManager::copyFolder(const QString& fromPath, const QString& toPath, bool override)
{
    QStringList files = getSupportedFilesInDir(fromPath);
    unsigned long filesCounter = files.length();
    DVAGLogger() << "******** Files copied = " << (int)filesCounter << " ***************";

    int filesCopied = 0;
    foreach (const QString& file, files) {
        if (isDir(file, fromPath)) {
            filesCopied += copyFolder(fromPath + "/" + file, toPath, override);
            DVAGLogger() << "******** Files copied from Folder " << file << " = " << filesCopied;
        } else {
            filesCopied += copyFileExtended(file, fromPath, toPath,  override);
        }
    }
    DVAGLogger() << "******** Files copied = " << filesCopied << " ***************";
    return filesCopied;
}

void FileManager::deleteFile(const QString& filename, const QString& path)
{
    QFile file(path + "/" + filename);
    file.remove();
}

void FileManager::deleteFilesInFolder(const QString& path)
{
    const QStringList fileList = getFilesInDir(path);
    for (const QString& tmpFile : fileList) {
        QFile file(path + "/" + tmpFile);
        if (isDir(tmpFile, path)) {
            QDir dir(path + "/" + tmpFile);
            bool removed = dir.removeRecursively();
            removed ? DVAGLogger() << path + "/" + tmpFile + " and all content was removed." : DVAGLogger() << path + "/" + tmpFile + " and all content was not removed.";
        } else {
            bool removed = file.remove();
            removed ? DVAGLogger() << path + "/" + tmpFile + " was removed." : DVAGLogger() << path + "/" + tmpFile + " was not removed.";
        }
    }
}

void FileManager::deleteFilesOlderThan(const QString& path, int ageInSec)
{
    QStringList fileList = getFilesInDir(path);
    for (const QString& tmpFile : fileList) {
        QFile file(path + "/" + tmpFile);
        QFileInfo fileInfo(file);
        QDateTime birthTime = fileInfo.birthTime();
        QDateTime now = QDateTime::currentDateTime();
        // Check if the creation date of the file is longer than 48h ago
        if ((now.toSecsSinceEpoch() - birthTime.toSecsSinceEpoch()) > ageInSec) {
            bool removed = file.remove();
            removed ? DVAGLogger() << path + "/" + tmpFile + " was removed." : DVAGLogger() << path + "/" + tmpFile + " was not removed.";
        }
    }
}

void FileManager::deleteBrowserStorage()
{
    deleteBrowserStorage("QtWebEngine");
}

void FileManager::deleteBrowserStorage( const QString& path ) {
    //DVAGLogger::getInstance()->log("Browser profile storage base directory: " + QStandardPaths::writableLocation(QStandardPaths::DataLocation));
    //DVAGLogger::getInstance()->log("Übergebener Parameter path: " + path);
    QDirIterator it(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation), QStringList() << "*", QDir::Dirs, QDirIterator::Subdirectories);
    while (it.hasNext()) {
        QString file = it.next();
        //DVAGLogger::getInstance()->log("Browser Data Location: " + file);
       // if (file.contains( path ) && !file.endsWith(".")) {
            //DVAGLogger() << "deleting: " + file;
            QDir(file).removeRecursively(); // (file);
       // }
    }
    DVAGLogger() << path;
}


bool FileManager::isDir(const QString& filename, const QString& path)
{
    QFileInfo fileInfo(path + "/" + filename);
    return fileInfo.isDir();
}

QString FileManager::getMimeType(const QString& filename, const QString& path)
{
    if (isDir(filename, path)) {
        return "folder";
    }
    QString datei = QFile(path + "/" + filename).fileName();
    /*DVAGLogger() << "************ MIME!!!" << datei;
    DVAGLogger() << QMimeDatabase().mimeTypeForFile(datei, QMimeDatabase::MatchDefault).name();*/
    return QMimeDatabase().mimeTypeForFile(datei, QMimeDatabase::MatchDefault).name();
}

QString FileManager::getRandomString(int length) {
    const QString possibleCharacters("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789");
    const int randomStringLength = length; // assuming you want random strings of 12 characters

    QString randomString;
    for (int i = 0; i < randomStringLength; ++i)
    {
        int index = QRandomGenerator::global()->generate() % possibleCharacters.length();
        QChar nextChar = possibleCharacters.at(index);
        randomString.append(nextChar);
    }
    return randomString;
}


bool FileManager::isMimeTypeSupported(const QString& typeName)
{
    if (typeName == "folder") {
        return true;
    }
    if (typeName == "application/pdf") {
        return true;
    }
    if (typeName == "image/jpeg") {
        return true;
    }
    if (typeName == "image/png") {
        return true;
    }
    if (typeName == "video/quicktime") {
        return true;
    }
    if (typeName == "video/mp4") {
        return true;
    }
    if (typeName == "video/x-msvideo") {
        return true;
    }
    if (typeName == "application/vnd.ms-powerpoint") {
        return true;
    }
    if (typeName == "application/vnd.openxmlformats-officedocument.presentationml.presentation") {
        return true;
    }
    if (typeName == "application/msword") {
        return true;
    }
    if (typeName == "application/vnd.openxmlformats-officedocument.wordprocessingml.document") {
        return true;
    }
    if (typeName == "application/vnd.ms-excel") {
        return true;
    }
    if (typeName == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet") {
        return true;
    }
    if (typeName == "audio/mpeg") {
        return true;
    }
    if (typeName == "audio/x-wav") {
        return true;
    }
    {
        return false;
    }
}

QString FileManager::getSupportedFileType(const QString& typeName)
{
    if (typeName == "folder") {
        return "folder";
    }
    if (typeName == "application/pdf") {
        return "pdf";
    }
    if (typeName == "image/jpeg") {
        return "image";
    }
    if (typeName == "image/png") {
        return "image";
    }
    if (typeName == "video/quicktime") {
        return "video";
    }
    if (typeName == "video/mp4") {
        return "video";
    }
    if (typeName == "video/x-msvideo") {
        return "video";
    }
    if (typeName == "application/vnd.ms-powerpoint") {
        return "powerpoint";
    }
    if (typeName == "application/vnd.openxmlformats-officedocument.presentationml.presentation") {
        return "powerpoint";
    }
    if (typeName == "application/msword") {
        return "word";
    }
    if (typeName == "application/vnd.openxmlformats-officedocument.wordprocessingml.document") {
        return "word";
    }
    if (typeName == "application/vnd.ms-excel") {
        return "excel";
    }
    if (typeName == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet") {
        return "excel";
    }
    if (typeName == "audio/mpeg") {
        return "audio";
    }
    if (typeName == "audio/x-wav") {
        return "audio";
    }
    {
        return "";
    }
}

QStringList FileManager::getFilesInDir(const QString& dir)
{
    QDir directory(dir);
    QStringList files = directory.entryList();
    QStringList newFiles;
    int counter = 0;
    for (int i = 0; i < files.count(); i++) {
        // Remove "dot" and "dotdot" folder
        if (files.at(i) != "." && files.at(i) != "..") {
            newFiles.insert(counter, files.at(i));
            counter++;
        }
    }
    return newFiles;
}

// Sorted by DirsFirst
QStringList FileManager::getSupportedFilesInDir(const QString& dir)
{
    QDir directory(dir);
    // Sort by DirsFirst
    QFileInfoList files = directory.entryInfoList(QDir::NoFilter, QDir::DirsFirst);
    QStringList newFiles;
    foreach (const QFileInfo& file, files) {
        QString typeName = getMimeType(file.fileName(), dir);
       // DVAGLogger::getInstance()->log(QString("MIME-Type detected: ").append(typeName).append("    [").append(file.fileName()).append("]"));
        if (file.fileName() != "." && file.fileName() != ".." && isMimeTypeSupported(typeName)) {
            newFiles.append(file.fileName());
        }
    }
    return newFiles;
}

QStringList FileManager::getSupportedFilesInDir(const QString& dir, int sortFlag)
{
    QDir::SortFlag sort;
    switch (sortFlag) {
    case 0:
        sort = QDir::Name;
        break;
    case 1:
        sort = QDir::Time;
        break;
    case 2:
        sort = QDir::Size;
        break;
    case 3:
        sort = QDir::Unsorted;
        break;
    case 4:
        sort = QDir::DirsFirst;
        break;
    case 8:
        sort = QDir::Reversed;
        break;
    case 10:
        sort = QDir::IgnoreCase;
        break;
    case 20:
        sort = QDir::DirsLast;
        break;
    case 40:
        sort = QDir::LocaleAware;
        break;
    case 80:
        sort = QDir::Type;
        break;
    default:
        sort = QDir::NoSort;
        break;
    }
    QDir directory(dir);
    QFileInfoList files = directory.entryInfoList(QDir::NoFilter, sort);
    QStringList newFiles;
    foreach (const QFileInfo& file, files) {
        QString typeName = getMimeType(file.fileName(), dir);
        //DVAGLogger::getInstance()->log(QString("MIME-Type detected: ").append(typeName).append("    [").append(file.fileName()).append("]"));
        if (file.fileName() != "." && file.fileName() != ".." && isMimeTypeSupported(typeName)) {
            newFiles.append(file.fileName());
        }
    }
    return newFiles;
}

QStringList FileManager::getVolumes()
{
    QStringList volumes;
    volumes.clear();
    foreach (const QStorageInfo& storage, QStorageInfo::mountedVolumes()) {
        if (storage.isValid() && storage.isReady()) {
            if (!storage.isReadOnly()) {
                if (storage.name().isEmpty()) {
                    // Returns the rootPath if name is empty
                    volumes.append(storage.displayName());
                } else {
                    // Returns the rootPath + name if name is not empty
                    volumes.append(storage.rootPath().append(storage.displayName()));
                }
            }
        }
    }
    return volumes;
}

QStringList FileManager::getSupportedVolumes()
{
    QStringList volumes;
    volumes.clear();
    foreach (const QStorageInfo& storage, QStorageInfo::mountedVolumes()) {
        if (storage.isValid() && storage.isReady()) {
            if (!storage.isReadOnly()) {
                // Filter out the c: and d: volume
                if (storage.rootPath() != "C:/") {
                    if (storage.name().isEmpty()) {
                        // Returns the rootPath if name is empty
                        volumes.append(storage.displayName());
                    } else {
                        // Returns the rootPath + name if name is not empty
                        volumes.append(storage.rootPath().append(storage.displayName()));
                    }
                }
            }
        }
    }
    return volumes;
}

// Returns a stringlist [filename1, path1, filename2, path2, ...]
QStringList FileManager::searchInDir(const QString& keyword, const QString& path)
{
    QStringList fileList = getSupportedFilesInDir(path);
    QStringList results;
    bool once = false;
    for (const QString& tmpFile : fileList) {
        once = false;
        if (!isDir(tmpFile, path)) {
            if (tmpFile.contains(keyword, Qt::CaseInsensitive)) {
                results.append(tmpFile);
                results.append(path);
                once = true;
            }
            for (const QString& tmpFile2 : fileMetaData->tag2Basename(keyword)) {
                if (tmpFile.contains(tmpFile2, Qt::CaseInsensitive) && !once) {
                    results.append(tmpFile);
                    results.append(path);
                    once = true;
                }
            }
        } else {
            results.append(searchInDir(keyword, path + "/" + tmpFile));
        }
    }
    return results;
}

void FileManager::searchInDirThread(QString keyword, QString path)
{
    auto thread = new QThread;
    Worker* worker = new Worker(std::move(keyword), std::move(path));
    //DVAGLogger::getInstance()->log("search keyword :" + keyword + " Path: " + path);
    worker->moveToThread(thread);
    connect(thread, SIGNAL(started()), worker, SLOT(process()));
    connect(worker, SIGNAL(resultReady(QStringList)), this, SLOT(handleResult(QStringList)));
    connect(worker, SIGNAL(finished()), thread, SLOT(quit()));
    connect(worker, SIGNAL(finished()), worker, SLOT(deleteLater()));
    connect(thread, SIGNAL(finished()), thread, SLOT(deleteLater()));
    thread->start();
}
void FileManager::copyFileThread(QList<QString> file, QString from, QString to, bool override)
{
    auto thread = new QThread;
    Worker* worker = new Worker(std::move(file), std::move(from), std::move(to), std::move(override));
    //DVAGLogger::getInstance()->log("search keyword :" + keyword + " Path: " + path);
    worker->moveToThread(thread);
    connect(thread, SIGNAL(started()), worker, SLOT(process()));
    connect(worker, SIGNAL(copyResultReady(int)), this, SLOT(handleCopyResult(int)));
    connect(worker, SIGNAL(finished()), thread, SLOT(quit()));
    connect(worker, SIGNAL(finished()), worker, SLOT(deleteLater()));
    connect(thread, SIGNAL(finished()), thread, SLOT(deleteLater()));
    thread->start();
}

void FileManager::deleteSession() {
    QFile file;
    QString fullname = QDir::home().path() + "/neo/data/" + "storyboard.json";
    file.setFileName(fullname);
    if (file.exists()) {
        DVAGLogger::getInstance()->log("Remove Storyboard");
        file.remove() ;
    } else {
        DVAGLogger::getInstance()->log("Remove Storyboard nothing to remove");
    }

}
/*
 * User-Agent-String
 * Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) QtWebEngine/5.15.2 Chrome/83.0.4103.122 Safari/537.36
 */

void FileManager::initWebEngine() {
    DVAGLogger::getInstance()->log("************Starte Initialisierung von WebEndine ************************");
    QWebEngineProfile *profile = QWebEngineProfile::defaultProfile();

    //profile->setHttpUserAgent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36");
    profile->clearHttpCache();
    profile->cookieStore()->deleteAllCookies();
    DVAGLogger::getInstance()->log("************ Cookies gelöscht ************************");
    profile->removeAllUrlSchemeHandlers();
    profile->cachePath().clear();
    DVAGLogger::getInstance()->log("************ Cache gelöscht ************************");
    //profile->persistentStoragePath().clear();
    profile->clearHttpCacheCompleted();
    DVAGLogger::getInstance()->log("************ lösche persistenten storage ************************");
    QString storagePath = profile->persistentStoragePath();
    if (!storagePath.isEmpty()) {
        qDebug() << "********** Beginne mit dem löschen von " << storagePath ;
        QDir storageDir(storagePath);
        if (storageDir.exists()) {
            bool removed = storageDir.removeRecursively();
            qDebug() << "Storage-Verzeichnis gelöscht:" << removed << storagePath;
        }
    }

    DVAGLogger::getInstance()->log("************ Web Engine initialised ************************");


}


// Returns a stringlist [name1, type1, path1, name2, type2, path2, ...]
QStringList FileManager::readStoryboardJson()
{
    QStringList storyboard;
    QString fullname = QDir::home().path() + "/neo/data/" + "storyboard.json";
    // Read from file
    QFile file;
    file.setFileName(fullname);
    if (file.exists()) {
        //DVAGLogger::getInstance()->log(QString("Read file: ").append(file.fileName()));
        file.open(QIODevice::ReadOnly | QIODevice::Text);
        QTextStream in(&file);
        in.setEncoding(QStringConverter::Utf8);
        QString val = in.readAll();
        file.close();

        QJsonDocument jDoc = QJsonDocument::fromJson(val.toUtf8());
        QJsonObject jObj = jDoc.object();
        QJsonArray jFiles = jObj["storyboard"].toArray();
        for (int i = 0; i < jFiles.count(); i++) {
            QJsonObject jFile = jFiles[i].toObject();

            QJsonValue jName = jFile["name"];
            storyboard.append(jName.toString());
            QJsonValue jType = jFile["type"];
            storyboard.append(jType.toString());
            QJsonValue jPath = jFile["path"];
            storyboard.append(jPath.toString());
        }
    }
    return storyboard;
}

void FileManager::writeStoryboardJson(QStringList storyboard)
{
    QJsonArray jStoryboard;
    for (int i = 0; i < storyboard.size(); i += 3) {
        QJsonObject jElement;
        jElement.insert("name", storyboard[i]);
        jElement.insert("type", storyboard[i + 1]);
        jElement.insert("path", storyboard[i + 2]);
        jStoryboard.push_back(jElement);
    }
    QJsonObject jObj;
    jObj.insert("storyboard", jStoryboard);
    QJsonDocument jDoc(jObj);

    // Write to file
    QFile file;
    QString fullname = QDir::home().path() + "/neo/data/" + "storyboard.json";
    file.setFileName(fullname);
    DVAGLogger::getInstance()->log(QString("Write file: ").append(file.fileName()));
    file.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream out(&file);
    //out.setCodec("UTF-8");
    out.setEncoding(QStringConverter::Utf8);
    out << jDoc.toJson();
    file.close();
}

// Returns a stringlist [id1, name1, url1, id2, name2, url2, ...]
QStringList FileManager::readOnlinePlatformsJson()
{
    //DVAGLogger() << "FileManager::readOnlinePlatformsJson()";
    QStringList onlinePlatforms;

    // Read from file
    QFile file;
    file.setFileName(getDataDir() + "/" + "onlineplatforms.json");
    //DVAGLogger() << "Trying to read " + file.fileName();
    if (file.exists()) {
        //DVAGLogger::getInstance()->log(QString("Read file: ").append(file.fileName()));
        file.open(QIODevice::ReadOnly | QIODevice::Text);
        QTextStream in(&file);
        in.setEncoding(QStringConverter::Utf8);
        // in.setCodec("UTF-8");
        QString val = in.readAll();
        file.close();

        QJsonDocument jDoc = QJsonDocument::fromJson(val.toUtf8());
        QJsonObject jObj = jDoc.object();
        QJsonArray jFiles = jObj["intranet"].toArray();
        for (int i = 0; i < jFiles.count(); i++) {
            QJsonObject jFile = jFiles[i].toObject();

            onlinePlatforms.append("intranet");
            QJsonValue jName = jFile["name"];
            onlinePlatforms.append(jName.toString());
            QJsonValue jUrl = jFile["url"];
            onlinePlatforms.append(jUrl.toString());
            QJsonValue jIcon = jFile["icon"];
            onlinePlatforms.append(jIcon.toString());
        }
        jFiles = jObj["socialmedia"].toArray();
        for (int i = 0; i < jFiles.count(); i++) {
            QJsonObject jFile = jFiles[i].toObject();

            onlinePlatforms.append("socialmedia");
            QJsonValue jName = jFile["name"];
            onlinePlatforms.append(jName.toString());
            QJsonValue jUrl = jFile["url"];
            onlinePlatforms.append(jUrl.toString());
            QJsonValue jIcon = jFile["icon"];
            onlinePlatforms.append(jIcon.toString());
        }
        jFiles = jObj["partners"].toArray();
        for (int i = 0; i < jFiles.count(); i++) {
            QJsonObject jFile = jFiles[i].toObject();

            onlinePlatforms.append("partners");
            QJsonValue jName = jFile["name"];
            onlinePlatforms.append(jName.toString());
            QJsonValue jUrl = jFile["url"];
            onlinePlatforms.append(jUrl.toString());
            QJsonValue jIcon = jFile["icon"];
            onlinePlatforms.append(jIcon.toString());
        }
        jFiles = jObj["headlines"].toArray();
        for (int i = 0; i < jFiles.count(); i++) {
            QJsonObject jFile = jFiles[i].toObject();

            onlinePlatforms.append("headlines");
            onlinePlatforms.append(jFile["dvag"].toString());
            onlinePlatforms.append(jFile["partners"].toString());
            onlinePlatforms.append("");
        }
    } else {
        DVAGLogger() << "Unable to read " + file.fileName();
    }
    return onlinePlatforms;
}

// Returns false if the file already exists
bool FileManager::createUrlFile(const QString& fileName, const QString& filePath, const QString& fileUrl)
{
    QFile file;
    QString ffName = filePath + "/" + fileName + ".url";
    file.setFileName(ffName);
    if (!file.exists()) {
        if (file.open(QIODevice::ReadWrite)) {
            QTextStream stream(&file);
            //stream << "[{000214A0-0000-0000-C000-000000000046}]" << endl;
            //stream << "Prop3=19,2" << endl;
            stream << "[InternetShortcut]\n";
            stream << "IDList=\n";
            stream << "URL=" + fileUrl +"\n";
            DVAGLogger::getInstance()->log(QString("Created url-file: ").append(ffName));
        }
        file.close();
        return true;
    }
    DVAGLogger::getInstance()->log(QString("Url-file ").append(ffName).append(" already exists."));
    return false;
}

void FileManager::startProgram(const QString& fileType, QString filePath)
{
    if (PowerPointSingleton::instance()->IsInitializing()) {
        return;
    }

    QString program;
    filePath.replace("/", "\\\\");
    QStringList arguments;
    bool winMoverThreadEnabled = false;
    if (fileType == "powerpoint" || fileType == "powerpointpresentation" || fileType == "word" || fileType == "excel") {       
        killAllOfficeProcesses();
    }
    if (fileType == "powerpoint" || fileType == "powerpointpresentation" ) {
    //    program = settings.value("Applications/PowerPoint").toString();
    //    arguments << "/C" << filePath;
    //    DVAGLogger::getInstance()->log("Powerpoint started.");
    //    setPowerPointVisible(true);
    //} else if (fileType == "powerpointpresentation") {
        program = settings.value("Applications/PowerPoint").toString();
        arguments << "/C" << filePath;
        //arguments << "/S" << filePath;
        DVAGLogger::getInstance()->log("Powerpoint presentation started.");
        winMoverThreadEnabled = true;
    } else if (fileType == "word") {
        program = settings.value("Applications/Word").toString();
        arguments << "/t" << filePath;
        DVAGLogger::getInstance()->log("Word started.");
    } else if (fileType == "excel") {
        program = settings.value("Applications/Excel").toString();
        arguments << filePath;
        DVAGLogger::getInstance()->log("Excel started.");
    } else if (fileType == "mediacontrol") {
        program = settings.value("Applications/CrestronXPanel").toString();
        arguments << filePath;
        DVAGLogger::getInstance()->log("CrestronXPanel started.");
    } else if (fileType == "pdf") {
        QUrl url = QUrl::fromLocalFile(filePath);
        QDesktopServices::openUrl(url);
        DVAGLogger::getInstance()->log("Default pdf reader started.");
    }

    auto m_process = new QProcess();
    m_process->setProgram(program);
    m_process->setArguments(arguments);
    m_process->start();

    if (winMoverThreadEnabled) {
        PowerPointSingleton::instance()->setAwaitFinish();
        setPowerPointVisible(true);
    }

    startPowerPointDetectionThread();
}

QString FileManager::findProgram(const wchar_t* prog)
{
#ifdef WIN32
    DWORD size = 300;
    INSTALLSTATE installstate;
    wchar_t* sPath;

    sPath = new wchar_t[size];
    installstate = MsiLocateComponent(prog, sPath, &size);

    QString res = QString::fromWCharArray(sPath);
    delete sPath;
    if ((installstate == INSTALLSTATE_LOCAL) || (installstate == INSTALLSTATE_SOURCE)) {
        DVAGLogger::getInstance()->log(QString("Installed in: ").append(res));
    } else {
        DVAGLogger::getInstance()->log("Application NOT found!!!");
        return "";
    }
    return res;
#else
    Q_UNUSED(prog)
    return "";
#endif
}

QString FileManager::readFileToBase64(const QString& file)
{
    QFile sourceFile(file);
    if (!sourceFile.open(QIODevice::ReadOnly))
        return "";
    QByteArray base64Encoded = sourceFile.readAll().toBase64();
    return QString::fromLatin1(base64Encoded);
}

qint64 FileManager::getFileSize(const QString& file)
{
    return QFileInfo(file).size();
}

int FileManager::getSettingInt(const QString& key)
{
    return settings.value(key).toInt();
}

QString FileManager::getSettingQString(const QString& key)
{
    return settings.value(key).toString();
}

// Get triggerd after the threaded search is finished
void FileManager::handleResult(QStringList results)
{
    searchResults = std::move(results);
    searchFinished();
    DVAGLogger::getInstance()->log("Threaded search finished and results are available.");
}
// Get triggerd after the threaded search is finished
void FileManager::handleCopyResult(int c)
{
    copiedFiles = std::move(c);
    copyFinished();
    DVAGLogger::getInstance()->log("Threaded copy-files finished and results are available.");
}
int FileManager::getCopiedFiles() {
    return copiedFiles;
}
void FileManager::setPowerPointVisible(bool visible) {
    PowerPointSingleton::instance()->ShowPowerPoint(visible);
}

bool FileManager::isPowerPointVisible() {
    return PowerPointSingleton::instance()->PowerPointIsVisible();
}

// WIN32 code
#ifdef WIN32

BOOL CALLBACK EnumWindowsProc(HWND hwnd, LPARAM lParam)
{
    char buffer[128];
    int written = GetWindowTextA(hwnd, buffer, 128);
    if (written && strstr(buffer, currentOpenFile.toLocal8Bit()) != nullptr) {
        *(HWND*)lParam = hwnd;
        return FALSE;
    }
    return TRUE;
}

#endif


bool FileManager::isPowerPointRunning()
{
    return PowerPointSingleton::instance()->PowerPointIsInitialized();
}

#ifdef WIN32

#define MAX_DIRS 1022
#define MAX_FILES 8199
#define MAX_BUFFER 1022 * 16

extern "C" {
WINBASEAPI BOOL WINAPI
ReadDirectoryChangesW(HANDLE hDirectory,
    LPVOID lpBuffer, DWORD nBufferLength,
    BOOL bWatchSubtree, DWORD dwNotifyFilter,
    LPDWORD lpBytesReturned,
    LPOVERLAPPED lpOverlapped,
    LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine);
}

// all purpose structure to contain directory information and provide
// the input buffer that is filled with file change data

typedef struct _DIRECTORY_INFO {
    HANDLE hDir;
    TCHAR lpszDirName[MAX_PATH];
    CHAR lpBuffer[MAX_BUFFER];
    DWORD dwBufLength;
    OVERLAPPED Overlapped;
} DIRECTORY_INFO, *PDIRECTORY_INFO, *LPDIRECTORY_INFO;

DIRECTORY_INFO DirInfo[MAX_DIRS]; // Buffer for all of the directories
TCHAR FileList[MAX_FILES * MAX_PATH]; // Buffer for all of the files
DWORD numDirs;

//Method to start watching a directory. Call it on a separate thread so it wont block the main thread.

void FileManager::quitPowerPointWorker() {
    PowerPointSingleton::instance()->StopPowerPoint();
}

void FileManager::watchDirectory()
{
    QString pt = getDataDir().replace("/", "\\");
    DVAGLogger::getInstance()->log(QString("DataDir path: ").append(pt));
    LPCWSTR path = (const wchar_t*)pt.utf16();

    char buf[2048];
    DWORD nRet;
    BOOL result = TRUE;
    char filename[MAX_PATH];
    DirInfo[0].hDir = CreateFile(path, GENERIC_READ | FILE_LIST_DIRECTORY,
        FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
        NULL, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS | FILE_FLAG_OVERLAPPED,
        NULL);

    if (DirInfo[0].hDir == INVALID_HANDLE_VALUE) {
        return; //cannot open folder
    }

    lstrcpy(DirInfo[0].lpszDirName, path);
    OVERLAPPED PollingOverlap;

    FILE_NOTIFY_INFORMATION* pNotify;
    int offset;
    PollingOverlap.OffsetHigh = 0;
    PollingOverlap.hEvent = CreateEvent(NULL, TRUE, FALSE, NULL);
    while (result) {
        result = ReadDirectoryChangesW(
            DirInfo[0].hDir, // handle to the directory to be watched
            &buf, // pointer to the buffer to receive the read results
            sizeof(buf), // length of lpBuffer
            TRUE, // flag for monitoring directory or directory tree
            FILE_NOTIFY_CHANGE_FILE_NAME | FILE_NOTIFY_CHANGE_DIR_NAME | FILE_NOTIFY_CHANGE_SIZE,
            //FILE_NOTIFY_CHANGE_LAST_WRITE |
            //FILE_NOTIFY_CHANGE_LAST_ACCESS |
            //FILE_NOTIFY_CHANGE_CREATION,
            &nRet, // number of bytes returned
            &PollingOverlap, // pointer to structure needed for overlapped I/O
            NULL);

        WaitForSingleObject(PollingOverlap.hEvent, INFINITE);

        offset = 0;
        /*
        int rename = 0;
        char oldName[260];
        char newName[260];
        */
        do {
            pNotify = (FILE_NOTIFY_INFORMATION*)((char*)buf + offset);
            filename[0] = '\0';

            //int filenamelen = WideCharToMultiByte(CP_ACP, 0, pNotify->FileName, pNotify->FileNameLength / 2, filename, sizeof(filename), NULL, NULL);
            filename[pNotify->FileNameLength / 2] = '\0';
            switch (pNotify->Action) {
            case FILE_ACTION_ADDED:
                DVAGLogger::getInstance()->log(QString("The file is added to the directory: [").append(filename).append("]"));
                break;
            case FILE_ACTION_REMOVED:
                DVAGLogger::getInstance()->log(QString("The file is removed from the directory: [").append(filename).append("]"));
                emit dataDirContentDeleted();
                //setPowerPointVisible(isPowerPointVisible());
                break;
            case FILE_ACTION_MODIFIED:
                DVAGLogger::getInstance()->log(QString("The file is modified. This can be a change in the time stamp or attributes: [").append(filename).append("]"));
                //setPowerPointVisible(isPowerPointVisible());
                break;
            case FILE_ACTION_RENAMED_OLD_NAME:
                DVAGLogger::getInstance()->log(QString("The file was renamed and this is the old name: [").append(filename).append("]"));
                //setPowerPointVisible(isPowerPointVisible());
                break;
            case FILE_ACTION_RENAMED_NEW_NAME:
                DVAGLogger::getInstance()->log(QString("The file was renamed and this is the new name: [").append(filename).append("]"));
                //setPowerPointVisible(isPowerPointVisible());
                break;
            default:
                DVAGLogger::getInstance()->log(QString("nDefault error."));
                break;
            }
            emit dataDirContentChanged();
            offset += pNotify->NextEntryOffset;
        } while (pNotify->NextEntryOffset); //(offset != 0);
    }

    CloseHandle(DirInfo[0].hDir);
}

#endif

void FileManager::logTMX(QString msg) {
    DVAGLogger::getInstance()->log(msg);
}

void FileManager::startPowerPointDetectionThread() {
    if (ppdThreadStarted ) {
        return;
    }

    ppdThreadStarted = true;

    //auto thread2 = new QThread;
    if (!ppdThread2->isRunning()) {
        auto fm2 = new FileManager();
        fm2->moveToThread(ppdThread2);
#ifdef WIN32
        connect(ppdThread2, SIGNAL(started()), fm2, SLOT(watchDirectory()));
        connect(ppdThread2, SIGNAL(finished()), ppdThread2, SLOT(deleteLater()));
#endif
        ppdThread2->start();
    }
    if (ppdThread2->isFinished()) {
        ppdThread2->exit();
    }

}

#ifdef WIN32

// 4ce576fa-83dc-4F88-951c-9d0782b4e376
DEFINE_GUID(CLSID_UIHostNoLaunch, 0x4CE576FA, 0x83DC, 0x4f88, 0x95, 0x1C, 0x9D, 0x07, 0x82, 0xB4, 0xE3, 0x76);

// 37c994e7_432b_4834_a2f7_dce1f13b834b
DEFINE_GUID(IID_ITipInvocation, 0x37c994e7, 0x432b, 0x4834, 0xa2, 0xf7, 0xdc, 0xe1, 0xf1, 0x3b, 0x83, 0x4b);

#endif

/*void FileManager::toggleOnScreenKeyboard()
{
#ifdef WIN32
    HRESULT hr;
    QString strHR;
    //killProcessByName("osk.exe");
    HWND hWnd = FindWindowW(L"IPTip_Main_Window", nullptr); // TabTip.exe window class
    if (!hWnd) {
        // is not running, needs to be started:
        void* was;
        Wow64DisableWow64FsRedirection(&was);
        ShellExecuteA(nullptr, "open", "TabTip.exe", nullptr, "C:\\Program Files\\Common Files\\microsoft shared\\ink", SW_SHOWMINIMIZED);
        Wow64RevertWow64FsRedirection(was);
    } else {
        // is already runnging, just toggle it via API:
        hr = CoInitialize(nullptr);
        DVAGLogger::getInstance()->log(strHR.setNum(hr));
        ITipInvocation* tip;
        hr = CoCreateInstance(CLSID_UIHostNoLaunch, nullptr, CLSCTX_INPROC_HANDLER | CLSCTX_LOCAL_SERVER, IID_ITipInvocation, (void**)&tip);
        hWnd = GetDesktopWindow();
        tip->Toggle(hWnd);
        tip->Release();
    }
#endif
}*/

void FileManager::killProcessByName(const char* filename)
{
    QString dummy(filename);
#ifdef WIN32
    HANDLE hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, NULL);
    PROCESSENTRY32 pEntry;
    pEntry.dwSize = sizeof(pEntry);
    BOOL hRes = Process32First(hSnapShot, &pEntry);
    while (hRes) {
        DVAGLogger::getInstance()->log(QString("Process snapshot helper tool initialized/iterated: ").append(QString::fromWCharArray(pEntry.szExeFile)));
        if (QString::fromWCharArray(pEntry.szExeFile) == QString(filename)) {
            DVAGLogger::getInstance()->log("Found process by name...");
            HANDLE hProcess = OpenProcess(PROCESS_TERMINATE, 0, static_cast<DWORD>(pEntry.th32ProcessID));
            if (hProcess != nullptr) {
                DVAGLogger::getInstance()->log("Got process handle, trying to terminate process...");
                TerminateProcess(hProcess, 9);
                CloseHandle(hProcess);
                return;
            }
        }
        hRes = Process32Next(hSnapShot, &pEntry);
    }
    CloseHandle(hSnapShot);
#endif
}

void FileManager::killProcess(QString exeName)
{
    killProcessByName(exeName.toUtf8().data());
}

void FileManager::killAllOfficeProcesses()
{
    killProcessByName("EXCEL.EXE");
    killProcessByName("POWERPNT.EXE");
    killProcessByName("WINWORD.EXE");
}

#ifndef WIN32
#define byte char
#endif

/*void simulateKey(byte ch)
{
    return;
#ifdef WIN32
    HWND hCurrentWindow;
    DWORD procID;
    GUITHREADINFO currentWindowGuiThreadInfo;

    //Sleep(5000);

    hCurrentWindow = GetForegroundWindow();

    if (!hCurrentWindow)
        DVAGLogger() << "Failed get main the window handle\n";

    GetWindowThreadProcessId(hCurrentWindow, &procID);
    GetGUIThreadInfo(procID, &currentWindowGuiThreadInfo);
    //hCurrentWindow = currentWindowGuiThreadInfo.hwndFocus;

    if (!hCurrentWindow)
        DVAGLogger() << "Failed get the child window handle\n";

    DVAGLogger() << "GO!!!\n";
    //hCurrentWindow = GetForegroundWindow();

    if (!PostMessage(hCurrentWindow, WM_KEYDOWN, ch, MapVirtualKey(ch, MAPVK_VK_TO_VSC)))
        DVAGLogger() << QString::number(GetLastError());
    Sleep(100);
    if (!PostMessage(hCurrentWindow, WM_KEYUP, ch, MapVirtualKey(ch, MAPVK_VK_TO_VSC)))
        DVAGLogger() << QString::number(GetLastError());
#endif
}*/

/*void FileManager::pressKey(QString ch)
{
    return;
    DVAGLogger::getInstance()->log(ch);
    //simulateKey(ch);
    //return;

#ifdef WIN32
    keybd_event(ch[0].toLatin1(), NULL, NULL, NULL);
    keybd_event(ch[0].toLatin1(), NULL, KEYEVENTF_KEYUP, NULL);
#endif

    //keybd_event(static_cast<byte>(ch), reinterpret_cast<WCHAR>(VkKeyScan(ch[0])), KEYEVENTF_SCANCODE, reinterpret_cast<ULONG_PTR>(nullptr));
    //keybd_event(static_cast<byte>(ch), VkKeyScan(ch[0]), KEYEVENTF_SCANCODE | KEYEVENTF_KEYUP, reinterpret_cast<ULONG_PTR>(nullptr));


    QKeyEvent * eve1 = new QKeyEvent (QEvent::KeyPress,Qt::Key_A,Qt::NoModifier,ch.toUtf8().data());
    QKeyEvent * eve2 = new QKeyEvent (QEvent::KeyRelease,Qt::Key_A,Qt::NoModifier,ch.toUtf8().data());

    qApp->postEvent((QObject*)engine->rootObjects().first(),(QEvent *)eve1);
    qApp->postEvent((QObject*)engine->rootObjects().first(),(QEvent *)eve2);



    HWND hCurrentWindow = GetForegroundWindow();

    PostMessage(nullptr,WM_KEYDOWN,ch,NULL);
    Sleep(200);
    PostMessage(nullptr,WM_KEYUP,ch,NULL);

}*/

void FileManager::unzip(QString file)
{
    const QString program = getDataDir().append("/7z.exe");
    const QStringList arguments = QStringList() << "x" << getImportDir().append("/").append(file);
    qgetenv("USERPROFILE");
    //copyFile(file, qgetenv("USERPROFILE") + "/Downloads", getImportDir());
    QProcess process;

    /* DVAGLogger::getInstance()->log(file);
    DVAGLogger::getInstance()->log(QString("setting download target directory = ").append(getImportDir()));
    DVAGLogger::getInstance()->log("argument list:");*/

    foreach (QString arg, arguments) {
        DVAGLogger::getInstance()->log(arg);
    }
    DVAGLogger::getInstance()->log(QString("program: ").append(program));
    process.setWorkingDirectory(getImportDir());
    process.start(program, arguments);
    process.waitForFinished(-1);
}
// Funktion zum Entpacken einer ZIP-Datei mit Windows Shell
bool FileManager::extractZipUsingWindows(const QString& zipFilePath, const QString& tempExtractDir) {
    QProcess process;

    const QStringList arguments = QStringList() << "-xf" << zipFilePath << "-C" << tempExtractDir;

    process.setWorkingDirectory(getImportDir());
    process.start("tar.exe", arguments);
    process.waitForFinished(-1);
    qDebug() << process.readAllStandardError();

    if (process.exitCode() != 0) {
        qDebug() << "Fehler beim Entpacken der Datei:" << zipFilePath;
        qDebug() << process.readAllStandardError();
        return false;
    } else {
        qDebug() << "succsesfull extracted";
    }

    return true;
}

// Hauptfunktion zum Verarbeiten eines Verzeichnisses
bool FileManager::extractAllZipFiles(const QString& directoryPath) {
    QDir dir(directoryPath);
    if (!dir.exists()) {
        qWarning() << "Das angegebene Verzeichnis existiert nicht:" << directoryPath;
        return false;
    }
    QStringList zipFiles = dir.entryList(QStringList() << "*.zip", QDir::Files);
    for (const QString& zipFileName : zipFiles) {
        QString zipFilePath = dir.filePath(zipFileName);
        qDebug() << "Entpacke Datei:" << zipFilePath;
        if (!extractZipUsingWindows(zipFilePath, directoryPath)) {
            qWarning() << "Fehler beim Entpacken von:" << zipFilePath;
            continue;
        }
        qDebug() << "Lösche ZIP-Datei:" << zipFilePath;
            if (!QFile::remove(zipFilePath)) {
            qWarning() << "Fehler beim Löschen der Datei:" << zipFilePath;
        }
        QStringList zipFolders = dir.entryList(QStringList() << "*", QDir::Dirs | QDir::NoDotAndDotDot );
        for (const QString& zipFolder : zipFolders) {
            moveExtractedFiles(zipFolder, directoryPath);
            deleteDirectory(directoryPath + "/" + zipFolder);
            //qDebug() << "************** Der Folder wird gelöscht : " << zipFolder;
        }

    }
    return true;
}
// Funktion zum Verschieben der extrahierten Dateien ins Zielverzeichnis
bool FileManager::moveExtractedFiles(const QString& sourceDirPath, const QString& targetDirPath) {
    QDir sourceDir(targetDirPath + "/" + sourceDirPath);
    if (!sourceDir.exists()) {
        qWarning() << "Das temporäre Verzeichnis existiert nicht:" << sourceDirPath;
            return false;
    }

    QDir targetDir(targetDirPath);
    if (!targetDir.exists()) {
        if (!targetDir.mkpath(".")) {
            qWarning() << "Fehler beim Erstellen des Zielverzeichnisses:" << targetDirPath;
            return false;
        }
    }

    QStringList fileList = sourceDir.entryList(QDir::Files);
    for (const QString& fileName : fileList) {
        QString sourceFilePath = sourceDir.filePath(fileName);
        QString targetFilePath = targetDir.filePath(fileName);

        if (!QFile::rename(sourceFilePath, targetFilePath)) {
            qWarning() << "Fehler beim Verschieben der Datei:" << sourceFilePath << "->" << targetFilePath;
            return false;
        }
    }

    return true;
}

// Funktion zum Löschen eines Verzeichnisses und seines Inhalts
bool FileManager::deleteDirectory(const QString& dirPath) {
    QDir dir(dirPath);
    if (!dir.exists()) {
        return true; // Nichts zu löschen
    }

    QFileInfoList fileList = dir.entryInfoList(QDir::NoDotAndDotDot | QDir::Files | QDir::Dirs);
    for (const QFileInfo& fileInfo : fileList) {
        if (fileInfo.isDir()) {
            if (!deleteDirectory(fileInfo.absoluteFilePath())) {
                return false;
            }
        } else {
            if (!QFile::remove(fileInfo.absoluteFilePath())) {
                qWarning() << "Fehler beim Löschen der Datei:" << fileInfo.absoluteFilePath();
                                                                  return false;
            }
        }
    }

    return dir.rmdir(dirPath);
}
