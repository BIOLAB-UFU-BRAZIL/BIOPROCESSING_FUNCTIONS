% Function name.: filter_no_dist
% Date..........: July 13, 2017
% Author........: Eric F Schmiele
%                 (eric.robotic@gmail.com)
% Description...:
%                 filter_no_dist applies a butterworth filter of any type
%                 (low pass, high pass, band pass or notch) without phase
%                 distortion
%                    
% Parameters....: 
%                 signal...-> input signal
%                 order....-> filter order
%                 cutFreq..-> cutoff frequency [Hz], must be a vector with
%                             two values in the case of bandpass or notch
%                 sampFreq.-> sampling frequency from the input signal [Hz]
%                 filtType.-> optional input: type of the filter:
%                             'low': low pass filter
%                             'high': high pass filter
%                             'band'/'bandpass': band pass filter
%                             'notch'/'stop': notch filter
%                             default: 'low' if cutFreq has only one value
%                             and 'bandpass' otherwise
%
% Return........:
%                 filtered.-> resulting filtered signal

function filtered = filter_no_dist(signal, order, cutFreq, sampFreq, filtType)

%% Manage inputs

if length(cutFreq) == 2
    if nargin < 5
        filtType = 'bandpass';
    end
    %determine correct frequency order
    if cutFreq(1) > cutFreq(2)
        aux = cutFreq(1);
        cutFreq(1) = cutFreq(2);
        cutFreq(2) = aux;
    end
else
    if nargin < 5
        filtType = 'low';
    end
    %in case there are more than 2 frequency values
    aux = cutFreq(1);
    cutFreq = [];
    cutFreq = aux;
end

%determine correct filter type name
if strcmp(filtType, 'band')
    filtType = 'bandpass';
elseif strcmp(filtType, 'notch')
    filtType = 'stop';
end

%% Filter
baseFreq = sampFreq / 2;
wc = cutFreq / baseFreq;
[b, a] = butter(order, wc, filtType);
filtered = filtfilt(b, a, signal);

end