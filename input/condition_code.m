function [ condition_code ] = condition_code( NEV_code, exp_param )
%CONDITION_CODE Summary of this function goes here
%   Detailed explanation goes here

condition_code = feval(['condition_' exp_param.exp_name], NEV_code, exp_param);


end

