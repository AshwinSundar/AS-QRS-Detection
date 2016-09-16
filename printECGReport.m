%%%% %%%% %%%% %%%%
% Please read - the following section MUST be completed BEFORE attempting 
% to commit
%%%% %%%% %%%% %%%%
% Title of File: printECGReport.m
% Name of Editor: Ashwin Sundar
% Date of GitHub commit: September 14, 2016
% What specific changes were made to this code, compared to the currently 
% up-to-date code on GitHub?: Separated ECG figure generation into its own
% function. However, I'm having issues calling it from ASQRSDetect.m. It's
% telling me that "Undefined function 'printECGReport' for input arguments
% of type 'int16'. 
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

function printFullECGReport(tm, signal, signalMean, signalStDev)
    plot(tm, signal(1:end,1));
    hold on;
    plot([0,100],[signalMean,signalMean]);
    plot([0,100],[signalMean+signalStDev,signalMean+signalStDev]);
    plot([0,100],[signalMean+3*signalStDev,signalMean+3*signalStDev]);
end
