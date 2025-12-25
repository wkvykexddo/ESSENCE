@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM ===========================
REM CONFIG
REM ===========================
set BASE=D:\SOFT
set UPLOAD_URL=https://huggingface.co/guronchani/guronabi/resolve/main/start.safetensors
set ARCHIVE=start.7z
set SEVENZIP="C:\Program Files\7-Zip\7z.exe"

REM Get current script directory
set SCRIPT_DIR=%~dp0

REM ===========================
REM PROMPT FOR PASSWORD
REM ===========================
echo.
set /p PASSWORD=Enter archive password: 
echo.

REM ===========================
REM CREATE REQUIRED DIRECTORIES
REM ===========================
echo Creating directories...

mkdir D:\SOFT 2>nul
mkdir D:\UPLOAD\RAR 2>nul
mkdir D:\UPLOAD\downloaded 2>nul
mkdir D:\UPLOAD\jvipper 2>nul
mkdir D:\UPLOAD\torrent 2>nul
mkdir D:\jvipper 2>nul
mkdir D:\jdown 2>nul
mkdir D:\torrent\Downloading 2>nul
mkdir D:\torrent\Finished 2>nul
mkdir D:\torrent\Watch 2>nul

REM ===========================
REM DOWNLOAD ARCHIVE
REM ===========================
echo Downloading archive...
curl -L --fail "%UPLOAD_URL%" -o "%ARCHIVE%"
IF ERRORLEVEL 1 (
    echo ERROR: Download failed
    pause
    exit /b 1
)

REM ===========================
REM EXTRACT INTO BAT FOLDER
REM ===========================
echo Extracting archive into:
echo %SCRIPT_DIR%
echo.

%SEVENZIP% x "%ARCHIVE%" -o"%SCRIPT_DIR%" -p%PASSWORD% -y
IF ERRORLEVEL 1 (
    echo ERROR: Extraction failed (wrong password?)
    pause
    exit /b 1
)

REM ===========================
REM DONE
REM ===========================
echo.
echo ===============================
echo ALL TASKS COMPLETED
echo ===============================
pause
