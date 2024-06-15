#ifndef LOGCOUT_H
#define LOGCOUT_H

#include <iostream>
#include <fstream>
#include <chrono>
#include <ctime>


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
