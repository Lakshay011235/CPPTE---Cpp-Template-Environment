#ifndef TIMER_H
#define TIMER_H

#include <iostream>
#include <chrono>
#include <functional>
#include <fstream>
#include <sstream>
#include <string>
#include "color.h"
#include "terminalHelp.h"
#include "logCout.h"

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
    // Function to test a function with multiple test cases from a file
    template<typename Func>
    static void Tester(Func func) {
        freopen("input.txt", "r", stdin);
        string line;
        while (getline(cin, line)) {
            istringstream iss(line);
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
                cout << Color::blue << "Time taken: " << Color::def << timeTaken << " seconds" << endl;


            } else {
                cerr << Color::red << "Invalid test case format: " << line << Color::def << endl;
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