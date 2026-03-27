#include <QDebug>
#include <utility>

#include "filemanager.h"
#include "filemetadata.h"
#include "worker.h"

Worker::Worker(QString k, QString p)
{
    keyword = std::move(k);
    path = std::move(p);
    modus = 0; // search
}
Worker::Worker(QList<QString> f, QString frm, QString t, bool o)
{
    filename = std::move(f);
    from = std::move(frm);
    to = std::move(t);
    override = std::move(o);
    modus = 1; // copy
}

void Worker::process()
{
    if (modus == 0 ) {
        searchResults = searchInDir(keyword, path);
        emit resultReady(searchResults);
        emit finished();
    } else {
        copyFilesProcess();
    }


}
void Worker::copyFilesProcess()
{
    copyingSuccessful = copyFile(filename, from, to, override);
    emit copyResultReady(copyingSuccessful);
    emit finished();
}

int Worker::copyFile(const QList<QString>& filename, const QString& from, const QString& to, bool override) {
    FileManager filemanager;
    return filemanager.copyFiles(filename, from, to, override);
}

QStringList Worker::searchInDir(const QString& keyword, const QString& path)
{
    FileManager filemanager;
    QStringList fileList = filemanager.getSupportedFilesInDir(path);
    QStringList results;
    bool once = false;
    for (const QString& tmpFile : fileList) {
        once = false;
        if (!filemanager.isDir(tmpFile, path)) {
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
