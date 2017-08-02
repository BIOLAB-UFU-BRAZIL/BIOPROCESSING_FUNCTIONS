% Function name.: plotEEG
% Date..........: July 6, 2017
% Author........: Eric F Schmiele
%                 (eric.robotic@gmail.com)
% Description...:
%                 plotEEG plots the signals from each EEG channel in the
%                 same figure
%                    
% Parameters....: 
%                 signal.........-> EEG signal (channels x time) or
%                                   (channels x time x epochs)
%                 optional input.-> 
%                                   range.-> vector with values for the
%                                            horizontal axis

function plotEEG(signal, range)

%% Manage inputs
if nargin < 2
    %if range is not given a vector from 1 to the length of the EEG signal
    %is created
    range = 1:size(signal, 2);
end

%% Plot
%prepareauxiliary variables
n_channels = size(signal, 1);
colors = winter(n_channels);
targets = size(signal, 3);

if targets == 1
    %if there is only one epoch to be ploted it is ploted normally
    
    %calculate offset between each EEG channel so they are all presented in
    %the same figure
    offset = [];
    for i = 1:n_channels
        offset(i) =  max(abs(signal(i,:)));
    end

    offset_total = 2 * max(offset);
    for i = n_channels:-1:1
        rate = n_channels - i;
        signal_to_plot = signal(i,:) + rate * offset_total;
        line = zeros(size(signal_to_plot)) + rate * offset_total;
        plot(range, line, 'k');
        hold on;
        plot(range, signal_to_plot,'color',colors(i,:));
        hold on;
    end
else
    %if there are more than one epoch to be ploted they are presented in a
    %subplot of 2 by (epochs/2)
    
    %calculate offset between each EEG channel so they are all presented in
    %the same subplot
    offset = [];
    for i = 1:n_channels
        offset(i) =  max(max(abs(signal(i,:,:)), [], 2));
    end
    
    offset_total = 2 * max(offset);
    for j = 1:targets
        subplot(2, roof(targets / 2), j);
        for i = n_channels:-1:1
            rate = n_channels - i;
            signal_to_plot = signal(i,:,j) + rate * offset_total;
            line = zeros(size(signal_to_plot)) + rate * offset_total;
            plot(range, line, 'k');
            hold on;
            plot(range, signal_to_plot,'color',colors(i,:));
            hold on;
        end
        hold off;
    end
end
    
end
        