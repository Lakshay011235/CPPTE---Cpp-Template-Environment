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
        FG_BLUE = 34,
        FG_DEFAULT = 39,
        BG_RED = 41,
        BG_GREEN = 42,
        BG_BLUE = 44,
        BG_DEFAULT = 49
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
    Modifier blue(Color::FG_BLUE);
    Modifier def(Color::FG_DEFAULT);
    Modifier bgRed(Color::BG_RED);
    Modifier bgGreen(Color::BG_GREEN);
    Modifier bgBlue(Color::BG_BLUE);
    Modifier bgDef(Color::BG_DEFAULT);
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



// ------------------------------------ Timing and Testing Helper Functions --------------------------------
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
