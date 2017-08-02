% Function name.: fourrier
% Date..........: July 13, 2017
% Author........: Eric F Schmiele
%                 (eric.robotic@gmail.com)
% Description...:
%                 fourrier returns the fft from a given signal and its
%                 frequency range
%                    
% Parameters....: 
%                 signal...-> input signal
%                 sampFreq.-> sampling frequency of the input signal
%                 opt......-> optional input:
%                                             1: plots the result
%                                             otherwise: nothing
%
% Return........:
%                 fourrier........-> resulting fft values
%                 frequency_range.-> frequency range of the fft values for
%                                    plotting

function [fourrier, frequency_range] = fourrier(signal, sampFreq, opt)        

%% Prepare variables
len = length(signal);
nfft = 2 ^ nextpow2(len);

%% Calculate fft and generate frequency vector
y = fft(signal, nfft) / len;
fourrier = 2 * abs(y(1:nfft / 2 + 1));

frequency_range = sampFreq / 2 * linspace(0, 1, nfft / 2 + 1);

%% Plot result
if nargin == 3
    if opt
        plot(frequency_range, fourrier);
    end
end

end