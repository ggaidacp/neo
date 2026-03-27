#include "graphclient.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QFile>
#include <QFileInfo>
#include <QDebug>
#include "dvaglogger.h"


GraphClient::GraphClient(QObject *parent)
    : QObject(parent)
{
    connect(&m_network, &QNetworkAccessManager::finished,
            this, [this](QNetworkReply *reply) {
                const QString url = reply->url().toString();
                qDebug() << "\n--- Antwort erhalten ---";
                qDebug() << "URL:" << url;
                qDebug() << "HTTP-Status:" << reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

                if (url.contains("/oauth2/v2.0/token")) {
                    DVAGLogger::getInstance()->log("URL contains token");
                    onAuthReply(reply);
                }
                else if (url.contains("/sendMail")) {
                    QByteArray response = reply->readAll();
                    if (reply->error() == QNetworkReply::NoError) {
                        qDebug() << "E-Mail erfolgreich versendet.";
                        qDebug() << "Serverantwort:" << response;
                        emit mailSent();
                        setLastError("Email versendet");
                    } else {
                        /*
                        qWarning() << "Fehler beim Senden der Mail:" << reply->errorString();*/
                        qDebug() << "Serverantwort:" << response;
                        m_lastError = "Fehler beim Senden der Mail ... prüfe die Konfiguration.";
                        emit errorOccurred(reply->errorString());

                        DVAGLogger::getInstance()->log("Fehler beim Senden der Mail:" + reply->errorString());
                        setLastError("Fehler beim Senden der Mail:" + reply->errorString());
                    }
                    //app->quit(); // Anwendung nach Versand beenden
                }

                reply->deleteLater();
            });
}
QString GraphClient::getMailBox() {
    return m_mailBox;
}
void GraphClient::setMailBox(const QString &target) {
    m_mailBox = target;
}
QString GraphClient::getLastError() {
    return m_lastError;
}
void GraphClient::setLastError(const QString &e) {
    m_lastError = e;
}

void GraphClient::setAuthData(const QString &tenantId, const QString &clientId, const QString &clientSecret) {
    m_tenantId = tenantId;
    m_clientId = clientId;
    m_clientSecret = clientSecret;
}

void GraphClient::authenticate() {
    qDebug() << "\n--- Authentifizierung gestartet ---";
    qDebug() << "Tenant:" << m_tenantId;
    qDebug() << "Client-ID:" << m_clientId;

    QUrl url(QStringLiteral("https://login.microsoftonline.com/%1/oauth2/v2.0/token").arg(m_tenantId));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    QByteArray data;
    data.append("client_id=" + m_clientId.toUtf8());
    data.append("&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default");
    data.append("&client_secret=" + m_clientSecret.toUtf8());
    data.append("&grant_type=client_credentials");

    qDebug() << "Token Request wird gesendet...";
    m_network.post(request, data);
}

void GraphClient::onAuthReply(QNetworkReply *reply) {
    if (reply->error() != QNetworkReply::NoError) {
        DVAGLogger::getInstance()->log( "Fehler bei der Authentifizierung:" + reply->errorString());
        m_lastError = "Email konnte nicht versendet werden. " + reply->errorString();
        DVAGLogger::getInstance()->log( "Email konnte nicht versendet werden. Fehler bei der Authentifizierung:" + reply->errorString());
        emit errorOccurred(reply->errorString());
        return;
    }

    QByteArray response = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(response);
    m_accessToken = doc["access_token"].toString();

    if (m_accessToken.isEmpty()) {
        qWarning() << "Kein Access Token erhalten.";
        m_lastError = "Kein Access Token erhalten.";
        qDebug() << "Antwort:" << response;
        emit errorOccurred("Kein Access Token erhalten");
        DVAGLogger::getInstance()->log("Kein Access Token erhalten");
        return;
    }

    qDebug() << "Access Token erfolgreich erhalten.";
    emit tokenReceived(m_accessToken);
}

void GraphClient::sendMail(const QStringList &recipients,
                           const QString &subject,
                           const QString &bodyText,
                           const QStringList &attachmentPaths
                           )
{
    DVAGLogger::getInstance()->log("send mail in graphclient startet");

    QString senderUserPrincipalName = (qgetenv("USERNAME") + "@dvag.com");
    qDebug() << "Sender User Principal Name " << senderUserPrincipalName;
    setMailBox(senderUserPrincipalName);

    if (m_accessToken.isEmpty()) {
        emit errorOccurred("Access Token fehlt.");
        return;
    } else {
        DVAGLogger::getInstance()->log("Token erfalten");
    }

   /* qDebug() << "\n--- Sende Mail über Microsoft Graph ---";*/
    qDebug() << "Absender:" << senderUserPrincipalName;
    qDebug() << "Empfänger:" << recipients;
    qDebug() << "Betreff:" << subject;
    qDebug() << "Anzahl Anhänge:" << attachmentPaths.size();

    // richtige URL
    QUrl url(QString("https://graph.microsoft.com/v1.0/users/%1/sendMail").arg(senderUserPrincipalName));
    QNetworkRequest request(url);
    request.setRawHeader("Authorization", QString("Bearer %1").arg(m_accessToken).toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    // Empfänger aufbauen
    QJsonArray toRecipients;
    for (const QString &addr : recipients) {
        toRecipients.append(QJsonObject {
            {"emailAddress", QJsonObject {{"address", addr}}}
        });
    }

    // Anhänge aufbauen
    QJsonArray attachments;
    for (const QString &path : attachmentPaths) {
        QFile file(path);
        DVAGLogger::getInstance()->log("Anhang Eins: " + path );
        if (!file.exists()) {
            qDebug() << "Anhang nicht gefunden:" << path;
            continue;
        }
        if (!file.open(QIODevice::ReadOnly)) {
            qDebug() << "Kann Anhang nicht öffnen:" << path << file.errorString();
            continue;
        }

        QByteArray content = file.readAll();
        QFileInfo info(file.fileName());

        QJsonObject attachment {
            {"@odata.type", "#microsoft.graph.fileAttachment"},
            {"name", info.fileName()},
            {"contentBytes", QString::fromUtf8(content.toBase64())}
        };
        attachments.append(attachment);
        qDebug() << "Anhang hinzugefügt:" << info.fileName() << "(" << content.size() << "Bytes)";
    }

    // Absenderobjekt
    QJsonObject fromObj {
        {"emailAddress", QJsonObject {
                             {"address", senderUserPrincipalName}
                         }}
    };


    // Wichtig: wegen Qt-JSON-Immutabilität manuell zusammensetzen
    QJsonObject emailAddress {
        {"address", senderUserPrincipalName}
    };
    fromObj = QJsonObject { {"emailAddress", emailAddress} };


    // E-Mail Objekt
    QJsonObject email {
        {"message", QJsonObject {
                        {"from", fromObj},
                        {"subject", subject},
                        {"body", QJsonObject {
                                     {"contentType", "Text"},
                                     {"content", bodyText}
                                 }},
                        {"toRecipients", toRecipients},
                        {"attachments", attachments}
                    }},
        {"saveToSentItems", true}
    };
    //qDebug() << "EMAIL INHALT " << email;
    QJsonDocument doc(email);
    QByteArray payload = doc.toJson(QJsonDocument::Compact);

    qDebug() << "JSON-Größe:" << payload.size() << "Bytes";
    qDebug() << "Sende Request...";

    m_network.post(request, payload);
}

