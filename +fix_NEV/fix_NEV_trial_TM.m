function fix_NEV_trial_TM(NEV_trial, trial_template)
% FIX_NEV_TRIAL_TM ...
%
%   fix a (NEV or CTX) trial by Template Matching.
%   TM originally means timing file. and this function is originally
%   designed to work with NEV files. however, it can work with CTX as well,
%   since it only requires codes and times.
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 21-Jul-2015 22:38:13 $
%% DEVELOPED : 8.3.0.532 (R2014a)
%% FILENAME  : fix_NEV_trial_TM.m


templateLength = double(trial_template.getCodesCount());

new_NEV_trial = zeros(templateLength,2);

next_idx_in_old_trial = 1;
fixable = true;
for i = 1:templateLength;
    if ~fixable
        return;
    end
    [new_NEV_trial(i,:),next_idx_in_old_trial, fixable] = ...
        fix_NEV_trial_TM_part(NEV_trial, ...
        next_idx_in_old_trial, trial_template.getCodes(i-1) );
end


end

function [new_trial_part, next_idx_in_old_trial, fixable] = ...
    fix_NEV_trial_TM_part(NEV_trial, next_idx_in_old_trial, template_part)
new_trial_part = NaN(1,2);
fixable = true;

className = 'com.leelab.monkey_exp.RewardedTrialTemplateProtos$SingleCode$CodeType';
typeObjSingle = javaMethod('valueOf', className, 'CODETYPE_SINGLE');
typeObjRange = javaMethod('valueOf', className, 'CODETYPE_RANGE');
%% switch over types.
if logical(typeObjSingle.equals(template_part.getType()))
    valid_index = find(NEV_trial(:,1)==template_part.getCode(0));
    valid_index = valid_index(valid_index >= next_idx_in_old_trial);
    if (isempty(valid_index))
        fixable = false;
        return;
    end
    new_trial_part = NEV_trial(valid_index(1),:);
    next_idx_in_old_trial = valid_index(1)+1;
    % the missing feature is not implemented yet...
else
    assert(typeObjRange.equals(template_part.getType()));
    % we assume that a spurious code will not occur between two condition codes.
    % basically this is only trying to handle the two byte encoding
    % scheme of condition numbers.
    min_value = double(template_part.getCode(0));
    max_value = double(template_part.getCode(1));
    valid_index = find((NEV_trial(:,1)>=min_value) & (NEV_trial(:,1)<=max_value));
    valid_index = valid_index(valid_index >= next_idx_in_old_trial);
    
    if ~logical(template_part.getMissable()) % not missable
        if (isempty(valid_index))
            fixable = false;
            return;
        end
        new_trial_part = NEV_trial(valid_index(1),:);
        next_idx_in_old_trial = valid_index(1)+1;
    else
        if isempty(valid_index) || (next_idx_in_old_trial~=valid_index(1)) % we missed our dear condition code. why second case? It means there are too many spurious codes between. actually, two codes should happen together.
            new_trial_part = NEV_trial(next_idx_in_old_trial-1,:); % copy the previous row % HERE I assume missing occur because same 2 codes in a row.
            if ~((NEV_trial(next_idx_in_old_trial-1,1)>=min_value) && (NEV_trial(next_idx_in_old_trial-1,1)<=max_value))
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








% Created with NEWFCN.m by Frank Gonz�lez-Morphy
% Contact...: frank.gonzalez-morphy@mathworks.de
% ===== EOF ====== [fix_NEV_trial_TM.m] ======
