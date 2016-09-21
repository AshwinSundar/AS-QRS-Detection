%%%% %%%% %%%% %%%%
% Please read - the following section MUST be completed BEFORE attempting 
% to commit
%%%% %%%% %%%% %%%%
% Title of File: getPPeak.m
% Name of Editor: Ashwin Sundar
% Date of GitHub commit: September 20, 2016
% What specific changes were made to this code, compared to the currently 
% up-to-date code on GitHub?: Initial commit. Modeled after getQPeak.m. I'm
% going to look for the local max prior to the Q peak that is above the 
% signal Mean, and call that the P peak. The next step is to calculate the
% noise Mean and use that value instead of signalMean to find the P Peak. 
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

% The P peak is like the T peak, but before the Q peak. I'll use the same
% code from getQPeak, but search for local maxima before Q peaks. 
function PPeaks = getPPeak(QPeaks, buffer, signalMean) 
% QIndex is the index location of each Q Peak in the buffer
[~,QIndex] = ismember(QPeaks(:,1),buffer(:,1),'R2012a');
i = 1; % for loop tracker
j = QIndex(1); % keeps track of where we are in the buffer
k = 1; % keeps track of location in QPeaks
PPeaks = zeros(length(QPeaks) - 1, 2); % prealloc QPeaks to optimize speed
exitFlag = 0; % if you underrun the buffer, get out
for i=1:length(QPeaks)
    flag = 0; % used to track whether I found a P peak or not
    while(flag == 0)
        switch(buffer(j,2) > buffer(j-1,2) && buffer(j-1,2) > signalMean)
            case 1 % on an upslope and above signalMean, record as P Peak and continue
                PPeaks(k, :) = buffer(j, :); % update P Peaks
                k = k+1; % move to next Q location
                flag = 1;
                if(i < length(QIndex)) % so you don't create an indexing error
                    j = QIndex(i+1); % move to next Q Peak
                end
            case 0 % on a downslope and/or below signalMean, keep checking
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