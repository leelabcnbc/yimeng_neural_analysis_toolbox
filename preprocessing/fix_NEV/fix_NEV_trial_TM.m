function [ new_NEV_trial, fixable ] = fix_NEV_trial_TM(NEV_trial, trial_template)
%FIX_NEV_TRIAL_TM fix an NEV trial based on timing file
%   Detailed explanation goes here
% trial_template = rewarded_trial_template(tm_file_name, cnd_file_name);

% our template is of fixed length.
new_NEV_trial = zeros(length(trial_template),2);

next_idx_in_old_trial = 1;
fixable = true;
for i = 1:length(trial_template);
    if ~fixable
        return;
    end
    [new_NEV_trial(i,:),next_idx_in_old_trial, fixable] = fix_NEV_trial_TM_part(NEV_trial, next_idx_in_old_trial, trial_template{i});
end


end



function [new_trial_part, next_idx_in_old_trial, fixable] = fix_NEV_trial_TM_part(NEV_trial, next_idx_in_old_trial, template_part)
new_trial_part = NaN(1,2);
fixable = true;
switch(template_part.type)
    case 1
        valid_index = find(NEV_trial(:,1)==template_part.value);
        valid_index = valid_index(valid_index >= next_idx_in_old_trial);
        if (isempty(valid_index))
            fixable = false;
            return;
        end
        new_trial_part = NEV_trial(valid_index(1),:);
        next_idx_in_old_trial = valid_index(1)+1;
        % the missing feature is not implemented yet...
    case 2
        % we assume that a spurious code will not occur between two condition codes.
        valid_index = find((NEV_trial(:,1)>=template_part.min_value) & (NEV_trial(:,1)<=template_part.max_value));
        valid_index = valid_index(valid_index >= next_idx_in_old_trial);
        
        switch template_part.missable
            case false
                if (isempty(valid_index))
                    fixable = false;
                    return;
                end
                new_trial_part = NEV_trial(valid_index(1),:);
                next_idx_in_old_trial = valid_index(1)+1;
            case true
                if isempty(valid_index) || (next_idx_in_old_trial~=valid_index(1)) % we missed our dear condition code
                    new_trial_part = NEV_trial(next_idx_in_old_trial-1,:); % copy the previous row
                    if ~((NEV_trial(next_idx_in_old_trial-1,1)>=template_part.min_value) && (NEV_trial(next_idx_in_old_trial-1,1)<=template_part.max_value))
                        fixable = false;
                    return;
                    end
                    %don't change next_idx_in_old_trial
                else
                    new_trial_part = NEV_trial(valid_index(1),:);
                    next_idx_in_old_trial = valid_index(1)+1;
                end
        end
end

end