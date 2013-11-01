function [NEV_info_list] = import_recording(raw_record)
% IMPORT_RECORDING ... 
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

%% $DATE     : 31-Oct-2013 21:22:56 $ 
%% $Revision : 1.00 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : import_recording.m 

%% MODIFICATIONS:
%% $26-Sep-2002 14:44:35 $
%% blablabla
%% ---
%% $25-Feb-2002 07:29:17 $ 
%% blablabla

global TB_CONFIG;

fid = fopen(raw_record);
mat_record = textscan(fid, '%q %q %q %q %q %q %q %q %q', 'Delimiter', ',');
fclose(fid);

NEV_info_list = cell(length(mat_record{1})-1,1);


for i = 1:length(NEV_info_list)
    for j = 1:length(mat_record)
        NEV_info_list{i}.(mat_record{j}{1}) = mat_record{j}{i+1}; 
        
        if strcmp(mat_record{j}{1},'channel') || strcmp(mat_record{j}{1},'ntrials')
            NEV_info_list{i}.(mat_record{j}{1}) = str2num(mat_record{j}{i+1}); 
        end
        
        
        
    end
    
    % add path name into filename, by creating a new field NEV_path
    NEV_info_list{i}.NEV_path=[TB_CONFIG.PATH.sorted_data NEV_info_list{i}.NEV_name];
    
    if isempty(NEV_info_list{i}.key)
        [~, name, ~] = fileparts(NEV_info_list{i}.NEV_path);
        NEV_info_list{i}.key = name;
    end
    
end

header = cell(length(mat_record),1);

for i = 1:length(header)
    header{i} = mat_record{i}{1}; 
end

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [import_recording.m] ======  
