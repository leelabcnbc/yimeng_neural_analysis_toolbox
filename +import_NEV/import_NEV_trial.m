function CDTTableRow = import_NEV_trial(trial_struct, import_params)
% IMPORT_NEV_TRIAL convert one trial into one row of CDT table.
%  
%   trial_struct 
%   
%   a struct with Electrode, Unit, TimeStamps, EventCodes, EventTimes.
%   see import_NEV.import_NEV_file to see how it is done.
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 23-Jul-2015 10:59:07 $ 
%% DEVELOPED : 8.3.0.532 (R2014a) 
%% FILENAME  : import_NEV_trial.m

%% get the function mapping trial event codes to condition.
trial_to_condition_func_str = char(import_params.getTrialToConditionFunc());
trial_to_condition_func = eval(['@' trial_to_condition_func_str]); 
% this means you can write lambda function as well... say set 
% trial_to_condition_func_str to '(x) x + 2'...



end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [import_NEV_trial.m] ======  
