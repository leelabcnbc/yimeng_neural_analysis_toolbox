function toolbox_init()
% TOOLBOX_INIT Initialize the toolbox
%  
%   Initialize the toolbox by setting up several global variables. 
%   This is the FIRST function to call when using the toolbox.
% Syntax:   toolbox_init()
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%

%% AUTHOR    : Yimeng Zhang
%% Computer Science Department, Carnegie Mellon University
%% EMAIL     : zym1010@gmail.com 

%% $DATE     : 31-Oct-2013 20:51:52 $ 
%% $Revision : 1.10 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : toolbox_init.m 

%% MODIFICATIONS:
%% $10-Nov-2013 18:16:20 $
%% change PATH.sorted_data to PATH.NEV_directory, add PATH.CTX_directory
%% ---

global TB_CONFIG % toolbox config

% specifiying path
%TB_CONFIG.PATH.stimuli = '/Users/yimengzh/Documents/Research/2013 Corentin Data Analysis/CTXFiles_edge_concept/edge_or/pngs_or33/';



TB_CONFIG.PATH.NEV_directory = '/Users/yimengzh/';
TB_CONFIG.PATH.CTX_directory = '';

TB_CONFIG.PATH.save_cdt = '/Users/yimengzh/Documents/Research/yimeng_neural_analysis_toolbox/data/';


% specifying parameters when converting recording to CDT
TB_CONFIG.CDT.no_secondary_unit = true; % no unit 2-254
TB_CONFIG.CDT.no_255_unit = true; % no unit 255
TB_CONFIG.CDT.no_0_unit = false; % no unit 0 
TB_CONFIG.CDT.margin_before = 0.3; % margin before the starting boundary code
TB_CONFIG.CDT.margin_after = 0.3; % margin after the ending boundary code

TB_CONFIG.CDT.throw_high_byte = true; % only use the least significant byte of the event code in NEV file.

TB_CONFIG.CDT.fix_NEV = true; % if this is true, you have to define the related template (more on this later)


% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [toolbox_init.m] ======  
