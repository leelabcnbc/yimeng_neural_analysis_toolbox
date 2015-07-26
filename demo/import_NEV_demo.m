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


%% load file list.
basePathNEV = fullfile(root_dir(),'demo','import_NEV_demo_data');
basePathCTX = fullfile(root_dir(),'demo','import_NEV_demo_data');

NEV_list = {
    'v1_2012_1105_003.nev';
    'v1_2012_1105_004.nev';
    };

CTX_list = {
    'GA110512.3';
    'GA110512.4';
    };

assert(numel(NEV_list)==numel(CTX_list));

for iNEV = 1:numel(NEV_list)
    NEV_list{iNEV} = fullfile(basePathNEV,NEV_list{iNEV});
    CTX_list{iNEV} = fullfile(basePathCTX,CTX_list{iNEV});
end

%% load in import parameters.
protoClass = 'com.leelab.monkey_exp.ImportParamsProtos$ImportParams';
importParamsPrototxt = fullfile(import_params_dir(),'edge_test.prototxt');
importParams = proto_functions.parse_proto_txt(importParamsPrototxt,protoClass);

%% do the actual conversion.
CDTTables = import_NEV_files(NEV_list,importParams,CTX_list);

%% compare results
referenceResultDir = fullfile(root_dir(),'demo','import_NEV_demo_results');
referenceResultFileList = {...
    'v1_2012_1105_003.mat';
    'v1_2012_1105_004.mat';
    };

assert(numel(referenceResultFileList)==numel(CDTTables));

for iFile = 1:numel(CDTTables)
    oldMatThis = ...
        load(fullfile(referenceResultDir,referenceResultFileList{iFile}));
    % compare oldMatThis.cdt and CDTTables{iFile}.
    cdtOld = oldMatThis.cdt;
    cdtNew = CDTTables{iFile};
    compare_old_and_new_CDT(cdtOld,cdtNew);
end


% just use vertcat (check my evernote note) to combine!

% TODO: save binary and text version of importParams.

%% save the result.
saveDir = referenceResultDir;
saveFileName = 'import_NEV_demo_result'; % no extension, which will be appended automatically.
% a custom meta field. set metaInfo = [] or just don't pass it into
% save_CDTTable if you don't need it.
metaInfo = struct();
metaInfo.NEV_list = NEV_list;
metaInfo.CTX_list = CTX_list;
metaInfo.timestamp = datestr(now,30);

save_CDTTable(fullfile(saveDir,saveFileName),CDTTables,importParams,metaInfo);

end



function compare_old_and_new_CDT(cdtOld,cdtNew)

tol = 1e-10;
% make sure cnd index and cnd itself are exchangeable.
assert(isequal(cdtOld.exp_param.condition_list(:)', ...
    1:numel(cdtOld.exp_param.condition_list)));

%% check trial orders by conditions.
assert(isequal(cdtOld.order(:,1),cdtNew.condition));

%% check events,spikes,times.
trialCount = cdtOld.trial_count;
conditionTotal = size(cdtOld.event,1);

for iCondition = 1:conditionTotal
    
    %% events.
    eventCodesNew = cdtNew.eventCodes(cdtNew.condition==iCondition);
    eventTimesNew = cdtNew.eventTimes(cdtNew.condition==iCondition);
    
    assert(numel(eventCodesNew)==trialCount(iCondition));
    assert(numel(eventTimesNew)==trialCount(iCondition));
    
    for iTrial = 1:trialCount(iCondition)
        eventThisOld = cdtOld.event{iCondition,iTrial};
        eventThisNew = [eventCodesNew{iTrial},eventTimesNew{iTrial}];
        assert(max(abs(eventThisOld(:)-eventThisNew(:)))<tol); % in case there's some round off errors on event times.
    end
    
    %% spikes
    spikeElecNew = cdtNew.spikeElectrode(cdtNew.condition==iCondition);
    spikeUnitNew = cdtNew.spikeUnit(cdtNew.condition==iCondition);
    spikeTimesNew = cdtNew.spikeTimes(cdtNew.condition==iCondition);
    
    
    
    for iTrial = 1:trialCount(iCondition)
        spikeElecNewThis = spikeElecNew{iTrial};
        spikeUnitNewThis = spikeUnitNew{iTrial};
        spikeTimesNewThis = spikeTimesNew{iTrial};
        
        spikeTimesOldThis = cdtOld.spike(:,iCondition,iTrial);
        
        % go over by maps.
        for iUnit = 1:size(cdtOld.map,1)
            spikeTimesThisUnitNew = spikeTimesNewThis(...
                spikeElecNewThis==cdtOld.map(iUnit,1) & spikeUnitNewThis==cdtOld.map(iUnit,2));
            if isempty(spikeTimesThisUnitNew)
                assert(isempty(spikeTimesOldThis{iUnit}));
            else
                assert(numel(spikeTimesThisUnitNew)==1);
                assert(max(abs(spikeTimesOldThis{iUnit}(:)-spikeTimesThisUnitNew{1}(:)))<tol);
            end
        end
    end
    
    
    %% times.
    starttimeNew = cdtNew.starttime(cdtNew.condition==iCondition,:);
    stoptimeNew = cdtNew.stoptime(cdtNew.condition==iCondition,:);
    
    for iTrial = 1:trialCount(iCondition)
        starttimeThisOld = cdtOld.time.start_time{iCondition,iTrial};
        stoptimeThisOld = cdtOld.time.stop_time{iCondition,iTrial};
        starttimeThisNew = starttimeNew(iTrial,:);
        stoptimeThisNew = stoptimeNew(iTrial,:);
        assert(max(abs(starttimeThisOld(:)-starttimeThisNew(:)))<tol);
        assert(max(abs(stoptimeThisOld(:)-stoptimeThisNew(:)))<tol);
    end

end

end



function save_CDTTable(savePath, CDTTables, importParams,metaInfo)
% demo function to save result. maybe it's good to change it into a
% standalone function.

if nargin < 4 || isempty(metaInfo)
    metaInfo = [];
end

save([savePath '.mat'],'CDTTables','savePath','metaInfo');
proto_functions.write_proto_bin(importParams,[savePath '.protobin']);
proto_functions.write_proto_txt(importParams,[savePath '.prototxt']);


end




% Created with NEWFCN.m by Frank Gonz�lez-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [import_NEV_demo.m] ======  
