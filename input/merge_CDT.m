function [ cdt_merged ] = merge_CDT( cdt_list )
%MERGE_CDT Summary of this function goes here
%   Detailed explanation goes here

cdt_first = load(cdt_list{1});
cdt_first = cdt_first.cdt;

cdt_merged = cdt_first;

cdt_merged.info.key = 'merged';
cdt_merged.info.NEV_name = 'merged.nev';
cdt_merged.info.CTX_name = 'merged.0';
% channel is the first CDT's channel.
% neuron is the first CDT's neuron.
cdt_merged.info.NEV_path = 'merged.nev';

for i = 2:length(cdt_list)
    cdt_next = load(cdt_list{i});
    cdt_next = cdt_next.cdt;
    
    % some parameters must match
    
    assert(isequal(cdt_next.CHANNELS,cdt_first.CHANNELS));
    assert(isequal(cdt_next.exp_param,cdt_first.exp_param));
    assert(isequal(size(cdt_next.TC),size(cdt_first.TC)));
    assert(isequal(cdt_next.map,cdt_first.map));
    
    size_event_next = size(cdt_next.EVENTS);
    size_event_first = size(cdt_first.EVENTS);
    assert(isequal(size_event_next(1:2),size_event_first(1:2)));
    
    assert(isequal(cdt_next.info.exp_name,cdt_first.info.exp_name));
    assert(isequal(cdt_next.info.rf,cdt_first.info.rf));
    assert(isequal(cdt_next.info.monkey,cdt_first.info.monkey));
     
    assert(isequal(cdt_next.data.margins,cdt_first.data.margins));
    
    % forget about this fucking ntrials thing!
    
    ntrials = cdt_next.info.ntrials;
    new_ntrials = cdt_merged.info.ntrials;
    
    now_TC = cdt_merged.TC;
    next_TC = cdt_next.TC;
    
    % merge
    for j = 1:length(cdt_first.TC)
        cdt_merged.data.starttime(j,now_TC(j)+1:now_TC(j)+next_TC(j))=cdt_next.data.starttime(j,1:next_TC(j));
        cdt_merged.data.stoptime(j,now_TC(j)+1:now_TC(j)+next_TC(j))=cdt_next.data.stoptime(j,1:next_TC(j));
        cdt_merged.data.fixation(j,now_TC(j)+1:now_TC(j)+next_TC(j))=cdt_next.data.fixation(j,1:next_TC(j));
        cdt_merged.EVENTS(:,j,now_TC(j)+1:now_TC(j)+next_TC(j)) = cdt_next.EVENTS(:,j,1:next_TC(j)); 
    end 
    
    cdt_merged.info.ntrials = new_ntrials + ntrials;

    cdt_merged.TC = cdt_merged.TC + cdt_next.TC;
    
end

end

