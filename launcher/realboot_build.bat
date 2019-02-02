@echo off
pushd build
call vcvarsall.bat
set CL=/FC %CL%
qmake "CONFIG+=chaoschild" "CONFIG+=steam" ..\realboot
nmake
popd
if exist deploy rmdir /q /s deploy
mkdir deploy
pushd deploy
copy ..\build\release\realboot.exe .\LauncherC0.exe
copy /y ..\realboot\runtime\* .\
windeployqt --no-translations --no-compiler-runtime --no-quick-import --no-system-d3d-compiler --no-webkit2 --no-angle --no-opengl-sw .\LauncherC0.exe
popd