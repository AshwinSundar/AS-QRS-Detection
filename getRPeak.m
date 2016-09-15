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

function RPeak = getRPeak(buffer, signalMean, signalStDev)
% I won't have access to a linear algebra toolbox in Particle. Since the
% amount of data above 3SD is very small, I think I'll just use the median
% (or left of median if I have an even number of points) 
% Next, let's locate the R peak. The R peak should be above the signal
% mean, let's say 3 standard deviations beyond the signalMean. I could
% preallocate a buffer to store the RPeak, but it's so small that I don't
% think it will matter. I could use parallel processing, but I won't have 
% access to that in Particle, so I won't. 
    j = 1;
    RPeak = zeros(1,2)
    for i=1:(length(buffer)-1)
        if(buffer(i,2) > signalMean + 3*signalStDev)
            RPeak(j,:) = buffer(i,:);
            j = j + 1;
        end
    end

% I won't have access to a linear algebra toolbox in Particle. Since the
% amount of data above 3SD is very small, I think I'll just use the median
% (or left of median if I have an even number of points)
    if(exist('RPeak'))
        fprintf('Found R Peak.\n')
        RPeak = RPeak(floor(length(RPeak)/2),:);
    else
        fprintf('Did not find R Peak.\n')
    end
end