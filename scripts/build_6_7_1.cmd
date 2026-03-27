REM Build QT 6.7.1
REM Author GGI
REM DATE: 17.06.2024

@echo off

cls

setlocal enabledelayedexpansion

rem -- Pfad zur .pro Datei anpassen --
set PRO_FILE=..\DVAG_Presenter.pro

rem -- VERSION Zeile suchen --
for /f "tokens=2 delims== " %%A in ('findstr /B "VERSION" "%PRO_FILE%"') do (
    set VERSION=%%A
)

echo Gefundene Version: %VERSION%



echo %DATE% %TIME% build starts ...
echo ###############################################################################################################################################################
echo Preparing output directory...
set USER_DIR=C:\Users\Thanos
set OUTPUT_DIR=%USER_DIR%\projekte\neo\build\build-NEO-6_7_1\
set QT_MAKE=C:\Qt5\6.7.1\msvc2019_64\bin\
set PROJECT_DIR=%USER_DIR%\projekte\neo\dvag_praesenter

C:
cd \

rmdir %OUTPUT_DIR% /s /q

mkdir %OUTPUT_DIR%
cd %OUTPUT_DIR%

echo ###############################################################################################################################################################
echo Starting to build the project:
echo Preparing build...
%QT_MAKE%qmake.exe %PROJECT_DIR%\DVAG_Presenter.pro CONFIG+=release CONFIG-=debug

echo ###############################################################################################################################################################
echo Compiling...

nmake release

echo ###############################################################################################################################################################
echo Adding required Qt libraries...

%QT_MAKE%\windeployqt.exe --qmldir %PROJECT_DIR% %OUTPUT_DIR%release\

echo ###############################################################################################################################################################
echo Removing intermediate files...

del %OUTPUT_DIR%release\*.cpp %OUTPUT_DIR%release\*.h
%OUTPUT_DIR%release\*.obj %OUTPUT_DIR%Makefile
%OUTPUT_DIR%Makefile.* %OUTPUT_DIR%.qmake.stash
%OUTPUT_DIR%*.rc %OUTPUT_DIR%*.qrc

echo ###############################################################################################################################################################
echo Adding further required DLLs...
xcopy %PROJECT_DIR%\data %OUTPUT_DIR%release\data\ /sy
echo copy open ssl dlls for mail client functions

echo no idea, who needs
copy C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Redist\MSVC\v143\vc_redist.x64.exe %OUTPUT_DIR%release
copy %PROJECT_DIR%\man\*.* %OUTPUT_DIR%release

echo ###############################################################################################################################################################
echo Organizing package folder structure...

rmdir %OUTPUT_DIR%debug\ /s /q
rmdir %OUTPUT_DIR%DVAG_Presenter\ /s /q

xcopy %OUTPUT_DIR%release %OUTPUT_DIR%DVAG_Presenter\ /sy

echo ###############################################################################################################################################################
echo Cleanup...

rmdir %OUTPUT_DIR%release\ /s /q

cd %OUTPUT_DIR%DVAG_Presenter
del *.obj
echo  %DATE% %TIME% FINISHED.
cd %PROJECT_DIR%\scripts
echo finally sign with certificate ...
powershell -ExecutionPolicy Bypass -File .\SigniereMitSelfSignedCert.ps1
powershell -Command "Compress-Archive -Path '%OUTPUT_DIR%DVAG_Presenter' -DestinationPath '%USER_DIR%\Downloads\DVAG_Presenter-%VERSION%.zip' -Force"
endlocal