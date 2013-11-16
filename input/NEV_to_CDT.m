function CDT_file_list = NEV_to_CDT( NEV_info_list, NEV_code_list, NEV_time_list )
% NEV_TO_CDT Convert NEV files to CDT structures.
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

%% $DATE     : 31-Oct-2013 21:39:18 $
%% $Revision : 1.10 $
%% DEVELOPED : 8.1.0.604 (R2013a)
%% FILENAME  : NEV_to_CDT.m

%% MODIFICATIONS:
%% $10-Nov-2013 21:13:42 $
%% rename fields, reorganize structure, add 'order', 'events', make 'condition_list' column vector, etc.
%% ---

global TB_CONFIG

if nargin == 3
    external_code = true; % don't depend on NEV files themselves for event codes.
else
    external_code = false;
end

CDT_file_list = cell(length(NEV_info_list),1);

for i = 1:length(NEV_info_list)
    
    % clear all
    time = [];
    cdt = [];
    
    fprintf('processing file %s...\n', NEV_info_list{i}.key);
    
    % subject to change...
    %%%%%%%%%%%%%%%%%%%%%%%%
    NEV_name = NEV_info_list{i}.NEV_path;
    exp_name = NEV_info_list{i}.exp_name;
    CTX_name = NEV_info_list{i}.CTX_path;
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    
    
    NEV_struct = openNEV(NEV_name,'nosave','nomat');
    
    
    exp_param = TB_CONFIG.exp_parameter_map(exp_name);
    exp_param.condition_list = (exp_param.condition_number(1):exp_param.condition_number(2))';
    
    if external_code
        NEV_code = NEV_code_list{i}; % this is  N*1 cell array, where N is number of trials.
        NEV_time = NEV_time_list{i};
    else
        [NEV_code, NEV_time]=fix_NEV_CTX(NEV_name, TB_CONFIG.CDT.fix_NEV, exp_param.timing_file, exp_param.condition_file, CTX_name, TB_CONFIG.CDT.throw_high_byte);
    end
    
    % NEV_code and NEV_time are error-free code list and time list for only
    % rewarded trials.
    
    
    %Margins (buffers in ms)
    before=TB_CONFIG.CDT.margin_before;
    after=TB_CONFIG.CDT.margin_after;
    time.margin=[before after];
    %%%%%%%%%%%%%%%%%%%%%%%

    % for compatibility
