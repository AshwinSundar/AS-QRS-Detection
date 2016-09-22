//// //// //// //// ////
// Please read - the following section MUST be completed BEFORE attempting to commit
//// //// //// //// ////
// Title of File: main.cpp
// Name of Editor: Ashwin Sundar
// Date of GitHub commit: September 21, 2016
// What specific changes were made to this code, compared to the currently up-to-date code
// on GitHub?: std::stol/stoi/stod (string to double converter) seems to have given up working. I have a feeling I'm running into array indexing errors. I'll look into it tomorrow.
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
#include <string>
#include <cstdlib>
#include <climits>
#include <array>

std::ifstream myFile;
std::string line;
double EKGData[650000][2]; // most MIT BIH data seems to be 650k samples long. I'm not sure why, but if I declare this inside main, I get what appears to be a memory address error. Clearing up space on my HDD didn't affect anything, but reducing the size of the array allocation inside the function, or just putting the declaration outside the function like I did here seems to clear the error.

int main(int argc, const char * argv[])
{
    std::string inputFile = "MITBIH100fullData.txt"; // I'm doing all this nasty file delimiting in main and not a separate function because I can't return arrays in C++ without some ridiculous legwork.
    std::string tempString; // holds a number while file is being parsed
    myFile.open(inputFile);
    
    if (myFile.is_open())
    {

        int j = 1; // used to track columns in EKGData array
        while (getline(myFile, line)) // while the file has more content
        {
            for(int i = 1; i < line.size(); i++)
            {
                std::cout << line[0];
                j = 1;
                switch (line[i] == ',')
                { // manual delimiting
                    case 0: // no comma, keep writing
                        tempString.push_back(line[i]);
                    case 1: // comma present, do something
                        tempString = std::stod(tempString); // write the temp string
                        tempString = ""; // clear the temp string
                        j++; // move to next column
                }
            }
        }
    }
    myFile.close();
    return 0;
}