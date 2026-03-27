@echo off
cls
echo ###############################################################################################################################################################
echo Preparing output directory...

D:
cd \

rmdir D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\ /s /q

mkdir D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\
cd D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\

echo ###############################################################################################################################################################
echo Starting to build the project:
echo Preparing build...

D:\Qt\Qt5.15.3\bin\qmake.exe ..\dvag-praesentations-software CONFIG+=release CONFIG-=debug

echo ###############################################################################################################################################################
echo Compiling...

nmake release

echo ###############################################################################################################################################################
echo Adding required Qt libraries...

D:\Qt\Qt5.15.3\bin\windeployqt.exe --qmldir D:\git\dvag-praesentations-software D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\release\

echo ###############################################################################################################################################################
echo Removing intermediate files...

del D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\release\*.cpp D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\release\*.h D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\release\*.obj D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\Makefile D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\Makefile.* D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\.qmake.stash D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\*.rc D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\*.qrc

echo ###############################################################################################################################################################
echo Adding further required DLLs...

copy D:\git\dvag-praesentations-software\SmtpClient-for-Qt\bin\release\SMTPEmail.dll D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\release\ /y
xcopy D:\git\dvag-praesentations-software\data D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\release\data\ /sy
copy D:\Qt\Qt5.15.3\OpenSSL-Win64\*.dll D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\release\
copy D:\git\dvag-praesentations-software\man\*.* D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\
copy D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\release\vc_redist.x64.exe D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\
copy D:\git\dvag-praesentations-software\bin\*.* D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\release\data\ /y

echo ###############################################################################################################################################################
echo Organizing package folder structure...

del D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\release\vc_redist.x64.exe
rmdir D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\debug\ /s /q
rmdir D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\DVAG_Presenter\ /s /q

xcopy D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\release D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\DVAG_Presenter\ /sy

echo ###############################################################################################################################################################
echo Cleanup...

rmdir D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\release\ /s /q

cd D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\
"C:\Program Files\7-Zip\7z.exe" a -r -mx9 D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\DVAG_Presenter.zip D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\*
copy D:\git\build-DVAG_Presenter-Desktop_Qt_5_12_10_MSVC2017_64bit-Release\DVAG_Presenter.zip Y:\Projekte\bin\dvag-presenter\

echo FINISHED.

