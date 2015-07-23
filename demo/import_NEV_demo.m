function import_NEV_demo()
% IMPORT_NEV_DEMO ... 
%  
%   a demo showing importing NEV files using import_NEV package. 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 23-Jul-2015 16:45:15 $ 
%% DEVELOPED : 8.3.0.532 (R2014a) 
%% FILENAME  : import_NEV_demo.m 

import import_NEV.import_params_dir
import import_NEV.import_NEV_files
% load file list.
basePathNEV = '/Users/yimengzh/Desktop/yimeng_box_old/zym1010/demo_nev_data';
basePathCTX = '/Users/yimengzh/Desktop/yimeng_box_old/zym1010/demo_ctx_data';

NEV_list = {
    'v1_2012_1105_003.nev';
    'v1_2012_1105_004.nev';
    'v1_2012_1105_005.nev';
    'v1_2012_1106_003.nev'};

CTX_list = {
    'GA110512.3';
    'GA110512.4';
    'GA110512.5';
    'GA110612.3'};

assert(numel(NEV_list)==numel(CTX_list));

for iNEV = 1:numel(NEV_list)
    NEV_list{iNEV} = fullfile(basePathNEV,NEV_list{iNEV});
    CTX_list{iNEV} = fullfile(basePathCTX,CTX_list{iNEV});
end


% load in experiment package.
protoClass = 'com.leelab.monkey_exp.ImportParamsProtos$ImportParams';
importParamsPrototxt = fullfile(import_params_dir(),'edge_test.prototxt');
importParams = proto_functions.parse_proto_txt(importParamsPrototxt,protoClass);

import_NEV_files(NEV_list(1:2),importParams,CTX_list(1:2));

% just use vertcat (check my evernote note) to combine!

end










% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [import_NEV_demo.m] ======  
