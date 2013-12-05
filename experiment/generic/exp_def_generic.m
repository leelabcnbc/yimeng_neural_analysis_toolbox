classdef exp_def_generic
    %EXP_DEF_GENERIC Generic base virtual class of experiment definition
    %   Detailed explanation goes here
    
    properties
        exp_name
        condition_list
        number_of_test_per_condition
        align_code
        timing_file
        condition_file
    end
    
    methods
        function rewarded_trial_template = trial_template(obj)
            error('method trial_template not implemented');
        end
    end
    
    methods (Static)
        function code = condition_code(NEV_code)  
            error('method find_condition_number not implemented');
        end
    end
    
end

