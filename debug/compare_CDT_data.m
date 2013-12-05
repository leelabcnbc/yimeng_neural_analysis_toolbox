function [ result ] = compare_CDT_data( cdt1, cdt2 )
%COMPARE_CDT_DATA Summary of this function goes here
%   Detailed explanation goes here
cdt1 = rmfield(cdt1,{'exp_param','info'});
cdt2 = rmfield(cdt2,{'exp_param','info'});

result = isequal(cdt1,cdt2);

end

