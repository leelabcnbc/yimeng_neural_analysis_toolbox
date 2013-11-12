function cdt = remove_outlier_trial_old(cdt, channel, threshold)
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

disp(' !!!  You must enter code into this file < remove_outlier_trial.m > !!!') 
 

if nargin < 2
    channel = cdt.info.channel;
end


if nargin < 3
    threshold = 2;
end

EVENTS = cdt.EVENTS;
event_size = size(EVENTS);

data = cdt.data;

if length(event_size) == 2 % only one trial
    event_size(end+1) = 1;
end

spike_count_struct = zeros(event_size(2:3));

for i = 1:length(cdt.TC)
    for j = 1:cdt.TC(i)
        spike_count_struct(i,j) = numel(EVENTS{channel,i,j});
    end
end

zscore_struct = zeros(event_size(2:3));
index_array = cell(event_size(2),1);

for i = 1:length(cdt.TC)
    zscore_struct(i,1:cdt.TC(i)) = zscore(spike_count_struct(i,1:cdt.TC(i)));
    
    index_array{i} = find(abs(zscore_struct(i,1:cdt.TC(i))) < threshold);
    
%     hist(zscore_struct(i,1:cdt.TC(i)));
%     pause;
    
    EVENTS(:,i,1:length(index_array{i})) = EVENTS(:,i,index_array{i});
    data.starttime(i,1:length(index_array{i})) = data.starttime(i,index_array{i});
    data.stoptime(i,1:length(index_array{i})) = data.stoptime(i,index_array{i});
    data.fixation(i,1:length(index_array{i})) = data.fixation(i,index_array{i});
    
    
    for j = length(index_array{i})+1:event_size(3)
        for k = 1:event_size(1)
            EVENTS{k,i,j} = [];
        end
        data.starttime{i,j} = [];
        data.stoptime{i,j} = [];
        data.fixation(i,j) = 0;
    end
    cdt.TC(i) = length(index_array{i});
    
end

cdt.EVENTS = EVENTS;
cdt.data = data;

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [remove_outlier_trial.m] ======  

