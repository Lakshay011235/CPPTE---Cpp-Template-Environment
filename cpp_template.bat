@echo off
setlocal EnableDelayedExpansion

:: Checking Windows version...
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
set "MAGENTA=%ESC%[35m"
set "CYAN=%ESC%[36m"
set "LIGHT_GREY=%ESC%[37m"
set "GREY=%ESC%[90m"
set "LIGHT_RED=%ESC%[91m"
set "LIGHT_GREEN=%ESC%[92m"
set "LIGHT_YELLOW=%ESC%[93m"
set "LIGHT_BLUE=%ESC%[94m"
set "LIGHT_MAGENTA=%ESC%[95m"
set "LIGHT_CYAN=%ESC%[96m"
set "WHITE=%ESC%[97m"
set "BOLD=%ESC%[1m"
set "UNDERLINE=%ESC%[4m"
set "RESET=%ESC%[0m"

echo =======================================================================================================
echo %YELLOW%
echo    __    _____   _____      _______   ___   _      _  _____  _        __    _______   ___   
echo  / ___^) ^|  _  ^) ^|  _  ^)    ^(__   __^)/ ____^)^|  \  /  ^|^|  _  ^)^| ^|     / __ \ ^(__   __^)/ ____^)              
echo ^| ^|     ^| ^|_^| ^) ^| ^|_^| ^)       ^| ^|   ^| ^|__  ^|   \/   ^|^| ^|_^| ^)^| ^|    ^| ^|__^| ^|   ^| ^|   ^| ^|__      
echo ^| ^|     ^|  ___^) ^|  ___^)       ^| ^|   ^|  __^) ^| ^|\  /^| ^|^|  ___^)^| ^|    ^|  __  ^|   ^| ^|   ^|  __^)     
echo ^| ^|___  ^| ^|     ^| ^|           ^| ^|   ^| ^|___ ^| ^| \/ ^| ^|^| ^|    ^| ^|___ ^| ^|  ^| ^|   ^| ^|   ^| ^|___      
echo  \____^) ^|_^|     ^|_^|           ^|_^|    \____^)^|_^|    ^|_^|^|_^|    ^|_____^|^|_^|  ^|_^|   ^|_^|    \____^)   
echo %RESET%
echo ------------------------------------------------------------------------------------------------------
echo This script is used to create a new template folder with C++ executable environment
echo Features:
echo    1. Ready-to-use c++ environment
echo    2. Advanced logging and testing support
echo    3. Simple to use input and output txt files for interview like experience
echo ------------------------------------------------------------------------------------------------------
echo %UNDERLINE%Default structure:%RESET%
echo %GREEN%
echo Parent directory
echo ^|
echo +- [filename] ^(Current directory^)
echo ^|   ^|
echo ^|   +- output
echo ^|   ^|  ^| 
echo ^|   ^|  +- output.exe
echo ^|   ^|  +- input.txt
echo ^|   ^|  +- output.txt
echo ^|   ^|  +- output.log
echo ^|   ^|  +- tests.log
echo ^|   ^|
echo ^|   +- README.md
echo ^|   +- test_[filename].cpp
echo ^|   +- [filename].cpp 
echo ^| 
echo +- test_suite.h %RESET%
echo ------------------------------------------------------------------------------------------------------
echo %UNDERLINE%How to use:%RESET%
echo - Select the folder where you want to create the environment
echo - Enter the folder name. Spaces are not be recommended.
echo - Choose whether you want test file.
echo - Choose if you want to have a README file
echo - Choose the input.txt option if you want to have input file
echo - Output file will be availible only if you have chosen input file. Output file will be connected to 
echo   input automatically.
echo - Finally, you can let the script to make a dummy executable and log to verify the install.
echo - %YELLOW%NOTE:%RESET% Incase you want to use a %RED%different template file%RESET%, you can have the
echo   template.cpp file defined in the parent folder you chose earlier.
echo - %YELLOW%NOTE:%RESET% This script is made for Windows 10 and above. If you use linux, you are smart 
echo   enough to change this batch file to your needs.
echo ------------------------------------------------------------------------------------------------------
echo %UNDERLINE%Common Errors:%RESET%
echo Error in making of cpp file: please use the %BLUE%template.cpp%RESET% defined in the comments of this file.
echo Error in compilation of cpp file: please use the %BLUE%test_suite.h%RESET% defined in the comments of this file.
echo Error in dialog box opening: Install powershell ^(recommended^) or ^set the selecterFolder variable 
echo to folderPath in the code ^set ^"selectedFolder=%%folderPath%%^" 
echo ------------------------------------------------------------------------------------------------------
echo %YELLOW%
echo    __    _____   _____      _______   ___   _      _  _____  _        __    _______   ___   
echo  / ___^) ^|  _  ^) ^|  _  ^)    ^(__   __^)/ ____^)^|  \  /  ^|^|  _  ^)^| ^|     / __ \ ^(__   __^)/ ____^)              
echo ^| ^|     ^| ^|_^| ^) ^| ^|_^| ^)       ^| ^|   ^| ^|__  ^|   \/   ^|^| ^|_^| ^)^| ^|    ^| ^|__^| ^|   ^| ^|   ^| ^|__      
echo ^| ^|     ^|  ___^) ^|  ___^)       ^| ^|   ^|  __^) ^| ^|\  /^| ^|^|  ___^)^| ^|    ^|  __  ^|   ^| ^|   ^|  __^)     
echo ^| ^|___  ^| ^|     ^| ^|           ^| ^|   ^| ^|___ ^| ^| \/ ^| ^|^| ^|    ^| ^|___ ^| ^|  ^| ^|   ^| ^|   ^| ^|___      
echo  \____^) ^|_^|     ^|_^|           ^|_^|    \____^)^|_^|    ^|_^|^|_^|    ^|_____^|^|_^|  ^|_^|   ^|_^|    \____^)   
echo %RESET%
echo =======================================================================================================


set "folderPath=C:\"  
set "projectFiles=" %

:: Prompt user for parent folder location...
for /f "delims=" %%a in ('powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog; $folderBrowser.SelectedPath = '%folderPath%'; $folderBrowser.ShowDialog() | Out-Null; echo $($folderBrowser.SelectedPath)"') do (
    set "selectedFolder=%%a"
)

echo %YELLOW%Selected Parent Folder:%RESET% %selectedFolder%
cd %selectedFolder%

