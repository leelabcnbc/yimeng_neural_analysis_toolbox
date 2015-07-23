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

CDTTableRow = struct();

% should have:
% condition number % condition number.
% starttime % time of 'start' markers.
% stoptime % time of 'end' markers.
% spikeElectrode % column vector of all spikes' electrode.
% spikeUnit % column vector of all spikes' unit.
% spikeTimes % cell array of all spikes in that electrode/unit combination.
% eventCodes % column vector of all event codes during the given window.
% eventTimes % column vector of all event times during the given window.

% all times are w.r.t. the time of trial start time, which should be
% usually the time of first start marker, shifted by the margin_before.
% So we shouldn't get any negative time (assuming every other marker
% happens after first start marker).

% this definition of time is consistent with my previous implementations.

%% get CDTTableRow.condition
CDTTableRow.condition = trial_to_condition_func(trial_struct.EventCodes);
%% get CDTTableRow.starttime/stoptime
CDTTableRow = import_NEV_trial_startstoptime(CDTTableRow,trial_struct,import_params);
%% work on getting the window for extracting spikes and events.
[trialStartTime, trialEndTime] = import_NEV_trial_trial_start_stop_time(...
    CDTTableRow,trial_struct,import_params);
%% get spikes in this window ( [trialStartTime,trialEndTime] ).
CDTTableRow = import_NEV_trial_getspikes(CDTTableRow,trial_struct,...
    import_params,trialStartTime,trialEndTime);
%% get events in this window
CDTTableRow = import_NEV_trial_getevents(CDTTableRow,trial_struct,...
    import_params,trialStartTime,trialEndTime);

end


function alignTimes = findEventTimesGivenCodes(alignCodes,eventCodes,eventTimes)
% helper function to find times of start/stop times.
% use a function to make code less redundant and easier to maintain.
[~,codeIdx] = ismember(alignCodes,eventCodes);
alignTimes = eventTimes(codeIdx);

end

function CDTTableRow = import_NEV_trial_startstoptime(CDTTableRow,trial_struct,import_params)
numPairMarker = double(import_params.getSubtrialStartCodesCount());
assert(numPairMarker>=1); % at least one pair.

% first, let's find the time of start markers.
startAlignCodes = zeros(numPairMarker,1);
for iAlignCode = 1:numPairMarker
    startAlignCodes(iAlignCode) = ...
        double(import_params.getSubtrialStartCodes(iAlignCode-1));
end

CDTTableRow.starttime = findEventTimesGivenCodes(...
    startAlignCodes,trial_struct.EventCodes,trial_struct.EventTimes);

% then, work on end time.
CDTTableRow.endtime = nan(numPairMarker,1);
% figure out which scheme is used for end time.
className = 'com.leelab.monkey_exp.ImportParamsProtos$ImportParams$AlignType';
typeObjCode = javaMethod('valueOf', className, 'ALIGNTYPE_CODE');
typeObjTime = javaMethod('valueOf', className, 'ALIGNTYPE_TIME');
if typeObjCode.equals(import_params.getSubtrialEndType())
    assert(numPairMarker==double(import_params.getSubtrialEndCodesCount()));
    
    % let's find the time of end markers.
    endAlignCodes = zeros(numPairMarker,1);
    for iAlignCode = 1:numPairMarker
        endAlignCodes(iAlignCode) = ...
            double(import_params.getSubtrialEndCodes(iAlignCode-1));
    end
    
    CDTTableRow.endtime = findEventTimesGivenCodes(...
        endAlignCodes,trial_struct.EventCodes,trial_struct.EventTimes);
elseif typeObjTime.equals(import_params.getSubtrialEndType())
    assert(numPairMarker==double(import_params.getSubtrialEndTimesCount()));
    
    % simply add time.
    for iAlignCode = 1:numPairMarker
        CDTTableRow.endtime(iAlignCode) = ...
            CDTTableRow.starttime(iAlignCode) + ...
            double(import_params.getSubtrialEndTimes(iAlignCode-1));
    end
else
    error('not implemented!');
end

% check numbers match.
assert(numel(CDTTableRow.starttime)==numPairMarker);
assert(numel(CDTTableRow.endtime)==numPairMarker);
end


function [trialStartTime, trialEndTime] = ...
    import_NEV_trial_trial_start_stop_time(...
    CDTTableRow,trial_struct,import_params)
% the window is defined by trialStartTime and trialEndTime.
% work on trial level start code.
if import_params.hasTrialStartCode()
    trialStartAlignCode = double(import_params.getTrialStartCode());
else
    trialStartAlignCode = startAlignCodes(1); % otherwise use first start code in subtrial level.
end
trialStartTime = findEventTimesGivenCodes(...
    trialStartAlignCode,trial_struct.EventCodes,trial_struct.EventTimes);
% work on end time.
% an if-else struct following the comment in proto definition.
% this block gives the unpadded trial end time.
if import_params.hasTrialEndCode() || import_params.hasTrialEndTime()
    % switch over trial_end_type
    if typeObjCode.equals(import_params.getTrialEndType()) % code based
        assert(import_params.hasTrialEndCode());
        trialEndTime = findEventTimesGivenCodes(...
            double(import_params.getTrialEndCode()),...
            trial_struct.EventCodes,trial_struct.EventTimes);
    elseif typeObjTime.equals(import_params.getTrialEndType()) % time based
        assert(import_params.hasTrialEndTime());
        trialEndTime = trialStartTime + ...
            double(import_params.getTrialEndTime());
    else
        error('not implemented!');
    end
else
    trialEndTime = CDTTableRow.endtime(end);
end

% these are the final products of this block.
% pad margin
trialEndTime = trialEndTime + double(import_params.getMarginAfter());
% pad margin. This can't be done before, since otherwise the end time will
% be wrong...
trialStartTime = trialStartTime - double(import_params.getMarginBefore());
end


% Created with NEWFCN.m by Frank González-Morphy
% Contact...: frank.gonzalez-morphy@mathworks.de
% ===== EOF ====== [import_NEV_trial.m] ======
