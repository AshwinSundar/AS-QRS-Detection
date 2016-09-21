//// //// //// //// ////
// Please read - the following section MUST be completed BEFORE attempting to commit
//// //// //// //// ////
// Title of File: main.cpp
// Name of Editor: Ashwin Sundar
// Date of GitHub commit: September 20, 2016
// What specific changes were made to this code, compared to the currently up-to-date code
// on GitHub?: Initial commit. Beginning translation from MATLAB to C++. To read files, change XCodes working directory in Product -> Scheme -> Edit Scheme -> Run -> Options -> Use custom working directory. Working on converting .txt files to arrays that I can calculate stats on. Trying to figure out how to return an array from a function. Code does not currently compile. 
//// //// //// //// ////
// Best coding practices
// 1) When you create a new variable or function, make it obvious what the variable or
// function does. The name of the variable or function should reflect its purpose.
// 2) Comment copiously. Created a new variable or function? Explain why. Explain what
// your functions do. Feel free to link to sites that you referenced for information.
// 3) Please compile your code and make sure it is functional BEFORE committing changes to GitHub.
//// //// //// //// ////
//// //// //// //// ////

#include <iostream>
#include <fstream>
#include <array>
#include <string>
#include <cstdlib>
#include <climits>
#include <array>

std::ifstream myFile;
std::string line;

// This function gets a file in the working directory, parses it for CSVs, and returns an array containing the data. Origin of the file is from MATLAB - use rdsamp from WFDB module to get full EKG data set, then call 'dlmwrite('MITBIH100fullData.txt', fullData, 'precision', '%.3f', 'newline', 'pc')' to write the data to a file with appropriate precision and custom delimiters.
double[] parseFile(std::string inputFile) {
    double tempArray[650000][2]; // arrays cannot change size at runtime in C++. Make sure the size of the array is exactly the size of the data you need to parse.
    std::string tempString; // holds a number while file is being parsed
    myFile.open(inputFile);
    
    if (myFile.is_open())
    {
        int j = 1; // used to track columns in tempArray
        while (getline(myFile, line)) // while the file has more content
        {
            for(int i = 0; i < line.size(); i++) {
                j = 1;
                switch (line[i] == ',') {
                    case 0: // no comma, keep writing
                        tempString.push_back(line[i]);
                    case 1: // comma present, do something
                        tempArray[i][j] = std::stoi(tempString); // write the temp string
                        tempString = ""; // clear the temp string
                        j++; // move to next column
                }
            }
            // std::cout << line << '\n';
            std::cout << line[1] << '\n';
        }
        myFile.close();
    }
    return tempArray;
}

int main(int argc, const char * argv[]) {
    parseFile("MITBIH100fullData.txt");
    return 0;
}