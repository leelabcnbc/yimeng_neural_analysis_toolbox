function [firing_rate_array, firing_count_array, firing_rate_matrix_array, firing_count_matrix_array, trial_count] = firing_stat(cdt, neuron, edge_type, edge, time_range)
% FIRING_STAT ... 
%  
%   ... 
% 
% Syntax:  [firing_rate_array, firing_count_array, firing_rate_matrix_array,
% firing_count_matrix_array, trial_count] = firing_stat(cdt, neuron,
% edge_type, edge, time_range)
%
% Inputs:
%    cdt - cdt struct
%    neuron - the neuron to be analyzed
%    edge_type - 'relative' or 'absolute'. You can use the times given in
%    start_time and stop_time to define the edge ('relative'), or you can
%    specify the edge yourself
%    edge - if edge_type is 'relative', here, we can make some adjustments
%    relative to these edges, say, [-0.1, 0.1] will make a 0.1s margin both
%    befre and after the original time window. If edge_type is 'absolute',
%    we have to specify the starting time and ending time for each bin. you
%    can specify Inf as the end time of the last bin.
%    time_range - specify the trials you want to include for calculation
%
% Outputs:
%    firing_rate_array - firing rate per condition. cell array, each cell
%    has a Bx1 vector, where B is number of bins.
%    firing_count_array - same as before, using firing count instead
%    firing_rate_matrix_array - cell array, each cell i has a [TC(i) x B]
%    double matrix, of firing rates for each trial, each bin
%    firing_count_matrix_array - same as above, using firing count instead
%    trial_count - number of trials per condition
%
%
% Other m-files required: none
% Subfunctions: firing_stat_single_condition
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2
%

%% AUTHOR    : Yimeng Zhang
%% Computer Science Department, Carnegie Mellon University
%% EMAIL     : zym1010@gmail.com 

%% $DATE     : 03-Nov-2013 13:23:31 $ 
%% $Revision : 1.00 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : firing_stat.m 

%% MODIFICATIONS:
%% $27-Nov-2013 22:17:40 $
%% Add documentation, fix a rare bug



if nargin < 5
    time_range = 1:size(cdt.order,1);
end

if nargin < 3
    edge_type = 'relative'; % relative to 
end 

if nargin < 4
    edge = 0;
end

TC = cdt.trial_count;

spike = squeeze(cdt.spike(neuron,:,:));

% case for single trial
if size(spike,1) == 1
    spike = spike';
end

firing_rate_array = cell(length(TC),1);
firing_count_array = cell(length(TC),1);

firing_rate_matrix_array = cell(length(TC),1);
firing_count_matrix_array = cell(length(TC),1);

trial_count = zeros(length(TC),1);

for i = 1:length(TC)
    new_order = cdt.order(time_range,:);
    trial_idx = new_order((new_order(:,1) == i),2);

    [firing_rate_array{i}, firing_count_array{i}, firing_rate_matrix_array{i}, firing_count_matrix_array{i}] = ...
        firing_stat_single_condition(spike(i,trial_idx), edge_type, edge,...
        cdt.time.margin(2),cdt.time.start_time(i,trial_idx), cdt.time.stop_time(i,trial_idx));
    
    trial_count(i) = length(trial_idx);
end   
    
end




function [firing_rate_list, firing_count_list, firing_rate_matrix, firing_count_matrix] = firing_stat_single_condition(spike_times,edge_type,edge,after_margin,start_time,stop_time)
spike_times = spike_times(:);

switch lower(edge_type)
    case 'relative'
        number_of_bin = numel(start_time{1});
        firing_count_matrix = zeros(length(spike_times),number_of_bin);
        firing_rate_matrix = zeros(length(spike_times),number_of_bin);
        
    case 'absolute'
        firing_count_matrix = zeros(length(spike_times),numel(edge)/2);
        firing_rate_matrix = zeros(length(spike_times),numel(edge)/2);
end



   
% process trial by trial
for i = 1:length(spike_times)
    
    % find the edge used in this case
    
    switch lower(edge_type)
        case 'relative'
            start_time_this_trial = start_time{i};
            stop_time_this_trial = stop_time{i};
            tmp_edge = [start_time_this_trial(:)'; stop_time_this_trial(:)'];
            tmp_edge = tmp_edge(:);
            assert(issorted(tmp_edge));
            tmp_edge = tmp_edge + edge(:);
        case 'absolute'
            tmp_edge = edge(:);
    end
    
    assert(rem(length(tmp_edge),2) == 0);
    
    number_of_bins = length(tmp_edge)/2;
    
    for j = 1:number_of_bins
        start_edge = tmp_edge(2*j-1);
        stop_edge = tmp_edge(2*j);
        
        if stop_edge == inf
            stop_edge = stop_time{i}(end) + after_margin;
        end
        
        assert(start_edge >=0);
        assert(stop_edge <= stop_time{i}(end) + after_margin);
        assert(stop_edge > start_edge);
        
        tmp_count = histc(spike_times{i},[start_edge, stop_edge]);
        
        firing_count_matrix(i,j) = tmp_count(1);
        firing_rate_matrix(i,j) = tmp_count(1)/(stop_edge-start_edge);
    end
end

firing_count_list = mean(firing_count_matrix,1)';
firing_rate_list = mean(firing_rate_matrix,1)';

end




% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [firing_stat.m] ======  


