%%%% %%%% %%%% %%%%
% Please read - the following section MUST be completed BEFORE attempting 
% to commit
%%%% %%%% %%%% %%%%
% Title of File: printECGReport.m
% Name of Editor: Ashwin Sundar
% What specific changes were made to this code, compared to the currently 
% up-to-date code on GitHub?: Added Q Peak print.
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

function printECGReport(buffer, bufferSize, signalMean, signalStDev, QPeaks, RPeaks, SPeaks)
plot(buffer(1:end,1), buffer(1:end,2));
hold on;
plot([0,buffer(bufferSize,1)],[signalMean,signalMean]);
plot([0,buffer(bufferSize,1)],[signalMean+signalStDev,signalMean+signalStDev]);
plot([0,buffer(bufferSize,1)],[signalMean+3*signalStDev,signalMean+3*signalStDev]);
plot(QPeaks(:,1), QPeaks(:,2), 'o', 'MarkerFaceColor', 'b');
plot(RPeaks(:,1), RPeaks(:,2), 'rv', 'MarkerFaceColor', 'r');
plot(SPeaks(:,1), SPeaks(:,2), 'rs', 'MarkerFaceColor', 'g');
legend('show');
legend('ECG', 'Signal Mean', '1SD', '3SD', 'Q', 'R', 'S');
end
