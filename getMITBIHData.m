%%%% %%%% %%%% %%%%
% Please read - the following section MUST be completed BEFORE attempting 
% to commit
%%%% %%%% %%%% %%%%
% Title of File: getMITBIHData.m
% Name of Editor: Ashwin Sundar
% Date of GitHub commit: September 16, 2016
% What specific changes were made to this code, compared to the currently 
% up-to-date code on GitHub?: Added ability to cd back to original directory.  
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

function [fullData, fullTime, fullSignal] = getMITBIHData
fullData = zeros(650000, 2);
sampleRate = 360; % Sample rate of MIT-BIH Arrhythmia data
QRSLength = 150; % QRS complex spans 60-100 ms in healthy patients, up to
% 150 ms in patients with cardiac problems (Sivaraks 2014, Kim 2016).
% First, get the data. WFDB Toolbox for MATLAB only runs in the wfdb folder. So navigate there first.
cd C:\Users\Ashwin\Dropbox\'Applied Project'\'MIT-BIH Arrhythmia Data'\wfdb-app-toolbox-0-9-9\mcode

% Next, get the data
% syntax: rdsamp(recordName,signalList,N,N0,rawUnits,highResolution)
% recordName: appears to follow format of mitdb/[file number]
% signalList: default - read all signals
% N: sample number to stop at
% N0: sample number to begin at
% rawunits: returns time and signal with varying precisions.
% high resolution: default is off, 1 causes record to be "read in high
% resolution mode"

[fullTime, fullSignal] = rdsamp('mitdb/100');
fullData(1:end,1) = fullTime;
fullData(1:end,2) = fullSignal(1:end,1);

% return to the directory you were originally in
cd C:\Users\Ashwin\Dropbox\'Applied Project'\AS-QRS-Detection
end
