function [recording_info_list] = import_recording(raw_record)
% IMPORT_RECORDING import recording database file into MATLAB
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
%% $Revision : 1.10 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : import_recording.m 

%% MODIFICATIONS:
%% $10-Nov-2013 18:05:04 $
%% change the format of the recording
%% ---

global TB_CONFIG;

fid = fopen(raw_record);
mat_record = textscan(fid, '%q %q %q %q %q', 'Delimiter', ',');
fclose(fid);

recording_info_list = cell(length(mat_record{1})-1,1);


for i = 1:length(recording_info_list)
    for j = 1:length(mat_record)
        recording_info_list{i}.(mat_record{j}{1}) = mat_record{j}{i+1};  
    end
    
    % add path name into filename, by creating a new field NEV_path
    recording_info_list{i}.NEV_path=[TB_CONFIG.PATH.NEV_directory recording_info_list{i}.NEV_name];
    
    % do the same for CTX file
    recording_info_list{i}.CTX_path=[TB_CONFIG.PATH.CTX_directory recording_info_list{i}.CTX_name];
    
    % auto fill the key
    if isempty(recording_info_list{i}.key)
        [~, name, ~] = fileparts(recording_info_list{i}.NEV_path);
        recording_info_list{i}.key = name;
    end
    
end

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [import_recording.m] ======  
