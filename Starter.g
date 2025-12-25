@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM ===========================
REM CONFIG
REM ===========================
SET BASE=D:\SOFT
SET TARGET=%BASE%\gramm
SET UPLOAD_URL=https://huggingface.co/guronchani/guronabi/resolve/main/gramm.safetensors
SET ARCHIVE=%BASE%\gramm.7z
SET PASSWORD=protocol
SET SEVENZIP="C:\Program Files\7-Zip\7z.exe"

SET INSTALL_DIR=%TARGET%\INSTALL
SET TC_INI_SRC=%TARGET%\WINCMD.INI
SET TC_INI_DST=C:\Users\RDP\AppData\Roaming\GHISLER
SET WALLPAPER=%TARGET%\background.jpg

REM ===========================
REM STEP 1: PREPARE FOLDERS
REM ===========================
echo Creating folders...
if not exist "%BASE%" mkdir "%BASE%"
if not exist "%TARGET%" mkdir "%TARGET%"
if not exist "%TC_INI_DST%" mkdir "%TC_INI_DST%"

REM ===========================
REM STEP 1A: CREATE UPLOAD / TORRENT STRUCTURE
REM ===========================
echo Creating upload and torrent folder structure...

for %%D in (
    D:\UPLOAD\RAR
    D:\UPLOAD\downloaded
    D:\UPLOAD\jvipper
    D:\UPLOAD\torrent
    D:\jvipper
    D:\jdown
    D:\torrent\Downloading
    D:\torrent\Finished
    D:\torrent\Watch
) do (
    if not exist "%%D" mkdir "%%D"
)

REM ===========================
REM STEP 2: DOWNLOAD ARCHIVE
REM ===========================
echo Downloading archive...
curl -L --fail "%UPLOAD_URL%" -o "%ARCHIVE%"
IF ERRORLEVEL 1 (
    echo ERROR: Download failed
    cmd /k
    exit /b 1
)

REM ===========================
REM STEP 3: EXTRACT INTO D:\SOFT\gramm
REM ===========================
echo Extracting into %TARGET% ...
%SEVENZIP% x "%ARCHIVE%" -o"%TARGET%" -p%PASSWORD% -y
IF ERRORLEVEL 1 (
    echo ERROR: Extraction failed
    cmd /k
    exit /b 1
)

REM ===========================
REM STEP 3A: MOVE RAR SCRIPTS TO UPLOAD
REM ===========================
echo Moving RAR batch scripts...

if exist "%TARGET%\Rar-sub-split-500.bat" (
    move /Y "%TARGET%\Rar-sub-split-500.bat" "D:\UPLOAD\Rar-sub-split-500.bat"
)

if exist "%TARGET%\Rar-sub-jvip.bat" (
    move /Y "%TARGET%\Rar-sub-jvip.bat" "D:\UPLOAD\Rar-sub-jvip.bat"
)

REM ===========================
REM STEP 4: MOVE TOTAL COMMANDER CONFIG
REM ===========================
echo Moving WINCMD.INI...
if exist "%TC_INI_SRC%" (
    move /Y "%TC_INI_SRC%" "%TC_INI_DST%\WINCMD.INI"
) else (
    echo WARNING: WINCMD.INI not found
)

REM ===========================
REM STEP 5: SILENT INSTALLS
REM ===========================
echo Installing software...

if exist "%INSTALL_DIR%\acdsee.exe" (
    "%INSTALL_DIR%\acdsee.exe" /S
)

if exist "%INSTALL_DIR%\vlc.exe" (
    "%INSTALL_DIR%\vlc.exe" /S
)

if exist "%INSTALL_DIR%\winfsp.msi" (
    msiexec /i "%INSTALL_DIR%\winfsp.msi" /quiet /norestart
)

if exist "%INSTALL_DIR%\WinRAR.exe" (
    "%INSTALL_DIR%\WinRAR.exe" /S
)

REM ===========================
REM STEP 6: LAUNCH TOTAL COMMANDER
REM ===========================
if exist "D:\SOFT\gramm\portable\Commander\TOTALCMD.EXE" (
    start "" "D:\SOFT\gramm\portable\Commander\TOTALCMD.EXE"
) else (
    echo WARNING: TOTALCMD.EXE not found
)

REM ===========================
REM STEP 7: ENABLE DARK THEME (FORCE APPLY)
REM ===========================
echo Enabling dark theme...

REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" ^
 /v AppsUseLightTheme /t REG_DWORD /d 0 /f

REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" ^
 /v SystemUsesLightTheme /t REG_DWORD /d 0 /f

taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
REG ADD "HKCU\Control Panel\Colors" /v AppsBackground /t REG_SZ /d "32 32 32" /f

REM ===========================
REM STEP 8: SET WALLPAPER
REM ===========================
echo Setting wallpaper...

powershell -NoProfile -ExecutionPolicy Bypass ^
  -Command "$w='D:\SOFT\gramm\background.jpg'; Add-Type 'using System.Runtime.InteropServices; public class W{[DllImport(\"user32.dll\")] public static extern bool SystemParametersInfo(int a,int b,string c,int d);}'; [W]::SystemParametersInfo(20,0,$w,3)"

REM ===========================
REM DONE
REM ===========================
echo.
echo ===============================
echo ALL TASKS COMPLETED
echo ===============================
cmd /k
