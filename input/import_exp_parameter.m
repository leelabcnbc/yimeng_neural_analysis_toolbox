function [exp_info_map] = import_exp_parameter(raw_record)
% IMPORT_EXP_PARAMETER Import all experiment parameters
%  
%   ... 
% 
% Syntax:  [output1,output2] = function_name(raw_record)
%
% Inputs:
%    raw_record - Description
%
% Outputs:
%    exp_info_map - Description
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

%% $DATE     : 31-Oct-2013 21:18:08 $ 
%% $Revision : 1.00 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : import_exp_parameter.m 


fid = fopen(raw_record);
mat_record = textscan(fid, '%q %q %q %q %q', 'Delimiter', ',');

fclose(fid);

exp_info_list = cell(length(mat_record{1})-1,1);

numerical_field = [2 3 4 5];

for i = 1:length(exp_info_list)
    for j = 1:length(mat_record)
        if ~ismember(j, numerical_field)
            exp_info_list{i}.(mat_record{j}{1}) = mat_record{j}{i+1}; 
        else
            exp_info_list{i}.(mat_record{j}{1}) = str2num(mat_record{j}{i+1});
        end
    end
end

header = cell(length(mat_record),1);

for i = 1:length(header)
    header{i} = mat_record{i}{1}; 
end



for i = 1:length(exp_info_list)
    for j = 1:length(mat_record)
        if ~ismember(j, numerical_field)
            exp_info_list{i}.(mat_record{j}{1}) = mat_record{j}{i+1}; 
        else
            exp_info_list{i}.(mat_record{j}{1}) = str2num(mat_record{j}{i+1});
        end
    end
end

exp_info_map = containers.Map;

for i = 1:length(exp_info_list)
    exp_info_map(exp_info_list{i}.(header{1})) = exp_info_list{i};
end

end


% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [import_exp_parameter.m] ======  
