//// //// //// //// ////
// Please read - the following section MUST be completed BEFORE attempting to commit
//// //// //// //// ////
// Title of File: main.cpp
// Name of Editor: Ashwin Sundar
// Date of GitHub commit: September 24, 2016
// What specific changes were made to this code, compared to the currently up-to-date code
// on GitHub?: After talking to Jon, I learned the difference between static and dynamic variable allocation, as well as heap versus stack. Stack is small and fast memory, heap is large and slow(er) memory. Local variables are good to store in the stack, unless they are so large they overflow the stack - hence stack overflow, which is exactly what is happening with my 650000x2 array of EKG Data. I could either dynamically allocate the array and manually manage memory myself, or I can just use the vector "template" and allow vector to manage my memory for me. One nice plus is I can append to vectors, which wasn't an option with array. 
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
// #include <array>
#include <vector>
#include "stdio.h"

std::ifstream myFile;
std::string line;
// double EKGData; // most MIT BIH data seems to be 650k samples long. I'm not sure why, but if I declare this inside main, I get what appears to be a memory address error. Clearing up space on my HDD didn't affect anything, but reducing the size of the array allocation inside the function, or just putting the declaration outside the function like I did here seems to clear the error. I'm declaring this as a double because according to Prof Spano, most computers do their math in double by default. Even if you declare this as a float, which is smaller, your computer will first convert it to a double, do the math, then go back to float - which ends up taking longer.
// EKGData = (double *) calloc (100, sizeof(int)); // not working

int getFileSize(std::ifstream& myFile) {
    int lineLength = 0;
    std::string line;
    while(getline(myFile,line))
    {
        lineLength++;
    }
    
    return lineLength;
}

int main(int argc, const char * argv[])
{
//    float *EKGData = new float[650000*2];
    std::vector<double> *EKGDataMeas; // preallocate is faster, but you can always append to vectors (as opposed to arrays)
    std::vector<double> *EKGTimes;
    std::string inputFile = "MITBIH100fullData.txt"; // I'm doing all this nasty file delimiting in main and not a separate function because I can't return arrays in C++ without some ridiculous legwork.
    std::string tempString; // holds a 'number' while file is being parsed
    myFile.open(inputFile);
    
    if (myFile.is_open())
    {
        int k = 0; // used to track position in vectors
        int loc;
        int flag;
        while (getline(myFile, line)) // while the file has more content
        {
            flag = 0;
            loc = 1;
            for(int i = 0; i < line.size(); i++)
            {
                // bool eval = (line[i] == ','); // for debugging
                // bool eval2 = (i == line.size() - 1); // for debugging
//                switch (line[i] == ',' || i == line.size() - 1) // manual delimiting
//                {
//                    case 0: // no comma, keep writing
//                        std::cout << line[i];
//                        tempString.push_back(line[i]);
//                        break; // switch cases have to break in C++ 
//                    case 1: // comma present, write the first set of data
//                        //std::sscanf(tempString.data(), "%f", &(EKGData[i][j])); // write the temp string
//                        //std::sscanf(tempString.c_str(), "%f", &(EKGData[i][j])); // write the temp string
//                        std::sscanf(tempString.data(), "%lf", &(EKGDataMeas[k][j])); // write the temp string
//                        tempString = ""; // clear the temp string
//                        j++; // move to next column
//                        break;
//                    default:
//                        break;
//                }
//
                if (flag == 1)
                {
                    loc++;
                    flag = 0;
                }
                
                if (line[i] == ',')
                {
                    loc++;
                    flag = 1;
                }
                
                if (i == line.size()- 1)
                {
                    loc++;
                }
                
 
                switch (loc)
                { 
                    case 1: // "before comma"
                        tempString.push_back(line[i]); // build EKGTimes tempString
                        break;
                    case 2: // "at comma"
                        std::sscanf(tempString.data(), "%lf", &(EKGTimes[k])); // write tempString to EKGTimes;
                        tempString = ""; // clear the temp string
                        break;
                    case 3: // "after comma"
                        tempString.push_back(line[i]); // build EKGDataMeas tempString
                        break;
                    case 4: // "end of line"
                        std::sscanf(tempString.data(), "%lf", &(EKGTimes[k])); // write tempString to EKGDataMeas;
                        tempString = ""; // clear the temp string
                        break;
                    default:
                        break;
                 
                }
            }
            k++;
        }
    }
    myFile.close();
    std::cout << EKGDataMeas;
    return 0;
}