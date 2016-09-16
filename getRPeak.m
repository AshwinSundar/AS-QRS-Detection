%%%% %%%% %%%% %%%%
% Please read - the following section MUST be completed BEFORE attempting 
% to commit
%%%% %%%% %%%% %%%%
% Title of File: getRPeak.m
% Name of Editor: Ashwin Sundar
% Date of GitHub commit: September 14, 2016
% What specific changes were made to this code, compared to the currently 
% up-to-date code on GitHub?: Separated finding R Peak into its own
% function. Having issues implementing though, getting error "Undefined
% function 'getRPeak' for input arguments of type 'double'. 
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

function RPeaks = getRPeak(buffer, signalMean, signalStDev)
% I won't have access to a linear algebra toolbox in Particle. Since the
% amount of data above 3SD is very small, I think I'll just use the median
% (or left of median if I have an even number of points) 
% Next, let's locate the R peak. The R peak should be above the signal
% mean, let's say 3 standard deviations beyond the signalMean. I could
% preallocate a buffer to store the RPeak, but it's so small that I don't
% think it will matter. I could use parallel processing, but I won't have 
% access to that in Particle, so I won't. 
    sampleRate = 360;
    refracPer = 0.250 % 250 milliseconds = 240bpm, which is probably 
    % humanly impossible. 
    j = 2;
    RPeaks = zeros(2,2)
    for i=1:(length(buffer)-1)
        % WARNING: this statement prohibits R detection in the first 250ms
        % of a record
        if(buffer(i,2) > signalMean + 3*signalStDev && (buffer(i,1) - RPeaks(j-1, 1)) > refracPer)
            RPeaks(j,:) = buffer(i,:);
            j = j + 1;
        end
    end

% I won't have access to a linear algebra toolbox in Particle. Since the
% amount of data above 3SD is very small, I think I'll just use the median
% (or left of median if I have an even number of points)
    RPeaks
end