#ifndef DVAGLOGGER_H
#define DVAGLOGGER_H

#include <QObject>
#include <QString>
#include <QTextStream>

class DVAGLogger : public QObject {
    Q_OBJECT
public:
    explicit DVAGLogger(QObject* parent = nullptr);
    ~DVAGLogger();

    static DVAGLogger* getInstance();

    static DVAGLogger* instance;

    DVAGLogger &operator<<(QString msg);
    DVAGLogger &operator>>(QString msg);
    DVAGLogger &operator<<(int msg);
    DVAGLogger &operator>>(int msg);
    DVAGLogger &operator<<(double msg);
    DVAGLogger &operator>>(double msg);

public slots:
    bool getEnabled() const;
    void setEnabled(bool value);
    QString getLogfile() const;
    void setLogfile(const QString& value);
    void log(QString msg, bool linebreak = true);


signals:

private:
    bool enabled;
    QString logfile;
    QString logMsg;
};

#endif // DVAGLOGGER_H
