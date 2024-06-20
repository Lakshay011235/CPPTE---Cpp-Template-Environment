#include "../test_suite.h" 
std::ofstream logger = LogCout("temp.log").logFile; 
void my_function( ) {  
    std::string line;  
    while ( std::getline( cin, line)) {  
        // Example processing: simply echo the line ( modify as needed)  
        cout << line << std::endl;  
    }  
}  
  
int main( ) {  
    Timer::Tester( my_function);  
    return 0;  
}  
