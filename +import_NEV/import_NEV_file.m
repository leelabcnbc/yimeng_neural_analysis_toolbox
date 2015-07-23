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
import import_NEV.import_NEV_trial

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
    fix_NEV_CTX(NEV_name, import_params.getFixNev(), ...
    trial_template, CTX_name, ...
    import_params.getFixNevThrowHighByte());

%% load NEV
addpath(genpath(NPMK_dir()));
NEV_struct=openNEV(NEV_name,'nosave','nomat','noread');
rmpath(genpath(NPMK_dir()));

%% collect all useful electrode/unit combinations.

spikeElecUnit = [NEV_struct.Data.Spikes.Electrode(:), ...
    NEV_struct.Data.Spikes.Unit(:)];
spikePruneIdx = false(numel(NEV_struct.Data.Spikes.Electrode),1);

if import_params.getSpikeNoSecondaryUnit()
    spikePruneIdx( (spikeElecUnit(:,2)>1) & (spikeElecUnit(:,2)<255) ) = true;
end

if import_params.getSpikeNo255Unit()
    spikePruneIdx(spikeElecUnit(:,2)==255) = true;
end

if import_params.getSpikeNo0Unit()
    spikePruneIdx(spikeElecUnit(:,2)==0) = true;
end 
spikeElecUnit = spikeElecUnit(~spikePruneIdx,:); % keep non pruned spikes.
elecUnitMap = ... % elecUnitMap is all maps not combined.
    unique(spikeElecUnit,'rows'); 


%% get all spike times.
TimeStamps=double(NEV_struct.Data.Spikes.TimeStamp(:))./double(NEV_struct.MetaTags.TimeRes);
assert(numel(TimeStamps) == numel(spikePruneIdx)); % thus, we throw away a lot of spikes.
assert(NEV_struct.MetaTags.TimeRes==30000);
TimeStamps = TimeStamps(~spikePruneIdx);
assert(numel(TimeStamps) == size(spikeElecUnit,1));
% I think this is crucial for the times in fix_NEV and in this function to
% be consistent.


%% unwrap some parameters in the import_params for faster access.
import_params_margin_before = double(import_params.getMarginBefore());
import_params_margin_after = double(import_params.getMarginAfter());

%% for cellfun applying processing function to each trial.
tmp_struct = cell(numel(NEV_code),1);

% pre-process all needed spike information for each trial.
for j = 1:numel(NEV_code)
    start_time_trial = NEV_time{j}(1);
    end_time_trial = NEV_time{j}(end);
    
    % notice that these are all open intervals, consistent with Corentin's
    % old program.
    selectIdx = ( (TimeStamps > start_time_trial-import_params_margin_before) ...
        & (TimeStamps < end_time_trial+import_params_margin_after) );
    
    tmp_struct{j}.Electrode = spikeElecUnit(selectIdx,1);
    tmp_struct{j}.Unit = spikeElecUnit(selectIdx,2);
    tmp_struct{j}.TimeStamps = TimeStamps(selectIdx);
    tmp_struct{j}.EventCodes = NEV_code{j};
    tmp_struct{j}.EventTimes = NEV_time{j};
end

CDTTableByTrials = cellfun(@(x) import_NEV_trial(x, import_params), ...
    tmp_struct, 'UniformOutput', false);

%% create a cell array for each column in the whole table.
CDTTable = struct();
numTrial = numel(NEV_code);
CDTTable.condition = zeros(numTrial,1);
CDTTable.starttime = cell(numTrial,1); % later to be represented as matrix.
CDTTable.stoptime = cell(numTrial,1); % later to be represented as matrix.
CDTTable.spikeElectrode = cell(numTrial,1);
CDTTable.spikeUnit = cell(numTrial,1);
CDTTable.spikeTimes = cell(numTrial,1);
CDTTable.eventCodes = cell(numTrial,1);
CDTTable.eventTimes = cell(numTrial,1);


for iTrial = 1:numTrial
    CDTTableThisRow = CDTTableByTrials{iTrial};
    CDTTable.condition(iTrial) = CDTTableThisRow.condition;
    CDTTable.starttime{iTrial} = CDTTableThisRow.starttime(:)'; % make them row
    CDTTable.stoptime{iTrial} = CDTTableThisRow.stoptime(:)'; % make them row.
    CDTTable.spikeElectrode{iTrial} = CDTTableThisRow.spikeElectrode;
    CDTTable.spikeUnit{iTrial} = CDTTableThisRow.spikeUnit;
    CDTTable.spikeTimes{iTrial} = CDTTableThisRow.spikeTimes;
    CDTTable.eventCodes{iTrial} = CDTTableThisRow.eventCodes;
    CDTTable.eventTimes{iTrial} = CDTTableThisRow.eventTimes;
end

CDTTable.starttime = cell2mat(CDTTable.starttime);
CDTTable.stoptime = cell2mat(CDTTable.stoptime);

end








% Created with NEWFCN.m by Frank González-Morphy
% Contact...: frank.gonzalez-morphy@mathworks.de
% ===== EOF ====== [import_NEV_file.m] ======
