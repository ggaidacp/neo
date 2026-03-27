#pragma once

#include <QObject>
#include <memory>

class PowerPointSingleton : public QObject {
    Q_OBJECT
public:
    PowerPointSingleton(PowerPointSingleton const&) = delete;
    PowerPointSingleton& operator=(PowerPointSingleton const&) = delete;

    static std::shared_ptr<PowerPointSingleton> instance()
    {
        static std::shared_ptr<PowerPointSingleton> s{ new PowerPointSingleton };
        return s;
    }

    void ShowPowerPoint(bool showPowerPoint);
    void StopPowerPoint();

    bool PowerPointIsVisible() { return m_powerPointVisible; }
    bool PowerPointIsRunning() { return m_powerPointRunning; }
    bool PowerPointIsInitialized() { return m_powerPointInitialized; }
    bool IsInitializing() { return m_powerPointRunning && !m_powerPointInitialized; }
    void setAwaitFinish() { m_awaitFinish = true; }

public slots:
    void pptWindowDetectionFinished();
    void pptLogMessage(QString msg);
    void pptInitialized();

signals:
    void setPptVisible(bool show);
    void stopPptWorker();

private:
    bool m_winMoverThreadStarted = false;
    bool m_powerPointVisible = false;
    bool m_powerPointRunning = false;
    bool m_powerPointInitialized = false;
    bool m_awaitFinish = false;

    PowerPointSingleton() {};
};
