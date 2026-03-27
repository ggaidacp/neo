#pragma once

#ifdef WIN32
#include <Windows.h>
#include <WinUser.h>
#include <conio.h>
#include <comdef.h>
#include <shellapi.h>
#include <ShObjIdl.h>
#include <initguid.h>
#include <objbase.h>
#include <process.h>
#include <TlHelp32.h>
#include <WinBase.h>
#include <Msi.h>

#include <QObject>



struct FindWindowData {
    FindWindowData(TCHAR const* windowTitle)
        : WindowTitle(windowTitle)
        , ResultHandle(nullptr)
    {
    }

    std::basic_string<TCHAR> WindowTitle;
    HWND ResultHandle;
};


struct ExtWindowResult {
    ExtWindowResult() : ppMainHandle(nullptr), ppPresentationHandle(nullptr), ppPresenterHandle(nullptr), windowSwitcherHandle(nullptr) {

    };

    HWND ppPresentationHandle;
    HWND ppPresenterHandle;
    HWND windowSwitcherHandle;
    HWND ppMainHandle;
};


#endif


class PowerPointWorker : public QObject {
    Q_OBJECT
public:
    PowerPointWorker( bool state );
    ~PowerPointWorker();
public slots:
    void MoveToForeground();
    void StartBackgroundWorker();
    void SetPptVisible(bool show);
    void StopWorker();
signals:
    void initialized();
    void finished();
    void logMessage(QString msg);
private:
    bool m_showPowerPoint;
    bool m_keepRunning;

    bool findWindow();
    bool PptWindowHandlesAreValid(ExtWindowResult windowData);
    bool SwitcherWindowHandlesAreValid(ExtWindowResult windowData);
    bool showWindowSwitcher(ExtWindowResult windowData, bool show);
    bool showPpt(ExtWindowResult windowData);
    bool showPptAndStartPresentation(ExtWindowResult windowData);
    // add your variables here
};