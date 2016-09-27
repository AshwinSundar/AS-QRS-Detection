//// //// //// //// ////
// Please read - the following section MUST be completed BEFORE attempting to commit
//// //// //// //// ////
// Title of File: main.cpp
// Name of Editor: Ashwin Sundar
// Date of GitHub commit: September 27, 2016
// What specific changes were made to this code, compared to the currently up-to-date code
// on GitHub?: Finished getting vector to work. I needed to just declare it normally, not as a pointer to a vector. Everything seems to work fine now. Next step is to implement R Peak detection.
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

int main(int argc, const char * argv[])
{

    // Use vectors, not arrays. Arrays must be preallocated, and cannot change size at runtime. Furthermore, arrays are stored in the stack, which is very fast but limited in size. On the other hand, vectors are stored in the heap, which is much larger (and suited for storing large sets). My program runs into memory issues when I attempt to use arrays to store large data sets.
    std::vector<double> EKGDataMeas; // preallocate is faster, but you can always append to vectors (as opposed to arrays)
    std::vector<double> EKGTimes;
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
                
                double tempVar;
                
                switch (loc)
                {
                    case 1: // "before comma"
                        tempString.push_back(line[i]); // build EKGTimes tempString
                        break;
                    case 2: // "at comma"
                        std::sscanf(tempString.data(), "%lf", &(tempVar)); // write tempString to EKGTimes;
                        EKGTimes.push_back(tempVar);
                        tempString = ""; // clear the temp string
                        break;
                    case 3: // "after comma"
                        tempString.push_back(line[i]); // build EKGDataMeas tempString
                        break;
                    case 4: // "end of line"
                        std::sscanf(tempString.data(), "%lf", &(tempVar)); // write tempString to EKGDataMeas;
                        EKGDataMeas.push_back(tempVar); 
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
    return 0;
}