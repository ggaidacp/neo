#ifndef APPINFO_H
#define APPINFO_H
#include <QObject>

#define APP_VERSION_STRING APP_VERSION

class AppInfo : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString version READ version CONSTANT)

public:
    explicit AppInfo(QObject *parent = nullptr) : QObject(parent) {}

    QString version() const {
        //qDebug() << "*********** AppInfo **********" << APP_VERSION_STRING;
        return QString(APP_VERSION_STRING);
    }
};

#endif // APPINFO_H
