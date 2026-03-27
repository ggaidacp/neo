REM Build QT 6.7.1
REM Author GGI
REM DATE: 17.06.2024

@echo off
cls
echo %DATE% %TIME% build starts ...
echo ###############################################################################################################################################################
echo Preparing output directory...
set USER_DIR=C:\Users\Thanos
set OUTPUT_DIR=%USER_DIR%\projekte\neo\build\build-DVAG_Presenter-Desktop_Qt_6_7_1_MSVC2019_64bit-Debug\
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
rem %QT_MAKE%qmake.exe %PROJECT_SMTP_DIR%\SMTPEmail.pro CONFIG+=release CONFIG-=debug
%QT_MAKE%qmake.exe %PROJECT_DIR%\DVAG_Presenter.pro CONFIG-=release CONFIG+=debug

echo ###############################################################################################################################################################
echo Compiling...

nmake debug

echo ###############################################################################################################################################################
echo Adding required Qt libraries...

%QT_MAKE%\windeployqt.exe --qmldir %PROJECT_DIR% %OUTPUT_DIR%debug\

echo ###############################################################################################################################################################
echo Removing intermediate files...

del %OUTPUT_DIR%debug\*.cpp %OUTPUT_DIR%debug\*.h
%OUTPUT_DIR%debug\*.obj %OUTPUT_DIR%Makefile
%OUTPUT_DIR%Makefile.* %OUTPUT_DIR%.qmake.stash
%OUTPUT_DIR%*.rc %OUTPUT_DIR%*.qrc

echo ###############################################################################################################################################################
echo Adding further required DLLs...

copy %PROJECT_DIR%\lib\SMTPEmail1.dll %OUTPUT_DIR%debug\ /y
xcopy %PROJECT_DIR%\data %OUTPUT_DIR%debug\data\ /sy
copy C:\git\dvag-praesentations-software\bin\*.* %OUTPUT_DIR%debug\data\
rem copy C:\Qt5\Qt5.15.2\OpenSSL-Win64\*.dll %OUTPUT_DIR%debug\
echo copy open ssl dlls for mail client functions
copy C:\Qt5\Tools\QtCreator\bin\libssl-1_1-x64.dll  %OUTPUT_DIR%debug\ /y
copy C:\Qt5\Tools\QtCreator\bin\libcrypto-1_1-x64.dll  %OUTPUT_DIR%debug\ /y

echo no idea, who needs
copy C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Redist\MSVC\v143\vc_redist.x64.exe %OUTPUT_DIR%debug
copy %PROJECT_DIR%\man\*.* %OUTPUT_DIR%debug
rem copy C:\git\dvag-praesentations-software\bin\*.* %OUTPUT_DIR%debug\data\ /y

echo ###############################################################################################################################################################
echo Organizing package folder structure...

rem del %OUTPUT_DIR%debug\vc_redist.x64.exe
rmdir %OUTPUT_DIR%debug\ /s /q
rmdir %OUTPUT_DIR%DVAG_Presenter\ /s /q

xcopy %OUTPUT_DIR%debug %OUTPUT_DIR%DVAG_Presenter\ /sy

echo ###############################################################################################################################################################
echo Cleanup...

rmdir %OUTPUT_DIR%debug\ /s /q

cd %OUTPUT_DIR%DVAG_Presenter
del *.obj
rem "C:\Program Files\7-Zip\7z.exe" a -r -mx9 %OUTPUT_DIR%DVAG_Presenter.zip %OUTPUT_DIR%*
rem copy %OUTPUT_DIR%DVAG_Presenter.zip C:\Projekte\bin\dvag-presenter\
echo  %DATE% %TIME% FINISHED.

cd %PROJECT_DIR%\scripts