:: Check if test_suite.h exists in the parent directory
echo Checking if test_suite.h exists in the parent folder...
if not exist "test_suite.h" (
    echo %YELLOW%test_suite.h does not exist in the parent directory.%RESET%
    echo Creating test_suite.h...

    setlocal DisableDelayedExpansion
    :: Create the header file and write the contents
    echo #include ^<sstream^> >> test_suite.h 2>>nul 
    echo #include ^<iostream^> >> test_suite.h 2>>nul 
    echo #include ^<string^> >> test_suite.h 2>>nul 
    echo #include ^<fstream^> >> test_suite.h 2>>nul 
    echo #include ^<chrono^> >> test_suite.h 2>>nul 
    echo #include ^<ctime^> >> test_suite.h 2>>nul 
    echo #include ^<functional^> >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo #ifdef _WIN32 >> test_suite.h 2>>nul 
    echo #include ^<windows.h^> >> test_suite.h 2>>nul 
    echo #else >> test_suite.h 2>>nul 
    echo #include ^<sys/ioctl.h^> >> test_suite.h 2>>nul 
    echo #include ^<unistd.h^> >> test_suite.h 2>>nul 
    echo #endif >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo // ---------------------------- Color Helper Functions ---------------------------- >> test_suite.h 2>>nul 
    echo namespace Color >> test_suite.h 2>>nul 
    echo { >> test_suite.h 2>>nul 
    echo     enum Code >> test_suite.h 2>>nul 
    echo     { >> test_suite.h 2>>nul 
    echo         FG_RED = 31, >> test_suite.h 2>>nul 
    echo         FG_GREEN = 32, >> test_suite.h 2>>nul 
    echo         FG_YELLOW = 33, >> test_suite.h 2>>nul 
    echo         FG_BLUE = 34, >> test_suite.h 2>>nul 
    echo         FG_MAGENTA = 35, >> test_suite.h 2>>nul 
    echo         FG_CYAN = 36, >> test_suite.h 2>>nul 
    echo         FG_LIGHT_GRAY = 37, >> test_suite.h 2>>nul 
    echo         FG_DEFAULT = 39, >> test_suite.h 2>>nul 
    echo         FG_DARK_GRAY = 90, >> test_suite.h 2>>nul 
    echo         FG_LIGHT_RED = 91, >> test_suite.h 2>>nul 
    echo         FG_LIGHT_GREEN = 92, >> test_suite.h 2>>nul 
    echo         FG_LIGHT_YELLOW = 93, >> test_suite.h 2>>nul 
    echo         FG_LIGHT_BLUE = 94, >> test_suite.h 2>>nul 
    echo         FG_LIGHT_MAGENTA = 95, >> test_suite.h 2>>nul 
    echo         FG_LIGHT_CYAN = 96, >> test_suite.h 2>>nul 
    echo         FG_WHITE = 97, >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         BG_RED = 41, >> test_suite.h 2>>nul 
    echo         BG_GREEN = 42, >> test_suite.h 2>>nul 
    echo         BG_YELLOW = 43, >> test_suite.h 2>>nul 
    echo         BG_BLUE = 44, >> test_suite.h 2>>nul 
    echo         BG_MAGENTA = 45, >> test_suite.h 2>>nul 
    echo         BG_CYAN = 46, >> test_suite.h 2>>nul 
    echo         BG_LIGHT_GRAY = 47, >> test_suite.h 2>>nul 
    echo         BG_DEFAULT = 49, >> test_suite.h 2>>nul 
    echo         BG_DARK_GRAY = 100, >> test_suite.h 2>>nul 
    echo         BG_LIGHT_RED = 101, >> test_suite.h 2>>nul 
    echo         BG_LIGHT_GREEN = 102, >> test_suite.h 2>>nul 
    echo         BG_LIGHT_YELLOW = 103, >> test_suite.h 2>>nul 
    echo         BG_LIGHT_BLUE = 104, >> test_suite.h 2>>nul 
    echo         BG_LIGHT_MAGENTA = 105, >> test_suite.h 2>>nul 
    echo         BG_LIGHT_CYAN = 106, >> test_suite.h 2>>nul 
    echo         BG_WHITE = 107, >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         BOLD = 1, >> test_suite.h 2>>nul 
    echo         UNDERLINE = 4, >> test_suite.h 2>>nul 
    echo         RESET = 0 >> test_suite.h 2>>nul 
    echo     }; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo     class Modifier >> test_suite.h 2>>nul 
    echo     { >> test_suite.h 2>>nul 
    echo         Code code; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo     public: >> test_suite.h 2>>nul 
    echo         Modifier^( Code pCode^) : code^( pCode^) {} >> test_suite.h 2>>nul 
    echo         friend std::ostream ^& >> test_suite.h 2>>nul 
    echo         operator^<^<^( std::ostream ^&os, const Modifier ^&mod^) >> test_suite.h 2>>nul 
    echo         { >> test_suite.h 2>>nul 
    echo             return os ^<^< ^"\033[^" ^<^< mod.code ^<^< ^"m^"; >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo     }; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo     Modifier red^( Color::FG_RED^); >> test_suite.h 2>>nul 
    echo     Modifier green^( Color::FG_GREEN^); >> test_suite.h 2>>nul 
    echo     Modifier yellow^( Color::FG_YELLOW^); >> test_suite.h 2>>nul 
    echo     Modifier blue^( Color::FG_BLUE^); >> test_suite.h 2>>nul 
    echo     Modifier magenta^( Color::FG_MAGENTA^); >> test_suite.h 2>>nul 
    echo     Modifier cyan^( Color::FG_CYAN^); >> test_suite.h 2>>nul 
    echo     Modifier lightGray^( Color::FG_LIGHT_GRAY^); >> test_suite.h 2>>nul 
    echo     Modifier darkGray^( Color::FG_DARK_GRAY^); >> test_suite.h 2>>nul 
    echo     Modifier lightRed^( Color::FG_LIGHT_RED^); >> test_suite.h 2>>nul 
    echo     Modifier lightGreen^( Color::FG_LIGHT_GREEN^); >> test_suite.h 2>>nul 
    echo     Modifier lightYellow^( Color::FG_LIGHT_YELLOW^); >> test_suite.h 2>>nul 
    echo     Modifier lightBlue^( Color::FG_LIGHT_BLUE^); >> test_suite.h 2>>nul 
    echo     Modifier lightMagenta^( Color::FG_LIGHT_MAGENTA^); >> test_suite.h 2>>nul 
    echo     Modifier lightCyan^( Color::FG_LIGHT_CYAN^); >> test_suite.h 2>>nul 
    echo     Modifier white^( Color::FG_WHITE^); >> test_suite.h 2>>nul 
    echo     Modifier def^( Color::FG_DEFAULT^); >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo     Modifier bgRed^( Color::BG_RED^); >> test_suite.h 2>>nul 
    echo     Modifier bgGreen^( Color::BG_GREEN^); >> test_suite.h 2>>nul 
    echo     Modifier bgYellow^( Color::BG_YELLOW^); >> test_suite.h 2>>nul 
    echo     Modifier bgBlue^( Color::BG_BLUE^); >> test_suite.h 2>>nul 
    echo     Modifier bgMagenta^( Color::BG_MAGENTA^); >> test_suite.h 2>>nul 
    echo     Modifier bgCyan^( Color::BG_CYAN^); >> test_suite.h 2>>nul 
    echo     Modifier bgLightGray^( Color::BG_LIGHT_GRAY^); >> test_suite.h 2>>nul 
    echo     Modifier bgDarkGray^( Color::BG_DARK_GRAY^); >> test_suite.h 2>>nul 
    echo     Modifier bgLightRed^( Color::BG_LIGHT_RED^); >> test_suite.h 2>>nul 
    echo     Modifier bgLightGreen^( Color::BG_LIGHT_GREEN^); >> test_suite.h 2>>nul 
    echo     Modifier bgLightYellow^( Color::BG_LIGHT_YELLOW^); >> test_suite.h 2>>nul 
    echo     Modifier bgLightBlue^( Color::BG_LIGHT_BLUE^); >> test_suite.h 2>>nul 
    echo     Modifier bgLightMagenta^( Color::BG_LIGHT_MAGENTA^); >> test_suite.h 2>>nul 
    echo     Modifier bgLightCyan^( Color::BG_LIGHT_CYAN^); >> test_suite.h 2>>nul 
    echo     Modifier bgWhite^( Color::BG_WHITE^); >> test_suite.h 2>>nul 
    echo     Modifier bgDef^( Color::BG_DEFAULT^); >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo     Modifier bold^( Color::BOLD^); >> test_suite.h 2>>nul 
    echo     Modifier underline^( Color::UNDERLINE^); >> test_suite.h 2>>nul 
    echo     Modifier reset^( Color::RESET^); >> test_suite.h 2>>nul 
    echo } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo // --------------------------- Terminal Helper Functions ------------------------ >> test_suite.h 2>>nul 
    echo int getTerminalWidth^( ^) { >> test_suite.h 2>>nul 
    echo #ifdef _WIN32 >> test_suite.h 2>>nul 
    echo     CONSOLE_SCREEN_BUFFER_INFO csbi; >> test_suite.h 2>>nul 
    echo     int columns; >> test_suite.h 2>>nul 
    echo     GetConsoleScreenBufferInfo^( GetStdHandle^( STD_OUTPUT_HANDLE^), ^&csbi^); >> test_suite.h 2>>nul 
    echo     columns = csbi.srWindow.Right - csbi.srWindow.Left + 1; >> test_suite.h 2>>nul 
    echo     return columns; >> test_suite.h 2>>nul 
    echo #else >> test_suite.h 2>>nul 
    echo     struct winsize w; >> test_suite.h 2>>nul 
    echo     ioctl^( STDOUT_FILENO, TIOCGWINSZ, ^&w^); >> test_suite.h 2>>nul 
    echo     return w.ws_col; >> test_suite.h 2>>nul 
    echo #endif >> test_suite.h 2>>nul 
    echo } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo //----------------------------- Logging Helper Functions -------------------------------- >> test_suite.h 2>>nul 
    echo #ifndef LOGCOUT_H >> test_suite.h 2>>nul 
    echo #define LOGCOUT_H >> test_suite.h 2>>nul 
    echo class LogCout { >> test_suite.h 2>>nul 
    echo     private: >> test_suite.h 2>>nul 
    echo         std::string formatNumber^( long long int number^) { >> test_suite.h 2>>nul 
    echo             std::stringstream ss; >> test_suite.h 2>>nul 
    echo             ss ^<^< number; >> test_suite.h 2>>nul 
    echo             std::string numberStr = ss.str^( ^); >> test_suite.h 2>>nul 
    echo             std::string formattedNumber; >> test_suite.h 2>>nul 
    echo             int count = 0; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo             for ^( int i = numberStr.size^( ^) - 1; i ^>= 0; --i^) { >> test_suite.h 2>>nul 
    echo                 formattedNumber = numberStr[i] + formattedNumber; >> test_suite.h 2>>nul 
    echo                 count++; >> test_suite.h 2>>nul 
    echo                 if ^( count %% 3 == 0 ^&^& i ^> 0^) { >> test_suite.h 2>>nul 
    echo                     formattedNumber = ' ' + formattedNumber; >> test_suite.h 2>>nul 
    echo                 } >> test_suite.h 2>>nul 
    echo             } >> test_suite.h 2>>nul 
    echo             // Remove trailing zeros >> test_suite.h 2>>nul 
    echo             while ^( ^!formattedNumber.empty^( ^) ^&^& formattedNumber.back^( ^) == '0'^) { >> test_suite.h 2>>nul 
    echo                 formattedNumber.pop_back^( ^); >> test_suite.h 2>>nul 
    echo             } >> test_suite.h 2>>nul 
    echo             return formattedNumber; >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo     public: >> test_suite.h 2>>nul 
    echo         std::ofstream logFile; >> test_suite.h 2>>nul 
    echo         LogCout^( const std::string^& filename^) { >> test_suite.h 2>>nul 
    echo             logFile.open^( filename, std::ios::app^); >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         ~LogCout^( ^) { >> test_suite.h 2>>nul 
    echo             logFile.close^( ^); >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         template ^<typename T^> >> test_suite.h 2>>nul 
    echo         LogCout^& operator^<^<^( const T^& output^) { >> test_suite.h 2>>nul 
    echo             auto currentTime = std::chrono::high_resolution_clock::now^( ^); >> test_suite.h 2>>nul 
    echo             auto epochTime = std::chrono::time_point_cast^<std::chrono::nanoseconds^>^( currentTime^).time_since_epoch^( ^); >> test_suite.h 2>>nul 
    echo             auto nanoseconds = std::chrono::duration_cast^<std::chrono::nanoseconds^>^( epochTime^); >> test_suite.h 2>>nul 
    echo             auto formattedNumber = formatNumber^( nanoseconds.count^( ^)^); >> test_suite.h 2>>nul 
    echo             logFile ^<^< formattedNumber ^<^< ^"\t^|\t^" ^<^< output ^<^< std::endl; >> test_suite.h 2>>nul 
    echo             return *this; >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo }; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo #endif >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo // --------------------------- Timing and Testing Helper Functions -------------------------- >> test_suite.h 2>>nul 
    echo #ifndef TIMER_H >> test_suite.h 2>>nul 
    echo #define TIMER_H >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo using namespace std; >> test_suite.h 2>>nul 
    echo using namespace std::chrono; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo class Timer { >> test_suite.h 2>>nul 
    echo public: >> test_suite.h 2>>nul 
    echo     // Function to measure execution time >> test_suite.h 2>>nul 
    echo     template^<typename Func^> >> test_suite.h 2>>nul 
    echo     static double measureTime^( Func func^) { >> test_suite.h 2>>nul 
    echo         auto start = high_resolution_clock::now^( ^); >> test_suite.h 2>>nul 
    echo         stringstream outputStream; >> test_suite.h 2>>nul 
    echo         streambuf* coutBuffer = cout.rdbuf^( outputStream.rdbuf^( ^)^); >> test_suite.h 2>>nul 
    echo         func^( ^); >> test_suite.h 2>>nul 
    echo         cout.rdbuf^( coutBuffer^); >> test_suite.h 2>>nul 
    echo         auto end = high_resolution_clock::now^( ^); >> test_suite.h 2>>nul 
    echo         duration^<double^> elapsed = end - start; >> test_suite.h 2>>nul 
    echo         return elapsed.count^( ^); >> test_suite.h 2>>nul 
    echo     } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo     // Function template to test a given function with multiple test cases from a file >> test_suite.h 2>>nul 
    echo     template^<typename Func^> >> test_suite.h 2>>nul 
    echo     static void Tester^( Func func^) { >> test_suite.h 2>>nul 
    echo         int test_count = 0; >> test_suite.h 2>>nul 
    echo         ifstream inputFile^( ^"input.txt^"^); >> test_suite.h 2>>nul 
    echo         if ^( inputFile.is_open^( ^)^) { >> test_suite.h 2>>nul 
    echo             string line; >> test_suite.h 2>>nul 
    echo             while ^( getline^( inputFile, line^)^) { >> test_suite.h 2>>nul 
    echo                 istringstream iss^( line^); >> test_suite.h 2>>nul 
    echo                 test_count++; >> test_suite.h 2>>nul 
    echo                 string testCase; >> test_suite.h 2>>nul 
    echo                 if ^( iss ^>^> testCase^) { >> test_suite.h 2>>nul 
    echo                     stringstream outputStream; >> test_suite.h 2>>nul 
    echo                     // Redirect cout to outputStream >> test_suite.h 2>>nul 
    echo                     streambuf* coutBuffer = cout.rdbuf^( outputStream.rdbuf^( ^)^); >> test_suite.h 2>>nul 
    echo                     func^( testCase^); >> test_suite.h 2>>nul 
    echo                     // Restore cout to standard output >> test_suite.h 2>>nul 
    echo                     cout.rdbuf^( coutBuffer^); >> test_suite.h 2>>nul 
    echo                     string actualOutput = outputStream.str^( ^); >> test_suite.h 2>>nul 
    echo                     double timeTaken = measureTime^( [func, testCase]^( ^) { func^( testCase^); }^); >> test_suite.h 2>>nul 
    echo                     cout ^<^< Color::blue ^<^< ^"Output: ^" ^<^< Color::def ^<^< actualOutput ^<^< endl; >> test_suite.h 2>>nul 
    echo                     string expectedOutput; >> test_suite.h 2>>nul 
    echo                     ifstream outputFile^( ^"output.txt^"^); >> test_suite.h 2>>nul 
    echo                     if ^( outputFile.is_open^( ^)^){ >> test_suite.h 2>>nul 
    echo                         std::string o_line; >> test_suite.h 2>>nul 
    echo                         int currentLine = 0; >> test_suite.h 2>>nul 
    echo                         while ^( std::getline^( outputFile, o_line^)^) { >> test_suite.h 2>>nul 
    echo                             currentLine++; >> test_suite.h 2>>nul 
    echo                             if ^( currentLine == test_count^) { >> test_suite.h 2>>nul 
    echo                                 expectedOutput = o_line; >> test_suite.h 2>>nul 
    echo                                 break; >> test_suite.h 2>>nul 
    echo                             } >> test_suite.h 2>>nul 
    echo                         } >> test_suite.h 2>>nul 
    echo                         if ^( actualOutput == expectedOutput^) { >> test_suite.h 2>>nul 
    echo                             cout ^<^< Color::green ^<^< ^"Test case passed^" ^<^< Color::def ^<^< endl; >> test_suite.h 2>>nul 
    echo                         } else { >> test_suite.h 2>>nul 
    echo                             cout ^<^< Color::red ^<^< ^"Test case failed^" ^<^< endl ^<^< Color::blue ^<^< ^"Expected : ^" ^<^< Color::def ^<^< expectedOutput ^<^< endl; >> test_suite.h 2>>nul 
    echo                         } >> test_suite.h 2>>nul 
    echo                         outputFile.close^( ^); >> test_suite.h 2>>nul 
    echo                     } >> test_suite.h 2>>nul 
    echo                     cout ^<^< Color::blue ^<^< ^"Time taken: ^" ^<^< Color::def ^<^< timeTaken ^<^< ^" seconds^" ^<^< endl; >> test_suite.h 2>>nul 
    echo                 } else { >> test_suite.h 2>>nul 
    echo                     cerr ^<^< Color::red ^<^< ^"Invalid test case format: ^" ^<^< line ^<^< Color::def ^<^< endl; >> test_suite.h 2>>nul 
    echo                 } >> test_suite.h 2>>nul 
    echo             } >> test_suite.h 2>>nul 
    echo             inputFile.close^( ^); >> test_suite.h 2>>nul 
    echo         } else { >> test_suite.h 2>>nul 
    echo             int make_input_file = 2; >> test_suite.h 2>>nul 
    echo             cout ^<^< Color::red ^<^< ^"Error: ^" ^<^< Color::def ^<^< ^" input.txt does not exist in the folder where the executable is present.\nTo add a new input.txt file press ^" ^<^< Color::red ^<^< ^"0^" ^<^< Color::def ^<^< ^" else press any key: ^" ^<^< std::flush; >> test_suite.h 2>>nul 
    echo             cin.clear^( ^); >> test_suite.h 2>>nul 
    echo             cin.ignore^( numeric_limits^<streamsize^>::max^( ^), '\n'^); >> test_suite.h 2>>nul 
    echo             cin ^>^> make_input_file; >> test_suite.h 2>>nul 
    echo             if ^( make_input_file == 0^) { >> test_suite.h 2>>nul 
    echo                 ofstream outFile^( ^"input.txt^"^); >> test_suite.h 2>>nul 
    echo                 if ^( outFile.is_open^( ^)^) { >> test_suite.h 2>>nul 
    echo                     string testCase; >> test_suite.h 2>>nul 
    echo                     cout ^<^< Color::blue ^<^< ^"Input: ^" ^<^< Color::def; >> test_suite.h 2>>nul 
    echo                     cin.clear^( ^); >> test_suite.h 2>>nul 
    echo                     cin.ignore^( numeric_limits^<streamsize^>::max^( ^), '\n'^); >> test_suite.h 2>>nul 
    echo                     cin ^>^> testCase; >> test_suite.h 2>>nul 
    echo                     outFile ^<^< testCase; >> test_suite.h 2>>nul 
    echo                     outFile.close^( ^); >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo                     // Prompt to make output file >> test_suite.h 2>>nul 
    echo                     int make_output_file = 2; >> test_suite.h 2>>nul 
    echo                     cout ^<^< Color::yellow ^<^< ^"Warning: ^" ^<^< Color::def ^<^< ^" output.txt does not exist in the folder where the executable is present.\nTo add a new output.txt file press ^" ^<^< Color::red ^<^< ^"0^" ^<^< Color::def ^<^< ^" else press any key: ^" ^<^< std::flush; >> test_suite.h 2>>nul 
    echo                     cin.clear^( ^); >> test_suite.h 2>>nul 
    echo                     cin.ignore^( numeric_limits^<streamsize^>::max^( ^), '\n'^); >> test_suite.h 2>>nul 
    echo                     cin ^>^> make_output_file; >> test_suite.h 2>>nul 
    echo                     if ^( make_output_file == 0^) { >> test_suite.h 2>>nul 
    echo                         ofstream outFile^( ^"output.txt^"^); >> test_suite.h 2>>nul 
    echo                         if ^( outFile.is_open^( ^)^) { >> test_suite.h 2>>nul 
    echo                             string testCase; >> test_suite.h 2>>nul 
    echo                             cout ^<^< Color::blue ^<^< ^"Output: ^" ^<^< Color::def; >> test_suite.h 2>>nul 
    echo                             cin.clear^( ^); >> test_suite.h 2>>nul 
    echo                             cin.ignore^( numeric_limits^<streamsize^>::max^( ^), '\n'^); >> test_suite.h 2>>nul 
    echo                             cin ^>^> testCase; >> test_suite.h 2>>nul 
    echo                             outFile ^<^< testCase; >> test_suite.h 2>>nul 
    echo                             outFile.close^( ^); >> test_suite.h 2>>nul 
    echo                         } else { >> test_suite.h 2>>nul 
    echo                             cout ^<^< Color::red ^<^< ^"Error: ^" ^<^< Color::def ^<^< ^"Could not open the file for writing.^" ^<^< endl; >> test_suite.h 2>>nul 
    echo                         } >> test_suite.h 2>>nul 
    echo                     } >> test_suite.h 2>>nul 
    echo                     Tester^( func^);  // Call Tester again after creating the file >> test_suite.h 2>>nul 
    echo                 } else { >> test_suite.h 2>>nul 
    echo                     cout ^<^< Color::red ^<^< ^"Error: ^" ^<^< Color::def ^<^< ^"Could not open the file for writing.^" ^<^< endl; >> test_suite.h 2>>nul 
    echo                 } >> test_suite.h 2>>nul 
    echo             } >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo     } >> test_suite.h 2>>nul 
    echo     // Function to test a function with multiple test cases from a file >> test_suite.h 2>>nul 
    echo     template^<typename Func^> >> test_suite.h 2>>nul 
    echo     static void Tester^( Func func, const string^& testFile^) { >> test_suite.h 2>>nul 
    echo         int width = getTerminalWidth^( ^); >> test_suite.h 2>>nul 
    echo         int total_cases = 0; >> test_suite.h 2>>nul 
    echo         int total_cases_passed = 0; >> test_suite.h 2>>nul 
    echo         LogCout logger^( ^"tests.log^"^); >> test_suite.h 2>>nul 
    echo         string logString; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         ifstream file^( testFile^); >> test_suite.h 2>>nul 
    echo         if ^( ^!file.is_open^( ^)^) { >> test_suite.h 2>>nul 
    echo             cerr ^<^< ^"Unable to open test file: ^" ^<^< testFile ^<^< endl; >> test_suite.h 2>>nul 
    echo             return; >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         string line; >> test_suite.h 2>>nul 
    echo         std::string dashes^( width, '-'^); >> test_suite.h 2>>nul 
    echo         std::string ddashes^( width, '='^); >> test_suite.h 2>>nul 
    echo         while ^( getline^( file, line^)^) { >> test_suite.h 2>>nul 
    echo             istringstream iss^( line^); >> test_suite.h 2>>nul 
    echo             string testCase, expectedOutput; >> test_suite.h 2>>nul 
    echo             if ^( iss ^>^> testCase ^>^> expectedOutput^) { >> test_suite.h 2>>nul 
    echo                 total_cases++; >> test_suite.h 2>>nul 
    echo                 cout ^<^< ddashes ^<^< endl; >> test_suite.h 2>>nul 
    echo                 cout ^<^< ^"Running test case: ^" ^<^< total_cases ^<^< endl; >> test_suite.h 2>>nul 
    echo                 stringstream outputStream; >> test_suite.h 2>>nul 
    echo                 // Redirect cout to outputStream >> test_suite.h 2>>nul 
    echo                 streambuf* coutBuffer = cout.rdbuf^( outputStream.rdbuf^( ^)^); >> test_suite.h 2>>nul 
    echo                 func^( testCase^); >> test_suite.h 2>>nul 
    echo                 // Restore cout to standard output >> test_suite.h 2>>nul 
    echo                 cout.rdbuf^( coutBuffer^); >> test_suite.h 2>>nul 
    echo                 string actualOutput = outputStream.str^( ^); >> test_suite.h 2>>nul 
    echo                 double timeTaken = measureTime^( [func, testCase]^( ^) { func^( testCase^); }^); >> test_suite.h 2>>nul 
    echo                 cout ^<^< dashes ^<^< endl; >> test_suite.h 2>>nul 
    echo                 cout ^<^< ^"Time taken: ^" ^<^< Color::blue ^<^< timeTaken ^<^< ^" seconds^" ^<^< Color::def ^<^< endl; >> test_suite.h 2>>nul 
    echo                 // cout ^<^< ^"Expected output: ^" ^<^< expectedOutput ^<^< endl; >> test_suite.h 2>>nul 
    echo                 // cout ^<^< ^"Actual output: ^" ^<^< actualOutput ^<^< endl; >> test_suite.h 2>>nul 
    echo                 logString = ^"Test case ^" + to_string^( total_cases^) + ^"\t^| ^"; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo                 if ^( actualOutput == expectedOutput^) { >> test_suite.h 2>>nul 
    echo                     cout ^<^< Color::green ^<^< ^"Test case passed^" ^<^< Color::def ^<^< endl; >> test_suite.h 2>>nul 
    echo                     total_cases_passed++; >> test_suite.h 2>>nul 
    echo                     logString += ^"[O] ^| ^"; >> test_suite.h 2>>nul 
    echo                 } else { >> test_suite.h 2>>nul 
    echo                     cout ^<^< Color::red ^<^< ^"Test case failed^" ^<^< endl ^<^< Color::blue ^<^< ^"Expected : ^" ^<^< Color::def ^<^< expectedOutput ^<^< endl ^<^< Color::blue ^<^< ^"Got : ^" ^<^< Color::def ^<^< actualOutput ^<^< endl; >> test_suite.h 2>>nul 
    echo                     logString += ^"[X] ^| ^"; >> test_suite.h 2>>nul 
    echo                 } >> test_suite.h 2>>nul 
    echo                 logString += ^"Time Taken: ^" + to_string^( timeTaken^) + ^" seconds\t^| ^"; >> test_suite.h 2>>nul 
    echo                 logString += ^"Input: ^" + testCase + ^"\t^| ^"; >> test_suite.h 2>>nul 
    echo                 logString += ^"Expected Output: ^" + expectedOutput + ^"\t^| ^"; >> test_suite.h 2>>nul 
    echo                 logString += ^"Actual Output: ^" + actualOutput; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo                 cout ^<^< ddashes ^<^< endl ^<^< endl; >> test_suite.h 2>>nul 
    echo                 logger ^<^< logString; >> test_suite.h 2>>nul 
    echo             } else { >> test_suite.h 2>>nul 
    echo                 cerr ^<^< Color::red ^<^< ^"Invalid test case format: ^" ^<^< line ^<^< Color::def ^<^< endl; >> test_suite.h 2>>nul 
    echo                 logString = ^"Invalid test case format^" + line; >> test_suite.h 2>>nul 
    echo                 logger ^<^< logString; >> test_suite.h 2>>nul 
    echo             } >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo         cout ^<^< ddashes ^<^< endl; >> test_suite.h 2>>nul 
    echo         cout ^<^< ^"Test cases passed : [^" ^<^< Color::green ^<^< total_cases_passed ^<^< Color::blue ^<^< ^"/^" ^<^< Color::red ^<^< total_cases ^<^< Color::def ^<^< ^"]^" ^<^< endl; >> test_suite.h 2>>nul 
    echo         cout ^<^< ddashes ^<^< endl; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         file.close^( ^); >> test_suite.h 2>>nul 
    echo     } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo }; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo #endif // TIMER_H >> test_suite.h 2>>nul 
    endlocal

    set "projectFiles=%projectFiles% test_suite.h"
    echo %GREEN%Created test_suite.h%RESET%

) else (
    echo %GREEN%test_suite.h exists in the parent directory.%RESET%
)


:: Prompt user for folder name
set /p "FOLDER_NAME=%BLUE%Enter the folder name: %RESET%"
set res=F

if "%FOLDER_NAME%" neq "" ( 
    :: Create the folder
    echo Creating folder "%FOLDER_NAME%"...
    mkdir "%FOLDER_NAME%"
    cd "%FOLDER_NAME%"
) else ( 
    set res=T
    set "FOLDER_NAME=main"
)
:: Check if template.cpp exists in the parent directory
echo Checking if template.cpp exists in the parent folder...
if not exist "..\template.cpp" (

    :: Create the C++ file and write the contents
    if "%res%"=="T" ( 
        echo #include "test_suite.h" > %FOLDER_NAME%.cpp 2>>nul
        echo %YELLOW%Creating files in parent directory.%RESET%
    ) else (
        echo #include "../test_suite.h" > %FOLDER_NAME%.cpp 2>>nul
        echo %YELLOW%template.cpp does not exist in the parent directory.%RESET%
    )
    echo Creating %FOLDER_NAME%.cpp...

    echo std::ofstream logger = LogCout^("output.log"^).logFile; >> %FOLDER_NAME%.cpp 2>>nul
    echo. >> %FOLDER_NAME%.cpp2 >>nul
    echo // TODO: Change function_name >> %FOLDER_NAME%.cpp 2>>nul
    echo. >> %FOLDER_NAME%.cpp 2>>nul
    echo auto function_name^(const string^& input^) { >> %FOLDER_NAME%.cpp 2>>nul
    echo     // Do-something >> %FOLDER_NAME%.cpp 2>>nul
    echo. >> %FOLDER_NAME%.cpp 2>>nul
    echo     // Debug cout >> %FOLDER_NAME%.cpp 2>>nul
    echo     // logger ^<^< input ^<^< endl; >> %FOLDER_NAME%.cpp 2>>nul
    echo. >> %FOLDER_NAME%.cpp 2>>nul
    echo     int num = stoi^(input^); >> %FOLDER_NAME%.cpp 2>>nul
    echo     if ^(^(num %% 2 == 0^) ^&^& ^(num ^>= 4^)^) { >> %FOLDER_NAME%.cpp 2>>nul
    echo         cout ^<^< "YES"; >> %FOLDER_NAME%.cpp 2>>nul
    echo     } >> %FOLDER_NAME%.cpp 2>>nul
    echo     else { >> %FOLDER_NAME%.cpp 2>>nul
    echo         cout ^<^< "NO"; >> %FOLDER_NAME%.cpp 2>>nul
    echo     } >> %FOLDER_NAME%.cpp 2>>nul
    echo } >> %FOLDER_NAME%.cpp 2>>nul
    echo. >> %FOLDER_NAME%.cpp 2>>nul
    echo int main^(int argc, char* argv[]^) { >> %FOLDER_NAME%.cpp 2>>nul
    echo. >> %FOLDER_NAME%.cpp 2>>nul
    echo     // Using test cases file ^(batch operation^) >> %FOLDER_NAME%.cpp 2>>nul
    echo     if ^(argc ^> 1^) { >> %FOLDER_NAME%.cpp 2>>nul
    echo         string testFile = argv[1]; >> %FOLDER_NAME%.cpp 2>>nul
    echo         Timer::Tester^(function_name, testFile^); >> %FOLDER_NAME%.cpp 2>>nul
    echo     } >> %FOLDER_NAME%.cpp 2>>nul
    echo     else { >> %FOLDER_NAME%.cpp 2>>nul
    echo         cout ^<^< Color::blue ^<^< "Choose runtime configuration : " ^<^< Color::def >> %FOLDER_NAME%.cpp 2>>nul
    echo             ^<^< "[ " ^<^< Color::red ^<^< "0" ^<^< Color::def ^<^< " : for input file, " >> %FOLDER_NAME%.cpp 2>>nul
    echo             ^<^< Color::red ^<^< "." ^<^< Color::def ^<^< " : for test file, " >> %FOLDER_NAME%.cpp 2>>nul
    echo             ^<^< Color::red ^<^< "1" ^<^< Color::def^<^< " : for terminal input] : "; >> %FOLDER_NAME%.cpp 2>>nul
    echo         char runType = '0'; >> %FOLDER_NAME%.cpp 2>>nul
    echo         cin ^>^> runType; >> %FOLDER_NAME%.cpp 2>>nul
    echo. >> %FOLDER_NAME%.cpp 2>>nul
    echo         // Using input file >> %FOLDER_NAME%.cpp 2>>nul
    echo         if ^(runType == '0'^){ >> %FOLDER_NAME%.cpp 2>>nul
    echo             Timer::Tester^(function_name^); >> %FOLDER_NAME%.cpp 2>>nul
    echo         } >> %FOLDER_NAME%.cpp 2>>nul
    echo         // Using test cases file >> %FOLDER_NAME%.cpp 2>>nul
    echo         else if ^(runType == '.'^){ >> %FOLDER_NAME%.cpp 2>>nul
    echo             string currentFilePath = __FILE__; >> %FOLDER_NAME%.cpp 2>>nul
    echo             size_t lastSlash = currentFilePath.find_last_of^("/\\"^); >> %FOLDER_NAME%.cpp 2>>nul
    echo             size_t lastDot = currentFilePath.find_last_of^('.'^); >> %FOLDER_NAME%.cpp 2>>nul
    echo             string test_file_path = currentFilePath.substr^(0, lastSlash + 1^) + "test_" + currentFilePath.substr^(lastSlash + 1, lastDot - lastSlash - 1^) + ".txt"; >> %FOLDER_NAME%.cpp 2>>nul
    echo             Timer::Tester^(function_name, test_file_path^); >> %FOLDER_NAME%.cpp 2>>nul
    echo         } >> %FOLDER_NAME%.cpp 2>>nul
    echo         // Using terminal >> %FOLDER_NAME%.cpp 2>>nul
    echo         else { >> %FOLDER_NAME%.cpp 2>>nul
    echo             string testCase; >> %FOLDER_NAME%.cpp 2>>nul
    echo             std::cout ^<^< Color::blue ^<^< "Input: " ^<^< Color::def; >> %FOLDER_NAME%.cpp 2>>nul
    echo             std::cin ^>^> testCase; >> %FOLDER_NAME%.cpp 2>>nul
    echo             double elapsedTime = Timer::measureTime([=]^(^) { >> %FOLDER_NAME%.cpp 2>>nul
    echo                 // TODO >> %FOLDER_NAME%.cpp 2>>nul
    echo                 function_name^(testCase^); >> %FOLDER_NAME%.cpp 2>>nul
    echo             }^);    >> %FOLDER_NAME%.cpp 2>>nul
    echo             stringstream outputStream;    >> %FOLDER_NAME%.cpp 2>>nul
    echo             streambuf* coutBuffer = cout.rdbuf^(outputStream.rdbuf^(^)^);    >> %FOLDER_NAME%.cpp 2>>nul
    echo. >> %FOLDER_NAME%.cpp 2>>nul
    echo             // TODO >> %FOLDER_NAME%.cpp 2>>nul
    echo             function_name^(testCase^);    >> %FOLDER_NAME%.cpp 2>>nul
    echo. >> %FOLDER_NAME%.cpp 2>>nul
    echo             cout.rdbuf^(coutBuffer^);    >> %FOLDER_NAME%.cpp 2>>nul
    echo             string actualOutput = outputStream.str^(^); >> %FOLDER_NAME%.cpp 2>>nul
    echo             std::cout ^<^< Color::blue ^<^< "Output: " ^<^< Color::def ^<^< actualOutput ^<^< std::endl >> %FOLDER_NAME%.cpp 2>>nul
    echo                 ^<^< Color::blue ^<^< "Time Elapsed : " ^<^< Color::def ^<^< elapsedTime ^<^< " seconds"; >> %FOLDER_NAME%.cpp 2>>nul
    echo         } >> %FOLDER_NAME%.cpp 2>>nul
    echo     } >> %FOLDER_NAME%.cpp 2>>nul
    echo } >> %FOLDER_NAME%.cpp 2>>nul

    echo %GREEN%Created %FOLDER_NAME%.cpp %RESET%

) else (
    echo %GREEN%template.cpp exists in the parent directory.%RESET%
    echo Copying to %FOLDER_NAME%.cpp...    
    copy "..\template.cpp" "%FOLDER_NAME%.cpp"
)
set "projectFiles=%projectFiles% %FOLDER_NAME%.cpp"

:: Prompt to create test file
set /p "makeTestFile=%BLUE%Do you want to make the %YELLOW%test_%FOLDER_NAME%.txt%BLUE% file%RESET% [press %GREEN%any key%RESET% for yes else press %RED%'N'%RESET% for no]: "
if /i "%makeTestFile%" NEQ "n" (
    echo Creating test_%FOLDER_NAME%.txt...
    echo 2 YES > "test_%FOLDER_NAME%.txt"
    set "projectFiles=%projectFiles% test_%FOLDER_NAME%.txt"
    echo %GREEN%Created test_%FOLDER_NAME%.cpp %RESET%
) else (
    echo Not creating test_%FOLDER_NAME%.txt...
)


set /p "makeReadmeFile=%BLUE%Do you want to make the %YELLOW%README.md%BLUE% file%RESET% [press %GREEN%any key%RESET% for yes else press %RED%'N'%RESET% for no]: "
if /i "%makeReadmeFile%"=="n" (
    echo Not creating README.md...
) else (
    echo Creating README.md...
    :: Create a blank README.md file with the folder name as the heading
    echo # %FOLDER_NAME% > README.md
    set "projectFiles=%projectFiles% README.md"
    echo %GREEN%Created READMD.md%RESET%
)

echo Creating output folder...
mkdir output
cd output

set /p "makeInputFile=%BLUE%Do you want to make the %YELLOW%input.txt%BLUE% file%RESET% [press %GREEN%any key%RESET% for yes else press %RED%'N'%RESET% for no]: "
if /i "%makeInputFile%"=="n" (
    echo Not creating input.txt...
) else (
    echo Creating input.txt...
    :: Create a test input file
    echo 2 > "input.txt"
    echo %GREEN%Created output/input.txt %RESET%

    set /p "makeOutputFile=%BLUE%Do you want to make the %YELLOW%output.txt%BLUE% file. (it will be auto-connected to input.txt) %RESET%[press %GREEN%any key%RESET% for yes else press %RED%'N'%RESET% for no]: "
    if /i "%makeOutputFile%"=="n" (
        echo Not creating output.txt...
        set "projectFiles=%projectFiles% input.txt"
    ) else (
        echo Creating output.txt...
        :: Create a test output file
        echo YES > "output.txt"
        set "projectFiles=%projectFiles% output.txt input.txt"
        echo %GREEN%Created output/output.txt %RESET%
    )

)

echo.
:: Notify user of completion
echo Project structure created successfully. %projectFiles%%GREEN%
for %%f in (%projectFiles%) do (
    echo %%~f
)
echo %RESET%

set /p "doExecute=%BLUE%Do you want to %YELLOW%compile and create log%BLUE% files. (log files are made automatically on execution)%RESET% [press %GREEN%any key%RESET% for yes else press %RED%'N'%RESET% for no]: "
if /i "%doExecute%"=="n" (
    echo Happy coding ^!^!^!
) else (
    cd ..
    echo Compiling file...
    :: Compile the C++ file
    g++ "%FOLDER_NAME%.cpp" -o "output/%FOLDER_NAME%.exe"
    if errorlevel 1 (
        echo %RED%Compilation failed.%RESET%
        echo %YELLOW%Note:%RESET% test_suite.h is to be loaded from %folderPath% folder.
        echo If not found then, use the batch file's comments to get it.
        pause
        exit
    )
    echo %FOLDER_NAME%.cpp complied to output\%FOLDER_NAME%.exe
    echo Running test file...
    echo.

    cd output
    :: Run the compiled executable with the test file
    "%FOLDER_NAME%.exe" "..\test_%FOLDER_NAME%.txt"
    echo.
    echo.
    echo Happy coding ^!^!^!
    echo.
)
pause
endlocal
exit





echo template.cpp
========================================================================================================================================
========================================================================================================================================

#include "../test_suite.h"
std::ofstream logger = LogCout("output.log").logFile;

// TODO: Change function_name


auto function_name(const string& input) {
    // Do-something

    // Debug cout
    // logger << input << endl;
    
    int num = stoi(input);
    if ((num % 2 == 0) && (num >= 4)) {
        cout << "YES";
    }
    else {
        cout << "NO";
    }
}

int main(int argc, char* argv[]) {
    
    // Using test cases file (batch operation)
    if (argc > 1) {
        string testFile = argv[1];
        Timer::Tester(function_name, testFile);
    }
    else {
        cout << Color::blue << "Choose runtime configuration : " << Color::def 
            << "[ " << Color::red << "0" << Color::def << " : for input file, " 
            << Color::red << "." << Color::def << " : for test file, " 
            << Color::red << "1" << Color::def<< " : for terminal input] : ";
        char runType = '0';
        cin >> runType;

        // Using input file
        if (runType == '0'){
            Timer::Tester(function_name);
        } 
        // Using test cases file
        else if (runType == '.'){
            string currentFilePath = __FILE__;
            size_t lastSlash = currentFilePath.find_last_of("/\\");
            size_t lastDot = currentFilePath.find_last_of('.');
            string test_file_path = currentFilePath.substr(0, lastSlash + 1) + "test_" + currentFilePath.substr(lastSlash + 1, lastDot - lastSlash - 1) + ".txt";
            Timer::Tester(function_name, test_file_path);
        }
        // Using terminal
        else {
            string testCase;
            std::cout << Color::blue << "Input: " << Color::def;
            std::cin >> testCase;
            double elapsedTime = Timer::measureTime([=]() {
                // TODO
                function_name(testCase);
            });    
            stringstream outputStream;    
            streambuf* coutBuffer = cout.rdbuf(outputStream.rdbuf());    
            
            // TODO
            function_name(testCase);    
            
            cout.rdbuf(coutBuffer);    
            string actualOutput = outputStream.str(); 
            std::cout << Color::blue << "Output: " << Color::def << actualOutput << std::endl 
                << Color::blue << "Time Elapsed : " << Color::def << elapsedTime << " seconds";
        }
    }
}

echo test_suite.h
========================================================================================================================================
========================================================================================================================================

#include <sstream>
#include <iostream>
#include <string>
#include <fstream>
#include <chrono>
#include <ctime>
#include <functional>

#ifdef _WIN32
#include <windows.h>
#else
#include <sys/ioctl.h>
#include <unistd.h>
#endif

// ---------------------------- Color Helper Functions ----------------------------
namespace Color
{
    enum Code
    {
        FG_RED = 31,
        FG_GREEN = 32,
        FG_YELLOW = 33,
        FG_BLUE = 34,
        FG_MAGENTA = 35,
        FG_CYAN = 36,
        FG_LIGHT_GRAY = 37,
        FG_DEFAULT = 39,
        FG_DARK_GRAY = 90,
        FG_LIGHT_RED = 91,
        FG_LIGHT_GREEN = 92,
        FG_LIGHT_YELLOW = 93,
        FG_LIGHT_BLUE = 94,
        FG_LIGHT_MAGENTA = 95,
        FG_LIGHT_CYAN = 96,
        FG_WHITE = 97,

        BG_RED = 41,
        BG_GREEN = 42,
        BG_YELLOW = 43,
        BG_BLUE = 44,
        BG_MAGENTA = 45,
        BG_CYAN = 46,
        BG_LIGHT_GRAY = 47,
        BG_DEFAULT = 49,
        BG_DARK_GRAY = 100,
        BG_LIGHT_RED = 101,
        BG_LIGHT_GREEN = 102,
        BG_LIGHT_YELLOW = 103,
        BG_LIGHT_BLUE = 104,
        BG_LIGHT_MAGENTA = 105,
        BG_LIGHT_CYAN = 106,
        BG_WHITE = 107,

        BOLD = 1,
        UNDERLINE = 4,
        RESET = 0
    };

    class Modifier
    {
        Code code;

    public:
        Modifier(Code pCode) : code(pCode) {}
        friend std::ostream &
        operator<<(std::ostream &os, const Modifier &mod)
        {
            return os << "\033[" << mod.code << "m";
        }
    };

    Modifier red(Color::FG_RED);
    Modifier green(Color::FG_GREEN);
    Modifier yellow(Color::FG_YELLOW);
    Modifier blue(Color::FG_BLUE);
    Modifier magenta(Color::FG_MAGENTA);
    Modifier cyan(Color::FG_CYAN);
    Modifier lightGray(Color::FG_LIGHT_GRAY);
    Modifier darkGray(Color::FG_DARK_GRAY);
    Modifier lightRed(Color::FG_LIGHT_RED);
    Modifier lightGreen(Color::FG_LIGHT_GREEN);
    Modifier lightYellow(Color::FG_LIGHT_YELLOW);
    Modifier lightBlue(Color::FG_LIGHT_BLUE);
    Modifier lightMagenta(Color::FG_LIGHT_MAGENTA);
    Modifier lightCyan(Color::FG_LIGHT_CYAN);
    Modifier white(Color::FG_WHITE);
    Modifier def(Color::FG_DEFAULT);

    Modifier bgRed(Color::BG_RED);
    Modifier bgGreen(Color::BG_GREEN);
    Modifier bgYellow(Color::BG_YELLOW);
    Modifier bgBlue(Color::BG_BLUE);
    Modifier bgMagenta(Color::BG_MAGENTA);
    Modifier bgCyan(Color::BG_CYAN);
    Modifier bgLightGray(Color::BG_LIGHT_GRAY);
    Modifier bgDarkGray(Color::BG_DARK_GRAY);
    Modifier bgLightRed(Color::BG_LIGHT_RED);
    Modifier bgLightGreen(Color::BG_LIGHT_GREEN);
    Modifier bgLightYellow(Color::BG_LIGHT_YELLOW);
    Modifier bgLightBlue(Color::BG_LIGHT_BLUE);
    Modifier bgLightMagenta(Color::BG_LIGHT_MAGENTA);
    Modifier bgLightCyan(Color::BG_LIGHT_CYAN);
    Modifier bgWhite(Color::BG_WHITE);
    Modifier bgDef(Color::BG_DEFAULT);

    Modifier bold(Color::BOLD);
    Modifier underline(Color::UNDERLINE);
    Modifier reset(Color::RESET);
}

// --------------------------- Terminal Helper Functions ------------------------
int getTerminalWidth() {
#ifdef _WIN32
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    int columns;
    GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);
    columns = csbi.srWindow.Right - csbi.srWindow.Left + 1;
    return columns;
#else
    struct winsize w;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
    return w.ws_col;
#endif
}


//----------------------------- Logging Helper Functions --------------------------------
#ifndef LOGCOUT_H
#define LOGCOUT_H
class LogCout {
    private:
        std::string formatNumber(long long int number) {
            std::stringstream ss;
            ss << number;
            std::string numberStr = ss.str();
            std::string formattedNumber;
            int count = 0;

            for (int i = numberStr.size() - 1; i >= 0; --i) {
                formattedNumber = numberStr[i] + formattedNumber;
                count++;
                if (count % 3 == 0 && i > 0) {
                    formattedNumber = ' ' + formattedNumber;
                }
            }
            // Remove trailing zeros
            while (!formattedNumber.empty() && formattedNumber.back() == '0') {
                formattedNumber.pop_back();
            }
            return formattedNumber;
        }

    public:
        std::ofstream logFile;
        LogCout(const std::string& filename) {
            logFile.open(filename, std::ios::app);
        }

        ~LogCout() {
            logFile.close();
        }

        template <typename T>
        LogCout& operator<<(const T& output) {
            auto currentTime = std::chrono::high_resolution_clock::now();
            auto epochTime = std::chrono::time_point_cast<std::chrono::nanoseconds>(currentTime).time_since_epoch();
            auto nanoseconds = std::chrono::duration_cast<std::chrono::nanoseconds>(epochTime);
            auto formattedNumber = formatNumber(nanoseconds.count());
            logFile << formattedNumber << "\t|\t" << output << std::endl;
            return *this;
        }
};

#endif



// --------------------------- Timing and Testing Helper Functions --------------------------
#ifndef TIMER_H
#define TIMER_H

using namespace std;
using namespace std::chrono;

class Timer {
public:
    // Function to measure execution time
    template<typename Func>
    static double measureTime(Func func) {
        auto start = high_resolution_clock::now();
        stringstream outputStream;
        streambuf* coutBuffer = cout.rdbuf(outputStream.rdbuf());
        func();
        cout.rdbuf(coutBuffer);        
        auto end = high_resolution_clock::now();
        duration<double> elapsed = end - start;
        return elapsed.count();
    }


    // Function template to test a given function with multiple test cases from a file
    template<typename Func>
    static void Tester(Func func) {
        int test_count = 0;
        ifstream inputFile("input.txt");
        if (inputFile.is_open()) {
            string line;
            while (getline(inputFile, line)) {
                istringstream iss(line);
                test_count++;
                string testCase;
                if (iss >> testCase) {
                    stringstream outputStream;
                    // Redirect cout to outputStream
                    streambuf* coutBuffer = cout.rdbuf(outputStream.rdbuf());
                    func(testCase);
                    // Restore cout to standard output
                    cout.rdbuf(coutBuffer);
                    string actualOutput = outputStream.str();
                    double timeTaken = measureTime([func, testCase]() { func(testCase); });
                    cout << Color::blue << "Output: " << Color::def << actualOutput << endl;
                    string expectedOutput;
                    ifstream outputFile("output.txt");
                    if (outputFile.is_open()){
                        std::string o_line;
                        int currentLine = 0;
                        while (std::getline(outputFile, o_line)) {
                            currentLine++;
                            if (currentLine == test_count) {
                                expectedOutput = o_line;
                                break;
                            }
                        }
                        if (actualOutput == expectedOutput) {
                            cout << Color::green << "Test case passed" << Color::def << endl;
                        } else {
                            cout << Color::red << "Test case failed" << endl << Color::blue << "Expected : " << Color::def << expectedOutput << endl;
                        }
                        outputFile.close();
                    }
                    cout << Color::blue << "Time taken: " << Color::def << timeTaken << " seconds" << endl;
                } else {
                    cerr << Color::red << "Invalid test case format: " << line << Color::def << endl;
                }
            }
            inputFile.close();
        } else {
            int make_input_file = 2;
            cout << Color::red << "Error: " << Color::def << " input.txt does not exist in the folder where the executable is present.\nTo add a new input.txt file press " << Color::red << "0" << Color::def << " else press any key: " << std::flush;
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cin >> make_input_file;
            if (make_input_file == 0) {
                ofstream outFile("input.txt");
                if (outFile.is_open()) {
                    string testCase;
                    cout << Color::blue << "Input: " << Color::def;
                    cin.clear();
                    cin.ignore(numeric_limits<streamsize>::max(), '\n');
                    cin >> testCase;
                    outFile << testCase;
                    outFile.close();

                    // Prompt to make output file
                    int make_output_file = 2;
                    cout << Color::yellow << "Warning: " << Color::def << " output.txt does not exist in the folder where the executable is present.\nTo add a new output.txt file press " << Color::red << "0" << Color::def << " else press any key: " << std::flush;
                    cin.clear();
                    cin.ignore(numeric_limits<streamsize>::max(), '\n');
                    cin >> make_output_file;
                    if (make_output_file == 0) {
                        ofstream outFile("output.txt");
                        if (outFile.is_open()) {
                            string testCase;
                            cout << Color::blue << "Output: " << Color::def;
                            cin.clear();
                            cin.ignore(numeric_limits<streamsize>::max(), '\n');
                            cin >> testCase;
                            outFile << testCase;
                            outFile.close();
                        } else {
                            cout << Color::red << "Error: " << Color::def << "Could not open the file for writing." << endl;
                        }
                    }
                    Tester(func);  // Call Tester again after creating the file
                } else {
                    cout << Color::red << "Error: " << Color::def << "Could not open the file for writing." << endl;
                }
            }
        }
    }
    // Function to test a function with multiple test cases from a file
    template<typename Func>
    static void Tester(Func func, const string& testFile) {
        int width = getTerminalWidth();
        int total_cases = 0;
        int total_cases_passed = 0;
        LogCout logger("tests.log");
        string logString;

        ifstream file(testFile);
        if (!file.is_open()) {
            cerr << "Unable to open test file: " << testFile << endl;
            return;
        }

        string line;
        std::string dashes(width, '-');
        std::string ddashes(width, '=');
        while (getline(file, line)) {
            istringstream iss(line);
            string testCase, expectedOutput;
            if (iss >> testCase >> expectedOutput) {
                total_cases++;
                cout << ddashes << endl;
                cout << "Running test case: " << total_cases << endl;
                stringstream outputStream;
                // Redirect cout to outputStream
                streambuf* coutBuffer = cout.rdbuf(outputStream.rdbuf());
                func(testCase);
                // Restore cout to standard output
                cout.rdbuf(coutBuffer);
                string actualOutput = outputStream.str();
                double timeTaken = measureTime([func, testCase]() { func(testCase); });
                cout << dashes << endl;
                cout << "Time taken: " << Color::blue << timeTaken << " seconds" << Color::def << endl;
                // cout << "Expected output: " << expectedOutput << endl;
                // cout << "Actual output: " << actualOutput << endl;
                logString = "Test case " + to_string(total_cases) + "\t| ";
                
                if (actualOutput == expectedOutput) {
                    cout << Color::green << "Test case passed" << Color::def << endl;
                    total_cases_passed++;
                    logString += "[O] | ";
                } else {
                    cout << Color::red << "Test case failed" << endl << Color::blue << "Expected : " << Color::def << expectedOutput << endl << Color::blue << "Got : " << Color::def << actualOutput << endl;
                    logString += "[X] | ";
                }
                logString += "Time Taken: " + to_string(timeTaken) + " seconds\t| ";
                logString += "Input: " + testCase + "\t| ";
                logString += "Expected Output: " + expectedOutput + "\t| ";
                logString += "Actual Output: " + actualOutput;

                cout << ddashes << endl << endl;
                logger << logString;
            } else {
                cerr << Color::red << "Invalid test case format: " << line << Color::def << endl;
                logString = "Invalid test case format" + line;
                logger << logString;
            }
        }
        cout << ddashes << endl;
        cout << "Test cases passed : [" << Color::green << total_cases_passed << Color::blue << "/" << Color::red << total_cases << Color::def << "]" << endl;
        cout << ddashes << endl;


        file.close();
    }

};

#endif // TIMER_H
