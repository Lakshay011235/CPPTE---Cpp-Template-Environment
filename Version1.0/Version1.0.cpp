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
