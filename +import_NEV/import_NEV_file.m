function CDTTable = import_NEV_file(NEV_name, import_params, CTX_name)
% IMPORT_NEV_FILE convert one NEV file into CDT table. 
%  
%   NEV_name is path of NEV file.
%   import_params is java object of class ImportParams. 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 23-Jul-2015 09:21:44 $ 
%% DEVELOPED : 8.3.0.532 (R2014a) 
%% FILENAME  : import_NEV_file.m 
import fix_NEV.fix_NEV_CTX
import import_NEV.trial_template_dir

if nargin < 3 || isempty(CTX_name)
    CTX_name = ''; % use [] is fine too.
end

%% get trial template.
template_prototxt = char(import_params.getTemplatePrototxt());
if isempty(strfind(template_prototxt,filesep)) % append the path with default dir of templates.
    template_prototxt = fullfile(trial_template_dir(),template_prototxt);
end
    
trial_template = proto_functions.parse_proto_txt(template_prototxt);

%% get trials. (sorry for double reading, since fix_NEV began as a separate package).
[NEV_code, NEV_time]=...
    fix_NEV_CTX(NEV_name, logical(import_params.getFixNev()), ...
    trial_template, CTX_name, ...
    logical(import_params.getFixNevThrowHighByte()));

%% load NEV
addpath(genpath(NPMK_dir()));
NEV_NMPK=openNEV(NEV_name,'nosave','nomat','noread');
rmpath(genpath(NPMK_dir()));



end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [import_NEV_file.m] ======  
