#include "PowerPointSingleton.h"
#include <QThread>
#include "PowerPointWorker.h"
#include "dvaglogger.h"

void PowerPointSingleton::ShowPowerPoint(bool showPowerPoint) {


    /*
    while (m_awaitFinish && m_winMoverThreadStarted) {
        DVAGLogger::getInstance()->log("WAITING ...");
        Sleep(20);
    }

    m_awaitFinish = false;*/

    if (m_awaitFinish && m_winMoverThreadStarted)
        return;
    else
        m_awaitFinish = false;

    if (showPowerPoint)
        DVAGLogger::getInstance()->log("SHOW PPT");
    else
        DVAGLogger::getInstance()->log("HIDE PPT");

    m_powerPointVisible = showPowerPoint;

    if (m_winMoverThreadStarted) {
        emit setPptVisible(showPowerPoint);
        return;
    }

    m_winMoverThreadStarted = true;
    DVAGLogger::getInstance()->log("starting new window mover thread...");

    m_powerPointRunning = true;
    auto thread = new QThread;
    auto pptWorker = new PowerPointWorker(showPowerPoint);
    pptWorker->moveToThread(thread);
#ifdef WIN32
    connect(thread, &QThread::started, pptWorker, &PowerPointWorker::StartBackgroundWorker);
    connect(pptWorker, &PowerPointWorker::logMessage, this, &PowerPointSingleton::pptLogMessage);
    connect(pptWorker, &PowerPointWorker::initialized, this, &PowerPointSingleton::pptInitialized);
    connect(pptWorker, &PowerPointWorker::finished, this, &PowerPointSingleton::pptWindowDetectionFinished);
    connect(this, &PowerPointSingleton::setPptVisible, pptWorker, &PowerPointWorker::SetPptVisible);
    //connect(this, &PowerPointSingleton::stopPptWorker, pptWorker, &PowerPointWorker::StopWorker);
    connect(pptWorker, &PowerPointWorker::finished, thread, &QThread::quit);
    connect(pptWorker, &PowerPointWorker::finished, pptWorker, &PowerPointWorker::deleteLater);
    connect(thread, &QThread::finished, thread, &QThread::deleteLater);
#endif
    thread->start();
}

void PowerPointSingleton::StopPowerPoint() {
    emit stopPptWorker(); 
}

void PowerPointSingleton::pptLogMessage(QString msg) {
    DVAGLogger() << msg;
}

void PowerPointSingleton::pptInitialized() {
    m_powerPointInitialized = true;
}

void PowerPointSingleton::pptWindowDetectionFinished() {
    DVAGLogger() << "Window detection-thread finished";
    m_winMoverThreadStarted = false;
    m_powerPointRunning = false;
    m_powerPointVisible = false;
    m_powerPointInitialized = false;

    if (m_awaitFinish)
        ShowPowerPoint(true);

    m_awaitFinish = false;
}