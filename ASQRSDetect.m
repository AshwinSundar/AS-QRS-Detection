%%%% %%%% %%%% %%%%
% Please read - the following section MUST be completed BEFORE attempting 
% to commit
%%%% %%%% %%%% %%%%
% Title of File: PhotonDataDump.ino
% Name of Editor: Ashwin Sundar
% Date of GitHub commit: September 10, 2016
% What specific changes were made to this code, compared to the currently 
% up-to-date code on GitHub?: I want to implement the ideas Professor Spano 
% has given me here. Let's just start by implementing what you think will 
% work best, without placing too much emphasis on having a basis for the 
% reasoning for your numerical decisions. I realize this is not a recommended 
% software development approach, but I'd like to start generating performance
% data and run a few tests, and then move from there. 
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
buffer; % circular buffer containing last 1k data points (5 seconds @ 200Hz)
signalMean; % average of circular buffer. Can be implemented in multiple 
% ways. Run perf testing to determine best technique. 
% Perf Test 1: Use inbuilt mean(data) function in MATLAB. Log results
% Perf Test 2: Calculate once, then subtract the point divided by 1000 and 
% add the newest point divided by 1000. Log results
signalStDev; % standard deviation of signal. Run perf testing to determine
% best technique
% Perf Test 1: Use inbuilt st(data) function in MATLAB. Log results
% Perf Test 2: Calculate once, drop first point's deviation divided by
% 1000, add new point's deviation divided by 1000

