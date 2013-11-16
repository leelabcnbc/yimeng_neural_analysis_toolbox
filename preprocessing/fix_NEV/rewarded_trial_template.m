function [ trial_template ] = rewarded_trial_template( tm_file_name, cnd_file_name )
%REWARDED_TRIAL_TEMPLATE Summary of this function goes here
%   Detailed explanation goes here

assert(~isempty(tm_file_name));
assert(~isempty(cnd_file_name));
trial_template = {};
switch lower(tm_file_name)
    case {'3ec_or.tm','3ec_ora.tm','3ec_a.tm','3ec.tm'}
        % before giving condition number codes
        trial_template{1} = trial_template_part(1, 9, false);
        trial_template{2} = trial_template_part(1, 10, false);
        trial_template{3} = trial_template_part(1, 15, false);
        trial_template{4} = trial_template_part(1, 100, false);
        trial_template{5} = trial_template_part(1, 16, false);
        % condition number codes
        switch lower(cnd_file_name)
            case 'edge_or.cnd'
                trial_template{6} = trial_template_part(2, 192, 198, false); % 198-192 = 6 = floor(415/64)
                trial_template{7} = trial_template_part(2, 192, 255, true);
            case 'images.cnd'
                trial_template{6} = trial_template_part(2, 192, 192, false); % 192-192 = 0 = floor(16/64)
                trial_template{7} = trial_template_part(2, 192, 208, true);
            case 'edge_pos.cnd'
                trial_template{6} = trial_template_part(2, 192, 199, false); % 199-192 = 7 = floor(467/64)
                trial_template{7} = trial_template_part(2, 192, 255, true); % actually, this can be more refined...
            case 'gratings.cnd'
                trial_template{6} = trial_template_part(2, 192, 192, false); % 192-192 = 0 = floor(16/64)
                trial_template{7} = trial_template_part(2, 192, 207, true);
            case 'edge_or0.cnd'
                trial_template{6} = trial_template_part(2, 192, 198, false); % 198-192 = 6 = floor(415/64)
                trial_template{7} = trial_template_part(2, 192, 255, true);
            case 'edge_cal.cnd'
                trial_template{6} = trial_template_part(2, 192, 192, false); % 192-192 = 0 = floor(63/64)
                trial_template{7} = trial_template_part(2, 192, 255, true);
        end
                
                
        % before giving the target code
        trial_template{8} = trial_template_part(1, 23, false);
        trial_template{9} = trial_template_part(1, 8, false);
        trial_template{10} = trial_template_part(1, 25, false);
        trial_template{11} = trial_template_part(1, 26, false);
        trial_template{12} = trial_template_part(1, 27, false);
        trial_template{13} = trial_template_part(1, 28, false);
        trial_template{14} = trial_template_part(1, 29, false);
        trial_template{15} = trial_template_part(1, 30, false);
        % target code
        trial_template{16} = trial_template_part(2, 121, 124, false);
        % another rigid block 
        trial_template{17} = trial_template_part(1, 120, false);
        trial_template{18} = trial_template_part(1, 8, false);
        trial_template{19} = trial_template_part(1, 24, false);
        trial_template{20} = trial_template_part(1, 17, false);
        trial_template{21} = trial_template_part(1, 0, false);
        trial_template{22} = trial_template_part(1, 101, false);
        trial_template{23} = trial_template_part(1, 96, false);
        trial_template{24} = trial_template_part(1, 18, false);
    case {'cg.tm'}
        trial_template{1} = trial_template_part(1, 9, false);
        trial_template{2} = trial_template_part(1, 10, false);
        trial_template{3} = trial_template_part(1, 15, false);
        trial_template{4} = trial_template_part(1, 100, false);
        trial_template{5} = trial_template_part(1, 16, false);
        
        trial_template{6} = trial_template_part(2, 192, 195, false); 
        trial_template{7} = trial_template_part(2, 192, 255, true);
        
        trial_template{8} = trial_template_part(1, 23, false);
        trial_template{9} = trial_template_part(1, 8, false);
        trial_template{10} = trial_template_part(1, 25, false);
        trial_template{11} = trial_template_part(1, 26, false);
        trial_template{12} = trial_template_part(1, 28, false);
        
        % target code
        trial_template{13} = trial_template_part(2, 110, 113, false);
        % another rigid block 
        
        trial_template{14} = trial_template_part(1, 120, false);
        trial_template{15} = trial_template_part(1, 8, false);
        trial_template{16} = trial_template_part(1, 24, false);
        trial_template{17} = trial_template_part(1, 17, false);
        trial_template{18} = trial_template_part(1, 128, false);
        trial_template{19} = trial_template_part(1, 101, false);
        trial_template{20} = trial_template_part(1, 96, false);
        trial_template{21} = trial_template_part(1, 18, false);
end

end

function template_part = trial_template_part(type, number1, missable_number2, missable)
    switch type
        case 1
            template_part.type = 1;
            template_part.value = number1; % actually, I can instead use min_value == max_value,
            % and eliminate the use of type. However, maybe in the future we have to support a range of incontinuous values.
            template_part.missable = missable_number2;
        case 2 
            template_part.type = 2;
            template_part.min_value = number1;
            template_part.max_value = missable_number2;
            template_part.missable = missable;
    end
end
