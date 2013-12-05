function [ parameter_obj ] = load_exp_parameter( exp_name )
%LOAD_EXP_PARAMETER Summary of this function goes here
%   Detailed explanation goes here

% default
parameter_obj = feval(['exp_def_' exp_name]);


end

