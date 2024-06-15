#include "test_suite.h"
std::ofstream logger = LogCout("output.log").logFile;

// TODO: Change function_name


auto function_name(const string& input) {
    // Do-something

    // Debug cout
    logger << input << endl;
    
    // Actual cout
    cout << input;
}

int main(int argc, char* argv[]) {
    
    // Using test cases file (batch operation)
    if (argc > 1) {
        string testFile = argv[1];
        Timer::Tester(function_name, testFile);
    }
    else {
        cout << Color::blue << "Choose runtime configuration : " << Color::def << "[ " << Color::red << "0" << Color::def << " : for input file, " << Color::red << "1" << Color::def<< " : for terminal input] : ";
        int runType = 0;
        cin >> runType;

        // Using input file
        if (runType == 0){
            Timer::Tester(function_name);
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
            std::cout << Color::blue << "Output: " << Color::def << actualOutput << std::endl << Color::blue << "Time Elapsed : " << Color::def << elapsedTime << " seconds";
        }
    }
}