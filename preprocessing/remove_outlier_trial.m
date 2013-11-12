function cdt = remove_outlier_trial(cdt, neuron, threshold)
% REMOVE_OUTLIER_TRIAL remove trials that are outliers.
%  
%   ... 
% 
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
%
% Inputs:
%    input1 - Description
%    input2 - Description
%    input3 - Description
%
% Outputs:
%    output1 - Description
%    output2 - Description
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2
%

%% AUTHOR    : Yimeng Zhang
%% Computer Science Department, Carnegie Mellon University
%% EMAIL     : zym1010@gmail.com 

%% $DATE     : 03-Nov-2013 13:30:41 $ 
%% $Revision : 1.00 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : remove_outlier_trial.m 

%% MODIFICATIONS:
%% $26-Sep-2002 14:44:35 $
%% blablabla
%% ---
%% $25-Feb-2002 07:29:17 $ 
%% blablabla


if nargin < 3
    threshold = 2;
end

spike = cdt.spike;
event_size = size(spike);

time = cdt.time;

if length(event_size) == 2 % only one trial
    event_size(end+1) = 1;
end

spike_count_struct = zeros(event_size(2:3));

for i = 1:length(cdt.trial_count)
    for j = 1:cdt.trial_count(i)
        spike_count_struct(i,j) = numel(spike{neuron,i,j});
    end
end

zscore_struct = zeros(event_size(2:3));
index_array = cell(event_size(2),1);

new_spike = {};
new_start_time = {};
new_stop_time = {};
new_fixation = [];
new_event = {};



for i = 1:length(cdt.trial_count)
    zscore_struct(i,1:cdt.trial_count(i)) = zscore(spike_count_struct(i,1:cdt.trial_count(i)));
    
    index_array{i} = find(abs(zscore_struct(i,1:cdt.trial_count(i))) < threshold);
    
%     hist(zscore_struct(i,1:cdt.TC(i)));
%     pause;
    
    new_spike(:,i,1:length(index_array{i})) = spike(:,i,index_array{i});
    new_start_time(i,1:length(index_array{i})) = time.start_time(i,index_array{i});
    new_stop_time(i,1:length(index_array{i})) = time.stop_time(i,index_array{i});
    new_fixation(i,1:length(index_array{i})) = time.fixation(i,index_array{i});
    new_event(i,1:length(index_array{i})) = cdt.event(i,index_array{i});
    
    cdt.trial_count(i) = length(index_array{i});

    order_index = find(cdt.order(:,1)==i);
    
    order_index_preserved = order_index(index_array{i});
    order_index_throw = setdiff(order_index, order_index_preserved);
    
    cdt.order(order_index_preserved,2) = 1:length(index_array{i});
    cdt.order(order_index_throw,:) = [];
    
end

cdt.spike = new_spike;
cdt.time.start_time = new_start_time;
cdt.time.stop_time = new_stop_time;
cdt.time.fixation = new_fixation;
cdt.event = new_event;

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [remove_outlier_trial.m] ======  

