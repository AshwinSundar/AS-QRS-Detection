%%%% %%%% %%%% %%%%
% Please read - the following section MUST be completed BEFORE attempting 
% to commit
%%%% %%%% %%%% %%%%
% Title of File: getSPeak.m
% Name of Editor: Ashwin Sundar
% Date of GitHub commit: September 17, 2016
% What specific changes were made to this code, compared to the currently 
% up-to-date code on GitHub?: Initial commit. Code is very simple to run -
% just looks for local minima following an R Peak. Of course, this is
% assuming I'm finding the R Peak at its actual peak!
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

% I need to pull the S wave from an ECG signal. The S wave is the valley
% following an R Peak. Sometimes, the S wave is very prominent and nearly
% matches the amplitude of the R wave, other times (such as in MIT BIH
% 100.dat) it's a blip that barely rises above the noise. To account for
% either scenario, I figure I can write a valley detection algorithm
% that searches for local minima following an R Peak. I can probably get
% away with keeping it very simple and just following the data until it
% starts to rise again - since the data is changing so rapidly, noise
% shouldn't be too much of an issue directly around the QRS complex. 
function SPeaks = getSPeak(RPeaks, buffer) 
% RIndex is the index location of each R Peak in the buffer
[~,RIndex] = ismember(RPeaks(:,1),buffer(:,1),'R2012a');
i = 1; % for loop tracker
j = RIndex(1); % keeps track of where we are in the buffer
k = 1; % keeps track of location in SPeaks
SPeaks = zeros(length(RPeaks) - 1, 2); % prealloc SPeaks to optimize speed
exitFlag = 0; % if you overrrun the buffer, get out
for i=1:length(RPeaks)
    flag = 0; % used to track whether I found a Q peak or not
    while(flag == 0)
        switch(buffer(j,2) > buffer(j+1,2))
            case 0 % on an upslope, record as Q Peak and continue
                if(buffer(j,2) <= buffer(j+1,2)) % we are on an upslope, break
                    SPeaks(k, :) = buffer(j, :); % update Q Peaks
                    k = k+1; % move to next Q location
                    flag = 1;
                    if(i < length(RIndex)) % so you don't create an indexing error
                        j = RIndex(i+1); % move to next R Peak
                    end
                end
            case 1 % on a downslope, keep checking
                j = j + 1;
                flag = 0;
                if (j+1 > length(buffer))
                    exitFlag = 1
                end
                if(exitFlag) % if you overrrun the buffer, get out
                    break
                end
        end
        if(exitFlag)
            return
        end
    end
end