#include "PowerPointWorker.h"
#include "dvaglogger.h"
//#include <qelapsedtimer.h>
#include <QDebug>
#include <QElapsedTimer>

#ifdef WIN32

QString GetWindowName(HWND hwnd) {
    int length = GetWindowTextLength(hwnd) + 1;
    if (length > 0) {
        std::vector<TCHAR> buffer(std::size_t(length), 0);
        if (GetWindowText(hwnd, &buffer[0], length)) {
            return QString::fromWCharArray(&buffer[0]).append("");
        }
    }

    return QString("");
}

BOOL CALLBACK FindWindowImpl(HWND hWnd, LPARAM lParam) {
    auto p = reinterpret_cast<ExtWindowResult*>(lParam);
    if (!p) {
        // Finish enumerating we received an invalid parameter
        return FALSE;
    }

    bool isVis = IsWindowVisible(hWnd);
    if (!isVis)
        return TRUE;

    QString wTitle = GetWindowName(hWnd);

    if (wTitle.contains("PowerPoint")) {
        DVAGLogger::getInstance()->log(QString("Found window: ").append(wTitle));
        if (wTitle.startsWith("Öffnen")) {
            // powerpoint is still loading, try next round
            p->ppMainHandle = nullptr;
            return FALSE;
        }
        else if (wTitle.contains("PowerPoint-Bildschirmpräsentation")) 
            p->ppPresentationHandle = hWnd;
        else if (wTitle.contains("Referentenansicht"))
            p->ppPresenterHandle = hWnd;
        else if (!wTitle.contains("Zuletzt vom Benutzer gespeichert") || p->ppMainHandle == nullptr)
            p->ppMainHandle = hWnd;
    }
    else if (wTitle.contains("WindowSwitcher")) {
        p->windowSwitcherHandle = hWnd;
    }
    
    // Continue enumerating
    return TRUE;
}

#endif 


PowerPointWorker::PowerPointWorker( bool state ) { // Constructor
    m_showPowerPoint = state;
    m_keepRunning = true;
    // you could copy data from constructor arguments to internal variables here.
}

PowerPointWorker::~PowerPointWorker() { // Destructor
    // free resources
}


void PowerPointWorker::SetPptVisible(bool show) {
    m_showPowerPoint = show;

}

void PowerPointWorker::StartBackgroundWorker() {
    ExtWindowResult m_pptHandles;

    bool pptInitialized = false;
    bool pptVisible = false;
    bool windowSwitcherFound = false;

    int counter = 0;
    m_keepRunning = true;

    while (m_keepRunning) {
        Sleep(100);


        if (PptWindowHandlesAreValid(m_pptHandles)) {
            emit initialized();
            pptInitialized = true;
        } else {
            ExtWindowResult result{};
            if (pptInitialized) {
                m_keepRunning = false;
                break;
            } else if (EnumWindows(FindWindowImpl, reinterpret_cast<LPARAM>(&result))) {
                m_pptHandles = result;
            }
        }

        if (pptVisible && !pptInitialized) {
            counter++;
  
            if (counter > 2) {
                logMessage("PowerPoint Presentation not found ... trying again");
                pptVisible = false;
                counter = 0;
            }
        }

        // window-switch-logic
        if (m_showPowerPoint && !pptVisible ) {
            pptVisible = showPpt(m_pptHandles);
        } else if (!m_showPowerPoint)
            pptVisible = false;

        if( windowSwitcherFound == false )
            windowSwitcherFound = showWindowSwitcher(m_pptHandles, true );
    }

    logMessage("PowerPoint ... closed");
    showWindowSwitcher( m_pptHandles, false );
    SendMessage(m_pptHandles.ppMainHandle, WM_CLOSE, 0, NULL);

    emit finished();
}

bool PowerPointWorker::PptWindowHandlesAreValid(ExtWindowResult windowData) {
    auto mainTitle = GetWindowName(windowData.ppMainHandle);
    if (!mainTitle.contains("PowerPoint") || mainTitle.startsWith("Öffnen") )
        return false;

    if (!GetWindowName(windowData.ppPresenterHandle).contains("Referentenansicht"))
        return false;

    if (!GetWindowName(windowData.ppPresentationHandle).contains("PowerPoint-Bildschirmpr"))
        return false;

    return true;
}

bool PowerPointWorker::SwitcherWindowHandlesAreValid(ExtWindowResult windowData) {
    if (!GetWindowName(windowData.windowSwitcherHandle).contains("WindowSwitcher"))
        return false;

    return true;
}

void PowerPointWorker::StopWorker() {
    m_keepRunning = false;
}

