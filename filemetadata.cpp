#include "filemetadata.h"
#include "dvaglogger.h"
#include "filemanager.h"

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>

FileMetaData::FileMetaData()
{
}

void FileMetaData::readMetaData()
{
    m_basename2pretty.clear();
    m_tag2basename.clear();
    // Read from file
    QFile file;
    QString fName = FileManager::getDataDir() + "/" + "filemetadata.json";
    file.setFileName(fName);
    if (file.exists()) {
        //DVAGLogger::getInstance()->log(QString("Read file: ").append(file.fileName()));
        file.open(QIODevice::ReadOnly | QIODevice::Text);
        QTextStream in(&file);
        in.setEncoding(QStringConverter::Utf8);
        QString val = in.readAll();
        file.close();

        QJsonDocument jDoc = QJsonDocument::fromJson(val.toUtf8());
        QJsonArray jFiles = jDoc.array();
        for (int i = 0; i < jFiles.count(); i++) {
            m_basename2pretty[jFiles[i].toObject()["basename"].toString()]
                = jFiles[i].toObject()["prettyname"].toString();
            for (int k = 0; k < jFiles[i].toObject()["tags"].toArray().count(); k++) {
                m_tag2basename[jFiles[i].toObject()["tags"].toArray()[k].toString()].append(
                    jFiles[i].toObject()["basename"].toString());
            }
            m_tag2basename[jFiles[i].toObject()["prettyname"].toString()].append(
                jFiles[i].toObject()["basename"].toString());
        }
    }
    m_fmdInitialized = true;
}

QList<QString> FileMetaData::tag2Basename(QString tag, bool exact)
{
    if (exact) {
        return (m_tag2basename.contains(tag)) ? m_tag2basename[tag] : QList<QString>();
    } else {
        QList<QString> res = QList<QString>();
        foreach (QString t, m_tag2basename.keys()) {
            if (t.contains(tag, Qt::CaseInsensitive)) {
                foreach (QString b, m_tag2basename[t]) {
                    if (!res.contains(b)) {
                        res.append(b);
                    }
                }
            }
        }
        return res;
    }
}

QString FileMetaData::basename2Pretty(QString basename)
{
    return (m_basename2pretty.contains(basename)) ? m_basename2pretty[basename] : basename;
}
