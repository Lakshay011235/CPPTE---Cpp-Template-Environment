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
echo This script is used to create a C++ executable environment for %RED% CodeForces %RESET%.
echo Features:
echo    1. Ready-to-use c++ environment for CodeForces
echo    2. Fetchs the inputs and outputs directly based on given folder name
echo    3. Advanced logging and testing support
echo    4. Simple to use input and output txt files for interview like experience
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
echo ^|   ^|  +- expected_output.txt
echo ^|   ^|  +- tests.log
echo ^|   ^|  +- temp.log
echo ^|   ^|
echo ^|   +- README.md
echo ^|   +- [filename].cpp 
echo ^| 
echo +- test_suite.h
echo +- main.py %RESET%
echo ------------------------------------------------------------------------------------------------------
echo %UNDERLINE%How to use:%RESET%
echo %RED%First-use:%RESET% Change the folderPath in this file to your prefered directory to avoid opening at root.
echo - Select the folder where you want to create the environment
echo - Enter the folder name: ContestID Index. For example: 1985 H2
echo - %YELLOW%NOTE:%RESET% Incase you want to use a %RED%different template file%RESET%, you can have the
echo   template.cpp file defined in the parent folder you chose earlier.
echo - %YELLOW%NOTE:%RESET% This script is made for Windows 10 and above. If you use linux, you are smart 
echo   enough to change this batch file to your needs.
echo ------------------------------------------------------------------------------------------------------
echo %UNDERLINE%Common Errors:%RESET%
echo Error in making of cpp file: please use the %BLUE%template.cpp%RESET% defined in the comments of this file.
echo Error in compilation of cpp file: please use the %BLUE%test_suite.h%RESET% defined in the comments of this file.
echo Error in execution of python file: please use the %BLUE%main.py%RESET% defined in the comments of this file.
echo Error in dialog box opening: Install powershell ^(recommended^) or ^set the selecterFolder variable 
echo to folderPath in the code ^set ^"selectedFolder=%%folderPath%%^" 
echo =======================================================================================================


