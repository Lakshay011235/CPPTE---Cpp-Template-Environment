@echo off
:: Enable Virtual Terminal Processing for colored output
setlocal EnableDelayedExpansion

:: Check Windows version
ver | findstr /r "10\..*" >nul
if %errorlevel% neq 0 (
    echo This script requires Windows 10 or later.
    exit /b
)

:: Enable virtual terminal processing
for /f "tokens=2 delims=:." %%i in ('ver') do set /a version=%%i
if %version% GEQ 10 (
    >nul 2>&1 (reg query "HKCU\Console" /v VirtualTerminalLevel) && (
        reg add "HKCU\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f
    )
)

:: Define ANSI color codes
set "ESC="
set "RED=%ESC%[31m"
set "GREEN=%ESC%[32m"
set "YELLOW=%ESC%[33m"
set "BLUE=%ESC%[34m"
set "RESET=%ESC%[0m"

:: Use PowerShell to open a file dialog and store the selected file path
for /f "delims=" %%I in ('powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog; $openFileDialog.Filter = 'C++ Files (*.cpp)|*.cpp|All Files (*.*)|*.*'; $openFileDialog.ShowDialog() | Out-Null; $openFileDialog.FileName"') do (
    set "cpp_file=%%I"
)

if not exist "%cpp_file%" (
    echo File not found: %cpp_file%
    goto end
)
echo %RED%Confirming cpp file: %GREEN%%cpp_file%%RESET%
pause

REM Extract filename without extension and directory
for %%a in ("%cpp_file%") do (
    set "filename=%%~na"
    set "filedir=%%~dpa"
)

REM Generate test file name with absolute path
set "test_file=%filedir%test_%filename%.txt"

echo %BLUE%Confirming test file: %GREEN%%test_file%%RESET%
pause

if not exist "%test_file%" (

    echo File not found: %test_file%
    goto end
)

:: Compile the C++ file
g++ "%cpp_file%" -o "%filedir%output.exe"
if errorlevel 1 (
    echo Compilation failed.
    goto end
)

:: Run the compiled executable with the test file
"%filedir%output.exe" "%test_file%"

echo %YELLOW%Check the log file for further information%RESET%
:end
pause
