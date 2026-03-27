#ifndef WORKER_H
#define WORKER_H

#include <QObject>

class Worker : public QObject {
    Q_OBJECT

public:
    Worker(QString keyword, QString path);
    Worker(QList<QString> filename, QString from, QString to, bool o);
    //    ~Worker();

public slots:
    void process();
    void copyFilesProcess();

signals:
    void finished();
    void resultReady(QStringList results); //Used after the search is finished
    void copyResultReady(int);

private:
    QString keyword;
    QString path;
    QList<QString> filename;
    QString from;
    QString to;
    bool override;
    int copyingSuccessful;
    QStringList searchResults;

    QStringList searchInDir(const QString& keyword, const QString& path);
    int copyFile(const QList<QString>& filename, const QString& from, const QString& to, bool override);
    int modus;
};

#endif // WORKER_H
