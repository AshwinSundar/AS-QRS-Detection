%%%% %%%% %%%% %%%%
% Please read - the following section MUST be completed BEFORE attempting 
% to commit
%%%% %%%% %%%% %%%%
% Title of File: ASQRSDetect.m
% Name of Editor: Ashwin Sundar
% Date of GitHub commit: September 19, 2016
% What specific changes were made to this code, compared to the currently 
% up-to-date code on GitHub?: Implemented getQPeak. 
%%%% %%%% %%%% %%%%
% Best coding practices
% 1) When you create a new variable or function, make it obvious what the 
% variable or function does. The name of the variable or function should 
% reflect its purpose.
% 2) Comment copiously. Created a new variable or function? Explain why. 
% Explain what your functions do. Feel free to link to sites that you 
% referenced for information.
% 3) Please compile your code and make sure it is functional BEFORE 
% committing changes to GitHub.
%%%% %%%% %%%% %%%% 
%%%% %%%% %%%% %%%% 

% if you don't have the full set locally, then get it.
if(~exist('fullData')) 
    [fullData, fullTime, fullSignal] = getMITBIHData;
end

% Now we have the data. Let's run some analysis on it. 
bufferSize = 650000; % larger buffers will likely improve performance, but are
% also likely to degrade QRS detection. Size is measured in # of data
% points to store, not temporal length.
buffer = fullData(1:bufferSize,:);
signalMean = mean(buffer(1:end,2)); 
signalStDev = std(buffer(1:end,2));

% Next, let's locate the R peak. The R peak should be above the signal
% mean, let's say 3 standard deviations beyond the signalMean. I could
% preallocate a buffer to store the RPeak, but it's so small that I don't
% think it will matter. I could use parallel processing, but I won't have 
% access to that in Particle, so I won't. 
RPeaks = getRPeak(buffer, signalMean, signalStDev); 
QPeaks = getQPeak(RPeaks, buffer); 
SPeaks = getSPeak(RPeaks, buffer); 

printECGReport(buffer, bufferSize, signalMean, signalStDev, QPeaks, RPeaks, SPeaks); 
