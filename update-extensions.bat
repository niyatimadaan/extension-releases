@echo off
REM ============================================
REM ChillSubs extensions - download / update (Windows)
REM ============================================
REM Downloads the latest zip, removes the old copies and extracts the new ones to:
REM   %USERPROFILE%\chillsubs-extensions\pagecrawl-lookup
REM   %USERPROFILE%\chillsubs-extensions\submittable-importer
REM First time: chrome://extensions -> Developer mode -> Load unpacked -> pick each folder.
REM After updates: click the reload icon on each extension in chrome://extensions.

setlocal
set "ZIP_URL=https://raw.githubusercontent.com/niyatimadaan/extension-releases/main/chillsubs-extensions.zip"
set "INSTALL_DIR=%USERPROFILE%\chillsubs-extensions"
set "TMP_ZIP=%TEMP%\chillsubs-extensions.zip"

echo Downloading latest extensions...
curl -fL --retry 3 -o "%TMP_ZIP%" "%ZIP_URL%"
if errorlevel 1 (
    echo Download failed. Existing extensions were left untouched.
    exit /b 1
)

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

echo Removing old versions...
if exist "%INSTALL_DIR%\pagecrawl-lookup" rmdir /s /q "%INSTALL_DIR%\pagecrawl-lookup"
if exist "%INSTALL_DIR%\submittable-importer" rmdir /s /q "%INSTALL_DIR%\submittable-importer"
if exist "%INSTALL_DIR%\VERSION.txt" del /q "%INSTALL_DIR%\VERSION.txt"

echo Extracting...
tar -xf "%TMP_ZIP%" -C "%INSTALL_DIR%"
if errorlevel 1 (
    echo Extraction failed.
    del /q "%TMP_ZIP%"
    exit /b 1
)
del /q "%TMP_ZIP%"

echo.
echo Done. Extensions are in: %INSTALL_DIR%
if exist "%INSTALL_DIR%\VERSION.txt" (
    set /p BUILD=<"%INSTALL_DIR%\VERSION.txt"
)
if defined BUILD echo Build: %BUILD%
echo Now open chrome://extensions and click reload on both extensions.
echo (First time: enable Developer mode, then "Load unpacked" and pick each folder.)
endlocal
pause
