@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem -------- Parameter constants (edit these) --------
set "CSPROJ_PATH=%~dp0..\..\Application\Ypdf.CommandLine\Ypdf.CommandLine.csproj"
set "PUBLISH_CONFIG=Release"
set "PUBLISH_FRAMEWORK=net10.0"
set "PUBLISH_RUNTIME_ID=win-x64"
set "PUBLISH_SELF_CONTAINED=true"

rem -------- Internal directories --------
set "SCRIPT_DIR=%~dp0"
set "OUT_DIR=%SCRIPT_DIR%\sources"
set "BIN_DIR=%OUT_DIR%\bin"

if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"

rem -------- Publish application --------
if not exist "%CSPROJ_PATH%" (
  echo error: .csproj not found: "%CSPROJ_PATH%" 1>&2
  exit /b 1
)

dotnet publish ^
  "%CSPROJ_PATH%" ^
  --configuration "%PUBLISH_CONFIG%" ^
  --framework "%PUBLISH_FRAMEWORK%" ^
  --runtime "%PUBLISH_RUNTIME_ID%" ^
  --self-contained "%PUBLISH_SELF_CONTAINED%" ^
  --output "%OUT_DIR%"

if errorlevel 1 exit /b %ERRORLEVEL%

rem -------- Copy launcher --------
if not exist "%SCRIPT_DIR%ypdf.cmd" (
  echo error: launcher ypdf.cmd not found: "%SCRIPT_DIR%ypdf.cmd" 1>&2
  exit /b 1
)

copy /Y "%SCRIPT_DIR%ypdf.cmd" "%BIN_DIR%\ypdf.cmd" >nul

if errorlevel 1 (
  echo error: failed to copy "%SCRIPT_DIR%ypdf.cmd" to "%BIN_DIR%\ypdf.cmd" 1>&2
  exit /b 1
)

exit /b 0