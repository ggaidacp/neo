REM Build QT 5.15.2
REM Author GGI
REM DATE: 17.06.2024

@echo off
cls
echo %DATE% %TIME% build starts ...
echo ###############################################################################################################################################################
echo Preparing output directory...
set USER_DIR=C:\Users\Thanos
set OUTPUT_DIR=%USER_DIR%\projekte\neo\build\build-DVAG_Presenter-Desktop_Qt_5_15_2_MSVC2019_64bit-Release\
set QT_MAKE=C:\Qt515\5.15.2\msvc2019_64\bin\
set PROJECT_DIR=%USER_DIR%\projekte\neo\dvag_praesenter
set VERSION=%1

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

copy %PROJECT_DIR%\lib\SMTPEmail.dll %OUTPUT_DIR%release\ /y
xcopy %PROJECT_DIR%\data %OUTPUT_DIR%release\data\ /sy
copy C:\git\dvag-praesentations-software\bin\*.* %OUTPUT_DIR%release\data\
rem copy C:\Qt5\Qt5.15.2\OpenSSL-Win64\*.dll %OUTPUT_DIR%release\
echo copy open ssl dlls for mail client functions
copy C:\Qt5\Tools\QtCreator\bin\libssl-1_1-x64.dll  %OUTPUT_DIR%release\ /y
copy C:\Qt5\Tools\QtCreator\bin\libcrypto-1_1-x64.dll  %OUTPUT_DIR%release\ /y

echo no idea, who needs
copy C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Redist\MSVC\v143\vc_redist.x64.exe %OUTPUT_DIR%release
copy %PROJECT_DIR%\man\*.* %OUTPUT_DIR%release
rem copy C:\git\dvag-praesentations-software\bin\*.* %OUTPUT_DIR%release\data\ /y

echo ###############################################################################################################################################################
echo Organizing package folder structure...

rem del %OUTPUT_DIR%release\vc_redist.x64.exe
rmdir %OUTPUT_DIR%debug\ /s /q
rmdir %OUTPUT_DIR%DVAG_Presenter\ /s /q

xcopy %OUTPUT_DIR%release %OUTPUT_DIR%DVAG_Presenter\ /sy

echo ###############################################################################################################################################################
echo Cleanup...

rmdir %OUTPUT_DIR%release\ /s /q

cd %OUTPUT_DIR%DVAG_Presenter
del *.obj
rem tar -a -c -f %OUTPUT_DIR%DVAG_Presenter%VERSION%.zip -C %OUTPUT_DIR%DVAG_Presenter .
rem "C:\Program Files\7-Zip\7z.exe" a -r -mx9 %OUTPUT_DIR%DVAG_Presenter.zip %OUTPUT_DIR%*
rem copy %OUTPUT_DIR%DVAG_Presenter.zip C:\Projekte\bin\dvag-presenter\
echo  %DATE% %TIME% FINISHED.

cd %PROJECT_DIR%\scripts
