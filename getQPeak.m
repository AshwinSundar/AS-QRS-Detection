%%%% %%%% %%%% %%%%
% Please read - the following section MUST be completed BEFORE attempting 
% to commit
%%%% %%%% %%%% %%%%
% Title of File: getQPeak.m
% Name of Editor: Ashwin Sundar
% Date of GitHub commit: September 19, 2016
% What specific changes were made to this code, compared to the currently 
% up-to-date code on GitHub?: Initial commit. Modeled after getSPeak -
% except looking for local minima before an R Peak. 
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

% The Q peak is like the S peak, but before the R peak. I'll use the same
% code from getSPeak, but run it in reverse. 
function QPeaks = getQPeak(RPeaks, buffer) 
% RIndex is the index location of each R Peak in the buffer
[~,RIndex] = ismember(RPeaks(:,1),buffer(:,1),'R2012a');
i = 1; % for loop tracker
j = RIndex(1); % keeps track of where we are in the buffer
k = 1; % keeps track of location in QPeaks
QPeaks = zeros(length(RPeaks) - 1, 2); % prealloc QPeaks to optimize speed
exitFlag = 0; % if you underrun the buffer, get out
for i=1:length(RPeaks)
    flag = 0; % used to track whether I found a Q peak or not
    while(flag == 0)
        switch(buffer(j,2) > buffer(j-1,2))
            case 0 % on a downslope, record as Q Peak and continue
                QPeaks(k, :) = buffer(j, :); % update Q Peaks
                k = k+1; % move to next Q location
                flag = 1;
                if(i < length(RIndex)) % so you don't create an indexing error
                    j = RIndex(i+1); % move to next R Peak
                end
            case 1 % on an upslope, keep checking
                j = j - 1;
                flag = 0;
                if (j-1 < 1)
                    exitFlag = 1
                end
                if(exitFlag) % if you underrun the buffer, go to the next point
                    i = i+1;
                    exitFlag = 0;
                end
        end
        end
    end
end