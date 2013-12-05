function [ cdt_merged ] = merge_CDT( cdt_list )
%MERGE_CDT Summary of this function goes here
%   Detailed explanation goes here

cdt_first = load(cdt_list{1});
cdt_first = cdt_first.cdt;

cdt_merged = cdt_first;

cdt_merged.info.key = 'merged';
cdt_merged.info.NEV_name = 'merged.nev';
cdt_merged.info.CTX_name = 'merged.0';
cdt_merged.info.NEV_path = 'merged.nev';
cdt_merged.info.CTX_path = 'merged.0';
cdt_merged.info.comment = 'merged';

% put all pre merged info here



for i = 2:length(cdt_list)
    cdt_next = load(cdt_list{i});
    cdt_next = cdt_next.cdt;
    
    % some parameters must match
    
    assert(isequal(cdt_next.exp_param,cdt_first.exp_param));
    assert(isequal(size(cdt_next.trial_count),size(cdt_first.trial_count)));
    assert(isequal(cdt_next.map,cdt_first.map));
    
    size_event_next = size(cdt_next.spike);
    size_event_first = size(cdt_first.spike);
    assert(isequal(size_event_next(1:2),size_event_first(1:2)));
    
    assert(isequal(cdt_next.info.exp_name,cdt_first.info.exp_name));
     
    assert(isequal(cdt_next.time.margin,cdt_first.time.margin));
    
    % forget about this fucking ntrials thing!
    

    now_TC = cdt_merged.trial_count;
    next_TC = cdt_next.trial_count;
    
    now_order = cdt_merged.order;
    next_order = cdt_next.order;
    
    % merge
    for j = 1:length(cdt_first.trial_count)
        cdt_merged.time.start_time(j,now_TC(j)+1:now_TC(j)+next_TC(j))=cdt_next.time.start_time(j,1:next_TC(j));
        cdt_merged.time.stop_time(j,now_TC(j)+1:now_TC(j)+next_TC(j))=cdt_next.time.stop_time(j,1:next_TC(j));
        cdt_merged.time.fixation(j,now_TC(j)+1:now_TC(j)+next_TC(j))=cdt_next.time.fixation(j,1:next_TC(j));
        cdt_merged.spike(:,j,now_TC(j)+1:now_TC(j)+next_TC(j)) = cdt_next.spike(:,j,1:next_TC(j)); 
        
        cdt_merged.event(j,now_TC(j)+1:now_TC(j)+next_TC(j)) = cdt_next.event(j,1:next_TC(j)); 
        
        condition_idx = (next_order(:,1)==j);
        next_order(condition_idx,2) = next_order(condition_idx,2) + now_TC(j);
    end 
    
    % marge order
    
    cdt_merged.order = [cdt_merged.order; next_order];
    
    cdt_merged.trial_count = cdt_merged.trial_count + cdt_next.trial_count;
    
end

end

