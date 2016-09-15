%%%% %%%% %%%% %%%%
% Please read - the following section MUST be completed BEFORE attempting 
% to commit
%%%% %%%% %%%% %%%%
% Title of File: ASQRSDetect.m
% Name of Editor: Ashwin Sundar
% Date of GitHub commit: September 14, 2016
% What specific changes were made to this code, compared to the currently 
% up-to-date code on GitHub?: Refactored code, separated functions into
% multiple files. Want to keep ASQRSDetect relatively clean and organized.
% Had some issues with separating getRPeak and printECGReport, see errors
% listed in the description on those files. Both had issues with the input
% variable types though. I extended the functionality of this code and
% made it easier to vary the buffer length. My next goal is to
% partition the data out and recalculate the mean every so many data
% points. Ultimate goal is to calculate moving averages and SDs.
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

[fullData, fullTime, fullSignal] = getMITBIHData;
% Now we have the data. Let's run some analysis on it. 

bufferSize = 10000; % larger buffers will likely improve performance, but are
% also likely to degrade QRS detection. Size is measured in # of data
% points to store, not temporal length.
buffer = fullData(1:bufferSize,:);
signalMean = mean(buffer(1:end,2)); 
signalStDev = std(buffer(1:end,2));

% If you want to plot, uncomment the following lines
plot(buffer(1:end,1), buffer(1:end,2));
hold on;
plot([0,buffer(bufferSize,1)],[signalMean,signalMean]);
plot([0,buffer(bufferSize,1)],[signalMean+signalStDev,signalMean+signalStDev]);
plot([0,buffer(bufferSize,1)],[signalMean+3*signalStDev,signalMean+3*signalStDev]); 
legend('show');
legend('ECG', 'Signal Mean', '1SD', '3SD');

% Next, let's locate the R peak. The R peak should be above the signal
% mean, let's say 3 standard deviations beyond the signalMean. I could
% preallocate a buffer to store the RPeak, but it's so small that I don't
% think it will matter. I could use parallel processing, but I won't have 
% access to that in Particle, so I won't. 
for i=1:(length(buffer)-1)
    if(buffer(i,2) > signalMean + 3*signalStDev)
        if(~exist('RPeaks'))
            RPeaks = zeros(1,2); % If no RPeaks detected yet, create a small buffer
        end
        RPeaks = [RPeaks; buffer(i,:)];
    end
end

% I won't have access to a linear algebra toolbox in Particle. Since the
% amount of data above 3SD is very small, I think I'll just use the median
% (or left of median if I have an even number of points) 
if(exist('RPeaks'))
    fprintf('Found R Peak(s).\n')
else
    fprintf('Did not find R Peak(s) in buffer.\n')
end