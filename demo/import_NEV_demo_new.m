% step1: extract NMPK.zip in 3rdparty and replace the original openNEV.m with openNEV_.m (remove the '_')!

toolbox_init; % initialize toolbox
global TB_CONFIG;
[NEV_info_list]=import_recording('sample_recording_database_new.csv');
[TB_CONFIG.exp_parameter_map]=import_exp_parameter('sample_exp_parameter_database.csv');
CDT_file_list = NEV_to_CDT(NEV_info_list);

cdt_merged = merge_CDT(CDT_file_list);

