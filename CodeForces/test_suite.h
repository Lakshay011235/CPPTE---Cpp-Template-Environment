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
        Modifier(  Code pCode) : code(  pCode) {}  
        friend std::ostream &  
        operator<<(  std::ostream &os, const Modifier &mod)  
        {  
            return os << "\033[" << mod.code << "m";  
        }  
    };  
  
    Modifier red(  Color::FG_RED);  
    Modifier green(  Color::FG_GREEN);  
    Modifier yellow(  Color::FG_YELLOW);  
    Modifier blue(  Color::FG_BLUE);  
    Modifier magenta(  Color::FG_MAGENTA);  
    Modifier cyan(  Color::FG_CYAN);  
    Modifier lightGray(  Color::FG_LIGHT_GRAY);  
    Modifier darkGray(  Color::FG_DARK_GRAY);  
    Modifier lightRed(  Color::FG_LIGHT_RED);  
    Modifier lightGreen(  Color::FG_LIGHT_GREEN);  
    Modifier lightYellow(  Color::FG_LIGHT_YELLOW);  
    Modifier lightBlue(  Color::FG_LIGHT_BLUE);  
    Modifier lightMagenta(  Color::FG_LIGHT_MAGENTA);  
    Modifier lightCyan(  Color::FG_LIGHT_CYAN);  
    Modifier white(  Color::FG_WHITE);  
    Modifier def(  Color::FG_DEFAULT);  
  
    Modifier bgRed(  Color::BG_RED);  
    Modifier bgGreen(  Color::BG_GREEN);  
    Modifier bgYellow(  Color::BG_YELLOW);  
    Modifier bgBlue(  Color::BG_BLUE);  
    Modifier bgMagenta(  Color::BG_MAGENTA);  
    Modifier bgCyan(  Color::BG_CYAN);  
    Modifier bgLightGray(  Color::BG_LIGHT_GRAY);  
    Modifier bgDarkGray(  Color::BG_DARK_GRAY);  
    Modifier bgLightRed(  Color::BG_LIGHT_RED);  
    Modifier bgLightGreen(  Color::BG_LIGHT_GREEN);  
    Modifier bgLightYellow(  Color::BG_LIGHT_YELLOW);  
    Modifier bgLightBlue(  Color::BG_LIGHT_BLUE);  
    Modifier bgLightMagenta(  Color::BG_LIGHT_MAGENTA);  
    Modifier bgLightCyan(  Color::BG_LIGHT_CYAN);  
    Modifier bgWhite(  Color::BG_WHITE);  
    Modifier bgDef(  Color::BG_DEFAULT);  
  
    Modifier bold(  Color::BOLD);  
    Modifier underline(  Color::UNDERLINE);  
    Modifier reset(  Color::RESET);  
}  
  
// --------------------------- Terminal Helper Functions ------------------------  
int getTerminalWidth(  ) {  
#ifdef _WIN32  
    CONSOLE_SCREEN_BUFFER_INFO csbi;  
    int columns;  
    GetConsoleScreenBufferInfo(  GetStdHandle(  STD_OUTPUT_HANDLE), &csbi);  
    columns = csbi.srWindow.Right - csbi.srWindow.Left + 1;  
    return columns;  
#else  
    struct winsize w;  
    ioctl(  STDOUT_FILENO, TIOCGWINSZ, &w);  
    return w.ws_col;  
#endif  
}  
  
  
//----------------------------- Logging Helper Functions --------------------------------  
#ifndef LOGCOUT_H  
#define LOGCOUT_H  
class LogCout {  
    private:  
        std::string formatNumber(  long long int number) {  
            std::stringstream ss;  
            ss << number;  
            std::string numberStr = ss.str(  );  
            std::string formattedNumber;  
            int count = 0;  
  
            for (  int i = numberStr.size(  ) - 1; i >= 0; --i) {  
                formattedNumber = numberStr[i] + formattedNumber;  
                count++;  
                if (  count % 3 == 0 && i > 0) {  
                    formattedNumber = ' ' + formattedNumber;  
                }  
            }  
            // Remove trailing zeros  
            while (  !formattedNumber.empty(  ) && formattedNumber.back(  ) == '0') {  
                formattedNumber.pop_back(  );  
            }  
            return formattedNumber;  
        }  
  
    public:  
        std::ofstream logFile;  
        LogCout(  const std::string& filename) {  
            logFile.open(  filename, std::ios::app);  
        }  
  
        ~LogCout(  ) {  
            logFile.close(  );  
        }  
  