%     cdt.CHANNELS = unique(NEV_struct.Data.Spikes.Electrode); %list of channels %for compatibility
    
    % neuron -> (channel, unit)
    cdt.map = unique([NEV_struct.Data.Spikes.Electrode; NEV_struct.Data.Spikes.Unit]','rows');
    
    
    CONFIG = TB_CONFIG.CDT;
    % reduce the map based on CONFIG
    if CONFIG.no_secondary_unit
        cdt.map = cdt.map(~(cdt.map(:,2)>1 & cdt.map(:,2)<255),:);
    end
    
    if CONFIG.no_255_unit
        cdt.map = cdt.map(~(cdt.map(:,2)==255),:);
    end
    
    if CONFIG.no_0_unit
        cdt.map = cdt.map(~(cdt.map(:,2)==0),:);
    end
    
    cdt.trial_count = zeros(length(exp_param.condition_list),1); %keep the number of trials for each condition
    cdt.spike = {};%cell(length(cdt.CHANNELS),length(condition_list),####,nbTEST); %spike trains
    cdt.info=NEV_info_list{i};
    cdt.exp_param = exp_param; %experiment's information
    cdt.order = zeros(length(NEV_code),2);
    
    map = cdt.map; % temporary variable to avoid warning of parfor
    
    tmp_struct = cell(length(NEV_code),1); % for parallel
    
    %conversion of TimeStamps in seconds
    TimeStamps=double(NEV_struct.Data.Spikes.TimeStamp)./double(NEV_struct.MetaTags.TimeRes);
    
    cdt.event = {}; %cell [condition x number_of_trials], storing event codes and timestamps.
    
    % pre-process all needed spike information for each trial.
    for j = 1:length(NEV_code)
        start_time_trial = NEV_time{j}(1);
        end_time_trial = NEV_time{j}(end);
        
        selectIdx = (TimeStamps > start_time_trial-before) & (TimeStamps < end_time_trial+after );
        
        tmp_struct{j}.Electrode = NEV_struct.Data.Spikes.Electrode(selectIdx);
        tmp_struct{j}.Unit = NEV_struct.Data.Spikes.Unit(selectIdx);
        tmp_struct{j}.TimeStamps = TimeStamps(selectIdx);
    end
    
    
    parfor j = 1:length(NEV_code)
        fprintf('processing trial %d...\n', j);
        NEV_trial_code = NEV_code{j};

        tcond = condition_code(NEV_trial_code,exp_param);
        
        tmp_struct{j}.cndidx = find(exp_param.condition_list == tcond);

        
        [~,codeIdx] = ismember(exp_param.align_code,NEV_trial_code);
        assert(length(codeIdx) == 2*exp_param.number_of_test_per_condition);
        
        starttime_list = zeros(exp_param.number_of_test_per_condition,1)';
        stoptime_list = zeros(exp_param.number_of_test_per_condition,1)';
        
        
        for k = 1:exp_param.number_of_test_per_condition
            starttime_list(k) = NEV_time{j}(codeIdx(2*k-1));
            stoptime_list(k) = NEV_time{j}(codeIdx(2*k));
        end
        
        tmp_struct{j}.starttime=starttime_list-(starttime_list(1)-before);
        tmp_struct{j}.stoptime=stoptime_list-(starttime_list(1)-before);
        
        
        %fixation
        %temp code %%%%%%%
        fixationcode = strfind(NEV_trial_code(:)',[23 8]);
        assert(isscalar(fixationcode));
        fixationcode = fixationcode+1;
        
        tmp_struct{j}.fixation=NEV_time{j}(fixationcode)-(starttime_list(1)-before);
        %%%%%%%
        
        tstartcode = (find(NEV_trial_code == exp_param.align_code(1)));
        assert(isscalar(tstartcode)); %debug
        tstopcode = (find(NEV_trial_code == exp_param.align_code(exp_param.number_of_test_per_condition*2)));
        assert(isscalar(tstopcode)); %debug
        
        % start and stop times
        starttime=NEV_time{j}(tstartcode)-before;
        stoptime =NEV_time{j}(tstopcode)+after;
        
        % debug
        assert(starttime==starttime_list(1)-before);
        
        % put those spikes in spike cell array [chan x condition x repeat x test]
        for c=1:size(map,1)
            ch=map(c,1);
            unit=map(c,2);
            spiketimes_c=(tmp_struct{j}.TimeStamps > starttime) & (tmp_struct{j}.TimeStamps < stoptime )...
                & (tmp_struct{j}.Electrode==ch) & (tmp_struct{j}.Unit==unit);
            tmp_struct{j}.spike{c} = tmp_struct{j}.TimeStamps(spiketimes_c)-starttime; 
            
        end
        
        index_of_event_included = NEV_time{j}> starttime & NEV_time{j}< stoptime; % consistent with spike timing; open interval.
        
        tmp_struct{j}.event = [NEV_code{j}(index_of_event_included), NEV_time{j}(index_of_event_included)-starttime];
    end % end trial loop
    
    
    for j = 1:length(NEV_code)
        cndidx = tmp_struct{j}.cndidx;
        cdt.trial_count(cndidx) = cdt.trial_count(cndidx) + 1;
        time.start_time{cndidx,cdt.trial_count(cndidx)}=tmp_struct{j}.starttime;
        time.stop_time{cndidx,cdt.trial_count(cndidx)}=tmp_struct{j}.stoptime;
        time.fixation(cndidx,cdt.trial_count(cndidx))=tmp_struct{j}.fixation;
        
        cdt.event{cndidx,cdt.trial_count(cndidx)} = tmp_struct{j}.event;
        
        cdt.order(j,:) = [cndidx,cdt.trial_count(cndidx)];
        
        for c = 1:size(cdt.map,1)
            cdt.spike{c,cndidx,cdt.trial_count(cndidx)} =tmp_struct{j}.spike{c};
        end
        
    end
    
    cdt.time=time;
    CDT_file_list{i} = [TB_CONFIG.PATH.save_cdt NEV_info_list{i}.key '.mat'];
    
    save(CDT_file_list{i},'cdt','CONFIG');
    
end % end file loop

end








% Created with NEWFCN.m by Frank González-Morphy
% Contact...: frank.gonzalez-morphy@mathworks.de
% ===== EOF ====== [NEV_to_CDT.m] ======
