#include "timer.h"
#include "LogCout.h"

std::ofstream logger = LogCout("output.log").logFile;


// Multi-line fetching
//----------------------------------------------------------------
// string line;
// while (getline(cin, line)) {
//     istringstream iss(line);
//     string testCase;
//     if (iss >> testCase) {}
// }



// Example function to be tested
auto exampleFunction(const string& input) {
    logger << input << endl;
    cout << input;
}

int main(int argc, char* argv[]) {

    string testFile = "test_cases.txt";
    string testCase = "1"; 

    if (argc > 1) {
        testFile = argv[1];
        Timer::Tester(exampleFunction, testFile);
    }

    cout << Color::white << testFile << Color::reset << endl;
    cout << Color::bold << Color::white << testFile << Color::reset << endl;
    cout << Color::underline << Color::white << testFile << Color::reset << endl;


    // Run the tester | Auto-Run
    // Timer::Tester(exampleFunction);

    // Get time elapsed | Single-Run
    double elapsedTime = Timer::measureTime([=]() {exampleFunction(testCase);});    stringstream outputStream;    streambuf* coutBuffer = cout.rdbuf(outputStream.rdbuf());    exampleFunction(testCase);    cout.rdbuf(coutBuffer);    string actualOutput = outputStream.str(); std::cout << Color::blue << "Output: " << Color::def << actualOutput << std::endl << Color::blue << "Time Elapsed : " << Color::def << elapsedTime << " seconds";
    
    // Run the tester | Test-Suite-Run
    // Timer::Tester(exampleFunction, testFile);

    return 0;
}