        template <typename T>  
        LogCout& operator<<(  const T& output) {  
            auto currentTime = std::chrono::high_resolution_clock::now(  );  
            auto epochTime = std::chrono::time_point_cast<std::chrono::nanoseconds>(  currentTime).time_since_epoch(  );  
            auto nanoseconds = std::chrono::duration_cast<std::chrono::nanoseconds>(  epochTime);  
            auto formattedNumber = formatNumber(  nanoseconds.count(  ));  
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
  
std::string trim( const std::string& str) {  
    size_t first = str.find_first_not_of( ' ');  
    if ( first == std::string::npos) {  
        return ""; // no content  
    }  
    size_t last = str.find_last_not_of( ' ');  
    return str.substr( first, ( last - first + 1));  
}  
  
class Timer {  
public:  
    // Function to measure execution time  
    template<typename Func>  
    static double measureTime(  Func func) {  
        auto start = high_resolution_clock::now(  );  
        func(  );  
        auto end = high_resolution_clock::now(  );  
        duration<double> elapsed = end - start;  
        return elapsed.count(  );  
    }  
  
  
    // Function template to test a given function with multiple test cases from a file  
    template<typename Func>  
    static void Tester(  Func func) {  
  
        LogCout logger(  "tests.log");  
        int width = getTerminalWidth(  );  
        std::string dashes(  width, '-');  
        std::string ddashes(  width, '=');  
  
        cout << ddashes << endl;  
        // Open the input file and redirect cin  
        std::ifstream bufferInputFile( "input.txt");  
        if ( !bufferInputFile.is_open( )) {  
            std::cerr << "Error: Could not open input file!" << std::endl;  
            logger << "Error: Could not open input file!";  
            return;  
        }  
        std::streambuf* cinBuffer = std::cin.rdbuf( bufferInputFile.rdbuf( ));  
        logger << "Input buffer redirected : cin to input file";  
  
        // Prepare the output file and redirect cout  
        std::ofstream bufferOutputFile( "output.txt");  
        if ( !bufferOutputFile.is_open( )) {  
            std::cerr << "Error: Could not open output file!" << std::endl;  
            logger << "Error: Could not open output file!";  
            return;  
        }  
        std::streambuf* coutBuffer = std::cout.rdbuf( bufferOutputFile.rdbuf( ));  
        logger << "Output buffer redirected : cout to output file";  
  
        // Call the function that processes input using cin and cout  
        double timeTaken = measureTime( func);  
        logger << "Executing function...";  
  
        // Restore cin and cout to their original states  
        std::cin.rdbuf( cinBuffer);  
        std::cout.rdbuf( coutBuffer);  
        logger << "Restored cin and cout buffers to original state";  
  
        // Close the files  
        bufferInputFile.close( );  
        bufferOutputFile.close( );  
  
        cout << Color::yellow << "Function successfully executed" << Color::def << std::endl;  
        cout << dashes << endl;  
  
        ifstream outputFile(  "output.txt");  
        ifstream expectedOutputFile(  "expected_output.txt");  
        string messageString;  
        if ( outputFile.is_open( ) && expectedOutputFile.is_open( )){  
            logger << "Opening the output and expected output files";  
            std::string o_line, e_line;  
            int currentLine = 0;  
            while ( std::getline(  outputFile, o_line) && std::getline( expectedOutputFile, e_line)) {  
                o_line = trim( o_line);  
                e_line = trim( e_line);  
                currentLine++;  
                string logLine = "Comparing Line [" + to_string( currentLine) + "] Expected : " + e_line + "\t Got : " + o_line;  
                logger << logLine;  
                if (  o_line != e_line) {  
                    messageString = "At line [" + to_string( currentLine) + "] |  Expected : " + e_line + "\t Got : " + o_line;  
                    break;  
                }  
            }  
            if (  messageString.empty( )) {  
                cout << Color::green << "Test passed" << Color::def << endl;  
                logger << "Test passed";  
            } else {  
                cout << Color::red << "Test failed" << endl << messageString << Color::def << endl;  
                logger << "Test failed";  
            }  
  
            outputFile.close( );  
            expectedOutputFile.close( );  
            cout << dashes << endl;  
            cout << Color::blue << "Time taken: " << Color::def << timeTaken << " seconds" << endl;  
            logger << "Time taken: " + to_string( timeTaken);  
            cout << ddashes << endl;  
        }  
    }  
  
};  
  
#endif // TIMER_H  
