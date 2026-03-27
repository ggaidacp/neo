#include <QWebEngineProfile>
#include <QWebEngineDownloadRequest>
#include <QObject>
#include <QDir>
#include "filemanager.h"

class DownloadManager : public QObject {
    Q_OBJECT
public:
    explicit DownloadManager(QObject *parent = nullptr) : QObject(parent) {
        // Verbinde das Download-Signal mit dem Slot
        QWebEngineProfile *defaultProfile = QWebEngineProfile::defaultProfile();
        connect(defaultProfile, &QWebEngineProfile::downloadRequested, this, &DownloadManager::onDownloadRequested);
    }
signals:
    // Signal, das in QML empfangen wird
    void downloadCompleted(const QString &fileName, const QString &filePath);

public slots:
    void onDownloadRequested(QWebEngineDownloadRequest *download) {
        FileManager fileMan;
        // Setze das Verzeichnis, in das du die Datei herunterladen möchtest
        QString downloadDirectory = fileMan.getImportDir();

        // Stelle sicher, dass das Verzeichnis existiert
        QDir dir(downloadDirectory);
        if (!dir.exists()) {
            dir.mkpath(downloadDirectory);  // Erstelle das Verzeichnis, falls es nicht existiert
        }
        //qDebug() << "!!!!!!******!!!!! Download Folder " << downloadDirectory << " **************";
        // Setze den Pfad der Datei auf das gewünschte Verzeichnis
        QString filePath = downloadDirectory + "/" + download->downloadFileName();
        //qDebug() << "!!!!!!******!!!!! Gesamte Pfad und datei " << filePath << " **************";
        download->setDownloadDirectory(downloadDirectory);

        // Starte den Download
        download->accept();

        // Optional: Benachrichtige den Benutzer
        qDebug() << "Datei wird heruntergeladen nach: " << filePath;
        // Verbinde das Signal stateChanged, um den Abschluss zu überwachen
        connect(download, &QWebEngineDownloadRequest::stateChanged, this, [this, download, filePath]() {
            if (download->state() == QWebEngineDownloadRequest::DownloadCompleted) {
                emit downloadCompleted(download->downloadFileName(), filePath);  // Signal für QML senden
            } else if (download->state() == QWebEngineDownloadRequest::DownloadInterrupted) {
                // Bei einem Fehler eine Warnung anzeigen
                qDebug() << "Download fehlgeschlagen";
            }
        });
    }
};
