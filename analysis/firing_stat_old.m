function [firing_rate_array, firing_count_array, firing_rate_matrix_array, firing_count_matrix_array] = firing_stat_old(cdt, channel, edge)
% FIRING_STAT ... 
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

%% $DATE     : 03-Nov-2013 13:23:31 $ 
%% $Revision : 1.00 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : firing_stat.m 

%% MODIFICATIONS:
%% $26-Sep-2002 14:44:35 $
%% blablabla
%% ---
%% $25-Feb-2002 07:29:17 $ 
%% blablabla

disp(' !!!  You must enter code into this file < firing_stat.m > !!!') 

if nargin < 3
    edge = [0, inf];
end

if nargin < 2
    channel = cdt.info.channel;
end

TC = cdt.TC;

EVENTS = squeeze(cdt.EVENTS(channel,:,:));

firing_rate_array = cell(length(TC),1);
firing_count_array = cell(length(TC),1);

firing_rate_matrix_array = cell(length(TC),1);
firing_count_matrix_array = cell(length(TC),1);

for i = 1:length(TC)
    [firing_rate_array{i}, firing_count_array{i}, firing_rate_matrix_array{i}, firing_count_matrix_array{i}] = firing_stat_single_condition(EVENTS(i,1:TC(i)),edge,cdt.data.stoptime(i,1:TC(i)),cdt.data.margins{2});
end   
    
end




function [firing_rate_list, firing_count_list, firing_rate_matrix, firing_count_matrix] = firing_stat_single_condition(spike_times,edge,stoptime,margin)
spike_times = spike_times(:);

firing_count_matrix = zeros(length(spike_times),numel(edge)-1);
firing_rate_matrix = zeros(length(spike_times),numel(edge)-1);
   
% process trial by trial
for i = 1:length(spike_times)
    tmp_edge = edge;
    
    if tmp_edge(end) == inf
        tmp_edge(end) = stoptime{i}(end) + margin;
    end
    
    firing_count = histc(spike_times{i}, tmp_edge);
    
    if edge(end) == inf
        assert(firing_count(end) == 0);
    end
    
    firing_count_matrix(i,:) = firing_count(1:end-1);
    
    firing_rate_matrix(i,:) = firing_count_matrix(i,:)./diff(tmp_edge);

end

firing_count_list = mean(firing_count_matrix,1)';

firing_rate_list = mean(firing_rate_matrix,1)';

end




% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [firing_stat.m] ======  
