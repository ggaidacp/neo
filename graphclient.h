#pragma once
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonObject>
#include <QSettings>

const static QString CLIENT_ID = "af47e496-46e0-4685-a237-5f5932a1d70d"; // APP_NEO-Presenter-ExchangeOnline-OAuth_PRD
const static QString CLIENT_SECRET = ""; // Secret at 24.10.2025
const static QString TENANT = "930d042f-8145-48e6-871e-7659c17b56da";  // microsoft azure tenant dvad/atlas

class GraphClient : public QObject {
    Q_OBJECT
public:
    explicit GraphClient(QObject *parent = nullptr);

    void setAuthData(const QString &tenantId, const QString &clientId, const QString &clientSecret);
    void setMailBox(const QString &target);
    QString getMailBox(void);
    Q_INVOKABLE void authenticate();  // Client credentials flow
    Q_INVOKABLE void sendMail(const QStringList &recipients,
                              const QString &subject,
                              const QString &bodyText,
                              const QStringList &attachmentPaths
                              );
    Q_INVOKABLE QString getLastError(void);
    void setLastError(const QString &e);

signals:
    void tokenReceived(const QString &token);
    void mailSent();
    void errorOccurred(const QString &error);

private:
    QNetworkAccessManager m_network;
    QString m_tenantId = TENANT;
    QString m_clientId = CLIENT_ID;
    QString m_clientSecret = CLIENT_SECRET;
    QString m_accessToken;
    QString m_mailBox;
    QString m_lastError;
    QSettings settings;

    void onAuthReply(QNetworkReply *reply);
    void onMailReply(QNetworkReply *reply);
    void dumpReplyDebug(QNetworkReply *reply);
};
