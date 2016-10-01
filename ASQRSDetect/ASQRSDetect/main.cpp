//// //// //// //// ////
// Please read - the following section MUST be completed BEFORE attempting to commit
//// //// //// //// ////
// Title of File: main.cpp
// Name of Editor: Ashwin Sundar
// Date of GitHub commit: October 1, 2016
// What specific changes were made to this code, compared to the currently up-to-date code
// on GitHub?: Finished creating ASVector, which inherits from std::vector<double>. I added some built-in statistics functions so I don't have to use a for loop every time I want to know something about the vector. Also made a print function for ASVector. getRPeak has some bugs, next step is to fix those bugs.
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
#include <vector>
#include "stdio.h"
#include <cmath>

std::ifstream myFile;
std::string line;

class ASVector : public std::vector<double> // ASVector inherits from std::vector<double>
{
private:
public:
    double getMean(ASVector vec) // this seems like a circular reference here, but the compiler seems fine with it. Not sure why.
    {
        double sum = 0;
        double vecLen = vec.size();
        
        for (int i = 0; i < vecLen; i++)
        {
            sum += vec[i];
        }
        double mean = sum/vecLen;
        return mean;
    }
    
    double getStDev(ASVector vec) // this seems like a circular reference here, but the compiler seems fine with it. Not sure why.
    {
        // subtract mean from each value, square each, add them up
        double vecLen = vec.size();
        double vecMean = vec.getMean(vec); // only need to do this once
        double stDev = 0.0;
        for (int i = 0; i < vecLen; i++)
        {
            stDev += pow((vec[i] - vecMean), 2);
        }
        
        stDev = stDev/vecLen;
        return stDev;
    }
    
    void print(ASVector vec)
    {
        for (int i = 0; i < vec.size(); i++)
        {
            std::cout << vec[i];
        }
        std::cout << "\n";
    }
    
};

ASVector getRPeak(ASVector EKGDataMeasBuffer, ASVector EKGTimesBuffer)
{
// I won't have access to a linear algebra toolbox in Particle. Since the amount of data above 3SD is very small, I think I'll just use the median (or left of median if I have an even number of points). Next, let's locate the R peak. The R peak should be above the signal mean, let's say 3 standard deviations beyond the signalMean. I could preallocate a buffer to store the RPeak, but it's so small that I don't think it will matter. I could use parallel processing, but I won't have access to that in Particle, so I won't.
    int sampleRate = 360; // AI: Needs to update dynamically depending on data stream
    double refracPer = 0.250; // AI: Need a better reference for using this number (250 ms = 240 bpm)
    double signalMean = EKGDataMeasBuffer.getMean(EKGDataMeasBuffer);
    double signalStDev = EKGDataMeasBuffer.getStDev(EKGDataMeasBuffer);
    bool flag = 0; // used for initial part of data, when refrac period hasn't kicked in yet
    ASVector RPeaksTimes;
    int j = 1; // counter
    for (int i = 0; i < sizeof(EKGTimesBuffer); i++)
    {
        if (flag) // then the refrac period has kicked in
        {
            if(EKGDataMeasBuffer[i] > (signalMean + 3*signalStDev) & EKGTimesBuffer[i] - RPeaksTimes[j-1] > refracPer & EKGDataMeasBuffer[i] > EKGDataMeasBuffer[i+1])
            {
                RPeaksTimes.push_back(EKGTimesBuffer[i]);
                j++;
            }

        }
        
        if (!flag) // refrac period hasn't kicked in yet
        {
            if(EKGDataMeasBuffer[i] > signalMean + 3*signalStDev & EKGDataMeasBuffer[i] > EKGDataMeasBuffer[i+1]) // no refrac period on first R Peak found
            {
                RPeaksTimes.push_back(EKGTimesBuffer[i]);
                j++;
                flag = 1; // RPeaks now exists, refrac period kicks in so don't execute this if statement anymore
            }
            
        }
    }
    
    return RPeaksTimes;
}


int main(int argc, const char * argv[])
{
    // Use vectors, not arrays. Arrays must be preallocated, and cannot change size at runtime. Furthermore, arrays are stored in the stack, which is very fast but limited in size. On the other hand, vectors are stored in the heap, which is much larger (and suited for storing large sets). My program runs into memory issues when I attempt to use arrays to store large data sets. So vector it is.
    ASVector EKGDataMeas; // preallocate is faster, but you can always append to vectors (as opposed to arrays, which are static at runtime)
    ASVector EKGTimes;
    std::string inputFile = "MITBIH100fullData.txt"; // I'm doing all this nasty file delimiting in main and not a separate function because I can't return multiple vectors in C++ without some ridiculous legwork. I suppose I could have used separate functions to handle each data set, but I already wrote this code.
    std::string tempString; // holds a 'number' while file is being parsed
    myFile.open(inputFile);
    
//
// STEP 1: PARSE FILE
//
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
    
    //
    // STEP 2: COMPUTE STATISTICS
    //
    // I built statistics computations into the ASVector custom class. Nothing to do here.
    
    //
    // STEP 3: GET R PEAKS
    //
    ASVector RPeaks = getRPeak(EKGDataMeas, EKGTimes);
    RPeaks.print(RPeaks);
    return 0;
}
