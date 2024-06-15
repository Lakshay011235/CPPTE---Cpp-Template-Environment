# CPP Template Environment (CPPTE)

This include a script is used to create a new template folder with C++ executable environment and other script to run test files against cpp files.

__FOR QUICK USE__: [online gdb](https://onlinegdb.com/BDwTxs-AM)

https://onlinegdb.com/BDwTxs-AM

__Features:__

   1. Ready-to-use c++ environment
   2. Advanced logging and testing support
   3. Simple to use input and output txt files for interview like experience

__Default structure:__

```(md)
Parent directory
|
+- [filename] ^(Current directory)
|   |
|   +- output
|   |  | 
|   |  +- output.exe
|   |  +- input.txt
|   |  +- output.log
|   |  +- tests.log
|   |  +- output.txt
|   |
|   +- README.md
|   +- test_[filename].cpp
|   +- [filename].cpp 
| 
+- test_suite.h
```

__How to use:__

- Make sure to install g++ compiler before running this script
- Select the folder where you want to create the environment
- Enter the folder name. Spaces are not be recommended.
- Choose whether you want test file.
- Choose if you want to have a README file
- Choose the input.txt option if you want to have input file
- Output file will be availible only if you have chosen input file. Output file will be connected to input automatically.
- Finally, you can let the script to make a dummy executable and log to verify the install.

__NOTE:__ Incase you want to use a __different template file__, you can have the template.cpp file defined in the parent folder you chose earlier.
__NOTE:__ This script is made for Windows 10 and above. If you use linux, you are smart enough to change this batch file to your needs.

---

_Common Errors:_

- Error in making of C++ file: please use the template.cpp defined in the comments of this file to override the sample content.
- Error in compilation of C++ file: please use the test_suite.h defined in the comments of this file or check if the C++ compiler is of version 17 and above.
- Error in dialog box opening: Install powershell (recommended) or set the selectedFolder variable to folderPath in the code `set "selectedFolder=%folderPath%"` 

---

## Instructions for running test suite

This test suite is compatible with testing and logging of functions.

Time taken for execution is calculated automatically.

Futures:

- [x] Add functionality for one large input and output files for code-forces 
- [ ] Add time-limit-exceeded error
- [x] File should find its test files automatically
- [x] Add support for separate folders
- [x] Combine all headers into one file
- [x] Add support for automatic test cases files

---

The C++ file should have following structure:

```(cpp)
int main(int argc, char* argv[]) {
    if (argc > 1) {
        string testFile = argv[1];
        Timer::Tester(function_name, testFile)
    }
}
```

---

Input of the function should be with `string` 
Output of the function should be with `cout`

```(cpp)
auto function_name(const string& input) {
    // Do-something

    cout << output;
}
```

---

###### For specific test case run, you can use __"input.txt"__ for input medium

```(cpp)
int main(int argc, char* argv[]) {
    Timer::Tester(function_name)  // Uses the content of input.txt for function input
}
```

---

#### For debugging: use `logger` instead of `cout` in function_name:

```(cpp)
#include "LogCout.h"
std::ofstream logger = LogCout("output.log").logFile;

// In the function call
logger << "Say something cool" << endl;
```

The debug will be returned in __output.log__ file.

---

For version information, check __Version0.1, Version0.2__
Current version: __Version1.0__

---

### Boilerplate (template.cpp):

```(cpp)
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
```

### Boilerplate (test_suite.h):

```(cpp)
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
  
class Timer {  
public:  
    // Function to measure execution time  
    template<typename Func>  
    static double measureTime( Func func) {  
        auto start = high_resolution_clock::now( );  
        stringstream outputStream;  
        streambuf* coutBuffer = cout.rdbuf( outputStream.rdbuf( ));  
        func( );  
        cout.rdbuf( coutBuffer);  
        auto end = high_resolution_clock::now( );  
        duration<double> elapsed = end - start;  
        return elapsed.count( );  
    }  
  
  
    // Function template to test a given function with multiple test cases from a file  
    template<typename Func>  
    static void Tester( Func func) {  
        int test_count = 0;  
        ifstream inputFile( "input.txt");  
        if ( inputFile.is_open( )) {  
            string line;  
            while ( getline( inputFile, line)) {  
                istringstream iss( line);  
                test_count++;  
                string testCase;  
                if ( iss >> testCase) {  
                    stringstream outputStream;  
                    // Redirect cout to outputStream  
                    streambuf* coutBuffer = cout.rdbuf( outputStream.rdbuf( ));  
                    func( testCase);  
                    // Restore cout to standard output  
                    cout.rdbuf( coutBuffer);  
                    string actualOutput = outputStream.str( );  
                    double timeTaken = measureTime( [func, testCase]( ) { func( testCase); });  
                    cout << Color::blue << "Output: " << Color::def << actualOutput << endl;  
                    string expectedOutput;  
                    ifstream outputFile( "output.txt");  
                    if ( outputFile.is_open( )){  
                        std::string o_line;  
                        int currentLine = 0;  
                        while ( std::getline( outputFile, o_line)) {  
                            currentLine++;  
                            if ( currentLine == test_count) {  
                                expectedOutput = o_line;  
                                break;  
                            }  
                        }  
                        if ( actualOutput == expectedOutput) {  
                            cout << Color::green << "Test case passed" << Color::def << endl;  
                        } else {  
                            cout << Color::red << "Test case failed" << endl << Color::blue << "Expected : " << Color::def << expectedOutput << endl;  
                        }  
                        outputFile.close( );  
                    }  
                    cout << Color::blue << "Time taken: " << Color::def << timeTaken << " seconds" << endl;  
                } else {  
                    cerr << Color::red << "Invalid test case format: " << line << Color::def << endl;  
                }  
            }  
            inputFile.close( );  
        } else {  
            int make_input_file = 2;  
            cout << Color::red << "Error: " << Color::def << " input.txt does not exist in the folder where the executable is present.\nTo add a new input.txt file press " << Color::red << "0" << Color::def << " else press any key: " << std::flush;  
            cin.clear( );  
            cin.ignore( numeric_limits<streamsize>::max( ), '\n');  
            cin >> make_input_file;  
            if ( make_input_file == 0) {  
                ofstream outFile( "input.txt");  
                if ( outFile.is_open( )) {  
                    string testCase;  
                    cout << Color::blue << "Input: " << Color::def;  
                    cin.clear( );  
                    cin.ignore( numeric_limits<streamsize>::max( ), '\n');  
                    cin >> testCase;  
                    outFile << testCase;  
                    outFile.close( );  
  
                    // Prompt to make output file  
                    int make_output_file = 2;  
                    cout << Color::yellow << "Warning: " << Color::def << " output.txt does not exist in the folder where the executable is present.\nTo add a new output.txt file press " << Color::red << "0" << Color::def << " else press any key: " << std::flush;  
                    cin.clear( );  
                    cin.ignore( numeric_limits<streamsize>::max( ), '\n');  
                    cin >> make_output_file;  
                    if ( make_output_file == 0) {  
                        ofstream outFile( "output.txt");  
                        if ( outFile.is_open( )) {  
                            string testCase;  
                            cout << Color::blue << "Output: " << Color::def;  
                            cin.clear( );  
                            cin.ignore( numeric_limits<streamsize>::max( ), '\n');  
                            cin >> testCase;  
                            outFile << testCase;  
                            outFile.close( );  
                        } else {  
                            cout << Color::red << "Error: " << Color::def << "Could not open the file for writing." << endl;  
                        }  
                    }  
                    Tester( func);  // Call Tester again after creating the file  
                } else {  
                    cout << Color::red << "Error: " << Color::def << "Could not open the file for writing." << endl;  
                }  
            }  
        }  
    }  
    // Function to test a function with multiple test cases from a file  
    template<typename Func>  
    static void Tester( Func func, const string& testFile) {  
        int width = getTerminalWidth( );  
        int total_cases = 0;  
        int total_cases_passed = 0;  
        LogCout logger( "tests.log");  
        string logString;  
  
        ifstream file( testFile);  
        if ( !file.is_open( )) {  
            cerr << "Unable to open test file: " << testFile << endl;  
            return;  
        }  
  
        string line;  
        std::string dashes( width, '-');  
        std::string ddashes( width, '=');  
        while ( getline( file, line)) {  
            istringstream iss( line);  
            string testCase, expectedOutput;  
            if ( iss >> testCase >> expectedOutput) {  
                total_cases++;  
                cout << ddashes << endl;  
                cout << "Running test case: " << total_cases << endl;  
                stringstream outputStream;  
                // Redirect cout to outputStream  
                streambuf* coutBuffer = cout.rdbuf( outputStream.rdbuf( ));  
                func( testCase);  
                // Restore cout to standard output  
                cout.rdbuf( coutBuffer);  
                string actualOutput = outputStream.str( );  
                double timeTaken = measureTime( [func, testCase]( ) { func( testCase); });  
                cout << dashes << endl;  
                cout << "Time taken: " << Color::blue << timeTaken << " seconds" << Color::def << endl;  
                // cout << "Expected output: " << expectedOutput << endl;  
                // cout << "Actual output: " << actualOutput << endl;  
                logString = "Test case " + to_string( total_cases) + "\t| ";  
  
                if ( actualOutput == expectedOutput) {  
                    cout << Color::green << "Test case passed" << Color::def << endl;  
                    total_cases_passed++;  
                    logString += "[O] | ";  
                } else {  
                    cout << Color::red << "Test case failed" << endl << Color::blue << "Expected : " << Color::def << expectedOutput << endl << Color::blue << "Got : " << Color::def << actualOutput << endl;  
                    logString += "[X] | ";  
                }  
                logString += "Time Taken: " + to_string( timeTaken) + " seconds\t| ";  
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
  
  
        file.close( );  
    }  
  
};  
  
#endif // TIMER_H  
```
