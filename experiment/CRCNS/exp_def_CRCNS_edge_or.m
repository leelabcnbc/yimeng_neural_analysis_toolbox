classdef exp_def_CRCNS_edge_or < exp_def_generic
    %EXP_DEF_CRCNS_EDGE_OR Summary of this class goes here
    %   Detailed explanation goes here
   
    methods
        function obj = exp_def_CRCNS_edge_or
            obj.exp_name = 'CRCNS_edge_or';
            obj.condition_list = (1:416)';
            obj.number_of_test_per_condition = 3;
            obj.align_code = 25:30;
            obj.timing_file = '3ec_or.tm';
            obj.condition_file = 'edge_or.cnd';
        end
        
        function template = trial_template(obj)
            template = rewarded_trial_template(obj.timing_file,obj.condition_file);
        end
        
    end
    
    methods (Static)
        function code = condition_code(NEV_code)
            assert(length(NEV_code)==24); % for proof
            code=(NEV_code(6)-192)*64+(NEV_code(7)-192)+1;
        end
    end
    
end

