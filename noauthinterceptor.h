#ifndef NOAUTHINTERCEPTOR_H
#define NOAUTHINTERCEPTOR_H
// noauthinterceptor.h
#include <QWebEngineUrlRequestInterceptor>

class NoAuthInterceptor : public QWebEngineUrlRequestInterceptor {
public:
    NoAuthInterceptor(QObject *parent = nullptr) : QWebEngineUrlRequestInterceptor(parent) {}
    void interceptRequest(QWebEngineUrlRequestInfo &info) override {
        // Entferne Authorization-Header komplett
        info.setHttpHeader("Authorization", QByteArray());
        // optional: blockiere bestimmte URLs/Hosts, wenn gewünscht:
        // if (info.requestUrl().host().contains("accounts.google.com")) { ... }
    }
};

#endif // NOAUTHINTERCEPTOR_H
