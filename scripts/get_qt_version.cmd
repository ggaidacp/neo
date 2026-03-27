@echo off
setlocal enabledelayedexpansion

rem -- Pfad zur .pro Datei anpassen --
set PRO_FILE=..\DVAG_Presenter.pro

rem -- VERSION Zeile suchen --
for /f "tokens=2 delims== " %%A in ('findstr /B "VERSION" "%PRO_FILE%"') do (
    set VERSION=%%A
)

echo Gefundene Version: %VERSION%

endlocal