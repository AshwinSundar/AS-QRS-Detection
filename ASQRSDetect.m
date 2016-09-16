%%%% %%%% %%%% %%%%
% Please read - the following section MUST be completed BEFORE attempting 
% to commit
%%%% %%%% %%%% %%%%
% Title of File: ASQRSDetect.m
% Name of Editor: Ashwin Sundar
% Date of GitHub commit: September 14, 2016
% What specific changes were made to this code, compared to the currently 
% up-to-date code on GitHub?: Fixed issues implementing other functions. I
% was cd'ing to a new directory to use WFDB, but not returning to the
% previous directory when I attempted to call those functions. Labelling R 
% peaks now as well. Next step is to implement moving average to help 
% eliminate baseline drift artifact. 
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

if(~exist('fullData'))
    [fullData, fullTime, fullSignal] = getMITBIHData;
end
% Now we have the data. Let's run some analysis on it. 

bufferSize = 1000; % larger buffers will likely improve performance, but are
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

% If you want to plot, uncomment the following lines
plot(buffer(1:end,1), buffer(1:end,2));
hold on;
plot([0,buffer(bufferSize,1)],[signalMean,signalMean]);
plot([0,buffer(bufferSize,1)],[signalMean+signalStDev,signalMean+signalStDev]);
plot([0,buffer(bufferSize,1)],[signalMean+3*signalStDev,signalMean+3*signalStDev]);
plot(RPeaks(:,1), RPeaks(:,2), 'rv', 'MarkerFaceColor', 'r'); 
legend('show');
legend('ECG', 'Signal Mean', '1SD', '3SD');

