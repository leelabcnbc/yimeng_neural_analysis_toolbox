function psth = calc_PSTH(spike_times, bounds, sigma)
% CALC_PSTH ... 
%  
%   ... 
% 
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
%
% Inputs:
%    spike_times - a cell array of matrices, each containing the time
%    stamps for all spikes happening in that trial.
%    bounds - only compute the PSTH during the time window [bounds(1),
%    bounds(2)]
%    sigma - smoothing parameter 
%
% Outputs:
%    psth - Description
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

%% $DATE     : 01-Nov-2013 10:05:46 $ 
%% $Revision : 1.00 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : calc_PSTH.m 

%% MODIFICATIONS:
%% $26-Sep-2002 14:44:35 $
%% blablabla
%% ---
%% $25-Feb-2002 07:29:17 $ 
%% blablabla

spike_times = spike_times(:);

ntrials = length(spike_times);

%make spike_times into a hugh double vector
for i = 1:ntrials
    spike_times{i} = spike_times{i}(:);
end
spike_times = cell2mat(spike_times);

%bounds
if isempty(bounds)
    bounds=[0 ceil(max(spike_times))];
end

%psth histogram count
psth = histc(spike_times,bounds(1):bounds(2));

%smoothing
psth = gauss_smooth(psth,sigma);

%normalization
psth = psth*1000/ntrials;

psth = psth(:);

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [calc_PSTH.m] ======  
