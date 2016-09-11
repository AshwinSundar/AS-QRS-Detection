%%%% %%%% %%%% %%%%
% Please read - the following section MUST be completed BEFORE attempting 
% to commit
%%%% %%%% %%%% %%%%
% Title of File: PhotonDataDump.ino
% Name of Editor: Ashwin Sundar
% Date of GitHub commit: September 11, 2016
% What specific changes were made to this code, compared to the currently 
% up-to-date code on GitHub?: Retrieved data, calculated statistics,
% plotted it. 
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
buffer = zeros(100, 2); % circular buffer containing last 100 data points 
% (0.5 seconds @ 200Hz). I chose this number because the max string length
% I can make in Particle is 623 chars, each data point is (up to) 6 digits
% long, 623/6 ~ 100 data points stored in circular buffer. 
signalMean = 0; % average of circular buffer. Can be implemented in multiple 
% ways. Run perf testing to determine best technique. 
% Perf Test 1: Use inbuilt mean(data) function in MATLAB. Log results
% Perf Test 2: Calculate once, then subtract the point divided by 1000 and 
% add the newest point divided by 1000. Log results
signalStDev = 0; % standard deviation of signal. Run perf testing to determine
% best technique
% Perf Test 1: Use inbuilt std(data) function in MATLAB. Log results
% Perf Test 2: Calculate once, drop first point's deviation divided by
% 1000, add new point's deviation divided by 1000

% First, get the data. WFDB Toolbox for MATLAB only runs in the wfdb
% folder. So navigate there first.
cd C:\Users\Ashwin\Dropbox\'Applied Project'\'MIT-BIH Arrhythmia Data'\wfdb-app-toolbox-0-9-9\mcode

% Next, get the data
% syntax: rdsamp(recordName,signalList,N,N0,rawUnits,highResolution)
% recordName: appears to follow format of mitdb/[file number]
% signalList: default - read all signals
% N: sample number to stop at
% N0: sample number to begin at 
% rawunits: returns time and signal with varying precisions. 3 is 16-bit
% integers, I chose this because this is closer to the Photon DAC
% resolution of 13 bit. 
% high resolution: default is off, 1 causes record to be "read in high
% resolution mode" 
[tm, signal] = rdsamp('mitdb/100', [], 100, 1, 3);
buffer(1:end,1) = tm;
buffer(1:end,2) = signal(1:end,1);

% Now we have the data. Let's run some analysis on it. 
signalMean = mean(buffer(1:end,2)); 
signalStDev = std(buffer(1:end,2));

% If you want to plot, uncomment the following lines
plot(tm, signal(1:end,1));
hold on;
plot([0,100],[signalMean,signalMean]);
plot([0,100],[signalMean+signalStDev,signalMean+signalStDev]);