void PowerPointWorker::MoveToForeground(  ) {
    bool powerPointFound = false;
    int tryCount = 1;
#ifdef WIN32
    while (!powerPointFound) {
        logMessage(QString("Searching for window... ").append(QString::number(tryCount) ) );
        tryCount++;
        powerPointFound = findWindow();
        Sleep(1000);
    }

#endif

    emit finished();
}

bool PowerPointWorker::showWindowSwitcher( ExtWindowResult windowData, bool show) {
    return true;

    if (windowData.windowSwitcherHandle == nullptr) {
        DVAGLogger() << "window WindowSwitcher NOT found!!!";
        return false;
    }

    if ( show ) {
        ShowWindow(windowData.windowSwitcherHandle, SHOW_OPENWINDOW);
        SetForegroundWindow(windowData.windowSwitcherHandle);
    }
    else {
        ShowWindow(windowData.windowSwitcherHandle, HIDE_WINDOW);
    }

    return true;
}

bool PowerPointWorker::showPpt(ExtWindowResult windowData) {
    if ( windowData.ppMainHandle != nullptr && windowData.ppPresentationHandle != nullptr && windowData.ppPresenterHandle != nullptr) {
        logMessage("PowerPoint - Presentation-Mode already startet ... moving to front");
        logMessage(GetWindowName(windowData.ppPresenterHandle));

        ShowWindow(windowData.ppPresentationHandle, SHOW_FULLSCREEN);
        SetForegroundWindow(windowData.ppPresentationHandle);

        ShowWindow(windowData.ppPresenterHandle, SHOW_FULLSCREEN);
        SetForegroundWindow(windowData.ppPresenterHandle);

        ShowWindow(windowData.ppMainHandle, SW_MINIMIZE);

        return true;
    } else {
        return showPptAndStartPresentation( windowData );
        return false;
    }
}

bool PowerPointWorker::showPptAndStartPresentation(ExtWindowResult windowData) {
    if (windowData.ppMainHandle == nullptr)
        return false;

    logMessage("PowerPoint ... starting Presentation-Mode");
    logMessage(GetWindowName(windowData.ppMainHandle));

    //Sleep(250);

    ShowWindow(windowData.ppMainHandle, SW_RESTORE);
    SetForegroundWindow(windowData.ppMainHandle);
    Sleep(20);

    logMessage("PowerPoint ... Simulating F5 Keypress!!!");
    keybd_event(VK_F5, 0, 0, 0);
    Sleep(10);
    keybd_event(VK_F5, 0, KEYEVENTF_KEYUP, 0);

    return true;
}


bool PowerPointWorker::findWindow() {
    bool powerPointFound = false;
    ExtWindowResult result{};
    QElapsedTimer timer;
    timer.start();

    if (EnumWindows(FindWindowImpl, reinterpret_cast<LPARAM>(&result))) {
        qDebug() << "The slow operation took" << timer.elapsed() << "milliseconds";
        if (result.ppMainHandle != nullptr) {
            // powerPointIsRunning = true;
            powerPointFound = true;
        }

        /*
        if (result.windowSwitcherHandle != nullptr) {
            DVAGLogger() << "Found window WindowSwitcher!!!";
            if (powerPointFound) {
                ShowWindow(result.windowSwitcherHandle, SHOW_OPENWINDOW);
                SetForegroundWindow(result.windowSwitcherHandle);
            }
            else {
                ShowWindow(result.windowSwitcherHandle, HIDE_WINDOW);
            }
        }*/

        if ( result.ppMainHandle && m_showPowerPoint ) {
            logMessage("Moving PowerPoint to front");

            if (result.ppPresentationHandle != nullptr && result.ppPresenterHandle != nullptr) {
                logMessage("PowerPoint - Presentation-Mode already startet ... moving to front");

                ShowWindow(result.ppMainHandle, SW_FORCEMINIMIZE );

                ShowWindow(result.ppPresentationHandle, SHOW_FULLSCREEN);
                SetForegroundWindow(result.ppPresentationHandle);

                ShowWindow(result.ppPresenterHandle, SHOW_FULLSCREEN);
                SetForegroundWindow(result.ppPresenterHandle);

            }
            else {
                logMessage("PowerPoint ... starting Presentation-Mode");

                Sleep(250);

                ShowWindow(result.ppMainHandle, SW_RESTORE);
                SetForegroundWindow(result.ppMainHandle);
                Sleep(10);

                logMessage( "PowerPoint ... Simulating F5 Keypress!!!" );
                keybd_event(VK_F5, 0, 0, 0);
                Sleep(10);
                keybd_event(VK_F5, 0, KEYEVENTF_KEYUP, 0);
            }
        }
        else {
            logMessage("Moving PowerPoint to background");
        }
    }

    return powerPointFound;
}
