@echo off
setlocal

set "EXE=%~dp0\..\ypdf.exe"
"%EXE%" %*

endlocal
