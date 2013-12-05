function [  ] = check_CDT( cdt )
%CHECK_CDT Verify a CDT
%   Detailed explanation goes here

exp_param = cdt.exp_param;
time = cdt.time;

% check cell number

cell_number = size(cdt.map,1);
assert(cell_number == size(cdt.spike,1));

% check total trial counts
total_trial = sum(cdt.trial_count);
assert(total_trial == size(cdt.order,1));

if isfield(exp_param,'condition_number')
% check number of conditions
condition_list = exp_param.condition_number(1):exp_param.condition_number(2);
else 
condition_list = exp_param.condition_list;
end
condition_list = condition_list(:);

condition_number = length(condition_list);

assert(isequal(condition_list(:),exp_param.condition_list(:)));

assert(condition_number == size(time.start_time,1));
assert(condition_number == size(time.stop_time,1));
assert(condition_number == size(time.fixation,1));



% size checking

third_dimension = size(cdt.spike,3);

assert(third_dimension==size(cdt.event,2));
assert(third_dimension==size(time.start_time,2));
assert(third_dimension==size(time.stop_time,2));
assert(third_dimension==size(time.fixation,2));


% check margin
assert(length(time.margin) == 2);

% check order
assert(isequal(size(unique(cdt.order,'rows')),  size(cdt.order)));

align_code = exp_param.align_code;

assert(length(align_code) == exp_param.number_of_test_per_condition*2);

% time checking
for i = 1:condition_number
    % check
    for j = 1:cdt.trial_count(i)
        assert(ismember([i,j], cdt.order, 'rows')); % exist in order
        
        % check timestamps
        event_trial = cdt.event{i,j};
        event_timestamp = event_trial(:,2);
        event_code = event_trial(:,1);
        
        [~,codeIdx] = ismember(align_code,event_code);
        
        align_code_time = event_timestamp(codeIdx);
        
        start_time = time.start_time{i,j};
        stop_time = time.stop_time{i,j};
        
        assert(length(start_time) == length(align_code_time)/2);
        assert(length(stop_time) == length(align_code_time)/2);
        
        for k = 1:(length(align_code_time)/2)
            assert(start_time(k)  == align_code_time(2*k-1));
            assert(stop_time(k)  == align_code_time(2*k));
        end
        
        
        
        if (time.fixation(i,j)>=0)
            fixationcode = strfind(event_code(:)',[23 8]);
            
            if isempty(fixationcode)
                fixationcode = 1;
            else
                fixationcode = fixationcode+1;
            end
            
            assert(isscalar(fixationcode));
            
            
            assert(event_timestamp(fixationcode)==time.fixation(i,j));
        else
            error('is this possible?');
        end
        
    end
end


% empty cell checking

for i = 1:condition_number
    
    for j = cdt.trial_count(i)+1:third_dimension
        
        for k = 1:cell_number
            assert(isempty(cdt.spike{k,i,j}));
        end
        
        assert(isempty(cdt.event{i,j}));
        
        assert(isempty(time.start_time{i,j}));
        assert(isempty(time.stop_time{i,j}));
        
        assert(time.fixation(i,j) == 0);
        
    end

end