set "folderPath=C:\Users\Lakshay Sharma\CODE PLAYGROUND\CP0\CodeForces" 

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
    echo         Modifier^(  Code pCode^) : code^(  pCode^) {} >> test_suite.h 2>>nul 
    echo         friend std::ostream ^& >> test_suite.h 2>>nul 
    echo         operator^<^<^(  std::ostream ^&os, const Modifier ^&mod^) >> test_suite.h 2>>nul 
    echo         { >> test_suite.h 2>>nul 
    echo             return os ^<^< ^"\033[^" ^<^< mod.code ^<^< ^"m^"; >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo     }; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo     Modifier red^(  Color::FG_RED^); >> test_suite.h 2>>nul 
    echo     Modifier green^(  Color::FG_GREEN^); >> test_suite.h 2>>nul 
    echo     Modifier yellow^(  Color::FG_YELLOW^); >> test_suite.h 2>>nul 
    echo     Modifier blue^(  Color::FG_BLUE^); >> test_suite.h 2>>nul 
    echo     Modifier magenta^(  Color::FG_MAGENTA^); >> test_suite.h 2>>nul 
    echo     Modifier cyan^(  Color::FG_CYAN^); >> test_suite.h 2>>nul 
    echo     Modifier lightGray^(  Color::FG_LIGHT_GRAY^); >> test_suite.h 2>>nul 
    echo     Modifier darkGray^(  Color::FG_DARK_GRAY^); >> test_suite.h 2>>nul 
    echo     Modifier lightRed^(  Color::FG_LIGHT_RED^); >> test_suite.h 2>>nul 
    echo     Modifier lightGreen^(  Color::FG_LIGHT_GREEN^); >> test_suite.h 2>>nul 
    echo     Modifier lightYellow^(  Color::FG_LIGHT_YELLOW^); >> test_suite.h 2>>nul 
    echo     Modifier lightBlue^(  Color::FG_LIGHT_BLUE^); >> test_suite.h 2>>nul 
    echo     Modifier lightMagenta^(  Color::FG_LIGHT_MAGENTA^); >> test_suite.h 2>>nul 
    echo     Modifier lightCyan^(  Color::FG_LIGHT_CYAN^); >> test_suite.h 2>>nul 
    echo     Modifier white^(  Color::FG_WHITE^); >> test_suite.h 2>>nul 
    echo     Modifier def^(  Color::FG_DEFAULT^); >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo     Modifier bgRed^(  Color::BG_RED^); >> test_suite.h 2>>nul 
    echo     Modifier bgGreen^(  Color::BG_GREEN^); >> test_suite.h 2>>nul 
    echo     Modifier bgYellow^(  Color::BG_YELLOW^); >> test_suite.h 2>>nul 
    echo     Modifier bgBlue^(  Color::BG_BLUE^); >> test_suite.h 2>>nul 
    echo     Modifier bgMagenta^(  Color::BG_MAGENTA^); >> test_suite.h 2>>nul 
    echo     Modifier bgCyan^(  Color::BG_CYAN^); >> test_suite.h 2>>nul 
    echo     Modifier bgLightGray^(  Color::BG_LIGHT_GRAY^); >> test_suite.h 2>>nul 
    echo     Modifier bgDarkGray^(  Color::BG_DARK_GRAY^); >> test_suite.h 2>>nul 
    echo     Modifier bgLightRed^(  Color::BG_LIGHT_RED^); >> test_suite.h 2>>nul 
    echo     Modifier bgLightGreen^(  Color::BG_LIGHT_GREEN^); >> test_suite.h 2>>nul 
    echo     Modifier bgLightYellow^(  Color::BG_LIGHT_YELLOW^); >> test_suite.h 2>>nul 
    echo     Modifier bgLightBlue^(  Color::BG_LIGHT_BLUE^); >> test_suite.h 2>>nul 
    echo     Modifier bgLightMagenta^(  Color::BG_LIGHT_MAGENTA^); >> test_suite.h 2>>nul 
    echo     Modifier bgLightCyan^(  Color::BG_LIGHT_CYAN^); >> test_suite.h 2>>nul 
    echo     Modifier bgWhite^(  Color::BG_WHITE^); >> test_suite.h 2>>nul 
    echo     Modifier bgDef^(  Color::BG_DEFAULT^); >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo     Modifier bold^(  Color::BOLD^); >> test_suite.h 2>>nul 
    echo     Modifier underline^(  Color::UNDERLINE^); >> test_suite.h 2>>nul 
    echo     Modifier reset^(  Color::RESET^); >> test_suite.h 2>>nul 
    echo } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo // --------------------------- Terminal Helper Functions ------------------------ >> test_suite.h 2>>nul 
    echo int getTerminalWidth^(  ^) { >> test_suite.h 2>>nul 
    echo #ifdef _WIN32 >> test_suite.h 2>>nul 
    echo     CONSOLE_SCREEN_BUFFER_INFO csbi; >> test_suite.h 2>>nul 
    echo     int columns; >> test_suite.h 2>>nul 
    echo     GetConsoleScreenBufferInfo^(  GetStdHandle^(  STD_OUTPUT_HANDLE^), ^&csbi^); >> test_suite.h 2>>nul 
    echo     columns = csbi.srWindow.Right - csbi.srWindow.Left + 1; >> test_suite.h 2>>nul 
    echo     return columns; >> test_suite.h 2>>nul 
    echo #else >> test_suite.h 2>>nul 
    echo     struct winsize w; >> test_suite.h 2>>nul 
    echo     ioctl^(  STDOUT_FILENO, TIOCGWINSZ, ^&w^); >> test_suite.h 2>>nul 
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
    echo         std::string formatNumber^(  long long int number^) { >> test_suite.h 2>>nul 
    echo             std::stringstream ss; >> test_suite.h 2>>nul 
    echo             ss ^<^< number; >> test_suite.h 2>>nul 
    echo             std::string numberStr = ss.str^(  ^); >> test_suite.h 2>>nul 
    echo             std::string formattedNumber; >> test_suite.h 2>>nul 
    echo             int count = 0; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo             for ^(  int i = numberStr.size^(  ^) - 1; i ^>= 0; --i^) { >> test_suite.h 2>>nul 
    echo                 formattedNumber = numberStr[i] + formattedNumber; >> test_suite.h 2>>nul 
    echo                 count++; >> test_suite.h 2>>nul 
    echo                 if ^(  count %% 3 == 0 ^&^& i ^> 0^) { >> test_suite.h 2>>nul 
    echo                     formattedNumber = ' ' + formattedNumber; >> test_suite.h 2>>nul 
    echo                 } >> test_suite.h 2>>nul 
    echo             } >> test_suite.h 2>>nul 
    echo             // Remove trailing zeros >> test_suite.h 2>>nul 
    echo             while ^(  ^!formattedNumber.empty^(  ^) ^&^& formattedNumber.back^(  ^) == '0'^) { >> test_suite.h 2>>nul 
    echo                 formattedNumber.pop_back^(  ^); >> test_suite.h 2>>nul 
    echo             } >> test_suite.h 2>>nul 
    echo             return formattedNumber; >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo     public: >> test_suite.h 2>>nul 
    echo         std::ofstream logFile; >> test_suite.h 2>>nul 
    echo         LogCout^(  const std::string^& filename^) { >> test_suite.h 2>>nul 
    echo             logFile.open^(  filename, std::ios::app^); >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         ~LogCout^(  ^) { >> test_suite.h 2>>nul 
    echo             logFile.close^(  ^); >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         template ^<typename T^> >> test_suite.h 2>>nul 
    echo         LogCout^& operator^<^<^(  const T^& output^) { >> test_suite.h 2>>nul 
    echo             auto currentTime = std::chrono::high_resolution_clock::now^(  ^); >> test_suite.h 2>>nul 
    echo             auto epochTime = std::chrono::time_point_cast^<std::chrono::nanoseconds^>^(  currentTime^).time_since_epoch^(  ^); >> test_suite.h 2>>nul 
    echo             auto nanoseconds = std::chrono::duration_cast^<std::chrono::nanoseconds^>^(  epochTime^); >> test_suite.h 2>>nul 
    echo             auto formattedNumber = formatNumber^(  nanoseconds.count^(  ^)^); >> test_suite.h 2>>nul 
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
    echo std::string trim^( const std::string^& str^) { >> test_suite.h 2>>nul 
    echo     size_t first = str.find_first_not_of^( ' '^); >> test_suite.h 2>>nul 
    echo     if ^( first == std::string::npos^) { >> test_suite.h 2>>nul 
    echo         return ^"^"; // no content >> test_suite.h 2>>nul 
    echo     } >> test_suite.h 2>>nul 
    echo     size_t last = str.find_last_not_of^( ' '^); >> test_suite.h 2>>nul 
    echo     return str.substr^( first, ^( last - first + 1^)^); >> test_suite.h 2>>nul 
    echo } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo class Timer { >> test_suite.h 2>>nul 
    echo public: >> test_suite.h 2>>nul 
    echo     // Function to measure execution time >> test_suite.h 2>>nul 
    echo     template^<typename Func^> >> test_suite.h 2>>nul 
    echo     static double measureTime^(  Func func^) { >> test_suite.h 2>>nul 
    echo         auto start = high_resolution_clock::now^(  ^); >> test_suite.h 2>>nul 
    echo         func^(  ^); >> test_suite.h 2>>nul 
    echo         auto end = high_resolution_clock::now^(  ^); >> test_suite.h 2>>nul 
    echo         duration^<double^> elapsed = end - start; >> test_suite.h 2>>nul 
    echo         return elapsed.count^(  ^); >> test_suite.h 2>>nul 
    echo     } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo     // Function template to test a given function with multiple test cases from a file >> test_suite.h 2>>nul 
    echo     template^<typename Func^> >> test_suite.h 2>>nul 
    echo     static void Tester^(  Func func^) { >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         LogCout logger^(  ^"tests.log^"^); >> test_suite.h 2>>nul 
    echo         int width = getTerminalWidth^(  ^); >> test_suite.h 2>>nul 
    echo         std::string dashes^(  width, '-'^); >> test_suite.h 2>>nul 
    echo         std::string ddashes^(  width, '='^); >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         cout ^<^< ddashes ^<^< endl; >> test_suite.h 2>>nul 
    echo         // Open the input file and redirect cin >> test_suite.h 2>>nul 
    echo         std::ifstream bufferInputFile^( ^"input.txt^"^); >> test_suite.h 2>>nul 
    echo         if ^( ^!bufferInputFile.is_open^( ^)^) { >> test_suite.h 2>>nul 
    echo             std::cerr ^<^< ^"Error: Could not open input file^!^" ^<^< std::endl; >> test_suite.h 2>>nul 
    echo             logger ^<^< ^"Error: Could not open input file^!^"; >> test_suite.h 2>>nul 
    echo             return; >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo         std::streambuf* cinBuffer = std::cin.rdbuf^( bufferInputFile.rdbuf^( ^)^); >> test_suite.h 2>>nul 
    echo         logger ^<^< ^"Input buffer redirected : cin to input file^"; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         // Prepare the output file and redirect cout >> test_suite.h 2>>nul 
    echo         std::ofstream bufferOutputFile^( ^"output.txt^"^); >> test_suite.h 2>>nul 
    echo         if ^( ^!bufferOutputFile.is_open^( ^)^) { >> test_suite.h 2>>nul 
    echo             std::cerr ^<^< ^"Error: Could not open output file^!^" ^<^< std::endl; >> test_suite.h 2>>nul 
    echo             logger ^<^< ^"Error: Could not open output file^!^"; >> test_suite.h 2>>nul 
    echo             return; >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo         std::streambuf* coutBuffer = std::cout.rdbuf^( bufferOutputFile.rdbuf^( ^)^); >> test_suite.h 2>>nul 
    echo         logger ^<^< ^"Output buffer redirected : cout to output file^"; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         // Call the function that processes input using cin and cout >> test_suite.h 2>>nul 
    echo         double timeTaken = measureTime^( func^); >> test_suite.h 2>>nul 
    echo         logger ^<^< ^"Executing function...^"; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         // Restore cin and cout to their original states >> test_suite.h 2>>nul 
    echo         std::cin.rdbuf^( cinBuffer^); >> test_suite.h 2>>nul 
    echo         std::cout.rdbuf^( coutBuffer^); >> test_suite.h 2>>nul 
    echo         logger ^<^< ^"Restored cin and cout buffers to original state^"; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         // Close the files >> test_suite.h 2>>nul 
    echo         bufferInputFile.close^( ^); >> test_suite.h 2>>nul 
    echo         bufferOutputFile.close^( ^); >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         cout ^<^< Color::yellow ^<^< ^"Function successfully executed^" ^<^< Color::def ^<^< std::endl; >> test_suite.h 2>>nul 
    echo         cout ^<^< dashes ^<^< endl; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo         ifstream outputFile^(  ^"output.txt^"^); >> test_suite.h 2>>nul 
    echo         ifstream expectedOutputFile^(  ^"expected_output.txt^"^); >> test_suite.h 2>>nul 
    echo         string messageString; >> test_suite.h 2>>nul 
    echo         if ^( outputFile.is_open^( ^) ^&^& expectedOutputFile.is_open^( ^)^){ >> test_suite.h 2>>nul 
    echo             logger ^<^< ^"Opening the output and expected output files^"; >> test_suite.h 2>>nul 
    echo             std::string o_line, e_line; >> test_suite.h 2>>nul 
    echo             int currentLine = 0; >> test_suite.h 2>>nul 
    echo             while ^( std::getline^(  outputFile, o_line^) ^&^& std::getline^( expectedOutputFile, e_line^)^) { >> test_suite.h 2>>nul 
    echo                 o_line = trim^( o_line^); >> test_suite.h 2>>nul 
    echo                 e_line = trim^( e_line^); >> test_suite.h 2>>nul 
    echo                 currentLine++; >> test_suite.h 2>>nul 
    echo                 string logLine = ^"Comparing Line [^" + to_string^( currentLine^) + ^"] Expected : ^" + e_line + ^"\t Got : ^" + o_line; >> test_suite.h 2>>nul 
    echo                 logger ^<^< logLine; >> test_suite.h 2>>nul 
    echo                 if ^(  o_line ^!= e_line^) { >> test_suite.h 2>>nul 
    echo                     messageString = ^"At line [^" + to_string^( currentLine^) + ^"] ^|  Expected : ^" + e_line + ^"\t Got : ^" + o_line; >> test_suite.h 2>>nul 
    echo                     break; >> test_suite.h 2>>nul 
    echo                 } >> test_suite.h 2>>nul 
    echo             } >> test_suite.h 2>>nul 
    echo             if ^(  messageString.empty^( ^)^) { >> test_suite.h 2>>nul 
    echo                 cout ^<^< Color::green ^<^< ^"Test passed^" ^<^< Color::def ^<^< endl; >> test_suite.h 2>>nul 
    echo                 logger ^<^< ^"Test passed^"; >> test_suite.h 2>>nul 
    echo             } else { >> test_suite.h 2>>nul 
    echo                 cout ^<^< Color::red ^<^< ^"Test failed^" ^<^< endl ^<^< messageString ^<^< Color::def ^<^< endl; >> test_suite.h 2>>nul 
    echo                 logger ^<^< ^"Test failed^"; >> test_suite.h 2>>nul 
    echo             } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo             outputFile.close^( ^); >> test_suite.h 2>>nul 
    echo             expectedOutputFile.close^( ^); >> test_suite.h 2>>nul 
    echo             cout ^<^< dashes ^<^< endl; >> test_suite.h 2>>nul 
    echo             cout ^<^< Color::blue ^<^< ^"Time taken: ^" ^<^< Color::def ^<^< timeTaken ^<^< ^" seconds^" ^<^< endl; >> test_suite.h 2>>nul 
    echo             logger ^<^< ^"Time taken: ^" + to_string^( timeTaken^); >> test_suite.h 2>>nul 
    echo             cout ^<^< ddashes ^<^< endl; >> test_suite.h 2>>nul 
    echo         } >> test_suite.h 2>>nul 
    echo     } >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo }; >> test_suite.h 2>>nul 
    echo. >> test_suite.h 2>>nul 
    echo #endif // TIMER_H >> test_suite.h 2>>nul 

    endlocal

    echo %GREEN%Created test_suite.h%RESET%

) else (
    echo %GREEN%test_suite.h exists in the parent directory.%RESET%
)

:: Check if test_suite.h exists in the parent directory
echo Checking if main.py exists in the parent folder...
if not exist "main.py" (
    echo %YELLOW%main.py does not exist in the parent directory.%RESET%
    echo Creating main.py

    setlocal DisableDelayedExpansion

    echo import json >> main.py 2>>nul 
    echo import sys >> main.py 2>>nul 
    echo import requests >> main.py 2>>nul 
    echo import os >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo if not os.path.exists^( ^"../problemset.json^"^): >> main.py 2>>nul 
    echo     problem_set_json = requests.get^( ^"https://codeforces.com/api/problemset.problems^"^).text >> main.py 2>>nul 
    echo     data = json.loads^( problem_set_json^)[^"result^"][^"problems^"] >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo else: >> main.py 2>>nul 
    echo     with open^( 'problemset.json', 'r', encoding='utf-8'^) as file: >> main.py 2>>nul 
    echo         data = json.load^( file^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo def get_problem^( name_or_id, index=None^): >> main.py 2>>nul 
    echo     ^"^"^" >> main.py 2>>nul 
    echo     Args: >> main.py 2>>nul 
    echo         `name_or_id ^( string^)`: Get the problem with given name or contest id >> main.py 2>>nul 
    echo         `index ^( string, optional^)`: Additional parameter to support contest id. Defaults to None. >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     Returns: >> main.py 2>>nul 
    echo         `{'contestId': int,` >> main.py 2>>nul 
    echo         `'index': string,` >> main.py 2>>nul 
    echo         `'name': string,` >> main.py 2>>nul 
    echo         `'tags': list[string],` >> main.py 2>>nul 
    echo         `'type': string}` >> main.py 2>>nul 
    echo     ^"^"^" >> main.py 2>>nul 
    echo     problem = [] >> main.py 2>>nul 
    echo     nullProblem = { 'contestId': 0, >> main.py 2>>nul 
    echo                     'index': '0', >> main.py 2>>nul 
    echo                     'name': '', >> main.py 2>>nul 
    echo                     'tags': [], >> main.py 2>>nul 
    echo                     'type': ''} >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     # Get problem via problem name >> main.py 2>>nul 
    echo     if index is None: >> main.py 2>>nul 
    echo         problem = [result for result in data if result[^"name^"] == name_or_id] >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     # Get problem via id and index >> main.py 2>>nul 
    echo     elif str^( name_or_id^).isdecimal^( ^): >> main.py 2>>nul 
    echo         problem = [result for result in data if result[^"contestId^"] == int^( name_or_id^) and result[^"index^"] == index] >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     problem = nullProblem if len^( problem^) == 0 else problem[0] >> main.py 2>>nul 
    echo     return problem >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo def extract_problem_div^( input_string, className=^"problem-statement^"^): >> main.py 2>>nul 
    echo     # Define the start and end markers for the div >> main.py 2>>nul 
    echo     start_marker = f'^<div class=^"{className}^"^>' >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     stack = 0 >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     # Find the start and end positions >> main.py 2>>nul 
    echo     start_pos = input_string.find^( start_marker^) >> main.py 2>>nul 
    echo     if start_pos == -1: >> main.py 2>>nul 
    echo         return None  # The div was not found >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     i = start_pos >> main.py 2>>nul 
    echo     length = len^( input_string^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     while i ^< length: >> main.py 2>>nul 
    echo         if input_string[i:i+4] == '^<div': >> main.py 2>>nul 
    echo             stack += 1 >> main.py 2>>nul 
    echo             i += 4 >> main.py 2>>nul 
    echo         elif input_string[i:i+6] == '^</div^>': >> main.py 2>>nul 
    echo             stack -= 1 >> main.py 2>>nul 
    echo             i += 6 >> main.py 2>>nul 
    echo         else: >> main.py 2>>nul 
    echo             i += 1 >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo         if stack == 0: >> main.py 2>>nul 
    echo             break >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     return input_string[start_pos: i] >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo def extract_problem_description_div^( input_string^): >> main.py 2>>nul 
    echo     # Define the start and end markers for the div >> main.py 2>>nul 
    echo     start_marker = f'^<div class=^"header^"^>' >> main.py 2>>nul 
    echo     end_marker = f'^<div class=^"input-specification^"^>' >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     stack = 0 >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     # Find the start and end positions >> main.py 2>>nul 
    echo     start_pos = input_string.find^( start_marker^) >> main.py 2>>nul 
    echo     if start_pos == -1: >> main.py 2>>nul 
    echo         return None  # The div was not found >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     i = start_pos >> main.py 2>>nul 
    echo     length = len^( input_string^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     while i ^< length: >> main.py 2>>nul 
    echo         if input_string[i:i+4] == '^<div': >> main.py 2>>nul 
    echo             stack += 1 >> main.py 2>>nul 
    echo             i += 4 >> main.py 2>>nul 
    echo         elif input_string[i:i+6] == '^</div^>': >> main.py 2>>nul 
    echo             stack -= 1 >> main.py 2>>nul 
    echo             i += 6 >> main.py 2>>nul 
    echo         else: >> main.py 2>>nul 
    echo             i += 1 >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo         if stack == 0: >> main.py 2>>nul 
    echo             break >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     return input_string[i: input_string.find^( end_marker^)] >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo def extract_text_content^( input_string, is_output=False, is_math=False^): >> main.py 2>>nul 
    echo     text_content = [] >> main.py 2>>nul 
    echo     inside_tag = False >> main.py 2>>nul 
    echo     current_text = [] >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     # Specially for math >> main.py 2>>nul 
    echo     if is_math: >> main.py 2>>nul 
    echo         return extract_text_content^( input_string^).replace^( ^"$$$^", ^"$^"^) >> main.py 2>>nul 
    echo     # Specially for output block >> main.py 2>>nul 
    echo     if is_output: >> main.py 2>>nul 
    echo         return extract_text_content^( input_string^).replace^( ^"Output^", ^"^"^).replace^( ^"Input^", ^"^"^).strip^( ^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     for char in input_string: >> main.py 2>>nul 
    echo         if char == '^<': >> main.py 2>>nul 
    echo             if current_text: >> main.py 2>>nul 
    echo                 text_content.append^( ''.join^( current_text^)^) >> main.py 2>>nul 
    echo                 current_text = [] >> main.py 2>>nul 
    echo             inside_tag = True >> main.py 2>>nul 
    echo         elif char == '^>': >> main.py 2>>nul 
    echo             inside_tag = False >> main.py 2>>nul 
    echo             text_content.append^( ' '^) >> main.py 2>>nul 
    echo         elif not inside_tag: >> main.py 2>>nul 
    echo             current_text.append^( char^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     if current_text: >> main.py 2>>nul 
    echo         text_content.append^( ''.join^( current_text^)^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     return ''.join^( text_content^).strip^( ^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo def extract_metric_content^( input_string, getImage=True, is_IO=False^): >> main.py 2>>nul 
    echo     input_string = input_string.replace^( ^"\n^", ^"^"^) >> main.py 2>>nul 
    echo     text_content = [] >> main.py 2>>nul 
    echo     inside_tag = False >> main.py 2>>nul 
    echo     current_text = [] >> main.py 2>>nul 
    echo     tag_content = ^"^" >> main.py 2>>nul 
    echo     image_text = ^"^" >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     for char in input_string: >> main.py 2>>nul 
    echo         if char == '^<': >> main.py 2>>nul 
    echo             if current_text: >> main.py 2>>nul 
    echo                 text_content.append^( ''.join^( current_text^)^) >> main.py 2>>nul 
    echo                 current_text = [] >> main.py 2>>nul 
    echo             inside_tag = True >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo         elif char == '^>': >> main.py 2>>nul 
    echo             inside_tag = False >> main.py 2>>nul 
    echo             if tag_content[:3] == ^"img^": >> main.py 2>>nul 
    echo                 start_pos = tag_content.find^( ^"src=^"^) + 5 >> main.py 2>>nul 
    echo                 end_pos = start_pos + tag_content[start_pos:].find^( ^"\^"^"^) >> main.py 2>>nul 
    echo                 image_text = f^"^![response-image]^( {tag_content[start_pos:end_pos]}^)^" >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo             if tag_content[:2] == ^"li^": >> main.py 2>>nul 
    echo                 image_text = ^"\n- ^" >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo             if tag_content[:3] == ^"/ul^" or tag_content[:2] == ^"/ol^": >> main.py 2>>nul 
    echo                 image_text = ^"\n^" >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo             tag_content = ^"^" >> main.py 2>>nul 
    echo             text_content.append^( '^>'^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo             if getImage and image_text ^!= ^"^": >> main.py 2>>nul 
    echo                 text_content.append^( f^"{image_text}^"^) >> main.py 2>>nul 
    echo                 image_text = ^"^" >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo         elif not inside_tag: >> main.py 2>>nul 
    echo             current_text.append^( char^) >> main.py 2>>nul 
    echo         else: >> main.py 2>>nul 
    echo             tag_content += char >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     if current_text: >> main.py 2>>nul 
    echo         text_content.append^( ''.join^( current_text^)^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     if is_IO: >> main.py 2>>nul 
    echo         return ''.join^( text_content^).replace^( ^"^>^>^", ^"\n^"^).replace^( ^"^>^", ^"^"^).replace^( ^"Input^", ^"^"^).replace^( ^"Output^", ^"^"^).replace^( ^"$$$^", ^"$^"^).strip^( ^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo     return ''.join^( text_content^).replace^( ^"^>^>^", ^"\n^"^).replace^( ^"^>^", ^"^"^).replace^( ^"$$$^", ^"$^"^).strip^( ^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo # Check the number of command-line arguments >> main.py 2>>nul 
    echo if len^( sys.argv^) ^< 2: >> main.py 2>>nul 
    echo     print^( ^"Insufficient arguments: Needed file name^"^) >> main.py 2>>nul 
    echo     sys.exit^( 1^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo # Problem name >> main.py 2>>nul 
    echo if len^( sys.argv^) == 2: >> main.py 2>>nul 
    echo     problem_info = get_problem^( sys.argv[1]^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo # Problem id and index >> main.py 2>>nul 
    echo if len^( sys.argv^) == 3: >> main.py 2>>nul 
    echo     problem_info = get_problem^( sys.argv[1], sys.argv[2]^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo problem_url = f^"https://codeforces.com/problemset/problem/{problem_info[^"contestId^"]}/{problem_info[^"index^"]}^" >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo response = requests.get^( problem_url^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo if response.status_code == 200: >> main.py 2>>nul 
    echo     response_text = response.text >> main.py 2>>nul 
    echo else: >> main.py 2>>nul 
    echo     response_text = ^"^" >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo problem_raw = extract_problem_div^( response_text^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo problem_header = extract_problem_div^( problem_raw, ^"header^"^) >> main.py 2>>nul 
    echo problem_title = extract_problem_div^( problem_header, ^"title^"^) >> main.py 2>>nul 
    echo problem_time_limit = extract_problem_div^( problem_header, ^"time-limit^"^) >> main.py 2>>nul 
    echo problem_memory_limit = extract_problem_div^( problem_header, ^"memory-limit^"^) >> main.py 2>>nul 
    echo problem_input_file = extract_problem_div^( problem_header, ^"input-file^"^) >> main.py 2>>nul 
    echo problem_output_file = extract_problem_div^( problem_header, ^"output-file^"^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo problem_description = extract_problem_description_div^( problem_raw^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo problem_input_specification = extract_problem_div^( problem_raw, ^"input-specification^"^) >> main.py 2>>nul 
    echo problem_output_specification = extract_problem_div^( problem_raw, ^"output-specification^"^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo problem_sample_tests = extract_problem_div^( problem_raw, ^"sample-tests^"^) >> main.py 2>>nul 
    echo problem_sample_test_input = extract_problem_div^( problem_sample_tests, ^"input^"^) >> main.py 2>>nul 
    echo problem_sample_test_output = extract_problem_div^( problem_sample_tests, ^"output^"^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo problem_note = extract_problem_div^( problem_raw, ^"note^"^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo readme_content = f^"^" >> main.py 2>>nul 
    echo readme_content += f^"# {extract_text_content^( problem_title^)} \n --- \n^" >> main.py 2>>nul 
    echo readme_content += f^"\t{extract_text_content^( problem_time_limit^)}\n^" >> main.py 2>>nul 
    echo readme_content += f^"\t{extract_text_content^( problem_memory_limit^)}\n^" >> main.py 2>>nul 
    echo readme_content += f^"\t{extract_text_content^( problem_input_file^)}\n^" >> main.py 2>>nul 
    echo readme_content += f^"\t{extract_text_content^( problem_output_file^)}\n^" >> main.py 2>>nul 
    echo readme_content += f^"{extract_metric_content^( problem_description^)}\n^" >> main.py 2>>nul 
    echo readme_content += f^"#### Input\n{extract_metric_content^( problem_input_specification^)[5:]}\n^" >> main.py 2>>nul 
    echo readme_content += f^"#### Output\n{extract_metric_content^( problem_output_specification^)[6:]}\n^" >> main.py 2>>nul 
    echo readme_content += f^"#### Example\n##### Input\n^<pre^>{extract_metric_content^( problem_sample_test_input^)[5:]}^</pre^>\n^" >> main.py 2>>nul 
    echo readme_content += f^"##### Output\n^<pre^>{extract_text_content^( problem_sample_test_output, is_output=True^)}^</pre^>\n^" >> main.py 2>>nul 
    echo readme_content += f^"##### Note\n{extract_metric_content^( problem_note^)[5:]}\n^" >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo # Make readme >> main.py 2>>nul 
    echo with open^( 'README.md', 'w'^) as f: >> main.py 2>>nul 
    echo     f.write^( readme_content^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo os.makedirs^( 'output', exist_ok=True^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo # Make input >> main.py 2>>nul 
    echo with open^( 'output/input.txt', 'w'^) as f: >> main.py 2>>nul 
    echo     f.write^( extract_metric_content^( problem_sample_test_input^)[6:]^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo # Make output >> main.py 2>>nul 
    echo with open^( 'output/expected_output.txt', 'w'^) as f: >> main.py 2>>nul 
    echo     f.write^( extract_text_content^( problem_sample_test_output, is_output=True^)^) >> main.py 2>>nul 
    echo. >> main.py 2>>nul 
    echo print^( f^"{extract_text_content^( problem_title^).replace^( ^".^", ^"^"^).strip^( ^).replace^( ^" ^", ^"_^"^)}^"^) >> main.py 2>>nul 


    endlocal

    echo %GREEN%Created main.py%RESET%

) else (
    echo %GREEN%main.py exists in the parent directory.%RESET%
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

echo %FOLDER_NAME% | findstr /c:" " >nul
if %errorlevel% equ 0 (
    rem Split the input string by space
    for /f "tokens=1,2 delims= " %%a in ("%FOLDER_NAME%") do (
        set part1=%%a
        set part2=%%b
    )
) else (
    rem No space found, keep the entire string as part1
    set part1=%FOLDER_NAME%
    set part2=
)

python "../main.py" %part1% %part2% > output.txt

set output=

for /f "delims=" %%i in (output.txt) do (
    set output=!output!%%i
)

set "FOLDER_NAME=%output%"

del output.txt

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

    setlocal DisableDelayedExpansion

    echo std::ofstream logger = LogCout^("temp.log"^).logFile; >> %FOLDER_NAME%.cpp 2>>nul
    echo void my_function^( ^) { >> %FOLDER_NAME%.cpp 2>>nul 
    echo     std::string line; >> %FOLDER_NAME%.cpp 2>>nul 
    echo     while ^( std::getline^( cin, line^)^) { >> %FOLDER_NAME%.cpp 2>>nul 
    echo         // Example processing: simply echo the line ^( modify as needed^) >> %FOLDER_NAME%.cpp 2>>nul 
    echo         cout ^<^< line ^<^< std::endl; >> %FOLDER_NAME%.cpp 2>>nul 
    echo     } >> %FOLDER_NAME%.cpp 2>>nul 
    echo } >> %FOLDER_NAME%.cpp 2>>nul 
    echo. >> %FOLDER_NAME%.cpp 2>>nul 
    echo int main^( ^) { >> %FOLDER_NAME%.cpp 2>>nul 
    echo     Timer::Tester^( my_function^); >> %FOLDER_NAME%.cpp 2>>nul 
    echo     return 0; >> %FOLDER_NAME%.cpp 2>>nul 
    echo } >> %FOLDER_NAME%.cpp 2>>nul 
    
    endlocal
    echo %GREEN%Created %FOLDER_NAME%.cpp %RESET%

) else (
    echo %GREEN%template.cpp exists in the parent directory.%RESET%
    echo Copying to %FOLDER_NAME%.cpp...    
    copy "..\template.cpp" "%FOLDER_NAME%.cpp"
)

pause
endlocal
exit

main.py
================================================================

import json
import sys
import requests
import os

if not os.path.exists("../problemset.json"):
    problem_set_json = requests.get("https://codeforces.com/api/problemset.problems").text
    data = json.loads(problem_set_json)["result"]["problems"]
    
else:
    with open('problemset.json', 'r', encoding='utf-8') as file:
        data = json.load(file)
        


def get_problem(name_or_id, index=None):
    """
    Args:
        `name_or_id (string)`: Get the problem with given name or contest id
        `index (string, optional)`: Additional parameter to support contest id. Defaults to None.

    Returns:
        `{'contestId': int,`
        `'index': string,`
        `'name': string,`
        `'tags': list[string],`
        `'type': string}`
    """
    problem = []   
    nullProblem = { 'contestId': 0,
                    'index': '0',
                    'name': '',
                    'tags': [],
                    'type': ''}
    
    # Get problem via problem name
    if index is None:
        problem = [result for result in data if result["name"] == name_or_id]
    
    # Get problem via id and index
    elif str(name_or_id).isdecimal():
        problem = [result for result in data if result["contestId"] == int(name_or_id) and result["index"] == index]
    
    problem = nullProblem if len(problem) == 0 else problem[0]
    return problem    


def extract_problem_div(input_string, className="problem-statement"):
    # Define the start and end markers for the div
    start_marker = f'<div class="{className}">'
    
    stack = 0
    
    # Find the start and end positions
    start_pos = input_string.find(start_marker)
    if start_pos == -1:
        return None  # The div was not found
    
    i = start_pos
    length = len(input_string)
    
    while i < length:
        if input_string[i:i+4] == '<div':
            stack += 1
            i += 4
        elif input_string[i:i+6] == '</div>':
            stack -= 1
            i += 6
        else:
            i += 1
        
        if stack == 0:
            break

    return input_string[start_pos: i]


def extract_problem_description_div(input_string):
    # Define the start and end markers for the div
    start_marker = f'<div class="header">'
    end_marker = f'<div class="input-specification">'

    stack = 0
    
    # Find the start and end positions
    start_pos = input_string.find(start_marker)
    if start_pos == -1:
        return None  # The div was not found
    
    i = start_pos
    length = len(input_string)
    
    while i < length:
        if input_string[i:i+4] == '<div':
            stack += 1
            i += 4
        elif input_string[i:i+6] == '</div>':
            stack -= 1
            i += 6
        else:
            i += 1
        
        if stack == 0:
            break
            
    return input_string[i: input_string.find(end_marker)]


def extract_text_content(input_string, is_output=False, is_math=False):
    text_content = []
    inside_tag = False
    current_text = []
    
    # Specially for math
    if is_math:
        return extract_text_content(input_string).replace("$$$", "$")
    # Specially for output block
    if is_output:
        return extract_text_content(input_string).replace("Output", "").replace("Input", "").strip()
        
    for char in input_string:
        if char == '<':
            if current_text:
                text_content.append(''.join(current_text))
                current_text = []
            inside_tag = True
        elif char == '>':
            inside_tag = False
            text_content.append(' ')
        elif not inside_tag:
            current_text.append(char)
    
    if current_text:
        text_content.append(''.join(current_text))
    
    return ''.join(text_content).strip()


def extract_metric_content(input_string, getImage=True, is_IO=False):
    input_string = input_string.replace("\n", "")
    text_content = []
    inside_tag = False
    current_text = []
    tag_content = ""
    image_text = ""
    
    for char in input_string:
        if char == '<':
            if current_text:
                text_content.append(''.join(current_text))
                current_text = []
            inside_tag = True
            
        elif char == '>':
            inside_tag = False
            if tag_content[:3] == "img":
                start_pos = tag_content.find("src=") + 5
                end_pos = start_pos + tag_content[start_pos:].find("\"")
                image_text = f"![response-image]({tag_content[start_pos:end_pos]})"
            
            if tag_content[:2] == "li":
                image_text = "\n- "

            if tag_content[:3] == "/ul" or tag_content[:2] == "/ol":
                image_text = "\n"
                
            tag_content = ""
            text_content.append('>')
            
            if getImage and image_text != "":
                text_content.append(f"{image_text}")
                image_text = ""
            
        elif not inside_tag:
            current_text.append(char)
        else:
            tag_content += char                
            
    if current_text:
        text_content.append(''.join(current_text))
    
    if is_IO:
        return ''.join(text_content).replace(">>", "\n").replace(">", "").replace("Input", "").replace("Output", "").replace("$$$", "$").strip()
    
    return ''.join(text_content).replace(">>", "\n").replace(">", "").replace("$$$", "$").strip()


# Check the number of command-line arguments
if len(sys.argv) < 2:
    print("Insufficient arguments: Needed file name")
    sys.exit(1)

# Problem name
if len(sys.argv) == 2:
    problem_info = get_problem(sys.argv[1])
    
# Problem id and index
if len(sys.argv) == 3:
    problem_info = get_problem(sys.argv[1], sys.argv[2])
    
    
problem_url = f"https://codeforces.com/problemset/problem/{problem_info["contestId"]}/{problem_info["index"]}"

response = requests.get(problem_url)

if response.status_code == 200:
    response_text = response.text
else:
    response_text = ""

problem_raw = extract_problem_div(response_text)

problem_header = extract_problem_div(problem_raw, "header")
problem_title = extract_problem_div(problem_header, "title")
problem_time_limit = extract_problem_div(problem_header, "time-limit")
problem_memory_limit = extract_problem_div(problem_header, "memory-limit")
problem_input_file = extract_problem_div(problem_header, "input-file")
problem_output_file = extract_problem_div(problem_header, "output-file")

problem_description = extract_problem_description_div(problem_raw)

problem_input_specification = extract_problem_div(problem_raw, "input-specification")
problem_output_specification = extract_problem_div(problem_raw, "output-specification")

problem_sample_tests = extract_problem_div(problem_raw, "sample-tests")
problem_sample_test_input = extract_problem_div(problem_sample_tests, "input")
problem_sample_test_output = extract_problem_div(problem_sample_tests, "output")

problem_note = extract_problem_div(problem_raw, "note")


readme_content = f""
readme_content += f"# {extract_text_content(problem_title)} \n --- \n"
readme_content += f"\t{extract_text_content(problem_time_limit)}\n"
readme_content += f"\t{extract_text_content(problem_memory_limit)}\n"
readme_content += f"\t{extract_text_content(problem_input_file)}\n"
readme_content += f"\t{extract_text_content(problem_output_file)}\n"
readme_content += f"{extract_metric_content(problem_description)}\n"
readme_content += f"#### Input\n{extract_metric_content(problem_input_specification)[5:]}\n"
readme_content += f"#### Output\n{extract_metric_content(problem_output_specification)[6:]}\n"
readme_content += f"#### Example\n##### Input\n<pre>{extract_metric_content(problem_sample_test_input)[5:]}</pre>\n"
readme_content += f"##### Output\n<pre>{extract_text_content(problem_sample_test_output, is_output=True)}</pre>\n"
readme_content += f"##### Note\n{extract_metric_content(problem_note)[5:]}\n"

# Make readme
with open('README.md', 'w') as f:
    f.write(readme_content)


os.makedirs('output', exist_ok=True)

# Make input
with open('output/input.txt', 'w') as f:
    f.write(extract_metric_content(problem_sample_test_input)[6:])

# Make output
with open('output/expected_output.txt', 'w') as f:
    f.write(extract_text_content(problem_sample_test_output, is_output=True))

print(f"{extract_text_content(problem_title).replace(".", "").strip().replace(" ", "_")}")


test_suite.h
================================================================

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
        Modifier( Code pCode) : code( pCode) {}  
        friend std::ostream &  
        operator<<( std::ostream &os, const Modifier &mod)  
        {  
            return os << "\033[" << mod.code << "m";  
        }  
    };  
  
    Modifier red( Color::FG_RED);  
    Modifier green( Color::FG_GREEN);  
    Modifier yellow( Color::FG_YELLOW);  
    Modifier blue( Color::FG_BLUE);  
    Modifier magenta( Color::FG_MAGENTA);  
    Modifier cyan( Color::FG_CYAN);  
    Modifier lightGray( Color::FG_LIGHT_GRAY);  
    Modifier darkGray( Color::FG_DARK_GRAY);  
    Modifier lightRed( Color::FG_LIGHT_RED);  
    Modifier lightGreen( Color::FG_LIGHT_GREEN);  
    Modifier lightYellow( Color::FG_LIGHT_YELLOW);  
    Modifier lightBlue( Color::FG_LIGHT_BLUE);  
    Modifier lightMagenta( Color::FG_LIGHT_MAGENTA);  
    Modifier lightCyan( Color::FG_LIGHT_CYAN);  
    Modifier white( Color::FG_WHITE);  
    Modifier def( Color::FG_DEFAULT);  
  
    Modifier bgRed( Color::BG_RED);  
    Modifier bgGreen( Color::BG_GREEN);  
    Modifier bgYellow( Color::BG_YELLOW);  
    Modifier bgBlue( Color::BG_BLUE);  
    Modifier bgMagenta( Color::BG_MAGENTA);  
    Modifier bgCyan( Color::BG_CYAN);  
    Modifier bgLightGray( Color::BG_LIGHT_GRAY);  
    Modifier bgDarkGray( Color::BG_DARK_GRAY);  
    Modifier bgLightRed( Color::BG_LIGHT_RED);  
    Modifier bgLightGreen( Color::BG_LIGHT_GREEN);  
    Modifier bgLightYellow( Color::BG_LIGHT_YELLOW);  
    Modifier bgLightBlue( Color::BG_LIGHT_BLUE);  
    Modifier bgLightMagenta( Color::BG_LIGHT_MAGENTA);  
    Modifier bgLightCyan( Color::BG_LIGHT_CYAN);  
    Modifier bgWhite( Color::BG_WHITE);  
    Modifier bgDef( Color::BG_DEFAULT);  
  
    Modifier bold( Color::BOLD);  
    Modifier underline( Color::UNDERLINE);  
    Modifier reset( Color::RESET);  
}  
  
// --------------------------- Terminal Helper Functions ------------------------  
int getTerminalWidth( ) {  
#ifdef _WIN32  
    CONSOLE_SCREEN_BUFFER_INFO csbi;  
    int columns;  
    GetConsoleScreenBufferInfo( GetStdHandle( STD_OUTPUT_HANDLE), &csbi);  
    columns = csbi.srWindow.Right - csbi.srWindow.Left + 1;  
    return columns;  
#else  
    struct winsize w;  
    ioctl( STDOUT_FILENO, TIOCGWINSZ, &w);  
    return w.ws_col;  
#endif  
}  
  
  
//----------------------------- Logging Helper Functions --------------------------------  
#ifndef LOGCOUT_H  
#define LOGCOUT_H  
class LogCout {  
    private:  
        std::string formatNumber( long long int number) {  
            std::stringstream ss;  
            ss << number;  
            std::string numberStr = ss.str( );  
            std::string formattedNumber;  
            int count = 0;  
  
            for ( int i = numberStr.size( ) - 1; i >= 0; --i) {  
                formattedNumber = numberStr[i] + formattedNumber;  
                count++;  
                if ( count % 3 == 0 && i > 0) {  
                    formattedNumber = ' ' + formattedNumber;  
                }  
            }  
            // Remove trailing zeros  
            while ( !formattedNumber.empty( ) && formattedNumber.back( ) == '0') {  
                formattedNumber.pop_back( );  
            }  
            return formattedNumber;  
        }  
  
    public:  
        std::ofstream logFile;  
        LogCout( const std::string& filename) {  
            logFile.open( filename, std::ios::app);  
        }  
  
        ~LogCout( ) {  
            logFile.close( );  
        }  
  
        template <typename T>  
        LogCout& operator<<( const T& output) {  
            auto currentTime = std::chrono::high_resolution_clock::now( );  
            auto epochTime = std::chrono::time_point_cast<std::chrono::nanoseconds>( currentTime).time_since_epoch( );  
            auto nanoseconds = std::chrono::duration_cast<std::chrono::nanoseconds>( epochTime);  
            auto formattedNumber = formatNumber( nanoseconds.count( ));  
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

std::string trim(const std::string& str) {
    size_t first = str.find_first_not_of(' ');
    if (first == std::string::npos) {
        return ""; // no content
    }
    size_t last = str.find_last_not_of(' ');
    return str.substr(first, (last - first + 1));
}

class Timer {  
public:  
    // Function to measure execution time  
    template<typename Func>  
    static double measureTime( Func func) {  
        auto start = high_resolution_clock::now( );  
        func( );  
        auto end = high_resolution_clock::now( );  
        duration<double> elapsed = end - start;  
        return elapsed.count( );  
    }  
  
  
    // Function template to test a given function with multiple test cases from a file  
    template<typename Func>  
    static void Tester( Func func) {  

        LogCout logger( "tests.log");  
        int width = getTerminalWidth( );  
        std::string dashes( width, '-');  
        std::string ddashes( width, '=');  

        cout << ddashes << endl; 
        // Open the input file and redirect cin
        std::ifstream bufferInputFile("input.txt");
        if (!bufferInputFile.is_open()) {
            std::cerr << "Error: Could not open input file!" << std::endl;
            logger << "Error: Could not open input file!";
            return;
        }
        std::streambuf* cinBuffer = std::cin.rdbuf(bufferInputFile.rdbuf());
        logger << "Input buffer redirected : cin to input file";

        // Prepare the output file and redirect cout
        std::ofstream bufferOutputFile("output.txt");
        if (!bufferOutputFile.is_open()) {
            std::cerr << "Error: Could not open output file!" << std::endl;
            logger << "Error: Could not open output file!";
            return;
        }
        std::streambuf* coutBuffer = std::cout.rdbuf(bufferOutputFile.rdbuf());
        logger << "Output buffer redirected : cout to output file";

        // Call the function that processes input using cin and cout
        double timeTaken = measureTime(func);  
        logger << "Executing function...";

        // Restore cin and cout to their original states
        std::cin.rdbuf(cinBuffer);
        std::cout.rdbuf(coutBuffer);
        logger << "Restored cin and cout buffers to original state";

        // Close the files
        bufferInputFile.close();
        bufferOutputFile.close();

        cout << Color::yellow << "Function successfully executed" << Color::def << std::endl;
        cout << dashes << endl; 

        ifstream outputFile( "output.txt"); 
        ifstream expectedOutputFile( "expected_output.txt");  
        string messageString;
        if (outputFile.is_open() && expectedOutputFile.is_open()){  
            logger << "Opening the output and expected output files";
            std::string o_line, e_line;  
            int currentLine = 0;  
            while (std::getline( outputFile, o_line) && std::getline(expectedOutputFile, e_line)) {  
                o_line = trim(o_line);
                e_line = trim(e_line);
                currentLine++;  
                string logLine = "Comparing Line [" + to_string(currentLine) + "] Expected : " + e_line + "\t Got : " + o_line;
                logger << logLine;
                if ( o_line != e_line) {  
                    messageString = "At line [" + to_string(currentLine) + "] |  Expected : " + e_line + "\t Got : " + o_line;
                    break;  
                }  
            }  
            if ( messageString.empty()) {  
                cout << Color::green << "Test passed" << Color::def << endl;  
                logger << "Test passed";
            } else {  
                cout << Color::red << "Test failed" << endl << messageString << Color::def << endl;  
                logger << "Test failed";
            }  

            outputFile.close();
            expectedOutputFile.close();  
            cout << dashes << endl;
            cout << Color::blue << "Time taken: " << Color::def << timeTaken << " seconds" << endl;  
            logger << "Time taken: " + to_string(timeTaken);
            cout << ddashes << endl;
        }         
    }
  
};  
  
#endif // TIMER_H  


template.cpp
================================================================
#include "../test_suite.h"

// Example function that uses cin and cout
void my_function() {
    std::string line;
    while (std::getline(cin, line)) {
        // Example processing: simply echo the line (modify as needed)
        cout << line << std::endl;
    }
}

int main() {
    Timer::Tester(my_function);
    return 0;
}

