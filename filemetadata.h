#ifndef FILEMETADATA_H
#define FILEMETADATA_H

#include <QQuickItem>
#include <QThread>
#include <QTimer>

class FileMetaData : public QQuickItem {
    Q_OBJECT
public:
    FileMetaData();

signals:

public slots:
    Q_INVOKABLE void readMetaData();
    Q_INVOKABLE QList<QString> tag2Basename(QString tag, bool exact = false);
    Q_INVOKABLE QString basename2Pretty(QString basename);

private:

};

static QMap<QString, QList<QString>> m_tag2basename = QMap<QString, QList<QString>>();
static QMap<QString, QString> m_basename2pretty = QMap<QString, QString>();

static FileMetaData* fileMetaData = new FileMetaData();

static bool m_fmdInitialized = false;

#endif // FILEMETADATA_H
