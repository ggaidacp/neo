#include <QObject>
#include <QApplication>
#include <QProcess>

#ifndef NEOMANAGER_H
#define NEOMANAGER_H
class NeoManager : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE static void restartApplication() {
        QString program = QApplication::applicationFilePath();
        QStringList arguments = QApplication::arguments();
        QProcess::startDetached(program, arguments);
        QCoreApplication::quit();
    }
};
#endif // NEOMANAGER_H
