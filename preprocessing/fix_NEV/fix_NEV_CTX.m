function [ NEV_codes_new, NEV_times_new ] = fix_NEV_CTX( NEV_file_name, fixing, tm_file_name, cnd_file_name, CTX_file_name, throw_high_byte)
%FIX_NEV_CTX Summary of this function goes here
%   Detailed explanation goes here

if nargin < 6
    throw_high_byte = true;
end

fixed_NEV_trials_array = [];
errors_fixed_by_CTX = 0;

[NEV_codes_new, NEV_times_new, NEV_rewarded_trials] = fix_NEV_file(NEV_file_name, fixing, tm_file_name, cnd_file_name, throw_high_byte);

if fixing && exist(CTX_file_name,'file') % use CTX as additional source of confidence
    [CTX_codes_new, ~, CORTEX_rewarded_trials]=fix_CTX_file(CTX_file_name, tm_file_name, cnd_file_name)
    
    extra_CORTEX_trials = setdiff(CORTEX_rewarded_trials, NEV_rewarded_trials);
    if ~isempty(extra_CORTEX_trials)
        fprintf('for file, we have extra Cortex trials.\n');
        disp(extra_CORTEX_trials);
    end
    
    
    useful_CORTEX_trials_for_NEV = intersect(CORTEX_rewarded_trials, NEV_rewarded_trials);
    unchecked_NEV_trials = setdiff(NEV_rewarded_trials, CORTEX_rewarded_trials);
    
    fprintf('merging trials for file\n');
    
    for rewarded_trial_idx = useful_CORTEX_trials_for_NEV(:)'
        NEV_code = NEV_codes_new{NEV_rewarded_trials==rewarded_trial_idx};
        CORTEX_code = CTX_codes_new{CORTEX_rewarded_trials==rewarded_trial_idx}; 
        if ~isequal(NEV_code,CORTEX_code)
            fprintf('for trial %d, NEV and CORTEX are different\n', rewarded_trial_idx);
            
            fixed_NEV_trials_array(end+1) = rewarded_trial_idx;
            
            disp([CORTEX_code, NEV_code, CORTEX_code-NEV_code]);
            errors_fixed_by_CTX = errors_fixed_by_CTX+1;
            
                fprintf('Replacing NEV codes with Cortex ones...\n');
                NEV_codes_new{NEV_rewarded_trials==rewarded_trial_idx} = CORTEX_code;
            
        end
    end
    
end

end

