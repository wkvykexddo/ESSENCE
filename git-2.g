@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM ===========================
REM CONFIG
REM ===========================
SET BASE=D:\SOFT
SET TARGET=%BASE%\gramm
SET ARCHIVE=%BASE%\gramm.7z
SET DOWNLOAD_URL=https://huggingface.co/guronchani/guronabi/resolve/main/short.safetensors
SET PASSWORD=protocol
SET SEVENZIP="C:\Program Files\7-Zip\7z.exe"

REM List of scripts to run
SET SCRIPTS=copy20.bat copy26.bat

REM ===========================
REM STEP 1: PREPARE FOLDERS
REM ===========================
echo [*] Preparing folders...

if not exist "%BASE%" mkdir "%BASE%"
if not exist "%TARGET%" mkdir "%TARGET%"

REM ===========================
REM STEP 2: DOWNLOAD ARCHIVE
REM ===========================
echo [*] Downloading archive...
curl -L --fail "%DOWNLOAD_URL%" -o "%ARCHIVE%"
IF ERRORLEVEL 1 (
    echo [!] ERROR: Download failed
    exit /b 1
)

REM ===========================
REM STEP 3: EXTRACT ARCHIVE
REM ===========================
echo [*] Extracting archive to %TARGET% ...

if not exist %SEVENZIP% (
    echo [!] ERROR: 7-Zip not found
    exit /b 1
)

%SEVENZIP% x "%ARCHIVE%" -o"%TARGET%" -p%PASSWORD% -y
IF ERRORLEVEL 1 (
    echo [!] ERROR: Extraction failed
    exit /b 1
)

REM ===========================
REM STEP 4: LAUNCH SCRIPTS (DETACHED)
REM ===========================
echo [*] Launching post-install scripts...

for %%S in (%SCRIPTS%) do (
    set SCRIPT_PATH=%TARGET%\%%S
    if exist "!SCRIPT_PATH!" (
        echo [*] Starting !SCRIPT_PATH! ...
        start "" cmd.exe /c "!SCRIPT_PATH!"
    ) else (
        echo [!] WARNING: %%S not found
    )
)

REM ===========================
REM DONE (DO NOT BLOCK)
REM ===========================
echo [*] Starter script finished successfully
exit /b 0
