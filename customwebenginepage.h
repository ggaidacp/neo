#ifndef CUSTOMWEBENGINEPAGE_H
#define CUSTOMWEBENGINEPAGE_H
#include<QWebEnginePage>
#include <QWebEngineCertificateError>

class CustomWebEnginePage : public QWebEnginePage {
    Q_OBJECT
public:
    explicit CustomWebEnginePage(QObject *parent = nullptr) : QWebEnginePage(parent) {
        qDebug() << "************* HIER IST MEINE CUSTOM PAGE ***********";
    }

    bool certificateError(const QWebEngineCertificateError &certificateError)  {
        qDebug() << "************* CERTIFIACATE ERROR AUFGETRETTEN ***********";
        emit certificateErrorOccurred(certificateError.description());
        return true;
    }

signals:
    void certificateErrorOccurred(const QString &errorDescription);
};
#endif // CUSTOMWEBENGINEPAGE_H
