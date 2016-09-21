%%%% %%%% %%%% %%%%
% Please read - the following section MUST be completed BEFORE attempting 
% to commit
%%%% %%%% %%%% %%%%
% Title of File: getTPeak.m
% Name of Editor: Ashwin Sundar
% Date of GitHub commit: September 20, 2016
% What specific changes were made to this code, compared to the currently 
% up-to-date code on GitHub?: Initial commit. Modeled after getPPeak.m and 
% getSPeak.m. I'm going to look for the local max after the S peak that is 
% above the signal Mean, and call that the T peak. The next step is to 
% calculate the noise Mean and use that value instead of signalMean to find 
% the T Peak. 
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
function TPeaks = getTPeak(SPeaks, buffer, signalMean) 
% SIndex is the index location of each S Peak in the buffer
[~,SIndex] = ismember(SPeaks(:,1),buffer(:,1),'R2012a');
i = 1; % for loop tracker
j = SIndex(1); % keeps track of where we are in the buffer
k = 1; % keeps track of location in SPeaks
TPeaks = zeros(length(SPeaks) - 1, 2); % prealloc TPeaks to optimize speed
exitFlag = 0; % if you overrrun the buffer, get out
for i=1:length(SPeaks)
    flag = 0; % used to track whether I found a T peak or not
    while(flag == 0)
        switch(buffer(j,2) > buffer(j+1,2) && buffer(j,2) > signalMean)
            case 1 % on a downslope and above signalMean, record as T Peak 
                % and continue
                TPeaks(k, :) = buffer(j, :); % update Q Peaks
                k = k+1; % move to next Q location
                flag = 1;
                if(i < length(SIndex)) % so you don't create an indexing error
                    j = SIndex(i+1); % move to next T Peak
                end
            case 0 % on an upslope and/or below signal mean, keep checking
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