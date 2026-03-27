#include "dvaglogger.h"

#include <QDir>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQuickItem>
#include <QSettings>
#include <QStringList>
#include <QDateTime>
#include <QFile>
#include <QTextStream>

#include <QFile>

DVAGLogger* DVAGLogger::instance = nullptr;

DVAGLogger::DVAGLogger(QObject* parent)
    : QObject(parent)
{
    enabled = false;
    logfile = "DVAG_Presenter.log";
}

DVAGLogger::~DVAGLogger() {}

DVAGLogger* DVAGLogger::getInstance()
{
    if (DVAGLogger::instance == nullptr)
        DVAGLogger::instance = new DVAGLogger();
    return instance;
}

bool DVAGLogger::getEnabled() const
{
    return enabled;
}

void DVAGLogger::setEnabled(bool value)
{
    enabled = value;
}

void DVAGLogger::log(QString msg, bool linebreak)
{
   try {
        QDateTime currentTime = QDateTime::currentDateTime();
        qDebug() << currentTime.toString(Qt::ISODate);
        qDebug() << " ";
        qDebug() << msg;
        if (!enabled)
            return;
        QFile lf(logfile);
        lf.open(QFile::Append);
        lf.write(currentTime.toString(Qt::ISODate).toUtf8() + " ");
        if (!linebreak) {
            lf.write(msg.toUtf8());
        }
        else {
            lf.write(msg.toUtf8().append("\r\n"));
        }
        lf.close();
   }
   catch (...) {

   }
}

DVAGLogger &DVAGLogger::operator<<(QString msg)
{
    log(msg);
    return *this;
}

DVAGLogger &DVAGLogger::operator>>(QString msg)
{
    log(msg);
    return *this;
}

DVAGLogger &DVAGLogger::operator<<(int msg)
{
    log(QString::number(msg));
    return *this;
}

DVAGLogger &DVAGLogger::operator>>(int msg)
{
    log(QString::number(msg));
    return *this;
}

DVAGLogger &DVAGLogger::operator<<(double msg)
{
    log(QString::number(msg));
    return *this;
}

DVAGLogger &DVAGLogger::operator>>(double msg)
{
    log(QString::number(msg));
    return *this;
}

QString DVAGLogger::getLogfile() const
{
    return logfile;
}

void DVAGLogger::setLogfile(const QString& value)
{
    logfile = value;
}
