% Function name.: get_index_from_trigger
% Date..........: July 6, 2017
% Author........: Eric F Schmiele
%                 (eric.robotic@gmail.com)
% Description...:
%                 get_index_from_trigger finds the trigger begining or
%                 ending moments from a trigger signal
%                    
% Parameters....: 
%                 raw_trigger.-> pure trigger input signal
%                 begin.......-> marker: 1.-> calculates begining
%                                        0.-> calculates ending
%                 min_diff....-> minimum difference between two triggers
%                                [sample points]
%                 max_diff....-> maximum difference between two triggers
%                                [sample points]
%
% Return........:
%                 index.-> index from trigger begining or ending positions

function index = get_index_from_trigger(raw_trigger, begin, min_diff, max_diff)

%% Normalize pure trigger signal
if ((max(raw_trigger) ~= 1) || (min(raw_trigger) ~= 0))
    thresh = min(raw_trigger) + ((max(raw_trigger) - min(raw_trigger))/2);
    trigger = raw_trigger > thresh;
else
    trigger = raw_trigger;
end

%% Find trigger begining or ending positions
if (begin == 1)
    begin_trigger = [0 diff(trigger)>0]>0;
else
    begin_trigger = [0 diff(trigger)<0]>0;
end

index_begin_trigger = find(begin_trigger);

%% Distance treatment
%calculate distances between triggers
difference = [];
for i = 1:(length(index_begin_trigger) - 1)
    difference = [difference (index_begin_trigger(i+1) - index_begin_trigger(i))];
end

%verify distances according to the minimum distance
index_filtered = index_begin_trigger(1);
for i = 1:length(difference)
    if (difference(i) < min_diff)
        if (i == 1)
            %if the first one is not distanced enough, discard it
            index_filtered = index_begin_trigger(i+1);
        elseif (i ~= length(difference))
            if (difference(i-1) < difference(i+1))
                %if the next difference is greater than the current,
                %discard the current and consider the next
                index_filtered(length(index_filtered)) = index_begin_trigger(i+1);
            end
        end
    else
        index_filtered = [index_filtered index_begin_trigger(i+1)];
    end
end

%verify if the last difference is greater than the maximum difference
if (difference(length(difference)) > max_diff)
    index_filtered(length(index_filtered)) = [];
end

%% Organize outputs
index = index_filtered;

end